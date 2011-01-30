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

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "IBAInputManager.h"
#import "IBACommon.h"
#import "IBAInputCommon.h"
#import "IBADateInputProvider.h"
#import "IBATextInputProvider.h"
#import "IBAInputNavigationToolbar.h"
#import "IBAMultiplePickListInputProvider.h"
#import "IBASinglePickListInputProvider.h"

@interface IBAInputManager ()
- (void)registerForNotifications;
- (void)registerSelector:(SEL)selector withNotification:(NSString *)notificationKey;
- (void)nextPreviousButtonSelected;

// Presenting the input manager view
- (void)displayInputManagerView;
- (void)hideInputManagerView;
- (void)inputManagerViewDidDisplay;
- (void)inputManagerViewDidHide;

// Visibility management of the input providers
- (void)displayInputProvider:(id<IBAInputProvider>)inputProvider;

// Methods called when notification come in
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardDidShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)keyboardDidHide:(NSNotification *)notification;
@end


@implementation IBAInputManager

SYNTHESIZE_SINGLETON_FOR_CLASS(IBAInputManager);

@synthesize inputRequestorDataSource = inputRequestorDataSource_;
@synthesize inputManagerView = inputManagerView_;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	IBA_RELEASE_SAFELY(inputProviders_);
	IBA_RELEASE_SAFELY(inputRequestorDataSource_);
	IBA_RELEASE_SAFELY(activeInputRequestor_);
	IBA_RELEASE_SAFELY(inputManagerView_);
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}

- (id)init {
	self = [super init];
	if (self != nil) {
		inputProviders_ = [[NSMutableDictionary alloc] init];
		
		inputManagerView_ = [[IBAInputManagerView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];	
		inputManagerView_.inputNavigationToolbar.doneButton.target = self;
		inputManagerView_.inputNavigationToolbar.doneButton.action = @selector(deactivateActiveInputRequestor);
		[inputManagerView_.inputNavigationToolbar.nextPreviousButton addTarget:self action:@selector(nextPreviousButtonSelected) 
			forControlEvents:UIControlEventValueChanged];
		
		// Setup some default input providers
		
		// Text
		[self registerInputProvider:[[[IBATextInputProvider alloc] init] autorelease]
						forDataType:IBAInputDataTypeText];
		// Date
		[self registerInputProvider:[[[IBADateInputProvider alloc] init] autorelease]
						forDataType:IBAInputDataTypeDate];
		// Time
		[self registerInputProvider:[[[IBADateInputProvider alloc] initWithDatePickerMode:UIDatePickerModeTime] autorelease] 
						forDataType:IBAInputDataTypeTime];
		
		// Date & Time
		[self registerInputProvider:[[[IBADateInputProvider alloc] initWithDatePickerMode:UIDatePickerModeDateAndTime] autorelease]
						forDataType:IBAInputDataTypeDateTime];
		
		// Single Picklist
		[self registerInputProvider:[[[IBASinglePickListInputProvider alloc] init] autorelease]
						forDataType:IBAInputDataTypePickListSingle];
		
    // Multiple Picklist
    [self registerInputProvider:[[[IBAMultiplePickListInputProvider alloc] init] autorelease]
                    forDataType:IBAInputDataTypePickListMultiple];
    
		[self registerForNotifications];
	}
	
	return self;
}


#pragma mark -
#pragma mark Accessors

- (BOOL)setActiveInputRequestor:(id<IBAInputRequestor>)inputRequestor {
	id<IBAInputProvider>oldInputProvider = nil;
	if (activeInputRequestor_ != nil) {
		oldInputProvider = [self inputProviderForRequestor:activeInputRequestor_];
		
		if (![activeInputRequestor_ deactivate]) {
			return NO;
		}
		
		oldInputProvider.inputRequestor = nil;
		[activeInputRequestor_ release];
	}
	
	if (inputRequestor != nil)  {
		activeInputRequestor_ = [inputRequestor retain];

		id<IBAInputProvider>newInputProvider = [self inputProviderForRequestor:activeInputRequestor_];
		
		if (newInputProvider != oldInputProvider) {
			[self displayInputProvider:newInputProvider];
		}
		
		// NOTE: the input requestor must be activated after the input provider has been displayed because the
		// act of displaying the input provider may affect the visibility of the input requestor, which needs
		// to be compensated for when the requestor is activated.
		[activeInputRequestor_ activate];
		
		newInputProvider.inputRequestor = activeInputRequestor_;
	} else {
		// The new input requestor is nil, so hide the input manager's view
		[self hideInputManagerView];
		activeInputRequestor_ = nil;
	}
	
	return YES;
}

- (id<IBAInputRequestor>)activeInputRequestor {
	return activeInputRequestor_;
}

#pragma mark -
#pragma mark Notification registration

- (void)registerForNotifications {
	[self registerSelector:@selector(keyboardWillShow:) withNotification:UIKeyboardWillShowNotification];
	[self registerSelector:@selector(keyboardDidShow:) withNotification:UIKeyboardDidShowNotification];
	[self registerSelector:@selector(keyboardWillHide:) withNotification:UIKeyboardWillHideNotification];
	[self registerSelector:@selector(keyboardDidHide:) withNotification:UIKeyboardDidHideNotification];
}

- (void)registerSelector:(SEL)selector withNotification:(NSString *)notificationKey {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:notificationKey object:nil];
}


