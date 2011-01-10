//
//  IBASinglePickListInputProvider.h
//  IBAForms
//
//  Created by sean on 10/01/11.
//  Copyright 2011 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAInputProvider.h"

@interface IBASinglePickListInputProvider : NSObject <IBAInputProvider, UIPickerViewDataSource, UIPickerViewDelegate> {
	id<IBAInputRequestor> inputRequestor_;
}

@end
