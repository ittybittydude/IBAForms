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

@interface IBAInputNavigationToolbar ()
@property (nonatomic, retain) UIBarButtonItem *nextPreviousBarButtonItem;
@end

@implementation IBAInputNavigationToolbar

@synthesize doneButton = doneButton_;
@synthesize nextPreviousButton = nextPreviousButton_;
@synthesize nextPreviousBarButtonItem = nextPreviousBarButtonItem_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(doneButton_);
	IBA_RELEASE_SAFELY(nextPreviousButton_);
	IBA_RELEASE_SAFELY(nextPreviousBarButtonItem_);
	
	[super dealloc];
}


- (id)initWithFrame:(CGRect)aRect {
	if (self = [super initWithFrame:(CGRect)aRect]) {
		self.barStyle = UIBarStyleBlack;
		
		doneButton_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																   target:nil 
																   action:nil];
		
		nextPreviousButton_ = [[UISegmentedControl alloc] initWithItems:[NSArray 
					arrayWithObjects:IBAInputNavigationToolbarPreviousTitle, IBAInputNavigationToolbarNextTitle, nil]];
		nextPreviousButton_.segmentedControlStyle = UISegmentedControlStyleBar;
		nextPreviousButton_.tintColor = [UIColor blackColor];
		nextPreviousButton_.momentary = YES;
		
		nextPreviousBarButtonItem_ = [[UIBarButtonItem alloc] initWithCustomView:self.nextPreviousButton];
		
		[self displayDoneButton:YES previousNextButton:YES];
	}
	
    return self;
}


- (void)displayDoneButton:(BOOL)displayDoneButton previousNextButton:(BOOL)displayPreviousNextButton {
	NSMutableArray *barItems = [NSMutableArray array];
	if (displayDoneButton) {
		[barItems addObject:doneButton_];
	}
	
	[barItems addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];

	if (displayPreviousNextButton) {
		[barItems addObject:nextPreviousBarButtonItem_];
	}
	
	[self setItems:barItems animated:YES];
}

@end
