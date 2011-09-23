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

static UIImage *clearImage_ = nil;

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
@synthesize hiddenCellCache = hiddenCellCache_;
@synthesize clearButton = clearButton_;
@synthesize nullable = nullable_;
@synthesize validator = validator_;


- (void)dealloc {
	IBA_RELEASE_SAFELY(inputView_);
	IBA_RELEASE_SAFELY(inputAccessoryView_);
	IBA_RELEASE_SAFELY(cellView_);
	IBA_RELEASE_SAFELY(label_);
	IBA_RELEASE_SAFELY(formFieldStyle_);
	hiddenCellCache_ = nil;
	
	[super dealloc];
}

- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier validator:(IBAInputValidatorGeneric *)valueValidator {
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
        self.validator = valueValidator;
    }
    return self;
}

- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [self initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier validator:nil];
}

- (void)activate {
    [self applyActiveStyle];
	self.active = YES;
}

-(BOOL)checkField
{
    return NO;
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

    if(self.formFieldStyle.behavior == IBAFormFieldBehaviorPlaceHolder)
    {
        self.label.frame = CGRectMake(IBAFormFieldLabelX, IBAFormFieldLabelY, IBAFormFieldValueWidth, IBAFormFieldLabelHeight);
        self.label.textAlignment   = UITextAlignmentLeft;
    }


	self.styleApplied = YES;
}

- (void)applyActiveStyle {
//    if((self.formFieldStyle.behavior | IBAFormFieldBehaviorClassic) == self.formFieldStyle.behavior)
//    {
    self.label.backgroundColor = self.formFieldStyle.activeColor;
    self.backgroundColor = self.formFieldStyle.activeColor;
//    }
}

- (void)updateActiveStyle {
    if ([self isActive]) {
		// We need to reapply the active style because the tableview has a nasty habbit of resetting the cell background 
		// when the cell is reattached to the view hierarchy.
		[self applyActiveStyle]; 
	}
}

- (void)drawRect:(CGRect)rect {
	if (!self.styleApplied) {
		[self applyFormFieldStyle];
	}

	[super drawRect:rect];
}

-(void)initButton
{
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setImage:[IBAFormFieldCell clearImage] forState:UIControlStateNormal];
    clearButton.contentMode = UIViewContentModeCenter;
    clearButton.center = CGPointMake(278, CGRectGetMidY(self.cellView.bounds));
    clearButton.frame = CGRectInset(clearButton.frame, -20, -20);
    self.clearButton = clearButton;
}

+ (UIImage *)clearImage {
	if (clearImage_ == nil) {
		CGFloat size = 19;
		CGFloat strokeInset = 5;
		CGFloat lineWidth = 2;
		
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, [[UIScreen mainScreen] scale]);
		UIBezierPath* circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size, size)];	
		
		[[UIColor colorWithRed:0.698 green:0.698 blue:0.698 alpha:1.0] setFill];
		[circle fill];
        
		UIBezierPath *stroke1 = [UIBezierPath bezierPath];
		stroke1.lineWidth = lineWidth;
		stroke1.lineCapStyle = kCGLineCapRound;
		[stroke1 moveToPoint:CGPointMake(strokeInset, strokeInset)];
		[stroke1 addLineToPoint:CGPointMake(size - strokeInset, size - strokeInset)];
		[stroke1 closePath];
		
		[[UIColor whiteColor] setStroke];
		[stroke1 strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
		
		UIBezierPath *stroke2 = [UIBezierPath bezierPath];
		stroke2.lineWidth = lineWidth;
		stroke2.lineCapStyle = kCGLineCapRound;
		[stroke2 moveToPoint:CGPointMake(size - strokeInset, strokeInset)];
		[stroke2 addLineToPoint:CGPointMake(strokeInset, size - strokeInset)];
		[stroke2 closePath];
		[stroke2 strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
		
		clearImage_ = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	
	return clearImage_;
}


- (CGSize)sizeThatFits:(CGSize)size
{
  return [self.cellView bounds].size;
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}


#pragma mark - 
#pragma mark Dirty laundry

// SW. So, what's all this dirty laundry business then? Well, let me tell you a little story
// about UIResponders. If you call becomeFirstResponder on a UIResponder that is not in the view hierarchy, it doesn't
// become the first responder. 'So what', you might ask. Well, when cells in a UITableView scroll out of view, they
// are removed from the view hierarchy. If you select a cell, then scroll it up out of view, when you press the 'Previous'
// button in the toolbar, the forms framework tries to activate the previous cell and make it the first responder.
// The previous cell won't be in the view hierarchy, and the becomeFirstResponder call will fail. We tried all sorts
// of workarounds, but the one that seems to work is to put the cells into a hidden view when they are removed from the
// UITableView, so that they are still in the view hierarchy. We ended up making this hidden view a subview of the 
// UIViewController's view. 

- (void)didMoveToWindow {
	if (self.window == nil) {
		NSAssert((self.hiddenCellCache != nil), @"Hidden cell cache should not be nil");
		[self.hiddenCellCache addSubview:self];
	}
}


@end
