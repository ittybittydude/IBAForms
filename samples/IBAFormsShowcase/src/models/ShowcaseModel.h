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

#import <Foundation/Foundation.h>

@interface ShowcaseModel : NSObject {
	BOOL shouldAutoRotate_;
	BOOL tableViewStyleGrouped_;
	BOOL modalPresentation_;
    BOOL displayNavigationToolbar_;
	UIModalPresentationStyle modalPresentationStyle_;
}

@property (nonatomic, assign) BOOL shouldAutoRotate;
@property (nonatomic, assign) BOOL tableViewStyleGrouped;
@property (nonatomic, assign) BOOL modalPresentation;
@property (nonatomic, assign) BOOL displayNavigationToolbar;
@property (nonatomic, assign) UIModalPresentationStyle modalPresentationStyle;

@end