#pragma mark -
#pragma mark Input Provider Registration/Deregistration

- (void)registerInputProvider:(id<IBAInputProvider>)provider forDataType:(NSString *)dataType {
	[inputProviders_ setValue:provider forKey:dataType];
}

- (void)deregisterInputProviderForDataType:(NSString *)dataType {
	[inputProviders_ removeObjectForKey:dataType];
}

- (id<IBAInputProvider>)inputProviderForDataType:(NSString *)dataType {
	return [inputProviders_ objectForKey:dataType];
}


#pragma mark -
#pragma mark Input navigation toolbar actions

- (void)nextPreviousButtonSelected {
	switch (self.inputManagerView.inputNavigationToolbar.nextPreviousButton.selectedSegmentIndex) {
		case IBAInputNavigationToolbarActionPrevious:
			[self activatePreviousInputRequestor];
			break;
		case IBAInputNavigationToolbarActionNext:
			[self activateNextInputRequestor];
			break;
		default:
			break;
	}
}

- (BOOL)deactivateActiveInputRequestor {
	return [self setActiveInputRequestor:nil]; // this deactivates the active input requestor
}


#pragma mark -
#pragma mark Input requestor activation

- (BOOL)activateNextInputRequestor {
	NSAssert(self.inputRequestorDataSource != nil, @"inputRequestorDataSource has not been set");
	id<IBAInputRequestor> inputRequestor = [self.inputRequestorDataSource nextInputRequestor:self.activeInputRequestor];
	return [self setActiveInputRequestor:inputRequestor];
}

- (BOOL)activatePreviousInputRequestor {
	NSAssert(self.inputRequestorDataSource != nil, @"inputRequestorDataSource has not been set");
	id<IBAInputRequestor> inputRequestor = [self.inputRequestorDataSource previousInputRequestor:self.activeInputRequestor];	
	return [self setActiveInputRequestor:inputRequestor];
}


#pragma mark -
#pragma mark Retrieving input providers for input requestors

- (id<IBAInputProvider>)inputProviderForRequestor:(id<IBAInputRequestor>)inputRequestor {
	if (inputRequestor.dataType == nil) {
		NSString *message = [NSString stringWithFormat:@"Data type for input requestor %@ has not been set", inputRequestor];
		NSAssert(NO, message);
	}

	id<IBAInputProvider> provider = [self inputProviderForDataType:inputRequestor.dataType];
	
	if (provider == nil) {
		NSString *message = [NSString stringWithFormat:@"No input provider bound to data type %@", inputRequestor.dataType];
		NSAssert(NO, message);
	}
	
	return provider;
}

