//
//  CategoriaVC.h
//  Stamina
//
//  Created by JOAO LUCAS BISCAIA SISANOSKI on 10/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "HideBBVC.h"
#import "ExercicioTVC.h"
#import "ExercisesList.h"
@interface CategoriaVC : HideBBVC <UITableViewDataSource, UITableViewDelegate>
@property NSArray *frontal, *traseiro;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property BOOL createTraining;
@end
