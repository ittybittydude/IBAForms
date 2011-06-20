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

@interface IBAButtonFormField ()
@property (nonatomic, retain) UIImage *iconImage;
@property (nonatomic, copy) IBAButtonFormFieldBlock executionBlock;
@end


@implementation IBAButtonFormField

@synthesize iconImage = iconImage_;
@synthesize executionBlock = executionBlock_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(cell_);
	IBA_RELEASE_SAFELY(iconImage_);
	IBA_RELEASE_SAFELY(executionBlock_);
	IBA_RELEASE_SAFELY(detailViewController_);

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
		detailViewController_ = [viewController retain];
	}

	return self;
}

- (IBAFormFieldCell *)cell {
	if (cell_ == nil) {
		cell_ = [[IBALabelFormCell alloc] initWithFormFieldStyle:self.formFieldStyle reuseIdentifier:@"Cell"];
		cell_.selectionStyle = UITableViewCellSelectionStyleGray;

		if (self.iconImage != nil) {
			UIImageView *imageView = [[UIImageView alloc] initWithImage:self.iconImage];
			imageView.userInteractionEnabled = YES;

			CGRect cellViewBounds = cell_.cellView.bounds;
			CGPoint imageCenter = CGPointMake(cell_.label.bounds.origin.x + CGRectGetMidX(imageView.bounds), CGRectGetMidY(cellViewBounds));

			imageView.center = imageCenter;

			[cell_.cellView addSubview:imageView];
			[imageView release];
		}
	}

	return cell_;
}

- (void)select {
	if (self.executionBlock != NULL) {
		self.cell.selected = NO;
		self.executionBlock();
	}
}

- (void)updateCellContents {
	if (self.cell != nil) {
		self.cell.label.text = self.title;
	}
}

- (BOOL)hasDetailViewController {
	return (detailViewController_ != nil);
}

- (UIViewController *)detailViewController {
	return detailViewController_;
}

@end

