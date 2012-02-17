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
//  Created by Sébastien HOUZE on 19/08/11.
//  Copyright (c) 2011 RezZza. All rights reserved.
//

#import "IBAInputCreditCardTypePicker.h"

@implementation IBAInputCreditCardTypePicker


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    [self.translation replaceObjectAtIndex:component withObject:[NSNumber numberWithInt:(row / [self.pickListOptions count])]];    
    id<IBAPickListOption> pickListOption = [self.pickListOptions objectAtIndex:(row - [[translation objectAtIndex:component] intValue] * [self.pickListOptions count])];
    UIView *rowView = nil;
    UIImageView *cardImageView;
    UILabel *lbl;
    
    if (view != nil)
    {
        cardImageView = (UIImageView *)[view viewWithTag:IBAInputCreditCardTypePickerImageViewTag];
        lbl = (UILabel *)[view viewWithTag:IBAInputCreditCardTypePickerLabelTag];
        lbl.text = pickListOption.name;
        lbl.font = pickListOption.font;
        cardImageView.frame = CGRectMake(cardImageView.frame.origin.x, cardImageView.frame.origin.y,
                                         pickListOption.iconImage.size.width, pickListOption.iconImage.size.height);
        cardImageView.image = pickListOption.iconImage;
        rowView = view;
    }
    else
    {
        rowView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] autorelease];
        
        // Label & Font
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(122.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        lbl.enabled                   = YES;
        lbl.text                      = pickListOption.name;
        lbl.adjustsFontSizeToFitWidth = YES;
        lbl.textAlignment             = UITextAlignmentLeft;
        lbl.font                      = pickListOption.font;
        lbl.opaque                    = NO;
        lbl.backgroundColor           = [UIColor clearColor];
        lbl.tag = IBAInputCreditCardTypePickerLabelTag;
        [rowView addSubview:lbl];
        [lbl release];
        
        // Image
        UIImage *cardImage = pickListOption.iconImage;
        cardImageView = [[UIImageView alloc] initWithImage:cardImage];
        cardImageView.tag = IBAInputCreditCardTypePickerImageViewTag;
        CGRect frame = cardImageView.frame;
        cardImageView.frame = CGRectMake(frame.origin.x + 5, frame.origin.y + 7, frame.size.width, frame.size.height);
        [rowView addSubview:cardImageView];
        [cardImageView release];
    }
    
    return rowView;
}

@end