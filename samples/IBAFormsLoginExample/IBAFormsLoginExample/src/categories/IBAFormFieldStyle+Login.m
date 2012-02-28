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

#import "IBAFormFieldStyle+Login.h"
#import <IBAForms/IBAFormConstants.h>

@implementation IBAFormFieldStyle (Authentication)

+ (IBAFormFieldStyle *)buttonFormFieldStyle {
	IBAFormFieldStyle *style = [[[IBAFormFieldStyle alloc] init] autorelease];

	[style setLabelTextColor:[UIColor colorWithRed:.318 green:.4 blue:.569 alpha:1.]];
	[style setLabelFont:[UIFont boldSystemFontOfSize:14.]];
	[style setLabelFrame:CGRectMake(10., 8., 300., 30.)];
	[style setLabelTextAlignment:UITextAlignmentCenter];
	[style setLabelAutoresizingMask:UIViewAutoresizingFlexibleWidth];

	return style;
}

+ (IBAFormFieldStyle *)textFormFieldStyle {
	IBAFormFieldStyle *style = [[[IBAFormFieldStyle alloc] init] autorelease];

	[style setLabelTextColor:[UIColor blackColor]];
	[style setLabelFont:[UIFont boldSystemFontOfSize:18.]];
	[style setLabelTextAlignment:UITextAlignmentLeft];
	[style setLabelFrame:CGRectMake(IBAFormFieldLabelX, 8., 140., IBAFormFieldLabelHeight)];

	[style setValueTextAlignment:UITextAlignmentRight];
	[style setValueTextColor:[UIColor colorWithRed:0.22 green:0.329 blue:0.529 alpha:1.]];
	[style setValueFont:[UIFont systemFontOfSize:16.]];
	[style setValueFrame:CGRectMake(160., 13., 150., IBAFormFieldValueHeight)];

	return style;
}

@end
