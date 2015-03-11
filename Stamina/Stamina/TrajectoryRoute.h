//
//  TrajectoryRoute.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 05/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TrajectoryRoute : NSManagedObject

@property (nonatomic, retain) NSData * arrayOfLocations;
@property (nonatomic, retain) NSNumber * trajectoryDistance;
@property (nonatomic, retain) NSString * trajectoryName;
@property (nonatomic, retain) NSData * picturesArray;

@end
