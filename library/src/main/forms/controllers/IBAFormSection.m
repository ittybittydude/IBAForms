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

@synthesize headerTitle = headerTitle_;
@synthesize footerTitle = footerTitle_;
@synthesize formFields = formFields_;
@synthesize modelManager = modelManager_;
@synthesize formFieldStyle = formFieldStyle_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(headerTitle_);
	IBA_RELEASE_SAFELY(footerTitle_);
	IBA_RELEASE_SAFELY(formFields_);
	IBA_RELEASE_SAFELY(formFieldStyle_);

	[super dealloc];
}

- (id)initWithHeaderTitle:(NSString *)header footerTitle:(NSString *)footer {
	self = [super init];
	if (self != nil) {
		self.headerTitle = header;
		self.footerTitle = footer;
		formFields_ = [[NSMutableArray alloc] init];
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
