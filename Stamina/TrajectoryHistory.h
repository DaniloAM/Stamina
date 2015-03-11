//
//  TrajectoryHistory.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 11/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "TrajectoryFile.h"

@interface TrajectoryHistory : NSObject

+(NSArray *)returnArrayOfTrajectoryFiles;
+(NSArray *)returnArrayOfDistancesInHistory;

@end
