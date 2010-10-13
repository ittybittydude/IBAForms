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

#import "IBAFormSection.h"
#import "IBACommon.h"

@implementation IBAFormSection

@synthesize headerTitle;
@synthesize footerTitle;
@synthesize formFields;
@synthesize modelManager;
@synthesize formFieldStyle;

- (void)dealloc {
	IBA_RELEASE_SAFELY(headerTitle);
	IBA_RELEASE_SAFELY(footerTitle);
	IBA_RELEASE_SAFELY(formFields);
	IBA_RELEASE_SAFELY(modelManager);
	IBA_RELEASE_SAFELY(formFieldStyle);
	
	[super dealloc];
}

- (id)initWithHeaderTitle:(NSString *)header footerTitle:(NSString *)footer {
	self = [super init];
	if (self != nil) {
		self.headerTitle = header;
		self.footerTitle = footer;
		formFields = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (id)init {
	return [self initWithHeaderTitle:nil footerTitle:nil];
}


- (void)addFormField:(IBAFormField *)newFormField {
	newFormField.formFieldStyle = self.formFieldStyle;
	newFormField.modelManager = self.modelManager;
	[self.formFields addObject:newFormField];
}

- (UIView *)headerView {
	return nil;
}

- (UIView *)footerView {
	return nil;	
}


@end
