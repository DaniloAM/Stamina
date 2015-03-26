//
//  CreateTrajectoryVC.h
//  Stamina
//
//  Created by Danilo Mative on 23/03/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerieKit.h"
#import "SeriePart.h"
#import "SeriesMapVC.h"

@interface CreateTrajectoryVC : HideBBVC <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property BOOL distanceSelected;

@property SerieKit *serieKit;

@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *timeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *distanceIcon;
@property (weak, nonatomic) IBOutlet UILabel *timeBackground;
@property (weak, nonatomic) IBOutlet UILabel *distanceBackground;
@property (weak, nonatomic) IBOutlet UILabel *timeRect;
@property (weak, nonatomic) IBOutlet UILabel *distanceRect;
@property (weak, nonatomic) IBOutlet UILabel *timeRect2;
@property (weak, nonatomic) IBOutlet UILabel *distanceRect2;
@property (weak, nonatomic) IBOutlet UILabel *valueBackground;

@property (weak, nonatomic) IBOutlet UITableView *serieTableView;

@end
