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

#import <IBAForms/IBAFormConstants.h>
#import "ShowcaseFieldStyle.h"


@implementation ShowcaseFieldStyle

- (id)init {
	if (self = [super init]) {
		self.labelTextColor = [UIColor blackColor];
		self.labelFont = [UIFont boldSystemFontOfSize:18];
		self.labelTextAlignment = UITextAlignmentLeft;
		self.labelFrame = CGRectMake(IBAFormFieldLabelX, 8, 140, IBAFormFieldLabelHeight);
		self.valueTextAlignment = UITextAlignmentRight;
		self.valueTextColor = [UIColor colorWithRed:0.220 green:0.329 blue:0.529 alpha:1.0];
		self.valueFont = [UIFont systemFontOfSize:16];
		self.valueFrame = CGRectMake(160, 13, 150, IBAFormFieldValueHeight);
	}
	
	return self;
}

@end
