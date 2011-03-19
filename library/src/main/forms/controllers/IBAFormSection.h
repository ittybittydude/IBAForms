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

#import "IBAFormField.h"
#import "IBAFormModelManager.h"

@interface IBAFormSection : NSObject {
	NSMutableArray *formFields_;
	id<IBAFormModelManager> modelManager_;
	IBAFormFieldStyle *formFieldStyle_;
	NSString *headerTitle_;
	NSString *footerTitle_;	
	UIView *headerView_;
	UIView *footerView_;
}

@property (nonatomic, readonly) NSMutableArray *formFields;
@property (nonatomic, assign) id<IBAFormModelManager> modelManager;
@property (nonatomic, retain) IBAFormFieldStyle *formFieldStyle;
@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *footerTitle;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIView *footerView;

- (id)initWithHeaderTitle:(NSString *)header footerTitle:(NSString *)footer;

- (void)addFormField:(IBAFormField *)formField;

@end
