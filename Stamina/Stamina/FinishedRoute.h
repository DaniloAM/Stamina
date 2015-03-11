//
//  FinishedRoute.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 08/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoutePointsCartesian.h"

@interface FinishedRoute : NSObject

@property float distanceInMeters;
@property int timeInSeconds, timeInMinutes;
@property RoutePointsCartesian *routePoints;
@property NSMutableArray *arrayOfSpeeds, *arrayOfLocations, *arrayOfPictures;

@end
