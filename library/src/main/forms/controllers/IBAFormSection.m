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

@synthesize formFields = formFields_;
@synthesize modelManager = modelManager_;
@synthesize formFieldStyle = formFieldStyle_;
@synthesize headerTitle = headerTitle_;
@synthesize footerTitle = footerTitle_;
@synthesize headerView = headerView_;
@synthesize footerView = footerView_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(formFields_);
	IBA_RELEASE_SAFELY(formFieldStyle_);
	IBA_RELEASE_SAFELY(headerTitle_);
	IBA_RELEASE_SAFELY(footerTitle_);
	IBA_RELEASE_SAFELY(headerView_);
	IBA_RELEASE_SAFELY(footerView_);
	
	[super dealloc];
}

- (id)initWithHeaderTitle:(NSString *)header footerTitle:(NSString *)footer {
	self = [super init];
	if (self != nil) {
		self.headerTitle = header;
		self.footerTitle = footer;
		formFields_ = [[NSMutableArray alloc] init];
		headerView_ = nil;
		footerView_ = nil;
	}
  
	return self;
}

- (id)init {
	return [self initWithHeaderTitle:nil footerTitle:nil];
}

- (void)addFormField:(IBAFormField *)newFormField {
	if (self.formFieldStyle && nil == newFormField.formFieldStyle) {
		newFormField.formFieldStyle = self.formFieldStyle;
	}
	newFormField.modelManager = self.modelManager;
	[self.formFields addObject:newFormField];
}

@end
