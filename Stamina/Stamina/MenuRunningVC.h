//
//  MenuRunningVC.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 28/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideBBVC.h"
#import "TrajectorySelectionVC.h"
#import "WeatherCondition.h"

@interface MenuRunningVC : HideBBVC <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property BOOL hasMoved;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;
@property (weak, nonatomic) IBOutlet UIImageView *temperatureImage;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *trajectoryButton;

@end
