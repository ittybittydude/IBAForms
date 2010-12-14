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

	UITableView *formTableView = [[[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped] autorelease];
	[formTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

	[self setTableView:formTableView];
	[self setView:formTableView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
