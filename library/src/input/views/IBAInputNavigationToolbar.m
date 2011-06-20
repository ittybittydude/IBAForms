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
- (void)updateButtons;
@end

@implementation IBAInputNavigationToolbar

@synthesize doneButton = doneButton_;
@synthesize nextPreviousButton = nextPreviousButton_;
@synthesize nextPreviousBarButtonItem = nextPreviousBarButtonItem_;
@synthesize displayDoneButton = displayDoneButton_;
@synthesize displayNextPreviousButton = displayNextPreviousButton_;


- (void)dealloc {
	IBA_RELEASE_SAFELY(doneButton_);
	IBA_RELEASE_SAFELY(nextPreviousButton_);
	IBA_RELEASE_SAFELY(nextPreviousBarButtonItem_);
	
	[super dealloc];
}


- (id)initWithFrame:(CGRect)aRect {
	if ((self = [super initWithFrame:(CGRect)aRect])) {
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
		
		displayDoneButton_ = YES;
		displayNextPreviousButton_ = YES;
		[self updateButtons];
	}
	
    return self;
}


- (void)setDisplayDoneButton:(BOOL)display {
	displayDoneButton_ = display;
	[self updateButtons];
}

- (void)setDisplayNextPreviousButton:(BOOL)display {
	displayNextPreviousButton_ = display;
	[self updateButtons];
}

- (void)updateButtons {
	NSMutableArray *barItems = [NSMutableArray array];
	if (self.displayDoneButton) {
		[barItems addObject:doneButton_];
	}
	
	[barItems addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];

	if (self.displayNextPreviousButton) {
		[barItems addObject:nextPreviousBarButtonItem_];
	}
	
	[self setItems:barItems animated:YES];
}

@end
