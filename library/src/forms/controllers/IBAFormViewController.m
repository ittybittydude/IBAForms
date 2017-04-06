//
// Copyright 2010 Itty Bitty Apps Pty Ltd
// 
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this 
// file except in compliance with the License. You may obtain a copy of the License at 
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import "IBAFormViewController.h"
#import "IBAFormConstants.h"
#import "IBAInputManager.h"
#import "IBAInputRequestorFormField.h"

@interface IBAFormViewController ()

@property (nonatomic, assign) CGRect keyboardFrame;

- (void)releaseViews;
- (void)registerForNotifications;
- (void)registerSelector:(SEL)selector withNotification:(NSString *)notificationKey;
- (void)adjustTableViewHeightForCoveringFrame:(CGRect)coveringFrame;
- (CGRect)rectForOrientationFrame:(CGRect)frame;
- (void)makeActiveFormFieldVisibleWithAnimation:(BOOL)animate;
- (void)makeFormFieldVisible:(id<IBAFormFieldProtocol>)formField animated:(BOOL)animate;

// Notification methods
- (void)pushViewController:(NSNotification *)notification;
- (void)presentModalViewController:(NSNotification *)notification;
- (void)dismissModalViewController:(NSNotification *)notification;

@end

@implementation IBAFormViewController

@synthesize tableView = tableView_;
@synthesize tableViewOriginalFrame = tableViewOriginalFrame_;
@synthesize formDataSource = formDataSource_;
@synthesize keyboardFrame = keyboardFrame_;
@synthesize autoAdjustTableHeight = autoAdjustTableHeight_;

#pragma mark -
#pragma mark Initialisation and memory management

- (void)dealloc {
	[self releaseViews];
	IBA_RELEASE_SAFELY(formDataSource_);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void)releaseViews {
	IBA_RELEASE_SAFELY(tableView_);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil formDataSource:(IBAFormDataSource *)formDataSource {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.formDataSource = formDataSource;
        self.autoAdjustTableHeight = YES;
	}

	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil formDataSource:nil];
}

- (id)initWithFormDataSource:(IBAFormDataSource *)formDataSource {
	if ((self = [self initWithNibName:nil bundle:nil formDataSource:formDataSource])) {
	}

	return self;
}

- (void)registerForNotifications {
	[self registerSelector:@selector(inputManagerWillShow:) withNotification:UIKeyboardWillShowNotification];
	[self registerSelector:@selector(inputManagerDidHide:) withNotification:UIKeyboardDidHideNotification];

	[self registerSelector:@selector(formFieldActivated:) withNotification:IBAInputRequestorFormFieldActivated];

	[self registerSelector:@selector(pushViewController:) withNotification:IBAPushViewController];
	[self registerSelector:@selector(presentModalViewController:) withNotification:IBAPresentModalViewController];
	[self registerSelector:@selector(dismissModalViewController:) withNotification:IBADismissModalViewController];
}

- (void)registerSelector:(SEL)selector withNotification:(NSString *)notificationKey {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:notificationKey object:nil];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.tableView.dataSource = self.formDataSource;
	self.tableView.delegate = self;

	tableViewOriginalFrame_ = self.tableView.frame;
}