- (id<IBAInputProvider>)inputProviderForActiveInputRequestor {
	return [self inputProviderForRequestor:self.activeInputRequestor];
}


#pragma mark -
#pragma mark Presenting the input manager view
- (void)displayInputManagerView {
	if (self.inputManagerView.superview == nil) {	
		// size up the input provider view to our screen and compute the start/end frame origin for our slide up animation
		// compute the start frame
		CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
		CGSize inputManagerViewSize = [self.inputManagerView sizeThatFits:CGSizeZero];
		CGRect startRect = CGRectMake(0.0, screenRect.origin.y + screenRect.size.height, 
									  inputManagerViewSize.width, 
									  inputManagerViewSize.height);
		self.inputManagerView.frame = startRect;
		
		// TODO should add userInfo
		[[NSNotificationCenter defaultCenter] postNotificationName:IBAInputManagerWillShowNotification object:self userInfo:nil];
		
		[[[UIApplication sharedApplication] keyWindow] addSubview:self.inputManagerView];

		// compute the end frame
		CGRect endRect = CGRectMake(0.0, screenRect.origin.y + screenRect.size.height - inputManagerViewSize.height, 
									inputManagerViewSize.width, inputManagerViewSize.height);
		
		// start the slide up animation
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDidStopSelector:@selector(inputManagerViewDidDisplay)];
		
		// we need to perform some post operations after the animation is complete
		[UIView setAnimationDelegate:self];
		
		self.inputManagerView.frame = endRect;
		
		[UIView commitAnimations];
	}
}

- (void)inputManagerViewDidDisplay {
	// TODO should add userInfo
	[[NSNotificationCenter defaultCenter] postNotificationName:IBAInputManagerDidShowNotification object:self userInfo:nil];
}


- (void)hideInputManagerView {
	if (self.inputManagerView.superview != nil) {
		// TODO should add userInfo
		[[NSNotificationCenter defaultCenter] postNotificationName:IBAInputManagerWillHideNotification object:self userInfo:nil];

		CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
		CGRect inputManagerViewEndFrame= self.inputManagerView.frame;
		inputManagerViewEndFrame.origin.y = screenRect.origin.y + screenRect.size.height;

		// start the slide down animation
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		
		// we need to perform some post operations after the animation is complete
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(inputManagerViewDidHide)];
		
		self.inputManagerView.frame = inputManagerViewEndFrame;
		
		[UIView commitAnimations];
	}
}

- (void)inputManagerViewDidHide {
	[self.inputManagerView removeFromSuperview];
	// TODO should add userInfo
	[[NSNotificationCenter defaultCenter] postNotificationName:IBAInputManagerDidHideNotification object:self userInfo:nil];
}


#pragma mark -
#pragma mark Presenting the input provider

- (void)displayInputProvider:(id<IBAInputProvider>)inputProvider {
	self.inputManagerView.inputProviderView = inputProvider.view;
	[self displayInputManagerView];
}


#pragma mark -
#pragma mark Keyboard management

- (void)keyboardWillShow:(NSNotification *)notification {
}

- (void)keyboardDidShow:(NSNotification *)notification {
}

- (void)keyboardWillHide:(NSNotification *)notification {
}

- (void)keyboardDidHide:(NSNotification *)notification {
}

#pragma mark -
#pragma mark Enablement of the input navigation toolbar
- (BOOL)inputNavigationToolbarEnabled {
	return self.inputManagerView.inputNavigationToolbarEnabled;
}

- (void)setInputNavigationToolbarEnabled:(BOOL)enabled {
	self.inputManagerView.inputNavigationToolbarEnabled = enabled;
}

@end
