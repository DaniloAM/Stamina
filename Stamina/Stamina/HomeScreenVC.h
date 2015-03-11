//
//  HomeScreenVC.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 06/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuShouldOpen.h"
#include "HideBBVC.h"
#import "UserData.h"
@interface HomeScreenVC : HideBBVC
@property (weak, nonatomic) IBOutlet UIButton *academiaBtn;
@property (weak, nonatomic) IBOutlet UIButton *runningBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *caloria;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *points;


@end
