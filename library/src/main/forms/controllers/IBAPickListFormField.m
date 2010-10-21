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

@synthesize pickListCell;
@synthesize selectionMode;
@synthesize pickListOptions;

- (void)dealloc {
	IBA_RELEASE_SAFELY(pickListCell);
	IBA_RELEASE_SAFELY(pickListOptions);

	[super dealloc];
}


- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle valueTransformer:(NSValueTransformer *)aValueTransformer 
	selectionMode:(IBAPickListSelectionMode)theSelectionMode options:(NSArray *)thePickListOptions editable:(BOOL)editableFlag movable:(BOOL)movableFlag {
	self = [super initWithKey:aKey title:aTitle valueTransformer:aValueTransformer editable:editableFlag movable:movableFlag];
	if (self != nil) {
		self.selectionMode = theSelectionMode;
		self.pickListOptions = thePickListOptions;
	}
	
	return self;
}


- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle valueTransformer:(NSValueTransformer *)aValueTransformer
	selectionMode:(IBAPickListSelectionMode)theSelectionMode options:(NSArray *)thePickListOptions {
	return [self initWithKey:aKey title:aTitle valueTransformer:aValueTransformer selectionMode:theSelectionMode options:thePickListOptions editable:NO movable:NO ];
}


- (NSString *)formFieldStringValue {
	NSMutableArray *itemNames = [[[NSMutableArray alloc] init] autorelease];
  
	for (id<IBAPickListOption> item in [self pickListOptions]) {
		NSString *itemName = [item name];
    if (([[self formFieldValue] containsObject:item]) && (itemName.length > 0)) {
			[itemNames addObject:itemName];
		}
	}
	
	return [itemNames componentsJoinedByString:@", "]; 
}


#pragma mark -
#pragma mark Cell management

- (IBAFormFieldCell *)cell {
	if (pickListCell == nil) {
		pickListCell = [[IBATextFormFieldCell alloc] initWithFormFieldStyle:self.formFieldStyle reuseIdentifier:@"Cell"];
		pickListCell.textField.enabled = NO;
	}
	
	return pickListCell;
}

- (void)updateCellContents {
	self.pickListCell.label.text = self.title;
	self.pickListCell.textField.text = [self formFieldStringValue];
}


#pragma mark -
#pragma mark IBAInputRequestor

- (NSString *)dataType {
	return IBAInputDataTypePickList;
}

@end


#pragma mark -
#pragma mark IBAPickListFormOption

@interface IBAPickListFormOption ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) UIImage *iconImage;

@end

@implementation IBAPickListFormOption 

@synthesize name;
@synthesize iconImage;

- (void)dealloc {
	IBA_RELEASE_SAFELY(name);
	IBA_RELEASE_SAFELY(iconImage);
	
	[super dealloc];
}

- (id)initWithName:(NSString *)theName iconImage:(UIImage *)theIconImage {
	self = [super init];
	if (self != nil) {
		self.name = theName;
		self.iconImage = theIconImage;
	}
	
	return self;
}

+ (NSArray *)pickListOptionsForStrings:(NSArray *)optionNames {
	NSMutableArray *options = [NSMutableArray array];
	for (NSString *optionName in optionNames) {
		[options addObject:[[[IBAPickListFormOption alloc] initWithName:optionName iconImage:nil] autorelease]];
	}
	
	return options;
}

@end



#pragma mark -
#pragma mark IBAPickListFormOptionsStringTransformer

@interface IBAPickListFormOptionsStringTransformer ()
- (IBAPickListFormOption *)optionWithName:(NSString *)optionName;
@end

@implementation IBAPickListFormOptionsStringTransformer

@synthesize pickListOptions;

- (void)dealloc {
	IBA_RELEASE_SAFELY(pickListOptions);
	
	[super dealloc];
}

- (id)initWithPickListOptions:(NSArray *)thePickListOptions {
	self = [super init];
	if (self != nil) {
		self.pickListOptions = thePickListOptions;
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