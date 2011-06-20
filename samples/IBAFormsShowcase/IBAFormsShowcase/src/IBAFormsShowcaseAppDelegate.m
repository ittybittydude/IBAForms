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

#import "IBAFormsShowcaseAppDelegate.h"
#import "ShowcaseModel.h"
#import "ShowcaseFormDataSource.h"
#import "ShowcaseController.h"


@interface IBAFormsShowcaseAppDelegate ()
@property (nonatomic, retain) IBOutlet UIWindow *window;
@end


@implementation IBAFormsShowcaseAppDelegate

@synthesize window;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

	ShowcaseModel *showcaseModel = [[[ShowcaseModel alloc] init] autorelease];
	ShowcaseFormDataSource *showcaseDataSource = [[[ShowcaseFormDataSource alloc] initWithModel:showcaseModel] autorelease];
	ShowcaseController *showcaseController = [[[ShowcaseController alloc] initWithNibName:nil bundle:nil formDataSource:showcaseDataSource] autorelease];
	[showcaseController setTitle:@"IBAForms Showcase"];
	
	UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:showcaseController] autorelease];
	
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
