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
#import "IBAInputManager.h"

@implementation IBAFormDataSource

@synthesize name = name_;
@synthesize sections = sections_;
@synthesize model = model_;
@synthesize formFieldStyle = formFieldStyle_;
@synthesize tableView = tableView_;

#pragma mark -
#pragma mark Initialisation and memory management

- (void)dealloc {
	IBA_RELEASE_SAFELY(name_);
	IBA_RELEASE_SAFELY(sections_);
	IBA_RELEASE_SAFELY(model_);
	IBA_RELEASE_SAFELY(formFieldStyle_);
    IBA_RELEASE_SAFELY(tableView_);
	
	[super dealloc];
}

- (id)initWithModel:(id)model {
	if ((self = [super init])) {
		model_ = [model retain];
		sections_ = [[NSMutableArray alloc] init];
		formFieldStyle_ = [[IBAFormFieldStyle alloc] init];
        tableView_ = nil;
	}
	
	return self;
}

- (id)init {
	return [self initWithModel:nil];
}


#pragma mark -
#pragma mark Section and field management

- (NSInteger)sectionCount {
	return [self.sections count];
}

- (NSInteger)numberOfFormFieldsInSection:(NSInteger)sectionLocation {
	IBAFormSection *section = [self.sections objectAtIndex:sectionLocation];
	return (section != nil) ? [section.formFields count] : 0;
}

- (UITableViewCell *)cellForFormFieldAtIndexPath:(NSIndexPath *)indexPath {
	// We make the form field update its contents before handing it back its cell
	id<IBAFormFieldProtocol> formField = [self formFieldAtIndexPath:indexPath];
	[formField updateCellContents];
	
	return [formField cell];
}

- (id<IBAFormFieldProtocol> )formFieldAtIndexPath:(NSIndexPath *)indexPath {
	IBAFormSection *section = [self.sections objectAtIndex:indexPath.section];
	return [section.formFields objectAtIndex:indexPath.row];
}


- (NSIndexPath *)indexPathForFormField:(id<IBAFormFieldProtocol>)formField {
	NSIndexPath *indexPath = nil;
	
	NSUInteger sectionCount = [self sectionCount];
	for (NSUInteger sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++) {
		IBAFormSection *section = [self.sections objectAtIndex:sectionIndex];
		NSUInteger fieldLocation = [section.formFields indexOfObject:formField];
		if (fieldLocation != NSNotFound) {
			indexPath = [NSIndexPath indexPathForRow:fieldLocation inSection:sectionIndex];
		}
	}
	
	return indexPath;
}

- (NSInteger)indexForFormSection:(IBAFormSection*)section {
    NSInteger index = [self.sections indexOfObject:section];
	return index;
}


// This method returns the next logical form field after the one provided. That may be the first field in the next 
// section if the given field is the last in its section.
- (IBAFormField *)formFieldAfter:(IBAFormField *)field {
	IBAFormField *nextField = nil;
	
	NSUInteger sectionCount = [self sectionCount];
	for (NSUInteger sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++) {
		IBAFormSection *section = [self.sections objectAtIndex:sectionIndex];
		NSUInteger fieldLocation = [section.formFields indexOfObject:field];
		if (fieldLocation != NSNotFound) {
			if ([field isEqual:[section.formFields lastObject]]) {
				// it's the last field in the section, so get the first one in the next section (if there is one)
                NSUInteger currentSectionIndex = sectionIndex;
				while (currentSectionIndex < (sectionCount - 1)) {
					section = [self.sections objectAtIndex:currentSectionIndex + 1];
					if ([section.formFields count] > 0) {
						nextField = [section.formFields objectAtIndex:0];
                        break;
					} else {
                        currentSectionIndex++;
                    }
				}
                if(nextField)
                    break;
			} else {
				nextField = [section.formFields objectAtIndex:fieldLocation + 1];
                break;
			}
		}
	}
	
	return nextField;
}

