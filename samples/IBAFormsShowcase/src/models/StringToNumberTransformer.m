//
//  StringToNumberTransformer.m
//  IBAFormsShowcase
//
//  Created by sean on 2/11/10.
//  Copyright 2010 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "StringToNumberTransformer.h"

@implementation StringToNumberTransformer

+ (id)instance {
	return [[[[self class] alloc] init] autorelease];
}

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSNumber class];
}

- (NSNumber *)transformedValue:(NSString *)value {
	return [NSNumber numberWithInteger:[value integerValue]];
}

- (NSString *)reverseTransformedValue:(NSNumber *)value {
	return [value stringValue];
}

@end
