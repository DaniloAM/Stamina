//
//  SerieKit.m
//  Stamina
//
//  Created by Danilo Mative on 23/03/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "SerieKit.h"

@implementation SerieKit

-(id)init {
    self = [super init];
    
    if(self) {
        [self setSeries:[NSMutableArray array]];
    }
    
    return self;
}

-(void)addSeriePart: (SeriePart *)part {
    [[self series] addObject:part];
}

-(void)startSeries {
    [self setCurrentSerie:0];
}

-(SeriePart *)getNextSerie {
    
    if([[self series] count] <= _currentSerie) {
        return nil;
    }
    
    _currentSerie++;
    
    return [[self series] objectAtIndex:_currentSerie - 1];
}

@end
