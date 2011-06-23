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

#import "IBABooleanFormField.h"


@interface IBABooleanFormField () 
- (void)switchValueChanged:(id)sender;
@end


@implementation IBABooleanFormField

@synthesize switchCell = switchCell_;
@synthesize checkCell = checkCell_;
@synthesize booleanFormFieldType = booleanFormFieldType_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(switchCell_);
	IBA_RELEASE_SAFELY(checkCell_);
	
	[super dealloc];
}

- (id)initWithKeyPath:(NSString *)keyPath title:(NSString *)title valueTransformer:(NSValueTransformer *)valueTransformer 
				 type:(IBABooleanFormFieldType)booleanFormFieldType {
	if ((self = [super initWithKeyPath:keyPath title:title valueTransformer:valueTransformer])) {
		self.booleanFormFieldType = booleanFormFieldType;
	}
	
	return self;	
}

- (id)initWithKeyPath:(NSString *)keyPath title:(NSString *)title type:(IBABooleanFormFieldType)booleanFormFieldType {
	return [self initWithKeyPath:keyPath title:title valueTransformer:nil type:booleanFormFieldType];
}


#pragma mark -
#pragma mark Cell management

- (IBAFormFieldCell *)cell {
	IBAFormFieldCell *cell = nil;
	
	switch (self.booleanFormFieldType) {
		case IBABooleanFormFieldTypeSwitch:
			cell = [self switchCell];
			break;
		case IBABooleanFormFieldTypeCheck:
			cell = [self checkCell];
			break;
		default:
			NSAssert(NO, @"Invalid booleanFormFieldType");
			break;
	}
	
	return cell;
}

- (IBABooleanSwitchCell *)switchCell {
	if (switchCell_ == nil) {
		switchCell_ = [[IBABooleanSwitchCell alloc] initWithFormFieldStyle:self.formFieldStyle 
																		reuseIdentifier:@"IBABooleanSwitchCell"];
	
		[switchCell_.switchControl addTarget:self action:@selector(switchValueChanged:) 
									  forControlEvents:UIControlEventValueChanged];
	}
	
	return switchCell_;
}

- (IBAFormFieldCell *)checkCell {
	if (checkCell_ == nil) {
		checkCell_ = [[IBAFormFieldCell alloc] initWithFormFieldStyle:self.formFieldStyle 
														   reuseIdentifier:@"IBABooleanCheckCell"];
	}
	
	return checkCell_;
}

- (void)updateCellContents {
	switch (self.booleanFormFieldType) {
		case IBABooleanFormFieldTypeSwitch:
		{
			self.switchCell.label.text = self.title;
			[self.switchCell.switchControl setOn:[[self formFieldValue] boolValue]];
			break;
		}
		case IBABooleanFormFieldTypeCheck:
		{
			self.checkCell.label.text = self.title;
			self.checkCell.accessoryType = ([[self formFieldValue] boolValue]) ? UITableViewCellAccessoryCheckmark : 
				UITableViewCellAccessoryNone;
			break;
		}
		default:
			NSAssert(NO, @"Invalid booleanFormFieldType");
			break;
	}
}

- (void)select {
	if (self.booleanFormFieldType == IBABooleanFormFieldTypeCheck) {
		[self setFormFieldValue:[NSNumber numberWithBool:![[self formFieldValue] boolValue]]];
		[self updateCellContents];
	}
}

- (void)switchValueChanged:(id)sender {
	if (sender == self.switchCell.switchControl) {
		[self setFormFieldValue:[NSNumber numberWithBool:self.switchCell.switchControl.on]];
	}
}

@end
