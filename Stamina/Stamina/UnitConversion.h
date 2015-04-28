//
//  UnityConversion.h
//  Stamina
//
//  Created by Danilo Mative on 02/04/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//
// Unity types
//
// Distance:
//
// 0 >> metric form
// 1 >> miles form
// 2 >> fts form
//
// Weigth
//
// 0 >> kilos form
// 1 >> lbs form
//
// Height
//
// 0 >> meters form
// 1 >> fts form
//

#import <Foundation/Foundation.h>
#import "UserConfigurations.h"

@interface UnitConversion : NSObject


+(NSString *)distanceFromMetric: (double)metric;
+(NSString *)heightFromMetric: (double)metric;
+(NSString *)weightFromKilos: (double)kilos;
+(NSString *)speedFromKilometersPerHour: (double)kilohour;
+(NSString *)temperatureFromCelsius: (double)celsius;

@end
