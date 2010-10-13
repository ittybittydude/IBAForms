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

#import "IBAMultilineTextViewController.h"
#import "IBAFormConstants.h"

@interface IBAMultilineTextViewController ()
- (void)releaseViews;
- (void)keyboardWillShow:(NSNotification *)notification;
@end


@implementation IBAMultilineTextViewController

@synthesize textView;
@synthesize inputRequestor;

#pragma mark -
#pragma mark Initialisation and memory management

- (void)dealloc {
	[self releaseViews];
	IBA_RELEASE_SAFELY(inputRequestor);
	[[NSNotificationCenter defaultCenter] removeObserver:self];

    [super dealloc];
}

- (void)releaseViews {
	IBA_RELEASE_SAFELY(textView);
}

- (id)initWithInputRequestor:(id<IBAInputRequestor>)anInputRequestor title:(NSString *)title {
	self = [super init];
	if (self != nil) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
		
		self.title = title;
		self.inputRequestor = anInputRequestor;
		
		textView = [[UITextView alloc] init];
		textView.font = [UIFont systemFontOfSize:16];
		textView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
		textView.autocorrectionType = UITextAutocorrectionTypeDefault;
		textView.dataDetectorTypes = UIDataDetectorTypeAll;
		textView.keyboardType =UIKeyboardTypeASCIICapable;
		textView.text = [self.inputRequestor inputRequestorValue];
		textView.delegate = self;
	}
	
	return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)loadView {
	[super loadView];

	self.textView.frame = self.view.bounds;
	[self.view addSubview:self.textView];
}

- (void)viewDidUnload {
	[self releaseViews];
	
	[super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)textViewDidChange:(UITextView *)theTextView {
	self.inputRequestor.inputRequestorValue = theTextView.text;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)theTextView {
	return YES;
}

#pragma mark -
#pragma mark Keyboard management 

- (void)keyboardWillShow:(NSNotification *)notification {
	CGRect keyboardBounds;
	[[notification.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue: &keyboardBounds];
	
	CGRect newTextViewFrame = textView.frame;
	newTextViewFrame.size.height = textView.frame.size.height - keyboardBounds.size.height - 20;
	
	textView.frame = newTextViewFrame;
	[textView flashScrollIndicators];
}

@end
