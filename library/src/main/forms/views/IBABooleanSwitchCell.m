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

#import "IBABooleanSwitchCell.h"
#import "IBAFormConstants.h"

@implementation IBABooleanSwitchCell

@synthesize switchControl = switchControl_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(switchControl_);

	[super dealloc];
}


- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier])) {
		switchControl_ = [[UISwitch alloc] initWithFrame:CGRectZero];
		[self.cellView addSubview:switchControl_];
		switchControl_.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		switchControl_.frame = CGRectMake(style.valueFrame.origin.x + style.valueFrame.size.width - switchControl_.bounds.size.width,
										  ceil((self.bounds.size.height - switchControl_.bounds.size.height)/2),
										  switchControl_.bounds.size.width,
										  switchControl_.bounds.size.height);
	}

    return self;
}

@end
