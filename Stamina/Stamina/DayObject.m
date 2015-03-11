//
//  DayObject.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 16/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "DayObject.h"

@implementation DayObject


-(id)init {
    self = [super init];
    
    if(self) {
        
        _date = nil;
        _dateDone = nil;
        _doneState = [NSNumber numberWithInt:0];
        _hasTraining = [NSNumber numberWithBool:false];
        _trainingName = @"";

    }
    
    return self;
}


@end
