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
@synthesize headerHeight = headerHeight_;
@synthesize footerHeight = footerHeight_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(formFields_);
	IBA_RELEASE_SAFELY(formFieldStyle_);
	IBA_RELEASE_SAFELY(headerTitle_);
	IBA_RELEASE_SAFELY(footerTitle_);
	IBA_RELEASE_SAFELY(headerView_);
	IBA_RELEASE_SAFELY(footerView_);
	
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"[%@] [HeaderTitle = '%@'] [FooterTitle = '%@']", [self class], [self headerTitle], [self footerTitle]];
}

- (id)initWithHeaderTitle:(NSString *)header footerTitle:(NSString *)footer {
	if ((self = [super init])) {
		self.headerTitle = header;
		self.footerTitle = footer;
		formFields_ = [[NSMutableArray alloc] init];
		headerView_ = nil;
		footerView_ = nil;
        headerHeight_ = UITableViewAutomaticDimension;
        footerHeight_ = UITableViewAutomaticDimension;
	}
  
	return self;
}

- (id)initWithHeaderTitle:(NSString *)header footerTitle:(NSString *)footer headerHeight:(CGFloat)headerHeight footerHeight:(CGFloat)footerHeight {
	if ((self = [super init])) {
		self.headerTitle = header;
		self.footerTitle = footer;
		formFields_ = [[NSMutableArray alloc] init];
		headerView_ = nil;
		footerView_ = nil;
        headerHeight_ = headerHeight;
        footerHeight_ = footerHeight;
	}
  
	return self;
}

- (id)init {
	return [self initWithHeaderTitle:nil footerTitle:nil];
}

- (void)addFormField:(id<IBAFormFieldProtocol>)newFormField {
	if (self.formFieldStyle && nil == newFormField.formFieldStyle) {
		newFormField.formFieldStyle = self.formFieldStyle;
	}
	newFormField.modelManager = self.modelManager;
	[self.formFields addObject:newFormField];
}

@end
