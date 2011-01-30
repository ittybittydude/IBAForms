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

#import "IBADateInputProvider.h"
#import "IBACommon.h"

@interface IBADateInputProvider ()
- (void)datePickerValueChanged;
@end


@implementation IBADateInputProvider

@synthesize inputRequestor = inputRequestor_;
@synthesize datePickerMode = datePickerMode_;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	IBA_RELEASE_SAFELY(datePickerView_);
	
	[super dealloc];
}

- (id)init {
	return [self initWithDatePickerMode:UIDatePickerModeDate];
}

- (id)initWithDatePickerMode:(UIDatePickerMode)datePickerMode {
	self = [super init];
	if (self != nil) {
		self.datePickerMode = datePickerMode;
	}
	
	return self;
}


#pragma mark -
#pragma mark Accessors

- (UIDatePicker *)datePickerView {
	if (datePickerView_ == nil) {
		datePickerView_ = [[UIDatePicker alloc] init];
		datePickerView_.datePickerMode = self.datePickerMode;
		datePickerView_.minuteInterval = 5;
		[datePickerView_ addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];		
	}
	
	return datePickerView_;
}


#pragma mark -
#pragma mark IBAInputProvider

- (UIView *)view {
	return self.datePickerView;
}


#pragma mark -
#pragma mark Date value change management

- (void)datePickerValueChanged {
	inputRequestor_.inputRequestorValue = self.datePickerView.date;
}


- (void)setInputRequestor:(id<IBAInputRequestor>)inputRequestor {
	inputRequestor_ = inputRequestor;
	
	if (inputRequestor != nil) {
		// update the date picker's value with that of the new inputRequestors current value
		NSDate *date = inputRequestor.inputRequestorValue;
		if (date == nil) {
			date = inputRequestor.defaultInputRequestorValue;
			inputRequestor.inputRequestorValue = date;
		}
		
		[self.datePickerView setDate:date animated:YES];
	}
}

@end
