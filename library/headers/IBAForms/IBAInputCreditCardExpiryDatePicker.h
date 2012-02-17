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
//
//  Created by Sébastien HOUZE on 18/08/11.
//  Copyright (c) 2011 RezZza. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MONTH_COMPONENT (0)
#define YEAR_COMPONENT  (1)
#define NB_COMPONENT_CCEDP    (2)
#define CREATION_DATE   (2011)
#define IBA_CREDIT_CARD_EXPIRY_DATE_PICKER_YEAR_RANGE (10)
#define IBAInputDatePickerViewRowUpdated @"IBAInputDatePickerViewRowUpdated"

@interface IBAInputCreditCardExpiryDatePicker : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *monthCollection;
    NSArray *yearCollection;
    NSDateComponents *dateComponents;
    NSDate *date;
}

-(NSArray *)createYearArray:(int)year;

@property(nonatomic,retain)NSDate *date;
@property(nonatomic,retain)NSArray *monthCollection;
@property(nonatomic,retain)NSArray *yearCollection;
@property(nonatomic,retain)NSDateComponents *dateComponents;

@end
