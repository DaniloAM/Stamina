//
//  WeatherCondition.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 08/12/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "WeatherCondition.h"

@implementation WeatherCondition

-(NSInteger)returnTemperatureInCurrentLocation {
    
    CLLocationCoordinate2D coor = [self getCurrentLocation];
    
    WeatherObject *obj = [WebServiceResponse previsaoDoTempoNaLatitude:coor.latitude eLongitude:coor.longitude];
    
    if(obj == nil) {
        return -1;
    }
    
    return obj.tempAtual;
    
}

-(CLLocationCoordinate2D) getCurrentLocation{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    [_locationManager startUpdatingLocation];
    CLLocation *location = [_locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    return coordinate;
}

@end
