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
#import "IBAFormFieldStyle.h"

@class IBAFormField;

@interface IBAFormFieldCell : UITableViewCell {
	UIView *inputView_;
	UIView *inputAccessoryView_;
	UIView *cellView_;
	UILabel *label_;
	IBAFormFieldStyle *formFieldStyle_;
	BOOL styleApplied_;
	BOOL active_;
	
	@private
	UIView *hiddenCellCache_;
}

@property (readwrite, retain) UIView *inputView;
@property (readwrite, retain) UIView *inputAccessoryView;
@property (nonatomic, retain) UIView *cellView;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) IBAFormFieldStyle *formFieldStyle;
@property (nonatomic, assign) BOOL styleApplied;
@property (nonatomic, assign) UIView *hiddenCellCache;


- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)activate;
- (void)deactivate;

- (void)applyFormFieldStyle;
- (void)applyActiveStyle;
- (void)updateActiveStyle;

@end
