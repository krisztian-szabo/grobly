//
//  ConditionTableViewCell.h
//  PebbleWeatherNotifier
//
//  Created by Szabó Krisztián on 3/17/14.
//  Copyright (c) 2014 Krisztian Szabo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+NibLoad.h"

#import "Condition.h"

@interface ConditionTableViewCell : UITableViewCell

@property (strong, nonatomic) Condition* condition;

-(void)updateCell;

@end
