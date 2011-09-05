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

#import "IBATextFormFieldCell.h"
#import "IBAFormConstants.h"

@implementation IBATextFormFieldCell

@synthesize textField = textField_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(textField_);
	
	[super dealloc];
}


- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier])) {
		// Create the text field for data entry
        
        if ((self.formFieldStyle.behavior | IBAFormFieldBehaviorClassic) == self.formFieldStyle.behavior)
        {
            CGRect initFrame;
            initFrame = style.valueFrame;
            if ((self.formFieldStyle.behavior | IBAFormFieldBehaviorCancel) == self.formFieldStyle.behavior)
                initFrame.size.width -= IBAFormFieldValueMarginCancel;
            else
                initFrame.size.width -= IBAFormFieldValueMargin;
            self.textField = [[[UITextField alloc] initWithFrame:initFrame] autorelease];
        }
            else if ((self.formFieldStyle.behavior | IBAFormFieldBehaviorPlaceHolder) == self.formFieldStyle.behavior)
            self.textField = [[[UITextField alloc] init] autorelease];
        
        self.textField.autoresizingMask = style.valueAutoresizingMask;
        self.textField.returnKeyType = UIReturnKeyNext;
        [self.cellView addSubview:self.textField];
        if ((self.formFieldStyle.behavior | IBAFormFieldBehaviorCancel) == self.formFieldStyle.behavior)
        {
            [self initButton];
        }
	}
	
    return self;
}

- (void)activate {
	[super activate];
	
	self.textField.backgroundColor = [UIColor clearColor];

    if ((self.formFieldStyle.behavior | IBAFormFieldBehaviorPlaceHolder) == self.formFieldStyle.behavior)
        self.label.hidden = YES;
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

- (void)applyFormFieldStyle {
	[super applyFormFieldStyle];
	
	self.textField.font = self.formFieldStyle.valueFont;
	self.textField.textColor = self.formFieldStyle.valueTextColor;
	self.textField.backgroundColor = self.formFieldStyle.valueBackgroundColor;
	self.textField.textAlignment = self.formFieldStyle.valueTextAlignment;

    if ((self.formFieldStyle.behavior | IBAFormFieldBehaviorPlaceHolder) == self.formFieldStyle.behavior)
    {
        if ((self.formFieldStyle.behavior | IBAFormFieldBehaviorCancel) == self.formFieldStyle.behavior)
            self.textField.frame = CGRectMake(IBAFormFieldLabelX + IBAFormFieldValueXAdjustement, IBAFormFieldLabelY+IBAFormFieldValueYAdjustement, IBAFormFieldValueWidth + IBAFormFieldValueMarginPlaceHolder, IBAFormFieldLabelHeight-IBAFormFieldValueYAdjustement);
        else
            self.textField.frame = CGRectMake(IBAFormFieldLabelX + IBAFormFieldValueXAdjustement, IBAFormFieldLabelY+IBAFormFieldValueYAdjustement, IBAFormFieldValueWidth + IBAFormFieldValueMarginPlaceHolderCancel, IBAFormFieldLabelHeight-IBAFormFieldValueYAdjustement);
        self.textField.placeholder = self.label.text;
        self.label.hidden = YES;
    }
}

@end
