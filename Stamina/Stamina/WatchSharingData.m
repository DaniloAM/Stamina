//
//  WatchSharingData.m
//  Stamina
//
//  Created by Danilo Mative on 15/04/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "WatchSharingData.h"

@implementation WatchSharingData

-(id)init {
    
    self = [super init];
    
    if(self) {
        watchDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.com.stamina.watch"];
    }
    
    return self;
}


-(void)setIsRunning:(BOOL)running {
    [watchDefaults setBool:running forKey:@"wk_isrunning"];
    [watchDefaults synchronize];
}

-(void)setRunningState:(int)runningState {
    [watchDefaults setInteger:runningState forKey:@"wk_runningstate"];
    [watchDefaults synchronize];
}
    
-(void)setTimerString: (NSString *)timer {
    [watchDefaults setObject:timer forKey:@"wk_timer"];
    [watchDefaults synchronize];
}

-(void)setBeatsPerSecond: (int)bps {
    [watchDefaults setInteger:bps forKey:@"wk_bps"];
    [watchDefaults synchronize];
}

-(void)setDistanceString: (NSString *)distance {
    [watchDefaults setObject:distance forKey:@"wk_distance"];
    [watchDefaults synchronize];
}


-(BOOL)isRunning {
    return [watchDefaults boolForKey:@"wk_isrunning"];
}

-(int)runningState {
    return (int)[watchDefaults integerForKey:@"wk_runningstate"];
}

-(NSString *)timerString {
    return [watchDefaults objectForKey:@"wk_timer"];
}

-(int)beatsPerSecond {
    return (int)[watchDefaults integerForKey:@"wk_bps"];
}

-(NSString *)distanceString {
    return [watchDefaults objectForKey:@"wk_distance"];
}

+(void)clearAllData {
    
    NSUserDefaults *watch = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.stamina.watch"];
    
    [watch setBool:false forKey:@"wk_isrunning"];
    [watch setInteger:0 forKey:@"wk_runningstate"];
    [watch setObject:@"" forKey:@"wk_timer"];
    [watch setInteger:0 forKey:@"wk_bps"];
    [watch setObject:@"" forKey:@"wk_distance"];
    
    [watch synchronize];
}


@end