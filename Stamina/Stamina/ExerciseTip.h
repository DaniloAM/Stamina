//
//  ExerciseTip.h
//  Stamina
//
//  Created by João Lucas Sisanoski on 07/12/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ExerciseTip : NSManagedObject

@property (nonatomic, retain) NSNumber * exercise_id;
@property (nonatomic, retain) NSString* tip;

@end
