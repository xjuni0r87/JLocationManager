
//
//  Created by Andrea Laudoni on 10/09/14.
//  Copyright (c) 2014 Andrea Laudoni. All rights reserved.
//

#import <Foundation/Foundation.h>


@import CoreLocation;

@interface JLocationManager : NSObject <CLLocationManagerDelegate>

+ (JLocationManager *)sharedInstance;

//- (void)saveLocation:(CLLocation*)location;
//- (NSDictionary*)getLocation;
+ (CLLocation*)getCLLLocation;
//- (void)removeLocation;
//- (BOOL)authorizationStatusAllowed;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
