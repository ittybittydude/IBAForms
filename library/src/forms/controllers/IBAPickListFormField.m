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

#import "IBAPickListFormField.h"
#import "IBAInputCommon.h"

#pragma mark -
#pragma mark IBAPickListFormField

@implementation IBAPickListFormField

@synthesize pickListCell = pickListCell_;
@synthesize selectionMode = selectionMode_;
@synthesize pickListOptions = pickListOptions_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(pickListCell_);
	IBA_RELEASE_SAFELY(pickListOptions_);

	[super dealloc];
}

- (id)initWithKeyPath:(NSString *)keyPath title:(NSString *)title valueTransformer:(NSValueTransformer *)valueTransformer
	selectionMode:(IBAPickListSelectionMode)selectionMode options:(NSArray *)pickListOptions {
	if ((self = [super initWithKeyPath:keyPath title:title valueTransformer:valueTransformer])) {
		self.selectionMode = selectionMode;
		self.pickListOptions = pickListOptions;
	}

	return self;
}


- (NSString *)formFieldStringValue {
	NSString *value = nil;
	
	if (self.formFieldValue != nil) {
		NSMutableArray *itemNames = [[[NSMutableArray alloc] init] autorelease];

		for (id<IBAPickListOption> item in [self pickListOptions]) {
			NSString *itemName = [item name];
			if (([[self formFieldValue] containsObject:item]) && (itemName.length > 0)) {
				[itemNames addObject:itemName];
			}
		}
		
		value = [itemNames componentsJoinedByString:@", "];
	}

	return value;
}


#pragma mark -
#pragma mark Cell management

- (IBAFormFieldCell *)cell {
	if (pickListCell_ == nil) {
		pickListCell_ = [[IBATextFormFieldCell alloc] initWithFormFieldStyle:self.formFieldStyle reuseIdentifier:@"Cell"];
		pickListCell_.textField.enabled = NO;
	}

	return pickListCell_;
}

- (void)updateCellContents {
	if (self.pickListCell != nil) {
		self.pickListCell.label.text = self.title;
		self.pickListCell.textField.text = [self formFieldStringValue];
	}
}


#pragma mark -
#pragma mark IBAInputRequestor

- (NSString *)dataType {
	return (self.selectionMode == IBAPickListSelectionModeSingle) ? IBAInputDataTypePickListSingle : 
           IBAInputDataTypePickListMultiple;
}

@end


#pragma mark -
#pragma mark IBAPickListFormOption

@interface IBAPickListFormOption ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) UIImage *iconImage;
@property (nonatomic, retain) UIFont *font;

@end

@implementation IBAPickListFormOption

@synthesize name = name_;
@synthesize iconImage = iconImage_;
@synthesize font = font_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(name_);
	IBA_RELEASE_SAFELY(iconImage_);
	IBA_RELEASE_SAFELY(font_);
	
	[super dealloc];
}

- (id)initWithName:(NSString *)name iconImage:(UIImage *)iconImage font:(UIFont *)font {
	if ((self = [super init])) {
		self.name = name;
		self.iconImage = iconImage;
		self.font = font;
	}

	return self;
}

+ (NSArray *)pickListOptionsForStrings:(NSArray *)optionNames {
	return [[self class] pickListOptionsForStrings:optionNames font:[UIFont systemFontOfSize:16]];
}

+ (NSArray *)pickListOptionsForStrings:(NSArray *)optionNames font:(UIFont *)font {
	NSMutableArray *options = [NSMutableArray array];
	for (NSString *optionName in optionNames) {
		[options addObject:[[[IBAPickListFormOption alloc] initWithName:optionName iconImage:nil font:font] autorelease]];
	}
	
	return options;
}

- (NSString *)description {
	return self.name;
}

@end



#pragma mark -
#pragma mark IBAPickListFormOptionsStringTransformer

@interface IBAPickListFormOptionsStringTransformer ()
- (IBAPickListFormOption *)optionWithName:(NSString *)optionName;
@end

@implementation IBAPickListFormOptionsStringTransformer

@synthesize pickListOptions = pickListOptions_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(pickListOptions_);

	[super dealloc];
}

- (id)initWithPickListOptions:(NSArray *)pickListOptions {
	if ((self = [super init])) {
		self.pickListOptions = pickListOptions;
	}

	return self;
}

+ (Class)transformedValueClass {
	return [NSSet class];
}

+ (BOOL)allowsReverseTransformation {
	return YES;
}

- (id)transformedValue:(id)value {
	// Assume we're given a set of IBAPickListFormOptions and convert them to a set of NSStrings
	NSMutableSet *optionNames = [[[NSMutableSet alloc] init] autorelease];
	for (IBAPickListFormOption *option in value) {
		[optionNames addObject:[option name]];
	}

	return optionNames;
}

- (id)reverseTransformedValue:(id)value {
	// Assume we're given a set of NSStrings and convert them to a set of IBAPickListFormOption
	NSMutableSet *options = [[[NSMutableSet alloc] init] autorelease];
	for (NSString *optionName in value) {
		IBAPickListFormOption *option = [self optionWithName:optionName];
		if (option != nil) {
			[options addObject:option];
		}
	}

	return options;
}


- (IBAPickListFormOption *)optionWithName:(NSString *)optionName {
	NSArray *filteredOptions = [self.pickListOptions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", optionName]];
	return (filteredOptions.count > 0) ? [filteredOptions lastObject] : nil;
}

@end


#pragma mark -
#pragma mark IBASingleIndexTransformer

@implementation IBASingleIndexTransformer

@synthesize pickListOptions = pickListOptions_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(pickListOptions_);
	
	[super dealloc];
}

- (id)initWithPickListOptions:(NSArray *)pickListOptions {
	if ((self = [super init])) {
		self.pickListOptions = pickListOptions;
	}
	
	return self;
}

+ (Class)transformedValueClass {
	return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation {
	return YES;
}

- (id)transformedValue:(id)value {
	// Assume we're given a set with a single IBAPickListFormOption and convert it to an NSNumber representing the option
	// index in to pickListOptions
	IBAPickListFormOption *option = [value anyObject];
	NSNumber *index = [NSNumber numberWithInt:[self.pickListOptions indexOfObject:option]];
	
	return index;
}

- (id)reverseTransformedValue:(id)value {
	// Assume we're given an NSNumber representing an index in to pickListOptions and convert it to a set with a 
	// single IBAPickListFormOption
	NSMutableSet *options = [[[NSMutableSet alloc] init] autorelease];
	int index = [(NSNumber *)value intValue];
	if ((index >= 0) && (index < [self.pickListOptions count])) {
		IBAPickListFormOption *option = [self.pickListOptions objectAtIndex:index];
		if (option != nil) {
			[options addObject:option];
		}
	}
	
	return options;
}

@end
