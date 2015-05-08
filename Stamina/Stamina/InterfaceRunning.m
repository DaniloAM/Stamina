//
//  InterfaceRunning.m
//  Stamina
//
//  Created by Danilo Mative on 15/04/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "InterfaceRunning.h"

@interface InterfaceRunning () {
    NSTimer *reloadTimer, *dataTimer;
    NSMutableAttributedString *attInfoButton, *attDistanceButton;
    NSFont *infoFont, *distanceFont;
}

@end

@implementation InterfaceRunning

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    sharing = [[WatchSharingData alloc] init];
    
    
    reloadTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkApplicationRunning) userInfo:nil repeats:true];
    
    
    //distanceFont = [UIFont fontWithName:@"Lato-Semibold" size:32.0];
    
    //attDistanceButton = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{ NSKernAttributeName : @2.0, NSFontAttributeName : buttonFont}];
    
    //infoFont = [UIFont fontWithName:@"Lato-Semibold" size:26.0];
    
    //attInfoButton = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{ NSKernAttributeName : @2.0, NSFontAttributeName : buttonFont}];
    
    
    [self.distanceButton setAttributedTitle:attDistanceButton];
    [self.infoButton setAttributedTitle:attInfoButton];
    
}


-(void)checkApplicationRunning {
    
    //Stamina is running
    if([sharing isRunning]) {
        
        //No Type of data case
        if(!dataTimer) {
            [self changeDataTypeTo:SRTime];
        }
        
        //Change state of buttons
        if(runningState != sharing.runningState) {
            [self updateRunningState];
        }
        
        //Update buttons
        [self updateRunningData];
    }
    
    //Staminna stopped running
    else {
        [WatchSharingData clearAllData];
        [self dismissController];
    }
    
}


-(void)updateRunningState {
    
    runningState = sharing.runningState;
    
    if(runningState == RSRunning) {
        
    }
    
    else if(runningState == RSPaused) {
        
    }
    
    else {
        
        
    }
    
    
}


-(void)nextDataType {
    [self changeDataTypeTo:dataType + 1];
}


-(void)changeDataTypeTo: (NSInteger)type {
    
    dataType = type;
    
    if(dataType == SRTime) {
        dataTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextDataType) userInfo:nil repeats:false];
    }
    
    else if(dataType == SRSpeed) {
        dataTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextDataType) userInfo:nil repeats:false];
    }
    
    else if(dataType == SRHeartbeat) {
        dataTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextDataType) userInfo:nil repeats:false];
    }
    
    else {
        dataType = SRTime;
    }
    
}



-(void)updateRunningData {
    
    
    switch ([sharing runningState]) {
        case RSNone:
            return;
            break;
        case RSRunning: {
            NSString *dataString;
            
            if(dataType == SRTime)
                dataString = sharing.timerString;
            else if(dataType == SRSpeed)
                dataString = sharing.speedString;
            else if(dataType == SRHeartbeat)
                dataString = sharing.beatsPerSecond;
            else dataString = sharing.timerString;
            
            //NSAttributedString *infoAtt = [[NSAttributedString alloc] initWithString:dataString attributes:@{ NSKernAttributeName : @2.0, NSFontAttributeName : infoFont}];
            
            //NSAttributedString *distanceAtt = [[NSAttributedString alloc] initWithString:sharing.distanceString attributes:@{ NSKernAttributeName : @2.0, NSFontAttributeName : distanceFont}];
            
            //[[self infoButton] setAttributedTitle:infoAtt];
            //[[self distanceButton] setAttributedTitle:distanceAtt];
            
            [[self infoButton] setTitle:dataString];
            [[self distanceButton] setTitle:sharing.distanceString];
            
        } break;
            
        case  RSPaused: {
            
        } break;
            
        case RSStopped: {
            
        } break;
    }
    
}


- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}


- (void)didDeactivate {
    
    if([dataTimer isValid]) {
        [dataTimer invalidate];
        dataTimer = nil;
    }
    
    if([reloadTimer isValid]) {
        [reloadTimer invalidate];
        reloadTimer = nil;
    }
    
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



