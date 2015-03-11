//
//  CriaTreinoVC.h
//  Stamina
//
//  Created by JOAO LUCAS BISCAIA SISANOSKI on 21/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "HideBBVC.h"
#import "CustomIOS7AlertView.h"
#import "CreateTrainTemp.h"
#import "AppDelegate.h"
#import "TrainingExercises.h"
#import "ExerciseTemporary.h"
#import "Traning.h"
#import "ExercicioTVC.h"
@interface CriaTreinoVC : HideBBVC <CustomIOS7AlertViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *trainoNomeTxt;
@property (weak, nonatomic) IBOutlet UIButton *btnDias;
@property (weak, nonatomic) IBOutlet UIButton *btnExercicio;
@property (weak, nonatomic) IBOutlet UITableView *tableExercicios;
@property (weak, nonatomic) IBOutlet UIButton *inicioHoraTxt;
@property UIDatePicker *datepicker, *startDate, *finalDate;
@property NSDate *inicio;
@property int sender;
@property UIAlertView *alert;
@property BOOL selected;
@property (weak, nonatomic) IBOutlet UIView *viewDays;
@property NSMutableArray *arrayOfDays;
@property (weak, nonatomic) IBOutlet UIView *viewAux;
@property (weak, nonatomic) IBOutlet UIView *viewAux2;
@property (weak, nonatomic) IBOutlet UIView *viewAux3;
@property (weak, nonatomic) IBOutlet UIView *viewAux4;
@property (weak, nonatomic) IBOutlet UIView *viewAux5;
@property (weak, nonatomic) IBOutlet UIButton *buttonFinalDay;
@property (weak, nonatomic) IBOutlet UIButton *buttonStartDate;
@property NSIndexPath *indexPath;
@property int whichView;
@end
