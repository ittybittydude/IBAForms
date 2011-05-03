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

#import "ShowcaseController.h"
#import "SampleFormDataSource.h"
#import "SampleFormController.h"
#import "ShowcaseModel.h"

@implementation ShowcaseController

- (void)loadView {
	[super loadView];
	
	UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithTitle:@"Back"
																	style:UIBarButtonItemStyleBordered 
																   target:nil 
																   action:nil] autorelease];
	self.navigationItem.backBarButtonItem = backButton;
	
	UIView *view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	[view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	
	UITableView *showcaseTableView = [[[UITableView alloc] initWithFrame:[view bounds] style:UITableViewStyleGrouped] autorelease];
	[showcaseTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self setTableView:showcaseTableView];
	
	[view addSubview:showcaseTableView];
	[self setView:view];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait) || [((ShowcaseModel *)self.formDataSource.model) shouldAutoRotate];
}

@end
