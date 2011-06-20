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

#import <UIKit/UIKit.h>

typedef enum {
	IBAInputNavigationToolbarActionPrevious = 0,
	IBAInputNavigationToolbarActionNext
} IBAInputNavigationToolbarAction;


@interface IBAInputNavigationToolbar : UIToolbar {
	UIBarButtonItem *doneButton_;
	UISegmentedControl *nextPreviousButton_;
	UIBarButtonItem *nextPreviousBarButtonItem_;
	BOOL displayDoneButton_;
	BOOL displayNextPreviousButton_;
}

@property (nonatomic, retain) UIBarButtonItem *doneButton;
@property (nonatomic, retain) UISegmentedControl *nextPreviousButton;
@property (nonatomic, assign) BOOL displayDoneButton;
@property (nonatomic, assign) BOOL displayNextPreviousButton;

@end
