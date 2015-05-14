//
//  LoginPattern.h
//  Stamina
//
//  Created by Joao Sisanoski on 5/12/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "IHKeyboardAvoiding.h"
@interface LoginPattern : UIViewController <UITextFieldDelegate, UserManagerDelegate>
{
    UserManager *manager;
    @public
    User *user;
    NSString *stringNextView;
}
@property UITextField *txt1, *txt2;

-(void)showAlertWithTitle: (NSString *)title andMainText: (NSString *)text andButtonText: (NSString *)buttonText;
-(void)callViewWithName:(NSString *)str;
-(void)checkAndTakeDecision;
@end
