//
//  GraphResultsVC.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 08/12/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphicScroller.h"
#import "StaminaUpdater.h"
#import "UnitConversion.h"
#import "HideBBVC.h"

@interface GraphResultsVC : HideBBVC

@property GraphicScroller *graphic;
@property (weak, nonatomic) IBOutlet UILabel *totalDistanceLabel;

@end
