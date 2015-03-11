//
//  CoreDataLoading.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 11/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//


#import "CoreDataLoading.h"

@implementation CoreDataLoading


-(void)initCoreData{
    [self setAppdel:[[UIApplication sharedApplication] delegate]];
    
    if(![self checkExercisesOnDatabase]) {
        ReadTXT *tx = [[ReadTXT alloc] init];
        [tx criaBancoDeDados];
    }
    
    [self loadCalendarInfo];
    [self loadTrainingsAndRoutesCreated];
}
#pragma mark - Load Calendar


-(void)loadCalendarInfo {
    
    CalendarObject *calendarObj = [CalendarObject alloc];
    
    NSManagedObjectContext *context = [[self appdel] managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TrainingDayObject"];
    NSError *error;
    
    NSArray *objectArray = [context executeFetchRequest:request error:&error];
    
    NSMutableArray *dayObjectsArray = [NSMutableArray array];
    
    for(int x = 0; x < [objectArray count]; x++) {
        
        TrainingDayObject *day = [objectArray objectAtIndex:x];
        DayObject *new = [[DayObject alloc] init];
        
        [new setDate:day.date];
        [new setDateDone:day.dateDone];
        [new setDoneState:day.doneState];
        [new setHasTraining:day.hasTraining];
        [new setTrainingName:day.trainingName];
        
        [dayObjectsArray addObject:new];
        
    }
    
    [calendarObj addDayObjects:dayObjectsArray];
    
}



#pragma mark - Load Trainings

-(void)loadTrainingsAndRoutesCreated {
    
    UserData *data = [UserData alloc];
    [data allocArray];
    
    NSManagedObjectContext *context = [[self appdel] managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TrainingExercises"];
    NSError *error;
    
    NSArray *exercisesArray = [context executeFetchRequest:request error:&error];
    
    for(int x = 0; x < [exercisesArray count]; x++) {
        
        TrainingExercises *training = [exercisesArray objectAtIndex:x];
        [[data trainingsArray] addObject:training];
        
    }
    
    request = [NSFetchRequest fetchRequestWithEntityName:@"TrajectoryRoute"];
    NSArray *routesArray = [context executeFetchRequest:request error:&error];
    
    for(int x = 0; x < [routesArray count]; x++) {
        
        TrajectoryRoute *route = [routesArray objectAtIndex:x];
        [[data routesArray] addObject:route];
        
    }
    
    
    
}

#pragma mark - Create Exercise Database

-(BOOL)checkExercisesOnDatabase {
    
    NSError *error;
    NSManagedObjectContext *context = [[self appdel] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Exercises" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];

    if([objects count] == 0) {
        return false;
    }
    
    else return true;
}

@end
