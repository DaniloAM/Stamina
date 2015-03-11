//
//  ExercisesList.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 11/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//
//---------------------------------------------------------------------//
//
//  This class is a list of all exercises that we have in our database.
//
//  This class is pre-loaded in the CoreDataLoading and is for ** reference-only **.
//
//  It separates in muscle arrays and the array outros.
//
//  If a new muscle array is created, you need to alloc it in allocArrays
//
//---------------------------------------------------------------------//
//
// frontal abdominal - 101
// frontal ante braco - 102
// frontal biceps - 103
// frontal peitoral - 104
// frontal quadriceps - 105
// frontal ombros - 106
// frontal trapezio - 107
// frontal triceps - 108
// trazeiro ante braco - 109
// trazeiro biceps - 110
// trazeiro dorsal - 111
// trazeiro gluteos - 112
// trazeiro lombar - 113
// trazeiro ombros - 114
// trazeiro panturrilha - 115
// trazeiro posterior coxa - 116
// trazeiro romboides - 117
// trazeiro trapezio - 118
// trazeiro triceps - 119

#import <Foundation/Foundation.h>
#import "Exercises.h"
#import "AppDelegate.h"
#define exercisesCategoryCount 19
#define frontalCategoryCount 8

@interface ExercisesList : NSObject

-(NSString *)getStringToIndex: (int )x;
-(NSMutableArray *)getArrayForCategory: (NSString *)string;
-(Exercises *)returnExerciseWithIdentifier: (int)identifier;
+(ExercisesList *)sharedStore;
+(NSString *)returnCategoryNameWithId :(int )identifier;

@end
