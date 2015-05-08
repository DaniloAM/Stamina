//
//  HomeInterface.m
//  Stamina
//
//  Created by Danilo Mative on 14/04/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "HomeInterface.h"

@interface HomeInterface ()

@end

@implementation HomeInterface

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    share = [[WatchSharingData alloc] init];
    
    [[self staminaIcon] setImage:[UIImage imageNamed:@"logo_stamina_yellow.png"]];
    
    // Configure interface objects here.
}


-(void)updateRunningProperty {
    
    if([share isRunning]) {
        [self presentControllerWithName:@"WatchRunning" context:nil];
    }
    
    else {
        [self performSelector:@selector(updateRunningProperty) withObject:nil afterDelay:2.0];
    }
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self performSelector:@selector(updateRunningProperty) withObject:nil afterDelay:2.0];
    
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



