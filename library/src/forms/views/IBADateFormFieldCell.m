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

static UIImage *clearImage_ = nil;


@interface IBADateFormFieldCell ()
+ (UIImage *)clearImage;
@end


@implementation IBADateFormFieldCell

@synthesize clearButton = clearButton_;
@synthesize nullable = nullable_;

- (void)dealloc {	
	IBA_RELEASE_SAFELY(clearButton_);
	
	[super dealloc];
}

- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier])) {
		UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[clearButton setImage:[IBADateFormFieldCell clearImage] forState:UIControlStateNormal];
		clearButton.contentMode = UIViewContentModeCenter;
		clearButton.center = CGPointMake(264, CGRectGetMidY(self.cellView.bounds));
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

- (void)deactivate {
	if ([self isNullable]) {
		[self.clearButton removeFromSuperview];
	}
	
	[super deactivate];
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

@end