- (IBAFormField *)formFieldBefore:(IBAFormField *)field {
	IBAFormField *previousField = nil;
	
	NSUInteger sectionCount = [self sectionCount];
	for (NSUInteger sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++) {
		IBAFormSection *section = [self.sections objectAtIndex:sectionIndex];
		NSUInteger fieldLocation = [section.formFields indexOfObject:field];
		if (fieldLocation != NSNotFound) {
			if ([field isEqual:[section.formFields objectAtIndex:0]]) {
				// it's the first field in the section, so get the last one in the previous section (if there is one)
                NSUInteger currentSectionIndex = sectionIndex;
				while (currentSectionIndex > 0) {
					section = [self.sections objectAtIndex:currentSectionIndex - 1];
					if ([section.formFields count] > 0) {
						previousField = [section.formFields lastObject];
                        break;
					} else {
                        currentSectionIndex--;
                    }
				}
                if(previousField)
                    break;
			} else {
				previousField = [section.formFields objectAtIndex:fieldLocation - 1];
                break;
			}
		}
	}
	
	return previousField;
}

- (IBAFormSection*)createSectionWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle {
    IBAFormSection *newSection = [[[IBAFormSection alloc] initWithHeaderTitle:headerTitle
																  footerTitle:footerTitle] autorelease];
    newSection.modelManager = self;
	newSection.formFieldStyle = self.formFieldStyle;
	return newSection;
}

- (void)insertWithAnimation:(UITableViewRowAnimation*)animation section:(IBAFormSection *)newSection {
	[self.sections addObject:newSection];
	newSection.modelManager = self;
	newSection.formFieldStyle = self.formFieldStyle;
    if(self.tableView != nil) {
        if(animation != NULL) {
            [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:[self.sections count]] withRowAnimation:*animation];
        } else {
            if([[IBAInputManager sharedIBAInputManager] setActiveInputRequestor:nil]) {
                [[self tableView] reloadData];
            }
        }
    }
}

- (void)insertWithAnimation:(UITableViewRowAnimation*)animation sections:(IBAFormSection *)firstSection, ... {
    va_list ap;
    NSInteger startIndex = [self.sections count];
    NSInteger length = 0;
    IBAFormSection* section = nil;
    va_start(ap, firstSection);
    section = firstSection;
    while(section){
        [self.sections addObject:section];
        section.modelManager = self;
        section.formFieldStyle = self.formFieldStyle;
        length++;
        section = va_arg(ap, IBAFormSection*);
    }
    va_end(ap);
    if(length > 0 && self.tableView != nil) {
        if(animation != NULL) {
            [[self tableView] insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, length)] withRowAnimation:*animation];
        } else {
            if([[IBAInputManager sharedIBAInputManager] setActiveInputRequestor:nil]) {
                [[self tableView] reloadData];
            }
        }
    }
}

- (void)insertWithAnimation:(UITableViewRowAnimation*)animation atIndex:(NSInteger)index section:(IBAFormSection *)newSection {
    if(index < 0) index = 0;
    if(index > [self.sections count]) index = [self.sections count];
    [self.sections insertObject:newSection atIndex:index];
    newSection.modelManager = self;
    newSection.formFieldStyle = self.formFieldStyle;
    if(self.tableView != nil) {
        if(animation != NULL) {
            [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:*animation];
        } else {
            if([[IBAInputManager sharedIBAInputManager] setActiveInputRequestor:nil]) {
                [[self tableView] reloadData];
            }
        }
    }
}

- (void)insertWithAnimation:(UITableViewRowAnimation*)animation atIndexes:(NSIndexSet*)indexes sections:(IBAFormSection *)firstSection, ... {
    va_list ap;
    NSMutableIndexSet *validIndexes = [NSMutableIndexSet indexSet];
    IBAFormSection* section = nil;
    va_start(ap, firstSection);
    section = firstSection;
    NSUInteger currentIndex = [indexes firstIndex];
    while(section){
        if(currentIndex > [self.sections count]) currentIndex = [self.sections count];
        [validIndexes addIndex:currentIndex];
        [self.sections insertObject:section atIndex:currentIndex];
        section.modelManager = self;
        section.formFieldStyle = self.formFieldStyle;
        section = va_arg(ap, IBAFormSection*);
        currentIndex = [indexes indexGreaterThanIndex:currentIndex];
    }
    va_end(ap);
    if([validIndexes count] > 0 && self.tableView != nil) {
        if(animation != NULL) {
            [[self tableView] insertSections:validIndexes withRowAnimation:*animation];
        } else {
            if([[IBAInputManager sharedIBAInputManager] setActiveInputRequestor:nil]) {
                [[self tableView] reloadData];
            }
        }
    }
}

