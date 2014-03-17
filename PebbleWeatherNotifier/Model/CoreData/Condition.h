//
//  Condition.h
//  PebbleWeatherNotifier
//
//  Created by Szabó Krisztián on 3/11/14.
//  Copyright (c) 2014 Krisztian Szabo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Condition : NSManagedObject

@property (nonatomic, retain) NSNumber * humidityAbove;
@property (nonatomic, retain) NSNumber * humidityBelow;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * speedAbove;
@property (nonatomic, retain) NSNumber * speedBelow;
@property (nonatomic, retain) NSNumber * tempAbove;
@property (nonatomic, retain) NSNumber * tempBelow;
@property (nonatomic, retain) NSNumber * type;

-(void)populateFromDictionary:(NSDictionary*)dict;
+(Condition*)createManagedObjectFromDictionary:(NSDictionary*)dict;
+(NSArray*)createManagedObjectsFromArray:(NSArray*)array;

+(Condition*)getConditionWithId:(NSString*)objId;


@end
