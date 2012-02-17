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
#import "IBAInputProvider.h"

typedef enum {
    IBADatePickerModeTime = UIDatePickerModeTime,           // Displays hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. 6 | 53 | PM)
    IBADatePickerModeDate = UIDatePickerModeDate,           // Displays month, day, and year depending on the locale setting (e.g. November | 15 | 2007)
    IBADatePickerModeDateAndTime = UIDatePickerModeDateAndTime,    // Displays date, hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. Wed Nov 15 | 6 | 53 | PM)
    IBADatePickerModeCountDownTimer = UIDatePickerModeCountDownTimer,  // Displays hour and minute (e.g. 1 | 53)
    IBADatePickerModeMonthAndYear =
    UIDatePickerModeCountDownTimer + 1
}  IBADatePickerMode;

@interface IBADateInputProvider : NSObject <IBAInputProvider> {
	UIView *datePickerView_;
	IBADatePickerMode datePickerMode_;
	UIView *datePicker_;
	id<IBAInputRequestor> inputRequestor_;
}

@property (nonatomic, assign) IBADatePickerMode datePickerMode;

- (id)initWithDatePickerMode:(IBADatePickerMode)datePickerMode;

@end