- (void)viewDidUnload {
	[self releaseViews];
	
	[super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

    [self registerForNotifications];

	[[IBAInputManager sharedIBAInputManager] setInputRequestorDataSource:self];	
	
	// SW. There is a bug with UIModalPresentationFormSheet where the keyboard won't dismiss even when there is
	// no first responder, so we remove the 'Done' button when UIModalPresentationFormSheet is used.
	BOOL displayDoneButton = (self.modalPresentationStyle != UIModalPresentationFormSheet);
	if (self.navigationController != nil) {
		displayDoneButton &= (self.navigationController.modalPresentationStyle != UIModalPresentationFormSheet);
	}
	
	[[[IBAInputManager sharedIBAInputManager] inputNavigationToolbar] setDisplayDoneButton:displayDoneButton];
	
	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	[[IBAInputManager sharedIBAInputManager] deactivateActiveInputRequestor];
	[[[IBAInputManager sharedIBAInputManager] inputNavigationToolbar] setDisplayDoneButton:YES];
	if ([[IBAInputManager sharedIBAInputManager] inputRequestorDataSource] == self) {
		[[IBAInputManager sharedIBAInputManager] setInputRequestorDataSource:nil];
	}
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (![[IBAInputManager sharedIBAInputManager] activeInputRequestor]) {
        if(self.autoAdjustTableHeight == YES)
            [self adjustTableViewHeightForCoveringFrame:CGRectZero];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	if ([[IBAInputManager sharedIBAInputManager] activeInputRequestor] != nil) {
		[self makeActiveFormFieldVisibleWithAnimation:YES];
	}
}

#pragma mark -
#pragma mark Property management

// this setter also sets the datasource of the tableView and reloads the table
- (void)setFormDataSource:(IBAFormDataSource *)dataSource {
	if (dataSource != formDataSource_) {
		IBAFormDataSource *oldDataSource = formDataSource_;
		formDataSource_ = [dataSource retain];
		IBA_RELEASE_SAFELY(oldDataSource);
        
        [formDataSource_ setTableView:self.tableView];
		self.tableView.dataSource = formDataSource_;
		[self.tableView reloadData];
	}
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id<IBAFormFieldProtocol> formField = [self.formDataSource formFieldAtIndexPath:indexPath];
	if ([formField hasDetailViewController]) {
		// The row has a detail view controller that we should push on to the navigation stack
		[[self navigationController] pushViewController:[formField detailViewController] animated:YES];
	} else if ([formField conformsToProtocol:@protocol(IBAInputRequestor)]){
		// Start editing the form field
		[[IBAInputManager sharedIBAInputManager] setActiveInputRequestor:(id<IBAInputRequestor>)formField];
	} else {
		[formField select];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return [self.formDataSource viewForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return [self.formDataSource viewForFooterInSection:section];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(IBAFormFieldCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell updateActiveStyle];
	
    if ([self respondsToSelector:@selector(willDisplayCell:forFormField:atIndexPath:)]) {
        id<IBAFormFieldProtocol> formField = [formDataSource_ formFieldAtIndexPath:indexPath];
        [self willDisplayCell:cell forFormField:formField atIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [[self formDataSource] heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [[self formDataSource] heightForFooterInSection:section];
}


#pragma mark - 
#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[IBAInputManager sharedIBAInputManager] deactivateActiveInputRequestor];
}

#pragma mark -
#pragma mark IBAInputRequestorDataSource

- (id<IBAInputRequestor>)nextInputRequestor:(id<IBAInputRequestor>)currentInputRequestor {
	// Return the next form field that supports inline editing
	id<IBAFormFieldProtocol> nextField = [self.formDataSource formFieldAfter:(id<IBAFormFieldProtocol>)currentInputRequestor];
	while ((nextField != nil) && (![nextField conformsToProtocol:@protocol(IBAInputRequestor)])) {
		nextField = [self.formDataSource formFieldAfter:nextField];
	}
	
	return (id<IBAInputRequestor>)nextField;
}


- (id<IBAInputRequestor>)previousInputRequestor:(id<IBAInputRequestor>)currentInputRequestor {
	// Return the previous form field that supports inline editing
	id<IBAFormFieldProtocol> previousField = [self.formDataSource formFieldBefore:(id<IBAFormFieldProtocol>)currentInputRequestor];
	while ((previousField != nil) && (![previousField conformsToProtocol:@protocol(IBAInputRequestor)])) {
		previousField = [self.formDataSource formFieldBefore:previousField];
	}
	
	return (id<IBAInputRequestor>)previousField;
}


#pragma mark -
#pragma mark Responses to IBAInputManager notifications

- (void)inputManagerWillShow:(NSNotification *)notification {
	NSDictionary* info = [notification userInfo];
	CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    if(self.autoAdjustTableHeight == YES) {
        [self adjustTableViewHeightForCoveringFrame:[self rectForOrientationFrame:keyboardFrame]];
    }
}

- (void)inputManagerDidHide:(NSNotification *)notification {
	if (![[IBAInputManager sharedIBAInputManager] activeInputRequestor]) {
        if(self.autoAdjustTableHeight == YES) {
            [self adjustTableViewHeightForCoveringFrame:CGRectZero];
        }
	}
}

- (void)formFieldActivated:(NSNotification *)notification {
	id<IBAFormFieldProtocol> formField = [[notification userInfo] objectForKey:IBAFormFieldKey];
	if (formField != nil) {
		[self makeFormFieldVisible:formField animated:YES];
		if ([formField hasDetailViewController]) {
			// The form field has a detail view controller that we should push on to the navigation stack
			[[self navigationController] pushViewController:[formField detailViewController] animated:YES];
		} else if([formField isKindOfClass:[IBAInputRequestorFormField class]]) {
            // this code is needed for fixing bug with "long" jump of table view
            // keyboard not display when next/previous field activated and it is located on large distance from current field
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 * NSEC_PER_MSEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                [[(IBAInputRequestorFormField *)formField responder] becomeFirstResponder];
            });
        }
	}
}

#pragma mark -
#pragma mark Size and visibility accommodations for the input manager view

- (void)makeActiveFormFieldVisibleWithAnimation:(BOOL)animate {
	if ([[IBAInputManager sharedIBAInputManager] activeInputRequestor] != nil) {
		[self makeFormFieldVisible:(id<IBAFormFieldProtocol>)[[IBAInputManager sharedIBAInputManager] activeInputRequestor] animated:animate];
	}
}

- (void)makeFormFieldVisible:(id<IBAFormFieldProtocol>)formField animated:(BOOL)animate {
    if ([self shouldAutoScrollTableToActiveField]) {
        NSIndexPath *formFieldIndexPath = [self.formDataSource indexPathForFormField:formField];
        [self.tableView scrollToRowAtIndexPath:formFieldIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:animate];
    }
}

- (void)adjustTableViewHeightForCoveringFrame:(CGRect)coveringFrame {
	if (!CGRectEqualToRect(coveringFrame, self.keyboardFrame)) {
		self.keyboardFrame = coveringFrame;
		CGRect normalisedWindowBounds = [self rectForOrientationFrame:[[[UIApplication sharedApplication] keyWindow] bounds]];
		CGRect normalisedTableViewFrame = [self rectForOrientationFrame:[self.tableView.superview convertRect:self.tableView.frame
																									   toView:[[UIApplication sharedApplication] keyWindow]]];
        UIEdgeInsets currentInsets = self.tableView.contentInset;
        CGFloat height = CGRectEqualToRect(coveringFrame, CGRectZero) ? 0 : coveringFrame.size.height - (normalisedWindowBounds.size.height - CGRectGetMaxY(normalisedTableViewFrame));
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(currentInsets.top, currentInsets.left, height, currentInsets.right);
		// NSLog(@"UIEdgeInsets contentInsets bottom %f", contentInsets.bottom);
		self.tableView.contentInset = contentInsets;
		self.tableView.scrollIndicatorInsets = contentInsets;
	}
}


#pragma mark -
#pragma mark Push view controller requests

- (void)pushViewController:(NSNotification *)notification {
	UIViewController *viewController = [[notification userInfo] objectForKey:IBAViewControllerKey];
	if (viewController != nil) {
		[[self navigationController] pushViewController:viewController animated:YES];
	}
}


#pragma mark -
#pragma mark Present modal view controller requests

- (void)presentModalViewController:(NSNotification *)notification {
	UIViewController *viewController = [[notification userInfo] objectForKey:IBAViewControllerKey];
	if (viewController != nil) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
        [self presentViewController:viewController animated:YES completion:nil];
#else
		[self presentModalViewController:viewController animated:YES];
#endif
	}
}

- (void)dismissModalViewController:(NSNotification *)notification {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    [self dismissViewControllerAnimated:YES completion:nil];
#else
    [self dismissModalViewControllerAnimated:YES];
#endif
}

#pragma mark -
#pragma mark Misc

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<IBAFormFieldProtocol> formField = [[self formDataSource] formFieldAtIndexPath:indexPath];
    if([formField cellHeight] != UITableViewAutomaticDimension) {
        return [formField cellHeight];
    } else {
        UITableViewCell *cell = [self.formDataSource tableView:aTableView cellForRowAtIndexPath:indexPath];
        [cell sizeToFit];
        return cell.bounds.size.height;
    }
}

- (CGRect)rectForOrientationFrame:(CGRect)frame {
	if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
		return frame;
	}
	else {
		return CGRectMake(frame.origin.y, frame.origin.x, frame.size.height, frame.size.width);
	}	
}

#pragma mark -
#pragma mark Methods for subclasses to customise behaviour

- (void)willDisplayCell:(IBAFormFieldCell *)cell forFormField:(id<IBAFormFieldProtocol>)formField atIndexPath:(NSIndexPath *)indexPath {
    // NO-OP; subclasses to override
}

- (BOOL)shouldAutoScrollTableToActiveField {
	// Return YES if the table view should be automatically scrolled to the active field
	// Defaults to YES

	return YES;
}

@end
