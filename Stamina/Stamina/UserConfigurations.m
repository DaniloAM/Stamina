//
//  UserConfigurations.m
//  Stamina
//
//  Created by Danilo Mative on 15/04/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "UserConfigurations.h"

@implementation UserConfigurations

+(UserConfigurations *)sharedStore{
    static UserConfigurations *sharedStore = nil;
    if(!sharedStore){
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
    
}
+(id) allocWithZone: (struct _NSZone *) zone{
    
    return [self sharedStore];
    
}

-(void)saveConfigurations {
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:[self measureDistance] forKey:@"ud_measureDistance"];
    [defaults setInteger:[self measureTemperature] forKey:@"ud_measureTemperature"];
    [defaults setInteger:[self measureHeight] forKey:@"ud_measureHeight"];
    [defaults setInteger:[self measureWeight] forKey:@"ud_measureWeight"];
    [defaults setInteger:[self timeAlarmBeforeTraining] forKey:@"ud_timebefore"];
    [defaults setInteger:[self language] forKey:@"ud_language"];
    [defaults setInteger:[self alerta] forKey:@"ud_alerta"];
    
    [defaults synchronize];
}

-(void)loadConfigurations {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _measureDistance = (int)[defaults integerForKey:@"ud_measureDistance"];
    _measureTemperature = (int)[defaults integerForKey:@"ud_measureTemperature"];
    _measureHeight = (int)[defaults integerForKey:@"ud_measureHeight"];
    _measureWeight = (int)[defaults integerForKey:@"ud_measureWeight"];
    _language = (int)[defaults integerForKey:@"ud_language"];
    _alerta = (int)[defaults integerForKey:@"ud_alerta"];
    _timeAlarmBeforeTraining = (int)[defaults integerForKey:@"ud_timebefore"];
    
    //Check for first use of app
    if (![defaults objectForKey:@"firstRun"]) {
        
        [defaults setObject:[NSDate date] forKey:@"firstRun"];
        
        NSString *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
        
        int num;
        
        if([countryCode isEqualToString:@"US"] || [countryCode isEqualToString:@"GB"])
        num = 1;
        
        else
        num = 0;
        
        [defaults setInteger:num forKey:@"ud_measureTemperature"];
        [defaults setInteger:num forKey:@"ud_measureDistance"];
        [defaults setInteger:num forKey:@"ud_measureHeight"];
        [defaults setInteger:num forKey:@"ud_measureWeight"];
        
        _measureTemperature = num;
        _measureDistance = num;
        _measureHeight = num;
        _measureWeight = num;
        
        [defaults synchronize];
        
    }
}

@end
