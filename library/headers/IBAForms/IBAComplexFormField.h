//
//  HPFormFieldWithMultipleKeyPath.h
//  Hemophilia
//
//  Created by Konstantin on 21.08.13.
//  Copyright (c) 2013 HintSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAFormFieldProtocol.h"
#import "IBACommon.h"

@interface IBAComplexFormField : NSObject <IBAFormFieldProtocol> {
    NSArray *keyPaths_;
	NSString *title_;
	__unsafe_unretained id<IBAFormModelManager> modelManager_;
	__unsafe_unretained id<IBAFormFieldDelegate> delegate_;
	IBAFormFieldStyle *formFieldStyle_;
	BOOL nullable_;
	NSArray *valueTransformers_;
    CGFloat cellHeight_;
    NSString* valuesSeparator_;
}
@property (nonatomic, copy) NSArray *keyPaths;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, getter=isNullable) BOOL nullable;
@property (nonatomic, retain) NSArray *valueTransformers;
@property (nonatomic, retain) NSString* valuesSeparator;


- (id)initWithKeyPaths:(NSArray *)keyPaths title:(NSString *)title valueTransformers:(NSArray *)valueTransformers;
- (id)initWithKeyPaths:(NSArray *)keyPaths title:(NSString *)title;
- (id)initWithKeyPaths:(NSArray*)keyPaths;
- (id)initWithTitle:(NSString*)title;

#pragma mark -
#pragma mark Getting and setting the form field value
- (NSArray*)formFieldValues;
- (NSString *)formFieldStringValue;
- (BOOL)setFormFieldValues:(NSArray*)formVieldValues;

@end