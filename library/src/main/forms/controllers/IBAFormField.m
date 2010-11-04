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


@implementation IBAFormField

@synthesize keyPath;
@synthesize title;
@synthesize modelManager;
@synthesize delegate;
@synthesize formFieldStyle;
@synthesize nullable;
@synthesize valueTransformer;

#pragma mark -
#pragma mark Initialisation and memory management

- (void)dealloc {
	IBA_RELEASE_SAFELY(keyPath);
	IBA_RELEASE_SAFELY(title);
	IBA_RELEASE_SAFELY(modelManager);
	IBA_RELEASE_SAFELY(formFieldStyle);
	IBA_RELEASE_SAFELY(valueTransformer);

	[super dealloc];
}

- (id)initWithKeyPath:(NSString*)aKeyPath title:(NSString*)aTitle valueTransformer:(NSValueTransformer *)aValueTransformer {
	self = [super init];
	if (self != nil) {
		self.keyPath = aKeyPath;
		self.title = aTitle;
		self.nullable = YES;
		self.valueTransformer = aValueTransformer;
	}

	return self;
}

- (id)initWithKeyPath:(NSString*)aKeyPath title:(NSString*)aTitle {
	return [self initWithKeyPath:aKeyPath title:aTitle valueTransformer:nil];
}

- (id)init {
	return [self initWithKeyPath:nil title:nil];
}


- (void)setModelManager:(id<IBAFormModelManager>) aModelManager {
	if (aModelManager != modelManager) {
		id<IBAFormModelManager> oldModelManager = modelManager;
		modelManager = [aModelManager retain];
		IBA_RELEASE_SAFELY(oldModelManager);

		// When the model manager changes we should update the content of the cell
		[self updateCellContents];
	}
}

- (void)setFormFieldStyle:(IBAFormFieldStyle *)style {
	if (style != formFieldStyle) {
		IBAFormFieldStyle *oldStyle = formFieldStyle;
		formFieldStyle = [style retain];
		IBA_RELEASE_SAFELY(oldStyle);

		self.cell.formFieldStyle = style;
	}
}

- (void)setTitle:(NSString *)newTitle {
	if (![newTitle isEqualToString:title]) {
		NSString *oldTitle = title;
		title = [newTitle copyWithZone:[self zone]];
		IBA_RELEASE_SAFELY(oldTitle);

		[self updateCellContents];
	}
}

#pragma mark -
#pragma mark Selection notification
- (void)select {
	// Subclasses should override this method
}


#pragma mark -
#pragma mark Cell management

- (IBAFormFieldCell *)cell {
	// To be implemented by subclasses
	NSAssert(NO, @"Subclasses of IBAFormField should override cell");
	return nil;
}

- (void)updateCellContents {
	// To be implemented by subclasses
	NSAssert(NO, @"Subclasses of IBAFormField should override updateCellContents");
}


#pragma mark -
#pragma mark Detail View Controller management

// Subclasses should override these methods
- (BOOL)hasDetailViewController {
	return NO;
}

- (UIViewController *)detailViewController {
	return nil;
}

#pragma mark -
#pragma mark Getting and setting the form field value
- (id)formFieldValue {
	id value = [self.modelManager modelValueForKeyPath:self.keyPath];

	if (self.valueTransformer != nil) {
		value = [self.valueTransformer reverseTransformedValue:value];
	}

	return value;
}

- (NSString *)formFieldStringValue {
	return [[self formFieldValue] description];
}

- (BOOL)setFormFieldValue:(id)formVieldValue {
	BOOL setValue = YES;

	// Transform the value if we have a transformer
	id value = formVieldValue;
	if (self.valueTransformer != nil) {
		value = [self.valueTransformer transformedValue:value];
	}

	if (self.delegate && [self.delegate respondsToSelector:@selector(formField:willSetValue:)]) {
		setValue = [self.delegate formField:self willSetValue:value];
	}

	if (setValue) {
		[self.modelManager setModelValue:value forKeyPath:self.keyPath];
		[self updateCellContents];

		if (self.delegate && [self.delegate respondsToSelector:@selector(formField:didSetValue:)]) {
			[self.delegate formField:self didSetValue:value];
		}
	}

	return setValue;
}


@end
