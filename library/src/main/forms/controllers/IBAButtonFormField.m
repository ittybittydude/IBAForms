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

#import "IBAButtonFormField.h"

#define IBAButtonTitleFrame CGRectMake(55, 10, 195, 24)
#define IBAButtonTitleFontSize 16

@interface IBAButtonFormField ()
@property (nonatomic, retain) UIImage *iconImage;
@property (nonatomic, retain) IBAButtonFormFieldBlock executionBlock;
@end


@implementation IBAButtonFormField

@synthesize iconImage;
@synthesize executionBlock;

- (void)dealloc {
	IBA_RELEASE_SAFELY(cell);
	IBA_RELEASE_SAFELY(iconImage);
	IBA_RELEASE_SAFELY(executionBlock);
	IBA_RELEASE_SAFELY(detailViewController);

	[super dealloc];
}


- (id)initWithTitle:(NSString*)aTitle icon:(UIImage *)anIconImage executionBlock:(IBAButtonFormFieldBlock)aBlock {
	return [self initWithTitle:aTitle icon:anIconImage executionBlock:aBlock detailViewController:nil];
}

- (id)initWithTitle:(NSString*)aTitle icon:(UIImage *)anIconImage detailViewController:(UIViewController *)viewController {
	return [self initWithTitle:aTitle icon:anIconImage executionBlock:nil detailViewController:viewController];
}

- (id)initWithTitle:(NSString*)aTitle icon:(UIImage *)anIconImage executionBlock:(IBAButtonFormFieldBlock)aBlock detailViewController:(UIViewController *)viewController {
	self = [super initWithKeyPath:nil title:aTitle];
	if (self != nil) {
		self.iconImage = anIconImage;
		self.executionBlock = aBlock;
		detailViewController = [viewController retain];
	}

	return self;
}

- (IBAFormFieldCell *)cell {
	if (cell == nil) {
		cell = [[IBALabelFormCell alloc] initWithFormFieldStyle:self.formFieldStyle reuseIdentifier:@"Cell"];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;

		if (self.iconImage != nil) {
			UIImageView *imageView = [[UIImageView alloc] initWithImage:self.iconImage];
			imageView.userInteractionEnabled = YES;

			CGRect cellViewBounds = cell.cellView.bounds;
			CGPoint imageCenter = CGPointMake(cell.label.bounds.origin.x + CGRectGetMidX(imageView.bounds), CGRectGetMidY(cellViewBounds));

			imageView.center = imageCenter;

			[cell.cellView addSubview:imageView];
			[imageView release];
		}

		formFieldStyle = [[IBAFormFieldStyle alloc] init];
		formFieldStyle.labelFont = [UIFont boldSystemFontOfSize:IBAButtonTitleFontSize];
		formFieldStyle.labelFrame = IBAButtonTitleFrame;
		formFieldStyle.labelTextColor = self.formFieldStyle.valueTextColor;
		formFieldStyle.labelTextAlignment = UITextAlignmentLeft;

		cell.formFieldStyle = formFieldStyle;
	}

	return cell;
}

- (void)select {
	if (self.executionBlock != NULL) {
		self.executionBlock();
		cell.selected = NO;
	}
}

- (void)setFormFieldStyle:(IBAFormFieldStyle *)style {
	// can't set the style of a IBAButtonFormField form field
}

- (void)updateCellContents {
	self.cell.label.text = self.title;
}

- (BOOL)hasDetailViewController {
	return (detailViewController != nil);
}

- (UIViewController *)detailViewController {
	return detailViewController;
}

@end

