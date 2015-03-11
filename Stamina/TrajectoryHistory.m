//
//  TrajectoryHistory.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 11/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "TrajectoryHistory.h"

@implementation TrajectoryHistory


+(NSArray *)returnArrayOfTrajectoryFiles {
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TrajectoryFile"];
    NSError *error;
    
    return [context executeFetchRequest:request error:&error];
}

+(NSArray *)returnArrayOfDistancesInHistory {
    
    NSArray *files = [TrajectoryHistory returnArrayOfTrajectoryFiles];
    
    NSMutableArray *arrayDistance = [NSMutableArray array];
    
    for(TrajectoryFile *file in files) {
        
        [arrayDistance addObject:file.distance];
        
    }
    
    return arrayDistance;
    
}


@end
