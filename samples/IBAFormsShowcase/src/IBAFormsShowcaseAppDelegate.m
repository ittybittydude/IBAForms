//
//  IBAFormsShowcaseAppDelegate.m
//  IBAFormsShowcase
//
//  Created by sean on 15/10/10.
//  Copyright 2010 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "IBAFormsShowcaseAppDelegate.h"
#import "FormController.h"
#import "FormModel.h"
#import "FormDataSource.h"

@interface IBAFormsShowcaseAppDelegate ()
@property (nonatomic, retain) IBOutlet UIWindow *window;
@end


@implementation IBAFormsShowcaseAppDelegate

@synthesize window;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	FormModel *formModel = [[FormModel alloc] init];
	FormDataSource *formDataSource = [[FormDataSource alloc] initWithModel:formModel];
	FormController *formController = [[FormController alloc] initWithNibName:nil bundle:nil formDataSource:formDataSource];
	[formController setTitle:@"IBAForms Showcase"];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:formController];
	
	[self setWindow:[[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease]];
	[[self window] setRootViewController:navController];
	[[self window] makeKeyAndVisible];
	
	[formDataSource release];
	[formModel release];
	[navController release];

    return YES;
}

- (void)dealloc {
    [self setWindow:nil];
	
    [super dealloc];
}

@end
