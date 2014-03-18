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

#import "PebbleManager.h"
#import "ConditionHandler.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource> {
    Condition *selectedCondition;
}
@property (strong, nonatomic) NSMutableArray *items;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MainViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
        [ConditionHandler handleConditions];
    });
}

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
    selectedCondition = (Condition*)self.items[indexPath.row];
    [[PebbleManager sharedManager] sendPebbleCondition:selectedCondition];
}

- (IBAction)deleteItem:(id)sender {
    if (selectedCondition) {
        [self.items removeObject:selectedCondition];
        [selectedCondition destroy];
        [[IBCoreDataStore mainStore] save];
        [self.tableView reloadData];
        selectedCondition = nil;
    }
}

@end
