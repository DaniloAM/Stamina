//
//  MainMenuVC.h
//  Stamina
//
//  Created by João Lucas Sisanoski on 08/12/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuVC : UIViewController <UINavigationControllerDelegate>
@property (strong, nonatomic) UINavigationController *navigationController;
@property UIViewController *viewPrincipal;
@end
