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

#import "IBAFormDataSource.h"
#import "IBACommon.h"

@implementation IBAFormDataSource

@synthesize name;
@synthesize sections;
@synthesize model;
@synthesize formFieldStyle;

#pragma mark -
#pragma mark Initialisation and memory management

- (void)dealloc {
	IBA_RELEASE_SAFELY(name);
	IBA_RELEASE_SAFELY(sections);
	IBA_RELEASE_SAFELY(model);
	IBA_RELEASE_SAFELY(formFieldStyle);
	
	[super dealloc];
}

- (id)initWithModel:(id)aModel {
	self = [super init];
	if (self != nil) {
		model = [aModel retain];
		sections = [[NSMutableArray alloc] init];
		formFieldStyle = [[IBAFormFieldStyle alloc] init];
	}
	
	return self;
}

- (id)init {
	return [self initWithModel:nil];
}


#pragma mark -
#pragma mark Section and field management

- (NSInteger)sectionCount {
	return [sections count];
}

- (NSInteger)numberOfFormFieldsInSection:(NSInteger)sectionLocation {
	IBAFormSection *section = [sections objectAtIndex:sectionLocation];
	return (section != nil) ? [section.formFields count] : 0;
}

- (UITableViewCell *)cellForFormFieldAtIndexPath:(NSIndexPath *)indexPath {
	// We make the form field update its contents before handing it back its cell
	IBAFormField *formField = [self formFieldAtIndexPath:indexPath];
//	[formField updateCellContents];
	
	return [formField cell];
}

- (IBAFormField *)formFieldAtIndexPath:(NSIndexPath *)indexPath {
	IBAFormSection *section = [sections objectAtIndex:indexPath.section];
	return [section.formFields objectAtIndex:indexPath.row];
}


- (NSIndexPath *)indexPathForFormField:(IBAFormField *)formField {
	NSIndexPath *indexPath = nil;
	
	NSUInteger sectionCount = [self sectionCount];
	for (NSUInteger sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++) {
		IBAFormSection *section = [sections objectAtIndex:sectionIndex];
		NSUInteger fieldLocation = [section.formFields indexOfObject:formField];
		if (fieldLocation != NSNotFound) {
			indexPath = [NSIndexPath indexPathForRow:fieldLocation inSection:sectionIndex];
		}
	}
	
	return indexPath;
}


// This method returns the next logical form field after the one provided. That may be the first field in the next 
// section if the given field is the last in its section.
- (IBAFormField *)formFieldAfter:(IBAFormField *)field {
	IBAFormField *nextField = nil;
	
	NSUInteger sectionCount = [self sectionCount];
	for (NSUInteger sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++) {
		IBAFormSection *section = [sections objectAtIndex:sectionIndex];
		NSUInteger fieldLocation = [section.formFields indexOfObject:field];
		if (fieldLocation != NSNotFound) {
			if ([field isEqual:[section.formFields lastObject]]) {
				// it's the last field in the section, so get the first one in the next section (if there is one)
				if (sectionIndex < (sectionCount - 1)) {
					section = [sections objectAtIndex:sectionIndex + 1];
					if ([section.formFields count] > 0) {
						nextField = [section.formFields objectAtIndex:0];
					}	
				}
			} else {
				nextField = [section.formFields objectAtIndex:fieldLocation + 1];
			}
		}
	}
	
	return nextField;
}

- (IBAFormField *)formFieldBefore:(IBAFormField *)field {
	IBAFormField *previousField = nil;
	
	NSUInteger sectionCount = [self sectionCount];
	for (NSUInteger sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++) {
		IBAFormSection *section = [sections objectAtIndex:sectionIndex];
		NSUInteger fieldLocation = [section.formFields indexOfObject:field];
		if (fieldLocation != NSNotFound) {
			if ([field isEqual:[section.formFields objectAtIndex:0]]) {
				// it's the first field in the section, so get the last one in the previous section (if there is one)
				if (sectionIndex > 0) {
					section = [sections objectAtIndex:sectionIndex - 1];
					if ([section.formFields count] > 0) {
						previousField = [section.formFields lastObject];
					}	
				}
			} else {
				previousField = [section.formFields objectAtIndex:fieldLocation - 1];
			}
		}
	}
	
	return previousField;
}

- (void)addSection:(IBAFormSection *)newSection {
	[sections addObject:newSection];
	newSection.modelManager = self;
	newSection.formFieldStyle = self.formFieldStyle;
}

- (IBAFormSection *)addSectionWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle {
	IBAFormSection *newSection = [[[IBAFormSection alloc] initWithHeaderTitle:headerTitle
																					 footerTitle:footerTitle] autorelease];
	[self addSection:newSection];
	
	return newSection;
}

- (UIView *)viewForHeaderInSection:(NSInteger)section {
	return [[sections objectAtIndex:section] headerView];
}

- (UIView *)viewForFooterInSection:(NSInteger)section {
	return [[sections objectAtIndex:section] footerView];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self sectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self numberOfFormFieldsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self cellForFormFieldAtIndexPath:(NSIndexPath *)indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[self.sections objectAtIndex:section] headerTitle];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return [[self.sections objectAtIndex:section] footerTitle];
}


#pragma mark -
#pragma mark IBAFormModelManager
- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
	[self.model setValue:value forKeyPath:keyPath];
}


- (id)modelValueForKeyPath:(NSString *)keyPath {
	return [self.model valueForKeyPath:keyPath];
}

@end
