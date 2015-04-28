//
//  WatchSharingData.h
//  Stamina
//
//  Created by Danilo Mative on 15/04/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WatchSharingData : NSObject {
    NSUserDefaults *watchDefaults;
}

typedef enum RunningState{
    RSStopped,
    RSPaused,
    RSRunning,
    RSReviewing
}RunningState;

@property RunningState state;


-(void)setIsRunning:(BOOL)running;
-(void)setRunningState:(int)runningState;
-(void)setTimerString: (NSString *)timer;
-(void)setBeatsPerSecond: (int)bps;
-(void)setDistanceString: (NSString *)distance;

-(BOOL)isRunning;
-(int)runningState;
-(NSString *)timerString;
-(int)beatsPerSecond;
-(NSString *)distanceString;

+(void)clearAllData;

@end
