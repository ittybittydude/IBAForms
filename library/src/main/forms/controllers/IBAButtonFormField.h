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

#import "IBAFormField.h"
#import "IBALabelFormCell.h"

typedef void (^IBAButtonFormFieldBlock)(void);

@interface IBAButtonFormField : IBAFormField {
	IBALabelFormCell *cell_;
	UIImage *iconImage_;
	IBAButtonFormFieldBlock executionBlock_;
	UIViewController *detailViewController_;
}

- (id)initWithTitle:(NSString*)title icon:(UIImage *)iconImage executionBlock:(IBAButtonFormFieldBlock)block;
- (id)initWithTitle:(NSString*)title icon:(UIImage *)iconImage detailViewController:(UIViewController *)viewController;
- (id)initWithTitle:(NSString*)title icon:(UIImage *)iconImage executionBlock:(IBAButtonFormFieldBlock)aBlock detailViewController:(UIViewController *)viewController;

@end
