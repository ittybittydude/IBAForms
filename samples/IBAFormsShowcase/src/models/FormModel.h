//
//  FormModel.h
//  IBAFormsShowcase
//
//  Created by sean on 16/10/10.
//  Copyright 2010 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FormModel : NSObject {
	NSString *text;
	NSString *textStyled;
	NSString *password;
	NSString *passwordStyled;
	NSDate *dateTime;
	NSDate *date;
	NSDate *time;
	NSString *multiLineText;
	NSString *url;
	NSString *urlStyled;
	NSSet *singlePickListItem;
	NSSet *multiplePickListItems;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *textStyled;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *passwordStyled;
@property (nonatomic, retain) NSDate *mandatoryDate;
@property (nonatomic, retain) NSDate *nonMandatoryDate;
@property (nonatomic, retain) NSString *multiLineText;
@property (nonatomic, retain, setter=setURL) NSString *url;
@property (nonatomic, retain, setter=setURLStyled) NSString *urlStyled;
@property (nonatomic, retain) NSSet *singlePickListItem;
@property (nonatomic, retain) NSSet *multiplePickListItems;

@end
