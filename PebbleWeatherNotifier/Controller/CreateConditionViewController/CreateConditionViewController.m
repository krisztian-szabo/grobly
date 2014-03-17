//
//  CreateConditionViewController.m
//  PebbleWeatherNotifier
//
//  Created by Szabó Krisztián on 3/10/14.
//  Copyright (c) 2014 Krisztian Szabo. All rights reserved.
//

#import "CreateConditionViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <IBCoreDataStore.h>
#import <SVProgressHUD.h>

#import "Condition.h"

enum UnitType {
    TypeMetric = 0,
    TypeImperial = 1
};

@interface CreateConditionViewController () <CLLocationManagerDelegate, UITextFieldDelegate> {
    enum UnitType unitType;
}

@property (weak, nonatomic) IBOutlet UIButton *useLocationButton;
@property (weak, nonatomic) IBOutlet UILabel *tempAboveMetricLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempBelowMetricLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedBelowMetricLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedAboveMetricLabel;
@property (weak, nonatomic) IBOutlet UITextField *conditionNameValue;
@property (weak, nonatomic) IBOutlet UITextField *locationValue;
@property (weak, nonatomic) IBOutlet UITextField *tempBelowValue;
@property (weak, nonatomic) IBOutlet UITextField *tempAboveValue;
@property (weak, nonatomic) IBOutlet UITextField *speedBelowValue;
@property (weak, nonatomic) IBOutlet UITextField *speedAboveValue;
@property (weak, nonatomic) IBOutlet UITextField *humidityBelowValue;
@property (weak, nonatomic) IBOutlet UITextField *humidityAboveValue;
@property (weak, nonatomic) IBOutlet UISwitch *unitTypeSwitch;

@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLLocation *currentLocation;

@end

@implementation CreateConditionViewController

#pragma mark -
#pragma mark - View Lifecycle

-(void)viewDidLoad {
    [super viewDidLoad];
    
    unitType = TypeMetric;
    
    [self setupViews];
    [self updateViews];
}

#pragma mark -
#pragma mark - Screen Update Methods

-(void)setupViews {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doSingleTap)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
}

-(void)updateViews {
    if (unitType == TypeMetric) {
        self.tempAboveMetricLabel.text = NSLocalizedString(@"°C", nil);
        self.tempBelowMetricLabel.text = NSLocalizedString(@"°C", nil);
        self.speedBelowMetricLabel.text = NSLocalizedString(@"Kmph", nil);
        self.speedAboveMetricLabel.text = NSLocalizedString(@"Kmph", nil);
    } else {
        self.tempAboveMetricLabel.text = NSLocalizedString(@"°F", nil);
        self.tempBelowMetricLabel.text = NSLocalizedString(@"°F", nil);
        self.speedBelowMetricLabel.text = NSLocalizedString(@"Mph", nil);
        self.speedAboveMetricLabel.text = NSLocalizedString(@"Mph", nil);
    }
}

#pragma mark -
#pragma mark - IBActions

-(void)doSingleTap {
    [self.locationValue resignFirstResponder];
    [self.tempAboveValue resignFirstResponder];
    [self.tempBelowValue resignFirstResponder];
    [self.speedAboveValue resignFirstResponder];
    [self.speedBelowValue resignFirstResponder];
    [self.humidityBelowValue resignFirstResponder];
    [self.humidityAboveValue resignFirstResponder];
}

- (IBAction)userCurrentLocation:(id)sender {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (IBAction)done:(id)sender {
    if ([self.tempBelowValue.text isEqualToString:@""] &&
        [self.tempAboveValue.text isEqualToString:@""] &&
        [self.speedBelowValue.text isEqualToString:@""] &&
        [self.speedAboveValue.text isEqualToString:@""] &&
        [self.humidityBelowValue.text isEqualToString:@""] &&
        [self.humidityAboveValue.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Empty Fields"
                                    message:@"You must complete at least one condition."
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil]show];
        return;
    }
    if ([self.locationValue.text isEqualToString:@""] ||
        self.currentLocation == nil) {
        [[[UIAlertView alloc] initWithTitle:@"Empty Location"
                                    message:@"You must set the location"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
        return;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:                          
                          self.conditionNameValue.text, @"name",
                          @(self.currentLocation.coordinate.latitude), @"latitude",
                          @(self.currentLocation.coordinate.longitude), @"longitude",
                          self.tempBelowValue.text, @"temp_below",
                          self.tempAboveValue.text, @"temp_above",
                          self.speedBelowValue.text, @"speed_below",
                          self.speedAboveValue.text, @"speed_above",
                          self.humidityBelowValue.text, @"humidity_below",
                          self.humidityAboveValue.text, @"humidity_above",
                          @(unitType), @"type",
                          nil];
    [Condition createManagedObjectFromDictionary:dict];
    [[IBCoreDataStore mainStore] save];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeTemperature:(id)sender {
    if (unitType == TypeMetric) {
        unitType = TypeImperial;
    } else {
        unitType = TypeMetric;
    }
    [self updateViews];
}

#pragma mark -
#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    self.currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count]) {
            CLPlacemark *placemark = placemarks[0];
            self.locationValue.text = placemark.locality;
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Sorry, location not found", nil)];
        }
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.useLocationButton setEnabled:NO];
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Location Error", nil)
                                message:NSLocalizedString(@"You must enable locations for this app from Settings", nil)
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
}

#pragma mark -
#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.locationValue.text isEqualToString:@""]) {
        [self.locationValue resignFirstResponder];
        return YES;
    }
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.locationValue.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count]) {
            CLPlacemark *placemark = placemarks[0];
            self.locationValue.text = placemark.locality;
            [self.locationValue resignFirstResponder];
            self.currentLocation = placemark.location;
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Sorry, location not found", nil)];
        }
    }];
    return YES;
}

@end
