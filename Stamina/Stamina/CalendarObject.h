//
//  CalendarObject.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 11/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//
//---------------------------------------------------------------------//
//
//  This class has the 12 month arrays of DayObjects.
//
//  This class is pre-loaded in the CoreDataLoading.
//
//  Everytime you create or delete trainings with DayObjects, you need to call the methods
//  fom this class.
//
//---------------------------------------------------------------------//
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "DayObject.h"
#import "TrainingDayObject.h"

@interface CalendarObject : NSObject {

    @private
    NSMutableArray *monthlyTrainingsArray;
    
}

+(CalendarObject *)sharedStore;
-(void)addDayObjects: (NSArray *)array;
-(void)removeDayObjects : (NSMutableArray *)array;
-(DayObject *)getDayObjectForDate: (NSDate *)date;
-(NSMutableArray *)getTrainingsInMonth: (int)month andYear: (int)year;
-(void)scheduleTrainingNamed: (NSString *)name inDate: (NSDate *)date;
-(NSArray *)getMonthArrays;

@end
