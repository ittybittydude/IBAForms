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
#import "IBAInputProvider.h"
#import "IBAInputRequestorDataSource.h"
#import "IBAInputRequestor.h"
#import "IBAInputNavigationToolbar.h"


@interface IBAInputManager : NSObject {
	NSMutableDictionary *inputProviders_;
	id<IBAInputRequestorDataSource> inputRequestorDataSource_;
	id<IBAInputRequestor> activeInputRequestor_;
	IBAInputNavigationToolbar *inputNavigationToolbar_;
    BOOL inputNavigationToolbarEnabled_;
}


@property (nonatomic, retain) id<IBAInputRequestorDataSource> inputRequestorDataSource;
@property (nonatomic, retain) IBAInputNavigationToolbar *inputNavigationToolbar;
@property (nonatomic, assign, getter = isInputNavigationToolbarEnabled) BOOL inputNavigationToolbarEnabled;

+ (IBAInputManager *)sharedIBAInputManager;

- (BOOL)setActiveInputRequestor:(id<IBAInputRequestor>)inputRequestor;
- (id<IBAInputRequestor>)activeInputRequestor;

#pragma mark -
#pragma mark Input Provider Registration/Deregistration
- (void)registerInputProvider:(id<IBAInputProvider>)provider forDataType:(NSString *)dataType;
- (void)deregisterInputProviderForDataType:(NSString *)dataType;
- (id<IBAInputProvider>)inputProviderForDataType:(NSString *)dataType;


#pragma mark -
#pragma mark Matching input requestors with input providers
- (id<IBAInputProvider>)inputProviderForRequestor:(id<IBAInputRequestor>)inputRequestor;
- (id<IBAInputProvider>)inputProviderForActiveInputRequestor;

#pragma mark -
#pragma mark Input requestor activation
- (BOOL)activateNextInputRequestor;
- (BOOL)activatePreviousInputRequestor;
- (BOOL)deactivateActiveInputRequestor;

@end
