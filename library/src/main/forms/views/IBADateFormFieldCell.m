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

@implementation IBADateFormFieldCell

@synthesize clearButton = clearButton_;
@synthesize nullable = nullable_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(clearButton_);
	
	[super dealloc];
}


- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier]) {
		UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[clearButton setImage:[UIImage imageNamed:@"clear.png"] forState:UIControlStateNormal];
		clearButton.contentMode = UIViewContentModeCenter;
		clearButton.center = CGPointMake(264, CGRectGetMidY(self.cellView.bounds) + 2);
		clearButton.frame = CGRectInset(clearButton.frame, -20, -20);
		self.clearButton = clearButton;
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

- (BOOL)deactivate {
	if ([self isNullable]) {
		[self.clearButton removeFromSuperview];
	}
	
	return [super deactivate];
}

@end
