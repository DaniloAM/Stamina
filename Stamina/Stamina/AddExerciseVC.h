//
//  AddExerciseVC.h
//  Stamina
//
//  Created by João Lucas Sisanoski on 18/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "HideBBVC.h"
#import "Exercises.h"
#import "CreateTrainTemp.h"
#import "ExerciseTemporary.h"
#import "TipsVC.h"
@interface AddExerciseVC : HideBBVC
typedef enum selected
{
    TIMER,
    SERIES
} menuSelected;
@property NSMutableArray *arrayOfExercises, *backupOfExercises;
@property NSMutableArray *fullArray;
@property (weak, nonatomic) IBOutlet UIImageView *imageExplain;
@property Exercises *exeCurrent;
@property (weak, nonatomic) IBOutlet UILabel *labelExercise;
@property (weak, nonatomic) IBOutlet UILabel *labelCategory;
@property (weak, nonatomic) IBOutlet UIButton *imageCronometer;
@property (weak, nonatomic) IBOutlet UIButton *imageSeries;
@property (weak, nonatomic) IBOutlet UITextField *txt1;
@property (weak, nonatomic) IBOutlet UITextField *txt2;
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property BOOL selected;
@property (weak, nonatomic) IBOutlet UITextField *txt3;
@property (weak, nonatomic) IBOutlet UILabel *lblX;
@property NSMutableArray *stack;
@property CGPoint startPoint;
@property BOOL hasSpace;
@property int currentPic;
@end
