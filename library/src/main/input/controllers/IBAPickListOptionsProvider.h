//
//  IBAPickListOptionsProvider.h
//  IBAForms
//
//  Created by sean on 18/10/10.
//  Copyright 2010 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	IBAPickListSelectionModeSingle = 0,
	IBAPickListSelectionModeMultiple,
} IBAPickListSelectionMode;

@protocol IBAPickListOptionsProvider
- (NSArray *)pickListOptions;
- (IBAPickListSelectionMode)selectionMode;
@end

@protocol IBAPickListOption <NSObject>
- (UIImage *)iconImage;
- (NSString *)name;
@end

