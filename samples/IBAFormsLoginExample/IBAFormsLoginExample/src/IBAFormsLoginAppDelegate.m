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

#import "IBAFormsLoginAppDelegate.h"

#import <IBAForms/IBAButtonFormField.h>

#import "LoginFormController.h"
#import "LoginDataSource.h"
#import "Credentials.h"

@interface IBAFormsLoginAppDelegate ()
@property (nonatomic, retain, readwrite) UIWindow *mainWindow;
@end

@implementation IBAFormsLoginAppDelegate

@synthesize mainWindow = mainWindow_;

- (void)dealloc {
	[mainWindow_ release];
	[super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// =====================================================================================================
	// STEP 1 - Setup model class.
	// =====================================================================================================
	Credentials *user_credential = [[Credentials alloc] init];
	[user_credential setEmailAddress:@"john.appleseed@apple.com"];
	[user_credential setPassword:@"apple"];

	// =====================================================================================================
	// STEP 2 - Setup data source.
	// =====================================================================================================
	IBAButtonFormFieldBlock login_action = ^{
		UIAlertView *alert_view = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login Successful", @"")
															 message:[user_credential description]
															delegate:nil
												   cancelButtonTitle:NSLocalizedString(@"OK", @"")
												   otherButtonTitles:nil];
		[alert_view show];
		[alert_view release];
	};
	LoginDataSource *auth_data_source = [[LoginDataSource alloc] initWithModel:user_credential formAction:login_action];

	// =====================================================================================================
	// STEP 3 - Setup form controller.
	// =====================================================================================================
	LoginFormController *auth_form_controller = [[LoginFormController alloc] initWithNibName:nil
                                                                                      bundle:nil
                                                                              formDataSource:auth_data_source];
	[auth_form_controller setTitle:NSLocalizedString(@"Sample Login Form", @"")];
	UINavigationController *navigation_controller = [[UINavigationController alloc] initWithRootViewController:auth_form_controller];

	// =====================================================================================================
	// STEP 4 - Setup the main window.
	// =====================================================================================================
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self setMainWindow:window];
	[window release], window = nil;

	[[self mainWindow] setBackgroundColor:[UIColor blackColor]];
	[[self mainWindow] setRootViewController:navigation_controller];
	[[self mainWindow] makeKeyAndVisible];

	// =====================================================================================================
	// STEP 5 - Clean up.
	// =====================================================================================================
	[user_credential release];
	[auth_data_source release];
	[auth_form_controller release];
	[navigation_controller release];

	return YES;
}

@end
