//
//  Exercises.h
//  Stamina
//
//  Created by João Lucas Sisanoski on 07/12/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Exercises : NSManagedObject

@property (nonatomic, retain) NSNumber * exerciseID;
@property (nonatomic, retain) NSNumber * numberImages;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * primaryMuscle;
@property (nonatomic, retain) NSString * secondaryMuscle;

@end
