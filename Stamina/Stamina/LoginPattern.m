//
//  LoginPattern.m
//  Stamina
//
//  Created by Joao Sisanoski on 5/12/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "LoginPattern.h"

@interface LoginPattern ()
{
    BOOL keyboardAtived, keyboardIsShown;
}
@property (nonatomic, assign) CGSize keyboardSize;
@property (nonatomic, strong) UITextField *currentTextField;
@end

@implementation LoginPattern
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setTxt1:nil];
    [self setTxt2:nil];
    
    manager = [[UserManager alloc] init];
    manager.delegate = self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self txt1] setDelegate:self];
    [[self txt2] setDelegate:self];
    [IHKeyboardAvoiding setAvoidingView:self.view];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag==0&&[self txt2]) {
        [[self txt2] becomeFirstResponder];
    }
    else{
        [self checkAndTakeDecision];
    }
    [textField resignFirstResponder];
    return YES;
    
}

-(void)checkAndTakeDecision{
    
}
-(void)showAlertWithTitle: (NSString *)title andMainText: (NSString *)text andButtonText: (NSString *)buttonText{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:text delegate:nil cancelButtonTitle:buttonText otherButtonTitles:nil, nil];
    [alert show];
}
-(void)callViewWithName:(NSString *)str{
    LoginPattern *login = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:str];
    login->user = user;

    [self.navigationController pushViewController:login animated:YES];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
