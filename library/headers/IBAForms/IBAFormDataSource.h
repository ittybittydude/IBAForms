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

#import <UIKit/UIKit.h>
#import "IBAFormSection.h"
#import "IBAFormFieldStyle.h"

@interface IBAFormDataSource : NSObject <UITableViewDataSource, IBAFormModelManager> {
	NSString *name_;
	id model_; // the underlying object this datasource represents
	NSMutableArray *sections_;
	IBAFormFieldStyle *formFieldStyle_;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSMutableArray *sections;
@property (nonatomic, retain, readonly) id model;
@property (nonatomic, retain) IBAFormFieldStyle *formFieldStyle;

- (id)initWithModel:(id)model;

#pragma mark -
#pragma mark Section and field management

- (NSInteger)sectionCount;
- (IBAFormSection *)addSectionWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle;
- (void)addSection:(IBAFormSection *)section;

- (UIView *)viewForFooterInSection:(NSInteger)section;
- (UIView *)viewForHeaderInSection:(NSInteger)section;

- (NSInteger)numberOfFormFieldsInSection:(NSInteger)section;
- (UITableViewCell *)cellForFormFieldAtIndexPath:(NSIndexPath *)indexPath;
- (IBAFormField *)formFieldAtIndexPath:(NSIndexPath *)indexPath;
- (IBAFormField *)formFieldAfter:(IBAFormField *)field;
- (IBAFormField *)formFieldBefore:(IBAFormField *)field;
- (NSIndexPath *)indexPathForFormField:(IBAFormField *)formField;

@end
