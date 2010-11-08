//
//  IBAFormFieldDefaultStyle.h
//  IttyBittyBits
//
//  Created by sean on 26/01/10.
//  Copyright 2010 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBAFormFieldStyle : NSObject {
	UIColor *labelTextColor_;
	UIColor *labelBackgroundColor_;
	UIFont *labelFont_;
	CGRect labelFrame_;
	UITextAlignment labelTextAlignment_;
	
	UIColor *valueTextColor_;
	UIColor *valueBackgroundColor_;
	UIFont *valueFont_;
	CGRect valueFrame_;
	UITextAlignment valueTextAlignment_;

	UIColor *activeColor_;
}

@property (nonatomic, retain) UIColor *labelTextColor;
@property (nonatomic, retain) UIColor *labelBackgroundColor;
@property (nonatomic, retain) UIFont *labelFont;
@property (nonatomic, assign) CGRect labelFrame;
@property (nonatomic, assign) UITextAlignment labelTextAlignment;

@property (nonatomic, retain) UIColor *valueTextColor;
@property (nonatomic, retain) UIColor *valueBackgroundColor;
@property (nonatomic, retain) UIFont *valueFont;
@property (nonatomic, assign) CGRect valueFrame;
@property (nonatomic, assign) UITextAlignment valueTextAlignment;

@property (nonatomic, retain) UIColor *activeColor;

@end
