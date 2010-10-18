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

@synthesize key;
@synthesize title;
@synthesize editable;
@synthesize movable;
@synthesize modelManager;
@synthesize delegate;
@synthesize formFieldStyle;
@synthesize nullable;

#pragma mark -
#pragma mark Initialisation and memory management

- (void)dealloc {	
	IBA_RELEASE_SAFELY(key);
	IBA_RELEASE_SAFELY(title);
	IBA_RELEASE_SAFELY(modelManager);
	IBA_RELEASE_SAFELY(formFieldStyle);

	[super dealloc];
}

- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle editable:(BOOL)editableFlag movable:(BOOL)movableFlag {
	self = [super init];
	if (self != nil) {
		self.key = aKey;
		title = [aTitle retain];
		self.editable = editableFlag;
		self.movable = movableFlag;
		self.nullable = YES;
	}
	
	return self;
}

- (id)initWithKey:(NSString*)aKey title:(NSString*)aTitle; {	
	return [self initWithKey:aKey title:aTitle editable:NO movable:NO];
}


- (id)init {
	return [self initWithKey:nil title:nil editable:NO movable:NO];
}


- (void)setModelManager:(id<IBAFormModelManager>) aModelManager {
	[modelManager release];
	modelManager = [aModelManager retain];
	
	// When the model manager changes we should update the content of the cell
	[self updateCellContents];
}

- (void)setFormFieldStyle:(IBAFormFieldStyle *)style {
	[formFieldStyle release];
	formFieldStyle = [style retain];
	
	self.cell.formFieldStyle = style;
}

- (void)setTitle:(NSString *)newTitle {
	[title release];
	title = [newTitle copyWithZone:[self zone]];
	[self updateCellContents];
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
	return [self.modelManager modelValueForKey:self.key];
}

- (NSString *)formFieldStringValue {
	return [[self formFieldValue] description];
}

- (BOOL)setFormFieldValue:(id)formVieldValue {
	BOOL setValue = YES;
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(formField:willSetValue:)]) {
		setValue = [self.delegate formField:self willSetValue:formVieldValue];
	}
	
	if (setValue) {
		[self.modelManager setModelValue:formVieldValue forKey:self.key];
		[self updateCellContents];
		
		if (self.delegate && [self.delegate respondsToSelector:@selector(formField:didSetValue:)]) {
			[self.delegate formField:self didSetValue:formVieldValue];
		}
	}
	
	return setValue;
}


@end
