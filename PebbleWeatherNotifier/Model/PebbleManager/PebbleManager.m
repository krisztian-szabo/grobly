//
//  PebbleManager.m
//  PebbleWeatherNotifier
//
//  Created by Szabó Krisztián on 3/18/14.
//  Copyright (c) 2014 Krisztian Szabo. All rights reserved.
//

#import "PebbleManager.h"
#import <PebbleKit.h>

@interface PebbleManager() <PBPebbleCentralDelegate>
@end

@implementation PebbleManager {
    PBWatch *_targetWatch;
}

#pragma mark Singleton Methods

+ (id)sharedManager {
    static PebbleManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        uuid_t myAppUUIDbytes;
        NSUUID *myAppUUID = [[NSUUID alloc] initWithUUIDString:@"1a4e614f-6dab-41c3-8d1e-05ebef8289bc"];
        [myAppUUID getUUIDBytes:myAppUUIDbytes];
        [[PBPebbleCentral defaultCentral] setAppUUID:[NSData dataWithBytes:myAppUUIDbytes length:16]];
        [[PBPebbleCentral defaultCentral] setDelegate:self];
        [self setTargetWatch:[[PBPebbleCentral defaultCentral] lastConnectedWatch]];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

#pragma mark -
#pragma mark - PBPebbleCentralDelegate

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidConnect:(PBWatch*)watch isNew:(BOOL)isNew {
    [self setTargetWatch:watch];
}

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidDisconnect:(PBWatch*)watch {
    [[[UIAlertView alloc] initWithTitle:@"Disconnected!" message:[watch name] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    if (_targetWatch == watch || [watch isEqual:_targetWatch]) {
        [self setTargetWatch:nil];
    }
}

- (void)setTargetWatch:(PBWatch*)watch {
    _targetWatch = watch;
}

#pragma mark - 
#pragma mark - Pebble Manager methods

- (void)sendPebbleCondition:(Condition*)condition {
    uint8_t weatherIconID = [self getIconForCondition:condition];
    NSNumber *iconKey = @(0); // This is our custom-defined key for the icon ID, which is of type uint8_t.
    NSNumber *temperatureKey = @(1); // This is our custom-defined key for the temperature string.
    NSDictionary *update = @{ iconKey:[NSNumber numberWithUint8:weatherIconID],
                              temperatureKey:[NSString stringWithFormat:@"%@\u00B0C", condition.temperature] };
    [_targetWatch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
    }];
}


- (int)getIconForCondition:(Condition*)condition {
    if ([condition.temperature intValue] <= 0 &&
        [condition.humidity intValue] >= 60) {
        return 3;
    } else if ([condition.humidity intValue] >= 60) {
        return 1;
    } else if ([condition.temperature intValue] < 15) {
        return 2;
    } else {
        return 0;
    }
}

@end
