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
#import "IBABooleanSwitchCell.h"

typedef enum {
	IBABooleanFormFieldTypeSwitch = 0,
	IBABooleanFormFieldTypeCheck,
} IBABooleanFormFieldType;


@interface IBABooleanFormField : IBAFormField {
	IBABooleanSwitchCell *switchCell_;
	IBAFormFieldCell *checkCell_;
	IBABooleanFormFieldType booleanFormFieldType_;
}

@property (nonatomic, readonly) IBABooleanSwitchCell *switchCell;
@property (nonatomic, readonly) IBAFormFieldCell *checkCell;
@property (nonatomic, assign) IBABooleanFormFieldType booleanFormFieldType;

- (id)initWithKeyPath:(NSString *)keyPath title:(NSString *)title type:(IBABooleanFormFieldType)booleanFormFieldType;
- (id)initWithKeyPath:(NSString *)keyPath title:(NSString *)title valueTransformer:(NSValueTransformer *)valueTransformer type:(IBABooleanFormFieldType)booleanFormFieldType;

@end
