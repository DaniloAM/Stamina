//
//  UserData.h
//  Projeto Final iOS Academia
//
//  Created by Danilo Augusto Mative on 25/07/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//
//---------------------------------------------------------------------//
//
//  This class has all the user data.
//
//  This class [trainingsArray] array is preloaded in the CoreDataLoading.
//
//  The other user info is loaded from UserDefaults.
//
//  The user basic info, trainings info and etc.
//
//  Every time a training is created, you need to call the method from this class.
//
//---------------------------------------------------------------------//
//

#import <Foundation/Foundation.h>
#import "TrainingExercises.h"
#import "AppDelegate.h"
#import "UserTraining.h"
#import "TrajectoryRoute.h"
#import "CalendarObject.h"

@interface UserData : NSObject

//Array of trainings and Routes
@property NSMutableArray *trainingsArray;
@property NSMutableArray *routesArray;

//Personal Info
@property NSString *name;
@property int heightInCentimeters;
@property int weightInKilograms;
@property BOOL sex;
@property int age;

//Login Info
@property NSString *nickName;
@property NSString *email;
@property NSString *password;

//History Info
@property int completedTrainings;
@property int bestSequence;
@property int currentSequence;
@property int userPoints;
@property int burnedCalories;
@property int lostWeight;
@property int initialWeight;
@property int currentObjective;
@property int timeInSeconds;
@property float kilometers;
@property BOOL nextExercise;

//Settings
@property BOOL offlineMode;
@property int language;
@property int measure;
@property int alerta;
@property NSInteger timeAlarmBeforeTraining;

//IDs
@property int groupID;
@property int userID;

//ETC
@property NSString *lastTrainName;
@property NSDate *lastTrainDate, *startAppUse;



-(void)clearTrainingFromCoreData;
+(UserData *)sharedStore;
-(NSArray *)returnTrainingWithName : (NSString *)trainingName;
-(void)removeTraning: (NSString *)trainingName;
-(void)addExerciseWithTrainingExercise: (TrainingExercises *)newExercise;
-(void)allocArray;
-(void)eraseData;
-(void)loadFromUserDefaults;
-(void)saveOnUserDefaults;

@end
