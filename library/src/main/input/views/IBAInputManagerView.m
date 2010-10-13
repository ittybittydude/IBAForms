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

#import "IBAInputManagerView.h"
#import "IBACommon.h"
#import "IBAInputNavigationToolbar.h"


@interface IBAInputManagerView ()
- (void)inputProviderViewSwapFinished;
@end


@implementation IBAInputManagerView

@synthesize inputNavigationToolbar;
@synthesize inputProviderView;
@synthesize previousInputProviderView;

- (void)dealloc {
	IBA_RELEASE_SAFELY(inputNavigationToolbar);
	IBA_RELEASE_SAFELY(inputProviderView);
	
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		CGRect inputNavigationToolbarFrame = frame;
		inputNavigationToolbarFrame.size.height = 44;
		inputNavigationToolbar = [[IBAInputNavigationToolbar alloc] initWithFrame:inputNavigationToolbarFrame];   
		[self setInputNavigationToolbarEnabled:YES]; // this will add the navigation toolbar as a subview and resize ourself
		
		self.backgroundColor = [UIColor viewFlipsideBackgroundColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	}
    
	return self;
}

- (void)setInputProviderView:(UIView *)newView {
	BOOL animate = (self.superview != nil);
	
	// TODO This needs some work to change the size of the InputManagerView to accommodate the size of newView instead
	// of constraining newView to InputManagerView - inputNavigationToolbar height.
	previousInputProviderView = inputProviderView;
	inputProviderView = newView;
	
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
//	int veiwHeight = self.inputNavigationToolbarEnabled ? self.bounds.size.height - self.inputNavigationToolbar.bounds.size.height : self.bounds.size.height;
	CGRect inputProviderViewStartFrame = CGRectMake(0, screenRect.origin.y + screenRect.size.height, inputProviderView.bounds.size.width, inputProviderView.bounds.size.height);
	CGRect inputProviderViewEndFrame = inputProviderViewStartFrame;
	inputProviderViewEndFrame.origin.y = self.inputNavigationToolbarEnabled ? self.inputNavigationToolbar.bounds.size.height : 0;
	
	if (inputProviderView != nil) {
		[self addSubview:inputProviderView];
		inputProviderView.frame = inputProviderViewStartFrame;
	}
		
	CGRect previousInputProviderViewEndFrame = previousInputProviderView.frame;
	previousInputProviderViewEndFrame.origin.y = screenRect.origin.y + screenRect.size.height;
	
	if (animate) {
		// start the slide down animation
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		
		// we need to perform some post operations after the animation is complete
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(inputProviderViewSwapFinished)];
	}
	
	previousInputProviderView.frame = previousInputProviderViewEndFrame;
	
	if (inputProviderView != nil) {
		inputProviderView.frame = inputProviderViewEndFrame;
	}
	
	if (animate) {
		[UIView commitAnimations];
	}
}

- (void)inputProviderViewSwapFinished {
	[previousInputProviderView removeFromSuperview];
}


#pragma mark -
#pragma mark Enablement of the input navigation toolbar
- (BOOL)inputNavigationToolbarEnabled {
	return inputNavigationToolbarEnabled;
}

- (void)setInputNavigationToolbarEnabled:(BOOL)enabled {
	inputNavigationToolbarEnabled = enabled;
	if (enabled) {
		[self addSubview:inputNavigationToolbar];
	} else {
		[inputNavigationToolbar removeFromSuperview];
	}

	[self sizeToFit];
}

- (CGSize)sizeThatFits:(CGSize)size {
	CGRect minRect = inputNavigationToolbarEnabled ? inputNavigationToolbar.bounds : CGRectZero;
	if (self.inputProviderView != nil) {
		minRect.size.width = fmax(minRect.size.width, self.inputProviderView.bounds.size.width);
		minRect.size.height += self.inputProviderView.bounds.size.height;
	}

	return minRect.size;
}

@end
