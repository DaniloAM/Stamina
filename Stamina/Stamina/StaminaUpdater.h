//
//  StaminaUpdater.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 08/12/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "GraphUpdater.h"
#import "TrajectoryHistory.h"

@interface StaminaUpdater : GraphUpdater

typedef enum Graphic {
    GSDistanceGraph,
    GSPointsGraph,
    GSCaloriesGraph
}Graphic;

@property Graphic graph;

@property NSInteger graphType;

@end