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
    UITableView *tableView_;
    
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSMutableArray *sections;
@property (nonatomic, retain, readonly) id model;
@property (nonatomic, retain) IBAFormFieldStyle *formFieldStyle;
@property (nonatomic, retain) UITableView *tableView;

- (id)initWithModel:(id)model;

#pragma mark -
#pragma mark Section and field management

- (NSInteger)sectionCount;

- (IBAFormSection*)createSectionWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle;

- (IBAFormSection *)addSectionWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle;
- (IBAFormSection *)addSectionWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle headerHeight:(CGFloat)headerHeight footerHeight:(CGFloat)footerHeight;

// inserting sections
- (void)insertWithAnimation:(UITableViewRowAnimation*)animation section:(IBAFormSection *)newSection;
- (void)insertWithAnimation:(UITableViewRowAnimation*)animation sections:(IBAFormSection *)firstSection, ... NS_REQUIRES_NIL_TERMINATION;
- (void)insertWithAnimation:(UITableViewRowAnimation*)animation atIndex:(NSInteger)index section:(IBAFormSection *)newSection;
- (void)insertWithAnimation:(UITableViewRowAnimation*)animation atIndexes:(NSIndexSet*)indexes sections:(IBAFormSection *)firstSection, ... NS_REQUIRES_NIL_TERMINATION;
- (void)insertOnceWithAnimation:(UITableViewRowAnimation*)animation section:(IBAFormSection *)newSection;
- (void)insertOnceWithAnimation:(UITableViewRowAnimation*)animation sections:(IBAFormSection *)firstSection, ... NS_REQUIRES_NIL_TERMINATION;
- (void)insertOnceWithAnimation:(UITableViewRowAnimation*)animation atIndex:(NSInteger)index section:(IBAFormSection *)newSection;
- (void)insertOnceWithAnimation:(UITableViewRowAnimation*)animation atIndexes:(NSIndexSet*)indexes sections:(IBAFormSection *)firstSection, ... NS_REQUIRES_NIL_TERMINATION;

// removing sections
- (void)removeWithAnimation:(UITableViewRowAnimation*)animation section:(IBAFormSection *)section;
- (void)removeWithAnimation:(UITableViewRowAnimation*)animation sections:(IBAFormSection *)firstSection, ... NS_REQUIRES_NIL_TERMINATION;

// inserting and removing sections
- (void)setWithAnimation:(UITableViewRowAnimation*)animation sections:(IBAFormSection *)firstSection, ... NS_REQUIRES_NIL_TERMINATION;

- (UIView *)viewForFooterInSection:(NSInteger)section;
- (UIView *)viewForHeaderInSection:(NSInteger)section;

- (CGFloat)heightForHeaderInSection:(NSInteger)section;

- (CGFloat)heightForFooterInSection:(NSInteger)section;

- (NSInteger)numberOfFormFieldsInSection:(NSInteger)section;
- (UITableViewCell *)cellForFormFieldAtIndexPath:(NSIndexPath *)indexPath;
- (id<IBAFormFieldProtocol>)formFieldAtIndexPath:(NSIndexPath *)indexPath;
- (id<IBAFormFieldProtocol>)formFieldAfter:(id<IBAFormFieldProtocol>)field;
- (id<IBAFormFieldProtocol>)formFieldBefore:(id<IBAFormFieldProtocol>)field;
- (NSIndexPath *)indexPathForFormField:(id<IBAFormFieldProtocol>)formField;
- (NSInteger)indexForFormSection:(IBAFormSection*)section;

@end
