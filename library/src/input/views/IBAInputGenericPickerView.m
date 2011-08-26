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

#import "IBAInputGenericPickerView.h"
#import "IBACommon.h"
#import "IBAPickListFormField.h"
#import "IBAPickListOptionsProvider.h"

@implementation IBAInputGenericPickerView

@synthesize isCircular, pickListOptions;
@synthesize translation, isFirstTime;

-(id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.showsSelectionIndicator = YES;
        self.dataSource = self;
        self.delegate = self;
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        self.pickListOptions = [NSArray arrayWithObjects:nil];

        self.isCircular = NO;
        self.translation = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0],nil];

        self.isFirstTime = YES;
    }
    
    return self;
}

- (id)init {
	if ((self = [super init])) {
        self.showsSelectionIndicator = YES;
		self.dataSource = self;
		self.delegate = self;
        self.pickListOptions = [NSArray arrayWithObjects:nil];
		self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;

        self.isCircular = NO;
        self.translation = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0],nil];
        self.isFirstTime = YES;
	}
	return self;
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1; 
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return isCircular ? [self.pickListOptions count] * (IBAPickListRowsMax / [self.pickListOptions count]) : [self.pickListOptions count];
}

#pragma mark -
#pragma mark UIPickerViewDelegate


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UILabel *label = nil;
    
	if ((view != nil) && ([view isKindOfClass:[UILabel class]])){
		label = (UILabel *)view;
	} else {
		label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.bounds.size.width - 40, 44)] autorelease];
		label.backgroundColor = [UIColor clearColor];
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0, 1);
	}    
    [self.translation replaceObjectAtIndex:component withObject:[NSNumber numberWithInt:(row / [self.pickListOptions count])]];
	id<IBAPickListOption> pickListOption = [self.pickListOptions objectAtIndex:(row - [[translation objectAtIndex:component] intValue] * [self.pickListOptions count])];
	label.text = pickListOption.name;
    label.font = pickListOption.font;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.translation replaceObjectAtIndex:component withObject:[NSNumber numberWithInt:(row / [self.pickListOptions count])]];
    self.isFirstTime = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:IBAInputPickerViewRowUpdated object:self userInfo:
    [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:
                                                                [NSNumber numberWithInt:(row - [[translation objectAtIndex:component] intValue] * [self.pickListOptions count])],
                                                                [NSNumber numberWithInt:component],
                                                                nil]
                                 forKey:@"selectedRow"]];
}

@end
