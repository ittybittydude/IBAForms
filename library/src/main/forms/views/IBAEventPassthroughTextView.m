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

#import "IBAEventPassthroughTextView.h"


@implementation IBAEventPassthroughTextView

- (void)dealloc {
    [super dealloc];
}

- (id)initWithFrame:(CGRect)aRect {
    if (self = [super initWithFrame:aRect]) {
		self.userInteractionEnabled = YES;
	}
	
    return self;
}

// All events end up going up the resonder chain
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
	return NO;
}

@end
