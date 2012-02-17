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
#import "IBAInputCreditCardExpiryDatePicker.h"

@interface IBADateInputProvider ()
@property (nonatomic, readonly) UIView *datePickerView;
@property (nonatomic, readonly) UIView *datePicker;
- (void)datePickerValueChanged;
@end


@implementation IBADateInputProvider

@synthesize inputRequestor = inputRequestor_;
@synthesize datePickerMode = datePickerMode_;
@synthesize datePicker = datePicker_;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	IBA_RELEASE_SAFELY(datePickerView_);
	IBA_RELEASE_SAFELY(datePicker_);
	
	[super dealloc];
}

- (id)init {
	return [self initWithDatePickerMode:IBADatePickerModeDate];
}

- (id)initWithDatePickerMode:(IBADatePickerMode)datePickerMode {
	if ((self = [super init])) {
		self.datePickerMode = datePickerMode;
	}
	
	return self;
}


#pragma mark -
#pragma mark Accessors

- (UIView *)datePickerView {
	if (datePickerView_ == nil) {
		datePickerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
		datePickerView_.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		datePickerView_.backgroundColor = [UIColor viewFlipsideBackgroundColor];

        if(self.datePickerMode == IBADatePickerModeMonthAndYear)
        {
            datePicker_ = [[IBAInputCreditCardExpiryDatePicker alloc] init];
            
            datePicker_.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(datePickerValueChanged) name:IBAInputDatePickerViewRowUpdated object:((IBAInputCreditCardExpiryDatePicker *)datePicker_)];

            [datePickerView_ addSubview:datePicker_];
            [datePicker_ sizeToFit];

        }
        else
        {
            datePicker_ = [[UIDatePicker alloc] init];
            ((UIDatePicker *)datePicker_).datePickerMode = (UIDatePickerMode)self.datePickerMode;
            ((UIDatePicker *)datePicker_).minuteInterval = 5;
            datePicker_.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
            [((UIDatePicker *)datePicker_) addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
            
            [datePickerView_ addSubview:datePicker_];
            [datePicker_ sizeToFit];
        }
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
	inputRequestor_.inputRequestorValue = ((UIDatePicker *)self.datePicker).date;
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
        if(self.datePickerMode == IBADatePickerModeMonthAndYear)
        {
            
        }
        else
            [((UIDatePicker *)self.datePicker) setDate:date animated:YES];
	}
}

@end
