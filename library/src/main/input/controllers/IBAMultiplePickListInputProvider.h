//
//  IBAPickListInputProvider.h
//  IBAForms
//
//  Created by sean on 18/10/10.
//  Copyright 2010 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAInputProvider.h"

@interface IBAMultiplePickListInputProvider : NSObject <IBAInputProvider, UITableViewDataSource, UITableViewDelegate> {
	UITableView *pickListTableView_;
	id<IBAInputRequestor> inputRequestor_;
}

@property (nonatomic, readonly) UITableView *pickListTableView;


@end
