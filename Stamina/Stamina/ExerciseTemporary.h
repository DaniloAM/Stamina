//
//  ExerciseTemporary.h
//  Stamina
//
//  Created by João Lucas Sisanoski on 18/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Exercises.h"
@interface ExerciseTemporary : NSObject
@property NSInteger serie;
@property NSInteger repeticoes;
@property Exercises *exercicio;
@property NSInteger minutos;
@property NSInteger segundos;

@property BOOL time;
@end
