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

#import "IBASinglePickListInputProvider.h"
#import "IBACommon.h"
#import "IBAPickListOptionsProvider.h"

@interface IBASinglePickListInputProvider ()
@property (nonatomic, readonly) UIPickerView *pickerView;
- (NSArray *)pickListOptions;
- (id<IBAPickListOptionsProvider>)pickListOptionsProvider;
- (void)setSelectedOptionWithIndex:(NSInteger)optionIndex;
- (void)setSelectedOption:(id<IBAPickListOption>)selectedOption;
- (void)updateSelectedOption;
@end


@implementation IBASinglePickListInputProvider

@synthesize pickerView = pickerView_;
@synthesize inputRequestor = inputRequestor_;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {	
	IBA_RELEASE_SAFELY(pickerView_);
	
	[super dealloc];
}

- (id)init {
	self = [super init];
	if (self != nil) {
		pickerView_ = [[UIPickerView alloc] init];
    pickerView_.showsSelectionIndicator = YES;
		pickerView_.dataSource = self;
		pickerView_.delegate = self;
	}
	
	return self;
}


- (void)setInputRequestor:(id<IBAInputRequestor>)inputRequestor {
	inputRequestor_ = inputRequestor;
	
	if (inputRequestor != nil) {
		[self.pickerView reloadAllComponents];
    [self updateSelectedOption];
	}
}


- (id<IBAPickListOptionsProvider>)pickListOptionsProvider {
	return ((id<IBAPickListOptionsProvider>)self.inputRequestor);
}


- (NSArray *)pickListOptions {
	return [self.pickListOptionsProvider pickListOptions];
}


#pragma mark -
#pragma mark IBAInputProvider

- (UIView *)view {
	return self.pickerView;
}


#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1; 
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return self.pickListOptions.count;
}


#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  id<IBAPickListOption> pickListOption = [self.pickListOptions objectAtIndex:row];
  return pickListOption.name;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  [self setSelectedOptionWithIndex:row];
}


#pragma mark -
#pragma mark Selection helpers

- (void)setSelectedOptionWithIndex:(NSInteger)optionIndex {
  id<IBAPickListOption> selectedOption = [self.pickListOptions objectAtIndex:optionIndex];
  [self setSelectedOption:selectedOption];
}


- (void)setSelectedOption:(id<IBAPickListOption>)selectedOption {
  self.inputRequestor.inputRequestorValue = [NSSet setWithObject:selectedOption]; 
}

- (void)updateSelectedOption {
  // Updates the UI to display the selected option, or defaults to the first option if none are already selected
  id<IBAPickListOption> selectedPickListOption = [self.inputRequestor.inputRequestorValue anyObject];
  if (nil != selectedPickListOption) {
    NSInteger selectedRow = [self.pickListOptions indexOfObject:selectedPickListOption];
    [self.pickerView selectRow:selectedRow inComponent:0 animated:YES];
  } else {
    [self setSelectedOptionWithIndex:0];
  } 
}

@end
