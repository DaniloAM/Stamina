//
//  MainMenuVC.m
//  Stamina
//
//  Created by João Lucas Sisanoski on 08/12/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "MainMenuVC.h"

@interface MainMenuVC ()

@end

@implementation MainMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationController = [[UINavigationController alloc] init];
    [self.view addSubview:_navigationController.view];
    //check if the first viewcontroller eixsts, otherwise create it
    _navigationController.navigationItem.hidesBackButton = YES;
    [self.navigationItem setHidesBackButton:YES];
    if(self.viewPrincipal == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *myVC;
        myVC= (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SlideMenu"];
        [self setViewPrincipal:myVC];
    
    }
    _navigationController.delegate = self;
    //push the first viewcontroller into the navigation view controller stack
    
    [self.navigationController pushViewController:self.viewPrincipal animated:YES];
    
 }
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //[viewController viewWillAppear:animated];
}
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
   // [viewController viewDidAppear:animated];
}
@end
