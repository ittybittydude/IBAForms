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
//
//  Created by Sébastien HOUZE on 23/08/11.
//  Copyright (c) 2011 RezZza. All rights reserved.
//

#import <UIKit/UIKit.h>

#if TARGET_IPHONE_SIMULATOR

#define IBAPickListRowsMax (NSIntegerMax / 100000)

#else

#define IBAPickListRowsMax (NSIntegerMax / 100000)

#endif

#define IBAInputPickerViewRowUpdated @"IBAInputPickerViewRowUpdated"

@interface IBAInputGenericPickerView : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>
{
    BOOL isCircular;
    NSMutableArray *translation;
    NSArray *pickListOptions;
}

@property (nonatomic, retain) NSArray *pickListOptions;
@property (nonatomic) BOOL isCircular;
@property (nonatomic, retain) NSMutableArray *translation;

@end
