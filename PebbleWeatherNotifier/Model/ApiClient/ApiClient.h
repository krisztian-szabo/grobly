//
//  ApiClient.h
//  PebbleWeatherNotifier
//
//  Created by Szabó Krisztián on 3/10/14.
//  Copyright (c) 2014 Krisztian Szabo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ApiClient : NSObject

- (void)getWeatherAtLocation:(CLLocationCoordinate2D)coordinate;
- (void)parseJSONData:(NSData *)data;

@end
