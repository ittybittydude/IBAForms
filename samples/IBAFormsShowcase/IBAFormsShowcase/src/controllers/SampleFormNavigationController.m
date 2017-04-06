//
//  SampleFormNavigationController.m
//  IBAFormsShowcase
//
//  Created by Kos on 27.12.13.
//  Copyright (c) 2013 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "SampleFormNavigationController.h"

@interface SampleFormNavigationController ()

@end

@implementation SampleFormNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return [[self topViewController] shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
