//
//  ShowcaseViewController.m
//  IBAFormsShowcase
//
//  Created by sean on 15/10/10.
//  Copyright 2010 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "FormController.h"


@implementation FormController

- (void)loadView;
{
	[super loadView];

	UITableView *formTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320., 460.) style:UITableViewStyleGrouped] autorelease];
	[formTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

	[self setTableView:formTableView];
	[self setView:formTableView];
}


@end
