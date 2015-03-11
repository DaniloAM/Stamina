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

//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//}



@end
