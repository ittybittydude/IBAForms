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

#import "IBATextInputProvider.h"
#import "IBACommon.h"

@implementation IBATextInputProvider

@synthesize inputRequestor;
@synthesize view;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {	
	IBA_RELEASE_SAFELY(view);
	
	[super dealloc];
}


- (id)init {
	self = [super init];
	if (self != nil) {
		view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)]; // this is a hack because we don't get the keyboard's size until after we need to size up the input manager view.
	}
	
	return self;
}

@end
