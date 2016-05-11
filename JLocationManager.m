
//  Created by Andrea Laudoni on 10/09/14.
//  Copyright (c) 2014 Andrea Laudoni. All rights reserved.
//

#import "JLocationManager.h"

@implementation JLocationManager

+ (JLocationManager *)sharedInstance
{
    static JLocationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JLocationManager alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        i=0;
        [self removeLocation];
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

        [self initLocationManager];
    }
    return self;
}

- (void)initLocationManager {
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self initLocationManager];
        
    } else {

        [self removeLocation];
        [self.locationManager stopUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{

    [self saveLocation:newLocation];

}

- (BOOL)authorizationStatusAllowed {
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    if ( authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse ) {
        
        return YES;
        
    }
    return NO;
}

- (void)saveLocation:(CLLocation*)location {
    NSNumber *lat = [NSNumber numberWithDouble:location.coordinate.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:location.coordinate.longitude];
    NSDictionary *userLocation=@{@"lat":lat,@"long":lon};
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setSecretObject:userLocation forKey:@"userLocation"];
    [defaults synchronize];
}

- (CLLocation*)getCLLLocation {
    
    NSDictionary * userLocationDictionary = [[JLocationManager sharedInstance] getLocation];
    
    if (userLocationDictionary) {
        
        NSNumber *latitude = [self objectOrNilForKey:@"lat" fromDictionary:userLocationDictionary];
        NSNumber *longitude = [self objectOrNilForKey:@"long" fromDictionary:userLocationDictionary];
        CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        
        return userLocation;
    }
    
    return nil;
}

- (NSDictionary*)getLocation {
    return [[NSUserDefaults standardUserDefaults] secretObjectForKey:@"userLocation"];
}

- (void)removeLocation {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"EuserLocation"];
    [defaults synchronize];
}

+ (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
