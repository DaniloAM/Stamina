//
//  HomeScreenVC.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 06/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "HomeScreenVC.h"

@interface HomeScreenVC ()

@end

@implementation HomeScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeBarNameWith:@"Stamina"];
    [self showBarWithAnimation:1];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UserData *user = [UserData alloc];
    if([user nickName]==nil){
        [[self nickName] setText:NSLocalizedString(@"Modo Offline", nil)];
    }
    else
        [[self nickName] setText:[user nickName]];
    [[self caloria] setText:[NSString stringWithFormat:@"%d kcal",[user burnedCalories]]];
    [[self points] setText:[NSString stringWithFormat:@"%d P",[user userPoints]]];
    [[self kilometros] setText:[UnitConversion distanceFromMetric:[user meters]]];
    //[[self kilometros] setText:[NSString stringWithFormat:@"%.01f Km",[user kilometers]]];
    
    int seconds = [user timeInSeconds] % 60;
    int minutes = [user timeInSeconds] / 60;
    minutes = minutes % 60;
    int hours = minutes / 60;
    
    [[self time] setText:[NSString stringWithFormat:@"%d:%.2d:%.2d",hours,minutes,seconds]];
    
    [self firstButtonMethod:@selector(function1)  fromClass:self  withImage:[UIImage staminaIconShare]];
    [self secondButtonMethod:@selector(function2) fromClass:self  withImage:[UIImage staminaIconCalendarTabDay]];
    [self thirdButtonMethod:nil  fromClass:self withImage:[UIImage staminaIconTrophy]];
    self.navigationItem.hidesBackButton = YES;
    [self addToButton:_academiaBtn imageWhenPressed:[UIImage imageNamed:@"s_icone_academia.png"] andNormal:[UIImage imageNamed:@"icone_academia.png"]];
    [self addToButton:_runningBtn imageWhenPressed:[UIImage imageNamed:@"s_icone_caminhada.png"] andNormal:[UIImage imageNamed:@"icone_caminhada.png"]];
    
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        [[self locationManager] requestAlwaysAuthorization];
//    }
    
}
-(void)function1{
    [self callViewWithName:@"shareScreen"];
}
-(void)function2{
    [self callViewWithName:@"Calendario"];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}


@end
