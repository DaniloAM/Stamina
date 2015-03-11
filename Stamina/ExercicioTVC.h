//
//  ExercicioTVC.h
//  Stamina
//
//  Created by JOAO LUCAS BISCAIA SISANOSKI on 13/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "HideBBVC.h"
#import "ExercisesList.h"
#import "Exercises.h"
#import "CreateTrainTemp.h"
#import "AddExerciseVC.h"
#import "TipsVC.h"
@interface ExercicioTVC : HideBBVC <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property NSArray *arrayOfExercises;
@property float lastContentOffset;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property NSString *strMuscle;
@property BOOL createTraining;
@end
