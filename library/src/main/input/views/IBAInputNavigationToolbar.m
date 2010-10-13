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

#import "IBAInputNavigationToolbar.h"
#import "IBACommon.h"

#define IBAInputNavigationToolbarNextTitle @"Next"
#define IBAInputNavigationToolbarPreviousTitle @"Previous"

@implementation IBAInputNavigationToolbar

@synthesize doneButton;
@synthesize nextPreviousButton;

- (void)dealloc {
	IBA_RELEASE_SAFELY(doneButton);
	IBA_RELEASE_SAFELY(nextPreviousButton);
	
	[super dealloc];
}


- (id)initWithFrame:(CGRect)aRect {
	if (self = [super initWithFrame:(CGRect)aRect]) {
		self.barStyle = UIBarStyleBlack;
		
		doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																   target:nil 
																   action:nil];
		
		nextPreviousButton = [[UISegmentedControl alloc] initWithItems:[NSArray 
					arrayWithObjects:IBAInputNavigationToolbarPreviousTitle, IBAInputNavigationToolbarNextTitle, nil]];
		nextPreviousButton.segmentedControlStyle = UISegmentedControlStyleBar;
		nextPreviousButton.tintColor = [UIColor blackColor];
		nextPreviousButton.momentary = YES;
		
		UIBarButtonItem *nextPreviousBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextPreviousButton];
		
		UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		
		[self setItems:[NSArray arrayWithObjects:doneButton, flexibleSpace, nextPreviousBarButtonItem, nil] animated:YES];
		[flexibleSpace release];
		[nextPreviousBarButtonItem release];
	}
	
    return self;
}


@end