- (void)insertOnceWithAnimation:(UITableViewRowAnimation*)animation section:(IBAFormSection *)newSection {
    if([self.sections containsObject:newSection] == NO) {
        [self insertWithAnimation:animation section:newSection];
    }
}

- (void)insertOnceWithAnimation:(UITableViewRowAnimation*)animation sections:(IBAFormSection *)firstSection, ... {
    va_list ap;
    NSInteger startIndex = [self.sections count];
    NSInteger length = 0;
    IBAFormSection* section = nil;
    va_start(ap, firstSection);
    section = firstSection;
    while(section){
        if([self.sections containsObject:section] == NO) {
            [self.sections addObject:section];
            section.modelManager = self;
            section.formFieldStyle = self.formFieldStyle;
            length++;
        }
        section = va_arg(ap, IBAFormSection*);
    }
    va_end(ap);
    if(length > 0 && self.tableView != nil) {
        if(animation != NULL) {
            [[self tableView] insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, length)] withRowAnimation:*animation];
        } else {
            if([[IBAInputManager sharedIBAInputManager] setActiveInputRequestor:nil]) {
                [[self tableView] reloadData];
            }
        }
    }
}

- (void)insertOnceWithAnimation:(UITableViewRowAnimation*)animation atIndex:(NSInteger)index section:(IBAFormSection *)newSection {
    if([self.sections containsObject:newSection] == NO) {
        [self insertWithAnimation:animation atIndex:index section:newSection];
    }
}

- (void)insertOnceWithAnimation:(UITableViewRowAnimation*)animation atIndexes:(NSIndexSet*)indexes sections:(IBAFormSection *)firstSection, ... {
    va_list ap;
    NSMutableIndexSet *validIndexes = [NSMutableIndexSet indexSet];
    IBAFormSection* section = nil;
    va_start(ap, firstSection);
    section = firstSection;
    NSUInteger currentIndex = [indexes firstIndex];
    while(section){
        if([self.sections containsObject:section] == NO) {
            if(currentIndex > [self.sections count]) currentIndex = [self.sections count];
            [validIndexes addIndex:currentIndex];
            [self.sections insertObject:section atIndex:currentIndex];
            section.modelManager = self;
            section.formFieldStyle = self.formFieldStyle;
        }
        section = va_arg(ap, IBAFormSection*);
        currentIndex = [indexes indexGreaterThanIndex:currentIndex];
    }
    va_end(ap);
    if([validIndexes count] > 0 && self.tableView != nil) {
        if(animation != NULL) {
            [[self tableView] insertSections:validIndexes withRowAnimation:*animation];
        } else {
            if([[IBAInputManager sharedIBAInputManager] setActiveInputRequestor:nil]) {
                [[self tableView] reloadData];
            }
        }
    }
}

- (IBAFormSection *)addSectionWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle {
	IBAFormSection *newSection = [[[IBAFormSection alloc] initWithHeaderTitle:headerTitle
																  footerTitle:footerTitle] autorelease];
	[self insertWithAnimation:NULL section:newSection];
	
	return newSection;
}

- (void)removeWithAnimation:(UITableViewRowAnimation*)animation section:(IBAFormSection *)section {
    if([self.sections containsObject:section] == YES) {
        NSIndexSet* indexesForDeleting = [NSIndexSet indexSetWithIndex:[self indexForFormSection:section]];
        [self.sections removeObject:section];
        if(self.tableView != nil) {
            if(animation != NULL) {
                [[self tableView] deleteSections:indexesForDeleting withRowAnimation:*animation];
            } else {
                if([[IBAInputManager sharedIBAInputManager] setActiveInputRequestor:nil]) {
                    [[self tableView] reloadData];
                }
            }
        }
    }
}

