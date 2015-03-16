//
//  FinishedRunningVC.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 30/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "HideBBVC.h"
#import "FinishedRoute.h"
#import "SocialSharingVC.h"
#import "TrajectoryRoute.h"
#import "TrajectoryFile.h"
#import "UIStaminaColor.h"
#import "UIStaminaButton.h"
#import "UserData.h"

@interface FinishedRunningVC : HideBBVC <UITextFieldDelegate>

@property FinishedRoute* route;

@property (weak, nonatomic) IBOutlet UITextField *routeNameTextField;

@property (weak, nonatomic) IBOutlet UIStaminaButton *leftButton;
@property (weak, nonatomic) IBOutlet UIStaminaButton *rightButton;

@property (weak, nonatomic) IBOutlet UILabel *calLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *routeImageView;

@property BOOL isWaitingPicture;
@property BOOL isGoingHome;

@property NSInteger state;

//State 0 - the initial state
//State 1

-(void)receiveRunningRoute: (FinishedRoute *)runningRoute;

@end
