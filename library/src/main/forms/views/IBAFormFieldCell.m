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

#import "IBAFormFieldCell.h"
#import "IBAFormConstants.h"

@interface IBAFormFieldCell ()
@property (nonatomic, assign, getter=isActive) BOOL active;
- (void)applyActiveStyle;
@end

@implementation IBAFormFieldCell

@synthesize inputView = inputView_;
@synthesize inputAccessoryView = inputAccessoryView_;
@synthesize cellView = cellView_;
@synthesize label = label_;
@synthesize formFieldStyle = formFieldStyle_;
@synthesize styleApplied = styleApplied_;
@synthesize active = active_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(inputView_);
	IBA_RELEASE_SAFELY(inputAccessoryView_);
	IBA_RELEASE_SAFELY(cellView_);
	IBA_RELEASE_SAFELY(label_);
	IBA_RELEASE_SAFELY(formFieldStyle_);

	[super dealloc];
}

- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;

		self.cellView = [[[UIView alloc] initWithFrame:self.contentView.bounds] autorelease];
		self.cellView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.cellView.userInteractionEnabled = YES;
		[self.contentView addSubview:self.cellView];

		// Create a label
		self.label = [[[UILabel alloc] initWithFrame:style.labelFrame] autorelease];
		self.label.autoresizingMask = style.labelAutoresizingMask;
		self.label.adjustsFontSizeToFitWidth = YES;
		self.label.minimumFontSize = 10;
		[self.cellView addSubview:self.label];

		// set the style after the views have been created
		self.formFieldStyle = style;
	}

    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
  [super setBackgroundColor:backgroundColor];

  if (self.backgroundView) {
    self.backgroundView.backgroundColor = backgroundColor;
  }

  self.label.backgroundColor = backgroundColor;
}

- (void)activate {
	[self applyActiveStyle];
	self.active = YES;
}


- (void)deactivate {
	[self applyFormFieldStyle];
	self.active = NO;
}

- (void)setFormFieldStyle:(IBAFormFieldStyle *)style {
	if (style != formFieldStyle_) {
		IBAFormFieldStyle *oldStyle = formFieldStyle_;
		formFieldStyle_ = [style retain];
		IBA_RELEASE_SAFELY(oldStyle);
		
		self.styleApplied = NO;
	}
}

- (void)applyFormFieldStyle {
	self.label.font = self.formFieldStyle.labelFont;
	self.label.textColor = self.formFieldStyle.labelTextColor;
	self.label.textAlignment = self.formFieldStyle.labelTextAlignment;
	self.label.backgroundColor = self.formFieldStyle.labelBackgroundColor;
	self.backgroundColor = self.formFieldStyle.labelBackgroundColor;

	self.styleApplied = YES;
}

- (void)applyActiveStyle {
	self.label.backgroundColor = self.formFieldStyle.activeColor;
	self.backgroundColor = self.formFieldStyle.activeColor;

  if (self.backgroundView) {
    self.backgroundView.backgroundColor = self.backgroundColor;
  }
}

- (void)drawRect:(CGRect)rect {
	if (!self.styleApplied) {
		[self applyFormFieldStyle];
	}

	[super drawRect:rect];
}

- (CGSize)sizeThatFits:(CGSize)size
{
  return [self.cellView bounds].size;
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)didMoveToWindow {
	if ((self.window != nil) && [self isActive] && (![self isFirstResponder]) && [self canBecomeFirstResponder]) {
		// We need to reapply the active style because the tableview has a nasty habbit of resetting the cell background 
		// when the cell is reattached to the view hierarchy.
		[self applyActiveStyle]; 
		
		[self becomeFirstResponder];
	}
}

@end
