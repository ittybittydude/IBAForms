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

#import <Foundation/Foundation.h>

@interface IBACoreDataContextProvider : NSObject {
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;	    
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSArray *resourceBundles;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Setting this property to YES will set the NSFileProtectionKey attribute to
// NSFileProtectionComplete on the db file, enabling db encryption.
@property (nonatomic, assign) BOOL fileProtectionEnabled;

+ (IBACoreDataContextProvider *)sharedIBACoreDataContextProvider;

- (id)initWithResourceBundles:(NSArray *)theResourceBundles;
- (NSManagedObjectContext *)newManagedObjectContext;
- (void)handleCoreDataError:(NSError *)error;
- (void)deletePersistentStore;


@end