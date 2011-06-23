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

@synthesize keyPath = keyPath_;
@synthesize title = title_;
@synthesize modelManager = modelManager_;
@synthesize delegate = delegate_;
@synthesize formFieldStyle = formFieldStyle_;
@synthesize nullable = nullable_;
@synthesize valueTransformer = valueTransformer_;

#pragma mark -
#pragma mark Initialisation and memory management

- (void)dealloc {
	IBA_RELEASE_SAFELY(keyPath_);
	IBA_RELEASE_SAFELY(title_);
	IBA_RELEASE_SAFELY(formFieldStyle_);
	IBA_RELEASE_SAFELY(valueTransformer_);

	[super dealloc];
}

- (id)initWithKeyPath:(NSString*)keyPath title:(NSString*)title valueTransformer:(NSValueTransformer *)valueTransformer {
	if ((self = [super init])) {
		self.keyPath = keyPath;
		title_ = [title copy];
		self.nullable = YES;
		self.valueTransformer = valueTransformer;
	}

	return self;
}

- (id)initWithKeyPath:(NSString*)keyPath title:(NSString*)title {
	return [self initWithKeyPath:keyPath title:title valueTransformer:nil];
}

- (id)initWithKeyPath:(NSString*)keyPath {
	return [self initWithKeyPath:keyPath title:nil valueTransformer:nil];
}

- (id)initWithTitle:(NSString*)title {
	return [self initWithKeyPath:nil title:title valueTransformer:nil];
}

- (id)init {
	return [self initWithKeyPath:nil title:nil];
}


- (void)setModelManager:(id<IBAFormModelManager>) modelManager {
	if (modelManager != modelManager_) {
		modelManager_ = modelManager;

		// When the model manager changes we should update the content of the cell
		[self updateCellContents];
	}
}

- (void)setFormFieldStyle:(IBAFormFieldStyle *)formFieldStyle {
	if (formFieldStyle != formFieldStyle_) {
		IBAFormFieldStyle *oldStyle = formFieldStyle_;
		formFieldStyle_ = [formFieldStyle retain];
		IBA_RELEASE_SAFELY(oldStyle);

		self.cell.formFieldStyle = formFieldStyle;
	}
}

- (void)setTitle:(NSString *)title {
	if (![title isEqualToString:title_]) {
		NSString *oldTitle = title_;
		title_ = [title copyWithZone:[self zone]];
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
	return [self.formFieldValue description];
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
