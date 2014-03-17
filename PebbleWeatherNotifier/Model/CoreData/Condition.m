//
//  Condition.m
//  PebbleWeatherNotifier
//
//  Created by Szabó Krisztián on 3/11/14.
//  Copyright (c) 2014 Krisztian Szabo. All rights reserved.
//

#import "Condition.h"

#import <NSManagedObject+InnerBand.h>

@implementation Condition

@dynamic tempAbove;
@dynamic tempBelow;
@dynamic humidityAbove;
@dynamic humidityBelow;
@dynamic speedAbove;
@dynamic speedBelow;
@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic type;

-(void)populateFromDictionary:(NSDictionary*)dict {
    self.tempBelow = (dict[@"temp_below"] && ![dict[@"temp_below"] isEqualToString:@""]) ? @([dict[@"temp_below"] integerValue])  : @(INT16_MIN);
    self.tempAbove = (dict[@"temp_above"] && ![dict[@"temp_above"] isEqualToString:@""]) ? @([dict[@"temp_above"] integerValue]): @(INT16_MIN);
    self.humidityAbove = (dict[@"humidity_above"] && ![dict[@"humidity_above"] isEqualToString:@""]) ? @([dict[@"humidity_above"] integerValue]) : @(INT16_MIN);
    self.humidityBelow = (dict[@"humidity_below"] && ![dict[@"humidity_below"] isEqualToString:@""]) ? @([dict[@"humidity_below"] integerValue]) : @(INT16_MIN);
    self.speedBelow = (dict[@"speed_below"] && ![dict[@"speed_below"] isEqualToString:@""]) ? @([dict[@"speed_below"] integerValue]) : @(INT16_MIN);
    self.speedAbove = (dict[@"speed_above"] && ![dict[@"speed_above"] isEqualToString:@""]) ? @([dict[@"speed_above"] integerValue]) : @(INT16_MIN);
    self.name = dict[@"name"];
    self.latitude = dict[@"latitude"];
    self.longitude = dict[@"longitude"];
    self.type = dict[@"type"];
}

+(Condition*)createManagedObjectFromDictionary:(NSDictionary*)dict {
    NSString *objId = dict[@"name"];
    Condition *obj = [Condition getConditionWithId:objId];
    [obj populateFromDictionary:dict];
    return obj;
}

+(NSArray*)createManagedObjectsFromArray:(NSArray*)array {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dict in array) {
        [result addObject:[self createManagedObjectFromDictionary:dict]];
    }
    return result;
}

+(Condition*)getConditionWithId:(NSString *)objId {
    Condition *obj = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", objId];
    NSArray *objs = [Condition allForPredicate:predicate];
    if ([objs count] > 0) {
        obj = (Condition *)[objs objectAtIndex:0];
    } else {
        obj = [Condition createInStore:[IBCoreDataStore mainStore]];
    }
    return obj;
}

-(NSString*)unitTypeForTemperature {
    return ([self.type integerValue] == 0) ? NSLocalizedString(@"°C", nil) : NSLocalizedString(@"°F", nil);
}

-(NSString*)unitTypeForSpeed {
    return ([self.type integerValue] == 0) ? NSLocalizedString(@"Kmph", nil) : NSLocalizedString(@"Mph", nil);
}

@end
