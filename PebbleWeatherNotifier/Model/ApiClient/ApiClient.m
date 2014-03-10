//
//  ApiClient.m
//  PebbleWeatherNotifier
//
//  Created by Szabó Krisztián on 3/10/14.
//  Copyright (c) 2014 Krisztian Szabo. All rights reserved.
//

#import "ApiClient.h"

#define kWWOKey @"xh34mrhptm3j3hst2wknrt7y"

@interface ApiClient()
@property (strong, nonatomic) NSString *currentLocation;
@property (strong, nonatomic) NSString *currentTemperature;
@end

@implementation ApiClient

- (void)getWeatherAtLocation:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v1/weather.ashx?q=%f,%f&format=json&num_of_days=1&includelocation=yes&key=%@", coordinate.latitude, coordinate.longitude, kWWOKey];
    NSURL *weatherURL = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:weatherURL];
    [self parseJSONData:data];
}

- (void)parseJSONData:(NSData *)data {
    NSError *error;
    NSDictionary *parsedJSONData = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:&error];
    NSDictionary *weather = [parsedJSONData objectForKey:@"data"];
    
    // Nearest Area and setting currentLocation property.
    NSDictionary *nearestArea = [weather objectForKey:@"nearest_area"];
    NSArray *array = [nearestArea valueForKey:@"areaName"];
    NSDictionary *currentLocation = [array objectAtIndex:0];
    NSArray *currentLocationString = [currentLocation valueForKey:@"value"];
    self.currentLocation = currentLocationString.lastObject;
    
    // Getting current temp in degrees C
    NSArray *currentCondition = [weather objectForKey:@"current_condition"];
    NSDictionary *tempDictionary = [currentCondition objectAtIndex:0];
    NSArray *tempInC = [tempDictionary valueForKey:@"temp_C"];
    
    //NSArray *weatherInC = [currentCondition objectForKey:@"temp_c"];
    NSString *temperature = [NSString stringWithFormat:@"%@", tempInC];
    self.currentTemperature = [temperature stringByAppendingString:@"C"];
}

@end
