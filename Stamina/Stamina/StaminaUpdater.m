//
//  StaminaUpdater.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 08/12/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "StaminaUpdater.h"

@implementation StaminaUpdater


-(id)init {
    
    self = [super init];
    
    if(self) {
        
        [self setGraphType:GSDistanceGraph];
        
    }
    
    return self;
}


-(NSArray *)currentNumberArray {
    
    return [super currentNumberArrayWithComponents:[self returnArrayOfComonents]];
}


-(NSArray *)nextNumberArray {
    
    NSArray *array = [super nextNumberArrayWithComponents:[self returnArrayOfComonents]];
    
    return array;
}


-(NSArray *)previousNumberArray {
    
    return [super previousNumberArrayWithComponents:[self returnArrayOfComonents]];
}


-(void)expandGraphic {
    
    [self setNumberInView:7];
    [super expandGraphic];
    
}


-(void)contractGraphic {
    
    [self setNumberInView:4];
    [super contractGraphic];
}


-(NSMutableArray *)returnArrayOfComonents {
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *history = [TrajectoryHistory returnArrayOfTrajectoryFiles];
    
    for(int x = 0; x < [history count]; x++) {
        
        GNComponent *component = [[GNComponent alloc] init];
        component.GNDate = [[history objectAtIndex:x] dateDone];
        
        
        //Graphic type (distance, points or calories)
        switch ([self graphType]) {
            case GSPointsGraph:
                //component.GraphicNumber = [[history objectAtIndex:x] points];
                break;
            case GSDistanceGraph:
                component.GraphicNumber = [[history objectAtIndex:x] distance];
                break;
            case GSCaloriesGraph:
                //component.GraphicNumber = [[history objectAtIndex:x] calo];
                break;
            default:
                break;
        }
        
        [array addObject:component];
    }
    
    return array;
}


@end