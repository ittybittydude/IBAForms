//
//  IBAFormsShowcaseAppDelegate.m
//  IBAFormsShowcase
//
//  Created by sean on 15/10/10.
//  Copyright 2010 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "IBAFormsShowcaseAppDelegate.h"
#import "FormController.h"
#import "FormDataSource.h"

@interface IBAFormsShowcaseAppDelegate ()
@property (nonatomic, retain) IBOutlet UIWindow *window;
@end


@implementation IBAFormsShowcaseAppDelegate

@synthesize window;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	NSMutableDictionary *formModel = [[[NSMutableDictionary alloc] init] autorelease];
	FormDataSource *formDataSource = [[[FormDataSource alloc] initWithModel:formModel] autorelease];
	FormController *formController = [[[FormController alloc] initWithNibName:nil bundle:nil formDataSource:formDataSource] autorelease];
	[formController setTitle:@"IBAForms Showcase"];
	UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:formController] autorelease];
	
	[self setWindow:[[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease]];
	[[self window] setRootViewController:navController];
	[[self window] makeKeyAndVisible];
	
    return YES;
}

- (void)dealloc {
    [self setWindow:nil];
	
    [super dealloc];
}

@end
