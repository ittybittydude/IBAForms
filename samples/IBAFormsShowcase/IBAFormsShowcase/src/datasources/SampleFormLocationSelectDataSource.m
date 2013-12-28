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

#import <IBAForms/IBAForms.h>
#import "SampleFormLocationSelectDataSource.h"
#import "StringToNumberTransformer.h"
#import "ShowcaseButtonStyle.h"

typedef NS_ENUM(NSInteger, Countries) {
    CountryRussia = 0,
    CountryUSA,
    CountryOther,
};

/****** Body parts detail legs ******/
typedef NS_ENUM(NSInteger, CitiesRussia) {
    RussiaMoscow = 0,
    RussiaYaroslavl = 1,
    RussiaOther = 2,
};

/****** Body parts detail hands ******/
typedef NS_ENUM(NSInteger, CitiesUSA) {
    USANewYork = 3,
    USALasVegas = 4,
    USAOther = 5,
};

@interface SampleFormLocationSelectDataSource()  <IBAFormFieldDelegate> {
    IBAPickListFormField *cityField_;
}

@end

@implementation SampleFormLocationSelectDataSource

- (id)initWithModel:(id)aModel {
	if (self = [super initWithModel:aModel]) {
		// Picklists
		IBAFormSection *pickListSection = [self addSectionWithHeaderTitle:@"Pick Lists" footerTitle:nil];

		NSArray *pickListOptionsCountry = [IBAPickListFormOption pickListOptionsForStrings:
                                           @[@"Russia", @"USA", @"Other"]];
        IBAPickListFormField *countryField = [[[IBAPickListFormField alloc] initWithKeyPath:@"locationCountry"
                                                                title:@"Country"
                                                     valueTransformer:[[[IBASingleIndexTransformer alloc] initWithPickListOptions:pickListOptionsCountry] autorelease]
                                                        selectionMode:IBAPickListSelectionModeSingle
                                                              options:pickListOptionsCountry] autorelease];
        [countryField setDelegate:self];
		[pickListSection addFormField:countryField];
        
        NSArray *pickListOptionsCity = [IBAPickListFormOption pickListOptionsForStrings:
                                        @[]];
        cityField_ = [[[IBAPickListFormField alloc] initWithKeyPath:@"locationCity"
                                                              title:@"City"
                                                   valueTransformer:[[[IBASingleIndexTransformer alloc] initWithPickListOptions:pickListOptionsCity] autorelease]
                                                      selectionMode:IBAPickListSelectionModeSingle
                                                            options:pickListOptionsCity] autorelease];
		[pickListSection addFormField:cityField_];
		
        // Text area field
        IBAFormFieldStyle *textAreaFieldStyle = [[[IBAFormFieldStyle alloc] init] autorelease];
        [textAreaFieldStyle setValueTextAlignment:UITextAlignmentLeft];
        [textAreaFieldStyle setValueBackgroundColor:[UIColor clearColor]];
        [textAreaFieldStyle setValueFrame:CGRectMake(0, 0, IBAFormFieldLabelWidth + IBAFormFieldValueWidth + 20, 80)];
        
        IBAFormSection *textAreaSection = [self addSectionWithHeaderTitle:@"Address" footerTitle:nil headerHeight:20.0f footerHeight:10.0f];
        
        // IBATextAreaFormField display multiline text view with placeholder text
        IBATextAreaFormField *textAreaField = [[[IBATextAreaFormField alloc] initWithKeyPath:@"locationAddress" title:@""] autorelease];
        [textAreaField setFormFieldStyle:textAreaFieldStyle];
        [textAreaField setCellHeight:80.0f];
        [textAreaField setPlaceholderText:@"Enter your address"];
        [textAreaSection addFormField:textAreaField];
    }
    
    [self updateCityField];
    
    return self;
}

- (void)updateCityField {
    if(cityField_ != nil) {
        NSNumber* currentCity = [[self model] objectForKey:@"locationCity"];
        if([currentCity isKindOfClass:[NSNumber class]] == NO) {
            currentCity = nil;
        }
        if([[self model] valueForKeyPath:@"locationCountry"] != nil) {
            switch([[[self model] valueForKeyPath:@"locationCountry"] integerValue]) {
                case CountryRussia: {
                    NSArray *pickListOptionsCity = [IBAPickListFormOption pickListOptionsForStrings:@[@"Moscow", @"Yaroslavl", @"Other",]];
                    [cityField_ setPickListOptions:pickListOptionsCity];
                    [cityField_ setValueTransformer:[[[IBASingleIndexTransformer alloc] initWithPickListOptions:pickListOptionsCity startValue:RussiaMoscow] autorelease]];
                    [[cityField_ cell] setUserInteractionEnabled:YES];
                    if(currentCity == nil || ([currentCity integerValue] < RussiaMoscow || [currentCity integerValue] > RussiaOther)) {
                        [[self model] setObject:@(RussiaMoscow) forKey:@"locationCity"];
                    }
                }
                    break;
                case CountryUSA: {
                    NSArray *pickListOptionsCity = [IBAPickListFormOption pickListOptionsForStrings:@[@"New York", @"Las Vegas", @"Other",]];
                    [cityField_ setPickListOptions:pickListOptionsCity];
                    [cityField_ setValueTransformer:[[[IBASingleIndexTransformer alloc] initWithPickListOptions:pickListOptionsCity startValue:USANewYork] autorelease]];
                    [[cityField_ cell] setUserInteractionEnabled:YES];
                    if(currentCity == nil || ([currentCity integerValue] < USANewYork || [currentCity integerValue] > USAOther)) {
                        [[self model] setObject:@(USANewYork) forKey:@"locationCity"];
                    }
                }
                    break;
                case CountryOther: {
                    NSArray *pickListOptionsCity = [IBAPickListFormOption pickListOptionsForStrings:@[@"Other",]];
                    [cityField_ setPickListOptions:pickListOptionsCity];
                    [cityField_ setValueTransformer:[[[IBASingleIndexTransformer alloc] initWithPickListOptions:pickListOptionsCity startValue:5] autorelease]];
                    [[cityField_ cell] setUserInteractionEnabled:NO];
                    [[self model] setObject:@(USAOther) forKey:@"locationCity"];
                }
                    break;
                default: {
                    NSArray *pickListOptionsCity = [IBAPickListFormOption pickListOptionsForStrings:@[]];
                    [cityField_ setPickListOptions:pickListOptionsCity];
                    [cityField_ setValueTransformer:[[[IBASingleIndexTransformer alloc] initWithPickListOptions:pickListOptionsCity] autorelease]];
                    [[cityField_ cell] setUserInteractionEnabled:NO];
                    [[self model] removeObjectForKey:@"locationCity"];
                }
            }
            [cityField_ updateCellContents];
        } else {
            [[cityField_ cell] setUserInteractionEnabled:NO];
        }
    }
}


#pragma mark - @protocol IBAFormFieldDelegate <NSObject>

- (void)formField:(IBAFormField *)formField didSetValue:(id)value {
    if([[formField keyPath] isEqualToString:@"locationCountry"]) {
        [self updateCityField];
    }
}

- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
	[super setModelValue:value forKeyPath:keyPath];
	
	NSLog(@"%@", [self.model description]);
}

@end
