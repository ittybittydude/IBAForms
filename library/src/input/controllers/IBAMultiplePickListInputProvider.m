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

#import "IBAMultiplePickListInputProvider.h"
#import "IBACommon.h"
#import "IBAPickListOptionsProvider.h"

@interface IBAMultiplePickListInputProvider ()
- (NSArray *)pickListOptions;
- (id<IBAPickListOptionsProvider>)pickListOptionsProvider;
@end


@implementation IBAMultiplePickListInputProvider

@synthesize pickListTableView = pickListTableView_;
@synthesize inputRequestor = inputRequestor_;

#pragma mark -
#pragma mark Memory management

- (void)dealloc
{	
	IBA_RELEASE_SAFELY(pickListTableView_);
	
	[super dealloc];
}

- (id)init {
	self = [super init];
	if (self != nil) {
		pickListTableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 216) style:UITableViewStyleGrouped];
		pickListTableView_.dataSource = self;
		pickListTableView_.delegate = self;
		pickListTableView_.backgroundColor = [UIColor viewFlipsideBackgroundColor];

		pickListTableView_.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	}
	
	return self;
}


- (void)setInputRequestor:(id<IBAInputRequestor>)inputRequestor{
	inputRequestor_ = inputRequestor;
	
	if (inputRequestor != nil) {
		[self.pickListTableView reloadData];
		[self.pickListTableView flashScrollIndicators];
	}
}


#pragma mark -
#pragma mark IBAInputProvider

- (UIView *)view {
	return self.pickListTableView;
}


#pragma mark -
#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}

	id<IBAPickListOption> pickListOption = [[self pickListOptions] objectAtIndex:indexPath.row];
	cell.textLabel.text = pickListOption.name;
	cell.imageView.image = pickListOption.iconImage;
	
	NSArray *selectedOptions = self.inputRequestor.inputRequestorValue;
	cell.accessoryType = [selectedOptions containsObject:pickListOption] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self pickListOptions].count;
}

- (id<IBAPickListOptionsProvider>)pickListOptionsProvider {
	return ((id<IBAPickListOptionsProvider>)[self inputRequestor]);
}

- (NSArray *)pickListOptions {
	return [self.pickListOptionsProvider pickListOptions];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSSet *selectedOptions = (NSSet *)self.inputRequestor.inputRequestorValue;
	NSMutableSet *newSelectedOptions = (([[self pickListOptionsProvider] selectionMode] == IBAPickListSelectionModeSingle) ? 
										[NSMutableSet set] : [NSMutableSet setWithSet:selectedOptions]);
	
	id<IBAPickListOption> pickListOption = [[self pickListOptions] objectAtIndex:indexPath.row];

	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
		[newSelectedOptions removeObject:pickListOption];
	} else {
		[newSelectedOptions addObject:pickListOption];
	}
	
	self.inputRequestor.inputRequestorValue = newSelectedOptions;
	
	[[self pickListTableView] reloadData];
}


@end