- (void)removeWithAnimation:(UITableViewRowAnimation*)animation sections:(IBAFormSection *)firstSection, ... {
    va_list ap;
    NSMutableIndexSet* indexes = [NSMutableIndexSet indexSet];
    IBAFormSection* section = nil;
    va_start(ap, firstSection);
    section = firstSection;
    while(section){
        if([self.sections containsObject:section] == YES) {
            [indexes addIndex:[self indexForFormSection:section]];
        }
        section = va_arg(ap, IBAFormSection*);
    }
    va_end(ap);
    va_start(ap, firstSection);
    section = firstSection;
    while(section){
        if([self.sections containsObject:section] == YES) {
            [self.sections removeObject:section];
        }
        section = va_arg(ap, IBAFormSection*);
    }
    va_end(ap);
    
    if([indexes count] > 0 && self.tableView != nil) {
        if(animation != NULL) {
            [[self tableView] deleteSections:indexes withRowAnimation:*animation];
        } else {
            if([[IBAInputManager sharedIBAInputManager] setActiveInputRequestor:nil]) {
                [[self tableView] reloadData];
            }
        }
    }
}

- (void)setWithAnimation:(UITableViewRowAnimation*)animation sections:(IBAFormSection *)firstSection, ... {
    NSMutableIndexSet* indexesForDeleting = [[[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self sectionCount])] mutableCopy] autorelease];
    va_list ap;
    NSInteger startIndex = [self.sections count];
    NSInteger length = 0;
    IBAFormSection* section = nil;
    va_start(ap, firstSection);
    section = firstSection;
    while(section) {
        if([self.sections containsObject:section] == NO) {
            [self.sections addObject:section];
            section.modelManager = self;
            section.formFieldStyle = self.formFieldStyle;
            length++;
        } else {
            [indexesForDeleting removeIndex:[self.sections indexOfObject:section]];
        }
        section = va_arg(ap, IBAFormSection*);
    }
    va_end(ap);
    startIndex -= [indexesForDeleting count];
    [self.sections removeObjectsAtIndexes:indexesForDeleting];
    
    if(length > 0 && self.tableView != nil) {
        if(animation != NULL) {
            [self.tableView beginUpdates];
            [[self tableView] deleteSections:indexesForDeleting withRowAnimation:*animation];
            [[self tableView] insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, length)] withRowAnimation:*animation];
            [[self tableView] endUpdates];
        } else {
            if([[IBAInputManager sharedIBAInputManager] setActiveInputRequestor:nil]) {
                [[self tableView] reloadData];
            }
        }
    }
}

- (IBAFormSection *)addSectionWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle headerHeight:(CGFloat)headerHeight footerHeight:(CGFloat)footerHeight {
    IBAFormSection *newSection = [[[IBAFormSection alloc] initWithHeaderTitle:headerTitle
																  footerTitle:footerTitle headerHeight:headerHeight footerHeight:footerHeight] autorelease];
	[self insertWithAnimation:NULL section:newSection];
	
	return newSection;
}

- (UIView *)viewForHeaderInSection:(NSInteger)section {
	return [[self.sections objectAtIndex:section] headerView];
}

- (UIView *)viewForFooterInSection:(NSInteger)section {
	return [[self.sections objectAtIndex:section] footerView];
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section {
    return [[self.sections objectAtIndex:section] headerHeight];
}

- (CGFloat)heightForFooterInSection:(NSInteger)section {
    return [[self.sections objectAtIndex:section] footerHeight];
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

- (id)modelValuesForKeyPaths:(NSArray *)keyPaths {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[keyPaths count]];
    for(NSString *keyPath in keyPaths) {
        if([keyPath isKindOfClass:[NSString class]]) {
            id val = [self.model valueForKeyPath:keyPath];
            if(val == nil) {
                val = [NSNull null];
            }
            [result addObject:val];
        } else {
            [[NSException exceptionWithName:@"Error" reason:@"keyPath must be a string" userInfo:nil] raise];
        }
    }
	return [NSArray arrayWithArray:result];
}

@end
