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

#import "IBACommon.h"

#define IBAFormFieldCellTextColor [UIColor colorWithRed:0.464 green:0.750 blue:0.775 alpha:1.000]
#define IBAFormFieldCellBackgoundColor [UIColor whiteColor]
#define IBAFormFieldActiveColor [UIColor colorWithRed:0.893 green:0.976 blue:0.976 alpha:1.000]

// Notifications
#define IBAPushViewController @"IBAPushViewController"
#define IBAPresentModalViewController @"IBAPresentModalViewController"
#define IBADismissModalViewController @"IBADismissModalViewController"
#define IBAViewControllerKey @"IBAViewControllerKey"
#define IBAInputRequestorFormFieldActivated @"IBAInputRequestorFormFieldActivated"
#define IBAInputRequestorFormFieldDeactivated @"IBAInputRequestorFormFieldDeactivated"
#define IBAFormFieldKey @"IBAFormFieldKey"

// Form field label style
#define IBAFormFieldLabelX 10
#define IBAFormFieldLabelY 5
#define IBAFormFieldLabelWidth 60
#define IBAFormFieldLabelHeight 30
#define IBAFormFieldLabelFont [UIFont systemFontOfSize:12]
#define IBAFormFieldLabelTextColor [UIColor grayColor]
#define IBAFormFieldLabelTextAlignment UITextAlignmentRight
#define IBAFormFieldLabelBackgroundColor [UIColor whiteColor]

// Form field value style
#define IBAFormFieldValueX 75
#define IBAFormFieldValueY 10
#define IBAFormFieldValueWidth 235
#define IBAFormFieldValueHeight 26
#define IBAFormFieldValueFont [UIFont systemFontOfSize:16]
#define IBAFormFieldValueTextColor [UIColor blackColor]
#define IBAFormFieldValueTextAlignment UITextAlignmentLeft
#define IBAFormFieldValueBackgroundColor [UIColor whiteColor]
