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

#import "IBASinglePickListInputProvider.h"
#import "IBACommon.h"
#import "IBAPickListOptionsProvider.h"

@interface IBASinglePickListInputProvider ()
@property (nonatomic, readonly) UIPickerView *pickerView;
@property (nonatomic, readonly) UIView *providerView;

- (NSArray *)pickListOptions;
- (id<IBAPickListOptionsProvider>)pickListOptionsProvider;
- (void)setSelectedOptionWithIndex:(NSInteger)optionIndex;
- (void)setSelectedOption:(id<IBAPickListOption>)selectedOption;
- (void)updateSelectedOption;
@end


@implementation IBASinglePickListInputProvider

@synthesize providerView = providerView_;
@synthesize pickerView = pickerView_;
@synthesize inputRequestor = inputRequestor_;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {	
	IBA_RELEASE_SAFELY(pickerView_);
	IBA_RELEASE_SAFELY(providerView_);

	[super dealloc];
}

- (id)init {
    if ((self = [super init])) {
        providerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
		providerView_.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		providerView_.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    }

	return self;
}

- (void)setInputRequestor:(id<IBAInputRequestor>)inputRequestor {
	inputRequestor_ = inputRequestor;
    
	if (inputRequestor != nil) {
        NSString *picklistClass = [inputRequestor_  getPicklistClass];
        BOOL isCircular = [inputRequestor_ getIsCircular];
        pickerView_ = [[NSClassFromString(picklistClass) alloc] initWithFrame:[providerView_ bounds]];
        ((IBAInputGenericPickerView *)self.pickerView).isCircular = isCircular;
		[providerView_ sizeToFit];
		[providerView_ addSubview:self.pickerView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:IBAInputPickerViewRowUpdated object:self.pickerView];
        
        ((IBAInputGenericPickerView *)self.pickerView).pickListOptions = self.pickListOptions;
		[self.pickerView reloadAllComponents];
        [self updateSelectedOption];
	}
}

- (void)notify:(NSNotification *)notification {
	id notificationUserInfo = [notification userInfo];
    [self setSelectedOptionWithIndex:[[[notificationUserInfo objectForKey:@"selectedRow"] objectAtIndex:0] intValue]];
}

- (id<IBAPickListOptionsProvider>)pickListOptionsProvider {
	return ((id<IBAPickListOptionsProvider>)self.inputRequestor);
}

- (NSArray *)pickListOptions {
	return [self.pickListOptionsProvider pickListOptions];
}

#pragma mark -
#pragma mark IBAInputProvider

- (UIView *)view {
    return self.providerView;
}

#pragma mark -
#pragma mark Selection helpers

- (void)setSelectedOptionWithIndex:(NSInteger)optionIndex {
    
	id<IBAPickListOption> selectedOption = [((IBAInputGenericPickerView *)self.pickerView).pickListOptions objectAtIndex:optionIndex];
	[self setSelectedOption:selectedOption];
}

- (void)setSelectedOption:(id<IBAPickListOption>)selectedOption {
	self.inputRequestor.inputRequestorValue = [NSSet setWithObject:selectedOption];     
}

- (void)updateSelectedOption {
    id<IBAPickListOption> selectedPickListOption = [self.inputRequestor.inputRequestorValue anyObject];
    NSInteger selectedRow;
    
    if (((IBAInputGenericPickerView *)self.pickerView).isCircular)
    {
        for (int i = 0; i < [((IBAInputGenericPickerView *)self.pickerView).translation count]; i++)
        {
            [((IBAInputGenericPickerView *)self.pickerView).translation replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:(IBAPickListRowsMax / [self.pickListOptions count] / 2)]];
        }
    }
    
    for (int i = 0; i < [((IBAInputGenericPickerView *)self.pickerView).translation count]; i++)
    {
        selectedRow = [((IBAInputGenericPickerView *)self.pickerView).pickListOptions count] * [[((IBAInputGenericPickerView *)self.pickerView).translation objectAtIndex:i] intValue] +
        (selectedPickListOption == nil ? 0 : [((IBAInputGenericPickerView *)self.pickerView).pickListOptions indexOfObject:selectedPickListOption]);

        [(IBAInputGenericPickerView *)self.pickerView pickerView:self.pickerView didSelectRow:selectedRow inComponent:i];
        [self.pickerView selectRow:selectedRow inComponent:i animated:NO];
    }
}

@end