//
//  ViewController.m
//  PebbleWeatherNotifier
//
//  Created by Szabó Krisztián on 3/10/14.
//  Copyright (c) 2014 Krisztian Szabo. All rights reserved.
//

#import "MainViewController.h"

#import "UIColor+Grobly.h"

@interface MainViewController ()
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self customizeNavigationBar];
}

-(void)customizeNavigationBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewCondition)];
    self.navigationItem.title = NSLocalizedString(@"Weather Conditions", nil);
}

#pragma mark - 
#pragma mark - Create New Condition

-(void)addNewCondition {
    
}

@end
