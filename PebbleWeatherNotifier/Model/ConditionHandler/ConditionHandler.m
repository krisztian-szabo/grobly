//
//  ConditionHandler.m
//  PebbleWeatherNotifier
//
//  Created by Szabó Krisztián on 3/17/14.
//  Copyright (c) 2014 Krisztian Szabo. All rights reserved.
//

#import "ConditionHandler.h"

#import <CoreLocation/CoreLocation.h>
#import <NSManagedObject+InnerBand.h>

#import "Condition.h"

#define kWWOKey @"xh34mrhptm3j3hst2wknrt7y"

@implementation ConditionHandler

+(void)handleConditions {
    NSArray *conditions = [Condition all];
    for (Condition *condition in conditions) {
        NSString *message;
        if (![self checkWeatherForCondition:condition withMessage:&message]) {
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            NSDate *now = [NSDate date];
            localNotification.fireDate = now;
            localNotification.alertBody = message;
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    }
}

+(BOOL)checkWeatherForCondition:(Condition*)condition withMessage:(NSString**)messagePtr{
    NSString *urlString = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v1/weather.ashx?q=%f,%f&format=json&num_of_days=1&includelocation=yes&key=%@", [condition.latitude doubleValue], [condition.longitude doubleValue], kWWOKey];
    NSURL *weatherURL = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:weatherURL];

    NSError *error;
    NSDictionary *parsedJSONData = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:&error];
    if (error) {
        *messagePtr = error.localizedDescription;
        return NO;
    }
    NSDictionary *weather = [parsedJSONData objectForKey:@"data"];
    
    NSArray *currentCondition = [weather objectForKey:@"current_condition"];
    NSDictionary *tempDictionary = [currentCondition objectAtIndex:0];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    if ([condition.type integerValue] == 0) {
        condition.temperature = [f numberFromString:[tempDictionary valueForKey:@"temp_C"]];
        condition.speed = [f numberFromString:[tempDictionary valueForKey:@"windspeedKmph"]];
    } else {
        condition.temperature = [f numberFromString:[tempDictionary valueForKey:@"temp_F"]];
        condition.speed = [f numberFromString:[tempDictionary valueForKey:@"windspeedMiles"]];
    }
    condition.humidity = [f numberFromString:[tempDictionary valueForKey:@"humidity"]];
    condition.weather_code = [f numberFromString:[tempDictionary valueForKey:@"weatherCode"]];
    [[IBCoreDataStore mainStore] save];
    
    if ([condition.temperature integerValue] <= [condition.tempBelow integerValue] && [condition.tempBelow integerValue] != INT16_MIN) {
        *messagePtr = [NSString stringWithFormat:@"The temperature is below %d%@!", [condition.tempBelow intValue], [condition unitTypeForTemperature]];
        return NO;
    }
    if ([condition.temperature integerValue] >= [condition.tempAbove integerValue] && [condition.tempAbove integerValue] != INT16_MIN) {
        *messagePtr = [NSString stringWithFormat:@"The temperature is above %d%@!", [condition.tempAbove intValue], [condition unitTypeForTemperature]];
        return NO;
    }
    if ([condition.speed integerValue] <= [condition.speedBelow integerValue] && [condition.speedBelow integerValue] != INT16_MIN) {
        *messagePtr = [NSString stringWithFormat:@"The wind speed is below %d%@!", [condition.speedBelow intValue], [condition unitTypeForSpeed]];
        return NO;
    }
    if ([condition.speed integerValue] >= [condition.speedAbove integerValue] && [condition.speedAbove integerValue] != INT16_MIN) {
        *messagePtr = [NSString stringWithFormat:@"The wind speed is above %d%@!", [condition.speedAbove intValue], [condition unitTypeForSpeed]];
        return NO;
    }
    if ([condition.humidity integerValue] <= [condition.humidityBelow integerValue] && [condition.humidityBelow integerValue] != INT16_MIN) {
        *messagePtr = [NSString stringWithFormat:@"The humidity is below %d%%!", [condition.humidityBelow intValue]];
        return NO;
    }
    if ([condition.humidity integerValue] >= [condition.humidityAbove integerValue] && [condition.humidityAbove integerValue] != INT16_MIN) {
        *messagePtr = [NSString stringWithFormat:@"The humidity is above %d%%!", [condition.humidityAbove intValue]];
        return NO;
    }
    return YES;
}

@end
