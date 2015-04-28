//
//  UnityConversion.m
//  Stamina
//
//  Created by Danilo Mative on 02/04/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//
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

#import "UnitConversion.h"

@implementation UnitConversion



+(NSString *)distanceFromMetric: (double)metric {
    
    
    UserConfigurations *user = [UserConfigurations alloc];
    
    switch (user.measureDistance) {
        
        case 1: {
            
            //Miles
            if(metric >= 1609.344) {
                return [NSString stringWithFormat:@"%.02f mi",metric * 0.000621371192];
            }
            
            //Feets
            else {
                return [NSString stringWithFormat:@"%.00f ft",metric * 3.28];
            }
        }
            break;
        
            
        default: {
            
            //Kilometers
            if(metric >= 1000.0) {
                return [NSString stringWithFormat:@"%.01f km",metric / 1000.0];
            }
            //Meters
            else {
                return [NSString stringWithFormat:@"%.00f m",metric];
            }
            
        }
            break;
    }
    
}

+(NSString *)heightFromMetric: (double)metric {
    
    
    UserConfigurations *user = [UserConfigurations alloc];
    
    switch (user.measureHeight) {

        case 1: {
            
            int feets = metric * 3.28;
            
            metric -= (feets / 3.28);
            
            int inches = metric * 39.37;
            
            return [NSString stringWithFormat:@"%d'%d\"", feets, inches];
            
        }
            break;
        
        default:
            return [NSString stringWithFormat:@"%.02f m",metric];
            break;
    }
    
}


+(NSString *)weightFromKilos: (double)kilos {
    
    
    UserConfigurations *user = [UserConfigurations alloc];
    
    switch (user.measureWeight) {
        case 1:
            return [NSString stringWithFormat:@"%.01f lb",kilos * 2.20462262];
            break;
        default:
            return [NSString stringWithFormat:@"%.01f kg",kilos];
            break;
    }
    
}

+(NSString *)speedFromKilometersPerHour: (double)kilohour {
    
    
    UserConfigurations *user = [UserConfigurations alloc];
    
    switch (user.measureDistance) {
        case 1:
            return [NSString stringWithFormat:@"%.01f mph",kilohour * 0.621371192];
            break;
        default:
            return [NSString stringWithFormat:@"%.01f km/h",kilohour];
            break;
    }
    
}

+(NSString *)temperatureFromCelsius: (double)celsius {
    
    UserConfigurations *user = [UserConfigurations alloc];

    
    switch (user.measureTemperature) {
        case 1:
            return [NSString stringWithFormat:@"%.00f °F",(celsius * 9/5 + 32)];
            break;
        default:
            return [NSString stringWithFormat:@"%.00f °C",celsius];
            break;
    }
    
}



@end
