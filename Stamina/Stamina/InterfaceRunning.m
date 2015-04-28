//
//  InterfaceRunning.m
//  Stamina
//
//  Created by Danilo Mative on 15/04/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "InterfaceRunning.h"

@interface InterfaceRunning ()

@end

@implementation InterfaceRunning

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    sharing = [[WatchSharingData alloc] init];
    
    //[[self distanceLabel] s]
 
    [self reloadValues];
    // Configure interface objects here.
}


-(void)reloadValues {
    
    if(![sharing isRunning]) {
        
        [WatchSharingData clearAllData];
        [self dismissController];
        
    }
    
    else {
        [self performSelector:@selector(reloadValues) withObject:nil afterDelay:1.0];
    }
    
    if([sharing runningState] == RSRunning) {
        
        if(labelsHidden) {
            [self showLabels];
        }
        
        NSLog(@"%@", sharing.timerString);
        
        [[self distanceLabel] setText:sharing.distanceString];
        [[self timeLabel] setText:sharing.timerString];
        
        //******* SEND BPS INFO HERE ******//
        //[sharing setBeatsPerSecond:??];
        //******* SEND BPS INFO HERE ******//
        
    }
    
    else if([sharing runningState] == RSPaused) {
        
        if(!labelsHidden) {
            [self hideLabels];
        }
        
        [[self timeLabel] setText:@"Paused"];
        
    }
    
    else if([sharing runningState] == RSStopped) {
        
        if(!labelsHidden) {
            [self hideLabels];
        }
        
        [[self timeLabel] setText:@"Stopped"];
        
    }
    
}

-(void)hideLabels {
    labelsHidden = true;
    [[self bpsLabel] setHidden:true];
    [[self distanceLabel] setHidden:true];
}

-(void)showLabels {
    labelsHidden = false;
    [[self bpsLabel] setHidden:false];
    [[self distanceLabel] setHidden:false];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}


- (void)didDeactivate {
    
    willLeave = true;
    
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



