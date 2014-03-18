//
//  PebbleManager.h
//  PebbleWeatherNotifier
//
//  Created by Szabó Krisztián on 3/18/14.
//  Copyright (c) 2014 Krisztian Szabo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Condition.h"

@interface PebbleManager : NSObject

+ (id)sharedManager;

- (void)sendPebbleCondition:(Condition*)condition;

@end
