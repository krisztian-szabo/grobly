//
//  ConditionTableViewCell.m
//  PebbleWeatherNotifier
//
//  Created by Szabó Krisztián on 3/17/14.
//  Copyright (c) 2014 Krisztian Szabo. All rights reserved.
//

#import "ConditionTableViewCell.h"

@interface ConditionTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedMaxLabel;

@end

@implementation ConditionTableViewCell

-(void)updateCell {
    NSString *unitTemp = [self.condition unitTypeForTemperature];
    NSString *unitSpeed = [self.condition unitTypeForSpeed];
    self.nameLabel.text = self.condition.name;
    self.tempMinLabel.text = [NSString stringWithFormat:@"< %@ %@", ([self.condition.tempBelow integerValue] == INT16_MIN) ? @"-" : self.condition.tempBelow, unitTemp];
    self.tempMaxLabel.text = [NSString stringWithFormat:@"> %@ %@", ([self.condition.tempAbove integerValue] == INT16_MIN) ? @"-" : self.condition.tempAbove, unitTemp];
    self.humidityMinLabel.text = [NSString stringWithFormat:@"< %@ %%", ([self.condition.humidityBelow integerValue] == INT16_MIN) ? @"-" : self.condition.humidityBelow];
    self.humidityMaxLabel.text = [NSString stringWithFormat:@"> %@ %%", ([self.condition.humidityAbove integerValue] == INT16_MIN) ? @"-" : self.condition.humidityAbove];
    self.speedMinLabel.text = [NSString stringWithFormat:@"< %@ %@", ([self.condition.speedBelow integerValue] == INT16_MIN) ? @"-" : self.condition.speedBelow, unitSpeed];
    self.speedMaxLabel.text = [NSString stringWithFormat:@"> %@ %@", ([self.condition.speedAbove integerValue] == INT16_MIN) ? @"-" : self.condition.speedAbove, unitSpeed];
}

@end
