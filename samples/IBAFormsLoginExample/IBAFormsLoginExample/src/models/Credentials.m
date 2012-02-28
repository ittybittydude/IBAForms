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

#import "Credentials.h"

@implementation Credentials

@synthesize emailAddress = emailAddress_;
@synthesize password = password_;

- (void)dealloc {
	[emailAddress_ release];
	[password_ release];
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Email address = %@, Password = %@", [self emailAddress], [self password]];
}

+ (Credentials *)credentialsWithEmailAddress:(NSString *)emailAddress password:(NSString *)password {
	Credentials *credentials = [[Credentials alloc] init];

	[credentials setEmailAddress:emailAddress];
	[credentials setPassword:password];

	return [credentials autorelease];
}

@end
