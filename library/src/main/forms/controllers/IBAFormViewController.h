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

#import <UIKit/UIKit.h>
#import "IBAFormDataSource.h"
#import "IBAInputNavigationToolbar.h"
#import "IBAInputRequestorDataSource.h"

@interface IBAFormViewController : UIViewController  <UITableViewDelegate, IBAInputRequestorDataSource> {
	UITableView *tableView_;
	CGRect tableViewOriginalFrame_;
	IBAFormField *editingFormField_; // The form field currently being edited
	IBAFormDataSource *formDataSource_;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, readonly) CGRect tableViewOriginalFrame;
@property (nonatomic, retain) IBAFormDataSource *formDataSource;
@property (nonatomic, assign) IBAFormField *editingFormField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
	   formDataSource:(IBAFormDataSource *)formDataSource;

@end
