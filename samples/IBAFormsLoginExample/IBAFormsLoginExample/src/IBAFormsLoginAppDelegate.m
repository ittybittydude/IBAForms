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
#import <IBAForms/IBAInputManager.h>

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
	Credentials *userCredentials = [[[Credentials alloc] init] autorelease];
	[userCredentials setEmailAddress:@"john.appleseed@apple.com"];
	[userCredentials setPassword:@"apple"];

	// =====================================================================================================
	// STEP 2 - Setup data source.
	// =====================================================================================================
	IBAButtonFormFieldBlock loginAction = ^{
		[[IBAInputManager sharedIBAInputManager] performSelector:@selector(setActiveInputRequestor:)
													  withObject:nil
													  afterDelay:1.];

		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login Successful", @"")
                                                            message:[userCredentials description]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	};
	LoginDataSource *loginDataSource = [[[LoginDataSource alloc] initWithModel:userCredentials formAction:loginAction] autorelease];

	// =====================================================================================================
	// STEP 3 - Setup form controller.
	// =====================================================================================================
	LoginFormController *loginFormController = [[[LoginFormController alloc] initWithNibName:nil
                                                                                      bundle:nil
                                                                              formDataSource:loginDataSource] autorelease];
	[loginFormController setTitle:NSLocalizedString(@"Sample Login Form", @"")];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:loginFormController] autorelease];

	// =====================================================================================================
	// STEP 4 - Setup the main window.
	// =====================================================================================================
	[self setMainWindow:[[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease]];
	[[self mainWindow] setBackgroundColor:[UIColor blackColor]];
	[[self mainWindow] setRootViewController:navigationController];
	[[self mainWindow] makeKeyAndVisible];

	return YES;
}

@end
