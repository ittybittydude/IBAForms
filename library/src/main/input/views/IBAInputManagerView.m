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

@synthesize inputNavigationToolbar = inputNavigationToolbar_;
@synthesize inputProviderView = inputProviderView_;
@synthesize previousInputProviderView = previousInputProviderView_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(inputNavigationToolbar_);
	IBA_RELEASE_SAFELY(inputProviderView_);
	
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		CGRect inputNavigationToolbarFrame = frame;
		inputNavigationToolbarFrame.size.height = 44;
		inputNavigationToolbar_ = [[IBAInputNavigationToolbar alloc] initWithFrame:inputNavigationToolbarFrame];   
		[self setInputNavigationToolbarEnabled:YES]; // this will add the navigation toolbar as a subview and resize ourself
		
		self.backgroundColor = [UIColor viewFlipsideBackgroundColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	}
    
	return self;
}

- (void)setInputProviderView:(UIView *)newView {
	BOOL animate = (self.superview != nil);
	
	self.previousInputProviderView = self.inputProviderView;
	inputProviderView_ = newView;
	
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect inputProviderViewStartFrame = CGRectMake(0, 
													screenRect.origin.y + screenRect.size.height, 
													self.inputProviderView.bounds.size.width, 
													self.inputProviderView.bounds.size.height);
	CGRect inputProviderViewEndFrame = inputProviderViewStartFrame;
	inputProviderViewEndFrame.origin.y = self.inputNavigationToolbarEnabled ? self.inputNavigationToolbar.bounds.size.height : 0;
	
	if (self.inputProviderView != nil) {
		[self addSubview:self.inputProviderView];
		self.inputProviderView.frame = inputProviderViewStartFrame;
	}
		
	CGRect previousInputProviderViewEndFrame = self.previousInputProviderView.frame;
	previousInputProviderViewEndFrame.origin.y = screenRect.origin.y + screenRect.size.height;
	
	if (animate) {
		// start the slide down animation
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		
		// we need to perform some post operations after the animation is complete
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(inputProviderViewSwapFinished)];
	}
	
	self.previousInputProviderView.frame = previousInputProviderViewEndFrame;
	
	if (self.inputProviderView != nil) {
		self.inputProviderView.frame = inputProviderViewEndFrame;
	}
	
	if (animate) {
		[UIView commitAnimations];
	}
}

- (void)inputProviderViewSwapFinished {
	[self.previousInputProviderView removeFromSuperview];
}


#pragma mark -
#pragma mark Enablement of the input navigation toolbar
- (BOOL)inputNavigationToolbarEnabled {
	return inputNavigationToolbarEnabled_;
}

- (void)setInputNavigationToolbarEnabled:(BOOL)enabled {
	inputNavigationToolbarEnabled_ = enabled;
	if (enabled) {
		[self addSubview:self.inputNavigationToolbar];
	} else {
		[self.inputNavigationToolbar removeFromSuperview];
	}

	[self sizeToFit];
}

- (CGSize)sizeThatFits:(CGSize)size {
	CGRect minRect = self.inputNavigationToolbarEnabled ? self.inputNavigationToolbar.bounds : CGRectZero;
	if (self.inputProviderView != nil) {
		minRect.size.width = fmax(minRect.size.width, self.inputProviderView.bounds.size.width);
		minRect.size.height += self.inputProviderView.bounds.size.height;
	}

	return minRect.size;
}

@end
