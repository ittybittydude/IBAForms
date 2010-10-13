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

#import "IBAURLFormField.h"
#import "IBAFormConstants.h"

#define IBAHTTPPrefix @"http://"

@interface IBAURLFormField ()
- (void)openURL;
- (void)updateButtonState;
@end


@implementation IBAURLFormField

@synthesize openURLButton;


- (void)dealloc {
	IBA_RELEASE_SAFELY(openURLButton);
	
	[super dealloc];
}


- (id)initWithKey:(NSString*)aKey title:(NSString*)aTitle; {	
    if (self = [super initWithKey:aKey title:aTitle]) {	
		IBATextFormFieldCell *formFieldCell = self.textFormFieldCell;
		
		// set the text input traits for url entry
		formFieldCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		formFieldCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
		formFieldCell.textField.keyboardType = UIKeyboardTypeURL;
		
		// Create the open URL button
		self.openURLButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		openURLButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		[openURLButton addTarget:self action:@selector(openURL) forControlEvents:UIControlEventTouchUpInside];
		
		CGRect cellViewBounds = formFieldCell.cellView.bounds;
		CGPoint buttonCenter = CGPointMake(CGRectGetMaxX(cellViewBounds) - CGRectGetMidX(openURLButton.bounds),
										   CGRectGetMidY(cellViewBounds));

		openURLButton.center = buttonCenter;
		[formFieldCell.cellView addSubview:openURLButton];
	}
	
    return self;
}

- (void)setModelManager:(id<IBAFormModelManager>)manager {
	[super setModelManager:manager];
	[self updateButtonState];
}


- (BOOL)deactivate {	
	[self updateButtonState];
	
	return [super deactivate];
}

- (void)updateButtonState {
	NSString *urlValue = [self formFieldValue];
	BOOL isEmptyOrNil = (urlValue == nil) || ([urlValue isEqual:@""]);
	self.openURLButton.hidden = isEmptyOrNil;
	self.openURLButton.enabled = !isEmptyOrNil;
}

- (void)openURL {
	// Just open the URL in Safari
	NSString *urlString = [self formFieldValue];
	
	if ((urlString != nil) && (![urlString isEqual:@""])) {
		if (![urlString hasPrefix:IBAHTTPPrefix]) {
			urlString = [NSString stringWithFormat:@"%@%@", IBAHTTPPrefix, urlString];
		}
		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
	}
	
}

@end
