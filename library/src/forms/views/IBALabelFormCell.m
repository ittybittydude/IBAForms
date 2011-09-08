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

#import "IBALabelFormCell.h"
#import "IBAFormConstants.h"

@implementation IBALabelFormCell

- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier validator:(IBAInputValidatorGeneric *)valueValidator
{
    if ((self = [super initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier validator:valueValidator])) {
		self.label.adjustsFontSizeToFitWidth = YES;
        self.validator = valueValidator;
	}
	
    return self;

}

- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [self initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier validator:nil];
}

@end
