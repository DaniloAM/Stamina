//
//  CoreDataLoading.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 11/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//
//---------------------------------------------------------------------//
//
//  This class load all the database info only in the start of the app.
//
//  This class gets all the data from and put it in the classes for future usage.
//
//  *** If a new muscle array is created, you need to compare in loadExercisesList ***
//
//---------------------------------------------------------------------//
//

#import <Foundation/Foundation.h>
#import "Exercises.h"
#import "TrainingDayObject.h"
#import "CalendarMath.h"
#import "TrainingExercises.h"
#import "TrajectoryRoute.h"
#import "AppDelegate.h"
#import "CalendarObject.h"
#import "UserData.h"
#import "ExercisesList.h"
#import "ReadTXT.h"
@interface CoreDataLoading : NSObject

@property AppDelegate *appdel;
-(void)initCoreData;
@end
