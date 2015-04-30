//
//  DevelopmentVC.m
//  Stamina
//
//  Created by Danilo Mative on 30/04/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "DevelopmentVC.h"

@interface DevelopmentVC ()

@end

@implementation DevelopmentVC


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UISwipeGestureRecognizer *gest1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(popView)];
    
    gest1.direction = UISwipeGestureRecognizerDirectionRight;
    
    UITapGestureRecognizer *gest2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popView)];
    
    [self.view addGestureRecognizer:gest1];
    [self.view addGestureRecognizer:gest2];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


-(void)popView {
    [self.navigationController popViewControllerAnimated:true];
}


@end