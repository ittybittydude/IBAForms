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

#import "IBADateFormFieldCell.h"
#import "IBAFormConstants.h"

@interface IBADateFormFieldCell ()
@end


@implementation IBADateFormFieldCell


- (void)dealloc {	
	[super dealloc];
}

- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier])) {
        if (!((self.formFieldStyle.behavior | IBAFormFieldBehaviorNoCancel) == self.formFieldStyle.behavior))
        {
            [self initButton];
        }
        self.textField.enabled = NO;
	}
	
    return self;
}

- (void)activate {
	[super activate];
	
	if ([self isNullable]) {
		[self.cellView addSubview:self.clearButton];
	}
}

- (void)deactivate {
	if ([self isNullable]) {
		[self.clearButton removeFromSuperview];
	}
    [super deactivate];
}

@end
