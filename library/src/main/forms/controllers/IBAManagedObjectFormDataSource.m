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

#import "IBAManagedObjectFormDataSource.h"
#import "IBACoreDataContextProvider.h"


@interface IBAManagedObjectFormDataSource ()
- (IBACoreDataContextProvider *)coreDataContext;
@end


@implementation IBAManagedObjectFormDataSource

@synthesize autoSaveEnabled;

- (id)initWithModel:(id)aModel {
	self = [super initWithModel:aModel];
	if (self != nil) {
		autoSaveEnabled = YES; // we save each time the model is changed by default
	}
	
	return self;
}


- (void)setModelValue:(id)value forKey:(NSString *)key {
	[super setModelValue:value forKey:key];

	if (autoSaveEnabled) {
		// If the model is a managed object, save the change to the database
		if ([self.model isKindOfClass:[NSManagedObject class]]) {
			NSManagedObject *managedObject = self.model;
			NSError *error;
			if (![managedObject.managedObjectContext save:&error]) {
				[[self coreDataContext] handleCoreDataError:error];
			}
		}
	}
}

// TODO We shouldn't assume the core data context is provided by the app delegate. It should be passed in to the 
// IBAManagedObjectFormDataSource
- (IBACoreDataContextProvider *)coreDataContext {
	return (IBACoreDataContextProvider *)[[UIApplication sharedApplication] delegate];
}

@end
