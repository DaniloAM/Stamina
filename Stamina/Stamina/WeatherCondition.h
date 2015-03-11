//
//  WeatherCondition.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 08/12/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherObject.h"
#import "WebServiceResponse.h"

@interface WeatherCondition : NSObject <CLLocationManagerDelegate>

@property CLLocationManager *locationManager;


-(NSInteger)returnTemperatureInCurrentLocation;

@end
