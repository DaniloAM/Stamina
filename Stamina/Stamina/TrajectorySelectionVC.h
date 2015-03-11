//
//  TrajectorySelectionVC.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 29/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaminaExpandTV.h"
#import "UserData.h"
#import "RoutePointsCartesian.h"
#import "TrajectoryFile.h"
#import "RunningMapVC.h"
#import <MapKit/MapKit.h>

@interface TrajectorySelectionVC : StaminaExpandTV 

@property UserData *user;
@property UITableView *routeTableView;

@property TrajectoryRoute *openRoute;

@end
