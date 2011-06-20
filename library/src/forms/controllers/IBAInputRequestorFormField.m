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


#import "IBAInputRequestorFormField.h"
#import "IBAFormConstants.h"


@implementation IBAInputRequestorFormField

#pragma mark -
#pragma mark IBAInputRequestor

- (NSString *)dataType {
	NSAssert(NO, @"Subclasses of IBAInputRequestorFormField should override dataType");
	return nil;
}

- (void)activate {
	[[self responder] becomeFirstResponder];

	NSDictionary *userInfo = [[NSMutableDictionary alloc] init];
	[userInfo setValue:self forKey:IBAFormFieldKey];

	[[NSNotificationCenter defaultCenter] postNotificationName:IBAInputRequestorFormFieldActivated object:self userInfo:userInfo];
	[userInfo release];
	
	if ([self hasDetailViewController]) {
		// If the form field has a detailViewController, then it should be displayed, and the form field should
		// be unselected when the detailViewController is popped back of the navigation stack
		[self deactivate];
	} else {
		// Give the cell a chance to change it's visual state to show that it has been activated
		[self.cell activate];		
	}
}

- (BOOL)deactivate {
	NSDictionary *userInfo = [[NSMutableDictionary alloc] init];
	[userInfo setValue:self forKey:IBAFormFieldKey];

	[[NSNotificationCenter defaultCenter] postNotificationName:IBAInputRequestorFormFieldDeactivated object:self userInfo:userInfo];
	[userInfo release];
	
	[self.cell deactivate];
	
	return YES;
}

- (id)inputRequestorValue {
	return [self formFieldValue];
}

- (void)setInputRequestorValue:(id)aValue {
	[self setFormFieldValue:aValue];
}

- (id)defaultInputRequestorValue {
	return nil;
}

- (UIResponder *)responder {
	return self.cell;
}

@end
