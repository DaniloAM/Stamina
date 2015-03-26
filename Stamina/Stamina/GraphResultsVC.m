//
//  GraphResultsVC.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 08/12/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "GraphResultsVC.h"

@implementation GraphResultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    StaminaUpdater *updater = [[StaminaUpdater alloc] init];
    
    [updater setNumberInView:7];
    
    _graphic = [[GraphicScroller alloc] init];
    
    [[self graphic] setGraphicFont:[UIFont fontWithName:@"Lato" size:14.0]];
    [[self graphic] startNewGraphicScrollViewWithUpdater:updater expanded:true];
    
    CGRect frame = [[[self graphic] graphicScrollView] frame];
    
    [[[self graphic] graphicScrollView] setFrame:CGRectMake(0, 110, frame.size.width, frame.size.height)];
    
    frame = [[[self graphic] monthLabel] frame];
    
    [[[self graphic] monthLabel] setFrame:CGRectMake(20, 10, frame.size.width, frame.size.height)];
    
    
    [self.view addSubview:[[self graphic] graphicScrollView]];
    [self.view addSubview:[[self graphic] monthLabel]];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showBarWithAnimation:true];
    
    [self firstButtonMethod:@selector(goHome)  fromClass:self  withImage:[UIImage imageNamed:@"icone_home_tab.png"]];
    [self secondButtonMethod:@selector(goToCalendar) fromClass:self  withImage:[UIImage imageNamed:@"icone_calendario_tab_06.png"]];
    [self thirdButtonMethod:@selector(goToRanking)  fromClass:self withImage:[UIImage imageNamed:@"icone_pontuacao_tab.png"]];
}

-(void)goHome {
    [self popToRoot];
}

-(void)goToCalendar {
    [self callViewWithName:@"Calendario"];
}

-(void)goToRanking {
    
}

//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//}



@end
