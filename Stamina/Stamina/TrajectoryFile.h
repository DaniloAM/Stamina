//
//  TrajectoryFile.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 09/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TrajectoryFile : NSManagedObject

@property (nonatomic, retain) NSDate * dateDone;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * trajectoryName;
@property (nonatomic, retain) NSNumber * distance;

@end
