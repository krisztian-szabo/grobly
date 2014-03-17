//
//  ViewController.m
//  PebbleWeatherNotifier
//
//  Created by Szabó Krisztián on 3/10/14.
//  Copyright (c) 2014 Krisztian Szabo. All rights reserved.
//

#import "MainViewController.h"

#import "ConditionTableViewCell.h"

#import <NSManagedObject+InnerBand.h>

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *items;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MainViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.items = [[Condition all] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ConditionTableViewCell";
    ConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [ConditionTableViewCell loadNibNamed:@"ConditionTableViewCell" ofClass:[ConditionTableViewCell class]];
    }
    
    Condition *condition = (Condition*)self.items[indexPath.row];
    cell.condition = condition;
    [cell updateCell];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
