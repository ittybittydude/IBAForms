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
//  Created by Sébastien HOUZE on 18/08/11.
//  Copyright (c) 2011 RezZza. All rights reserved.
//


#import "IBAInputCreditCardExpiryDatePicker.h"
#import "IBAInputGenericPickerView.h"

@implementation IBAInputCreditCardExpiryDatePicker

@synthesize monthCollection, yearCollection, dateComponents, date;

-(id)init
{
    self = [super init];

    self.delegate = self;
    self.dataSource = self;

    self.date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    self.dateComponents = [calendar components:(NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekCalendarUnit) fromDate:self.date];
    [calendar release];
    
    self.monthCollection =[NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
	self.yearCollection = [self createYearArray:[self.dateComponents year]];
    self.showsSelectionIndicator = YES;
	self.backgroundColor = [UIColor clearColor];


    NSInteger month = [self.dateComponents month] - 1;
    NSInteger year = [self.dateComponents year] - CREATION_DATE;
	[self selectRow:(month + [monthCollection count] *  ((IBAPickListRowsMax / [self.monthCollection count]) / 2)) inComponent:MONTH_COMPONENT animated:YES];
    [self selectRow:(year + [yearCollection count] *  ((IBAPickListRowsMax / [self.yearCollection count]) / 2)) inComponent:YEAR_COMPONENT animated:YES];
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    NSLog(@"==%ld==", IBAPickListRowsMax);
	return NB_COMPONENT_CCEDP;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (component == MONTH_COMPONENT)
        return [monthCollection count] * (IBAPickListRowsMax / [self.monthCollection count]);
    else if (component == YEAR_COMPONENT)
        return [yearCollection count] *  (IBAPickListRowsMax / [self.yearCollection count]);
    return -1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (component == MONTH_COMPONENT)
        return [monthCollection objectAtIndex:(row % [monthCollection count])];
    else if (component == YEAR_COMPONENT)
        return [yearCollection objectAtIndex:(row % [yearCollection count])];
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:([self selectedRowInComponent:YEAR_COMPONENT] % [yearCollection count] + CREATION_DATE)];
    [comps setMonth:([self selectedRowInComponent:MONTH_COMPONENT] % [monthCollection count] + 1)];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    if(component == YEAR_COMPONENT)
    {
        [self reloadComponent:MONTH_COMPONENT];
    }
    if ([self selectedRowInComponent:MONTH_COMPONENT] % [monthCollection count] < [self.dateComponents month] - 1 &&
        ([self selectedRowInComponent:YEAR_COMPONENT] % [yearCollection count] + CREATION_DATE <= [self.dateComponents year]))
    {
        [self selectRow:([self.dateComponents month] - 1 + [monthCollection count] *  ((IBAPickListRowsMax / [self.monthCollection count]) / 2)) inComponent:MONTH_COMPONENT animated:YES];
        comps.month = [self.dateComponents month];
    }
    if ([self selectedRowInComponent:YEAR_COMPONENT] % [yearCollection count] + CREATION_DATE < [self.dateComponents year])
    {
        [self selectRow:([self.dateComponents year] - CREATION_DATE + [yearCollection count] *  ((IBAPickListRowsMax / [self.yearCollection count]) / 2)) inComponent:YEAR_COMPONENT animated:YES];
        comps.year = [self.dateComponents year];
    }
    self.date = [gregorian dateFromComponents:comps];
    [comps release];
    [gregorian release];

    [[NSNotificationCenter defaultCenter] postNotificationName:IBAInputDatePickerViewRowUpdated object:self];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] autorelease];
    [lbl setEnabled:YES];
    if (component == MONTH_COMPONENT)
    {
        lbl.text = [monthCollection objectAtIndex:(row % (component == MONTH_COMPONENT ? [monthCollection count] : [yearCollection count]))];
        if ((row % [monthCollection count]) < [self.dateComponents month] - 1 &&
            ([self selectedRowInComponent:YEAR_COMPONENT] % [yearCollection count]) + CREATION_DATE <= [self.dateComponents year])
            [lbl setEnabled:NO];
    }
    else if (component == YEAR_COMPONENT)
    {
        lbl.text = [yearCollection objectAtIndex:(row % [yearCollection count])];
        if ((row % [yearCollection count])+ CREATION_DATE < [self.dateComponents year])
            [lbl setEnabled:NO];
    }
    else
    {
        return nil;
    }
    
    lbl.adjustsFontSizeToFitWidth = YES;
    lbl.textAlignment=UITextAlignmentCenter;
    lbl.font=[UIFont systemFontOfSize:20];
    return lbl;
}

-(NSArray *)createYearArray:(int)year
{
    NSMutableArray *yearArray = [NSMutableArray new];

    for (int i = 0; i <= IBA_CREDIT_CARD_EXPIRY_DATE_PICKER_YEAR_RANGE; i++) {
        [yearArray addObject:[NSString stringWithFormat:@"%d", (year + i)]];
    }
    return (NSArray *)yearArray;
}

@end
