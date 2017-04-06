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

#import <Foundation/Foundation.h>
#import "IBAFormFieldProtocol.h"
#import "IBACommon.h"

@interface IBAFormField : NSObject <IBAFormFieldProtocol> {
	NSString *keyPath_;
	NSString *title_;
	id<IBAFormModelManager> modelManager_;
	id<IBAFormFieldDelegate> delegate_;
	IBAFormFieldStyle *formFieldStyle_;
	BOOL nullable_;
	NSValueTransformer *valueTransformer_;
    CGFloat cellHeight_;
}

@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, getter=isNullable) BOOL nullable;
@property (nonatomic, retain) NSValueTransformer *valueTransformer;


- (id)initWithKeyPath:(NSString *)keyPath title:(NSString *)title valueTransformer:(NSValueTransformer *)valueTransformer;
- (id)initWithKeyPath:(NSString *)keyPath title:(NSString *)title;
- (id)initWithKeyPath:(NSString*)keyPath;
- (id)initWithTitle:(NSString*)title;


#pragma mark -
#pragma mark Getting and setting the form field value
- (id)formFieldValue;
- (NSString *)formFieldStringValue;
- (BOOL)setFormFieldValue:(id)formVieldValue;

@end