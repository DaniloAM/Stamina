//
//  LoginVC.m
//  Stamina
//
//  Created by Joao Sisanoski on 5/12/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved./Users/joaosisanoski/Desktop/Stamina/Stamina/Stamina/Main.storyboard
//

#import "LoginVC.h"
#import "AlertViewLoading.h"
#import <CloudKit/CloudKit.h>
#import "ExceptionFactory.h"
#import "AlertViewLoading.h"
#import "UserManager.h"
#import "UIStaminaColor.h"
@interface LoginVC ()
{
    AlertViewLoading *alertLoading;
    UserManager *signInModel;
}
@property (weak, nonatomic) IBOutlet UITextField *txtfEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor staminaBlackColor]];
    [self setTitle:@"LogIn"];
    [self.txtfPassword setDelegate:self];
    [self.txtfEmail setDelegate:self];
    [self.txtfEmail setTag:1];
    [self.txtfPassword setTag:2];
    [IHKeyboardAvoiding setAvoidingView:self.view];
    //[self prepareObjectsLayout];
    
    signInModel = [[UserManager alloc] init];
    signInModel.delegate = self;
    [self.btnLogin setTitle:NSLocalizedString(@"SignIn", nil) forState:UIControlStateNormal];
    [self.btnSignIn setTitle:NSLocalizedString(@"CreateAccount", nil) forState:UIControlStateNormal];
    
    alertLoading = [[AlertViewLoading alloc] init];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}

-(void)icloudAccountValidation{
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        if (accountStatus == CKAccountStatusNoAccount) {
            
        }
        else {
            [signInModel signInValidate:[[self txtfEmail] text] password:[[self txtfPassword] text]];
        }
    }];

}

-(void)cloudKitConnected:(BOOL)connected{
    if(connected){
        [self performSelectorOnMainThread:@selector(callCreateView) withObject:nil waitUntilDone:NO];
        
    }
    else{
        [self performSelectorOnMainThread:@selector(showUnconnectedIcloud) withObject:nil waitUntilDone:NO];
    }
    
}

-(void)callCreateView{
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"nameVC"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)loginSuccesfull:(NSNumber *)number{
    [alertLoading close];
    NSLog(@"login succesgull");
}
-(void)signInResult:(BOOL)result{
    if(result){
        [self performSelectorOnMainThread:@selector(loginSuccesfull:) withObject:[NSNumber numberWithBool:result] waitUntilDone:NO];
    }
    else{
        [self performSelectorOnMainThread:@selector(loginNotSuccesfull:) withObject:[NSNumber numberWithBool:result] waitUntilDone:NO];
    }
}

-(void)loginNotSuccesfull:(NSNumber *)number{
    [alertLoading close];
        NSLog(@"login not sucessfull");
}
-(IBAction)createUser{
    [signInModel cloudKitStatus];
}
-(void)showUnconnectedIcloud{
    [alertLoading close];
    UnconnectedIcloud *exception = [ExceptionFactory getUnconnectedIcloudReason:NSLocalizedString(@"iCloudErrorLogin", nil)];
    
    [self showAlertWithTitle:exception.name message:exception.reason];
}
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message{
    
    UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
    
}
- (IBAction)doLogon:(id)sender {
    @try {
        
        [signInModel nameValidate:[self.txtfEmail.text lowercaseString]];
        [self icloudAccountValidation];
        [alertLoading show];
        
    }
    @catch (EmptyFieldException *exception){
        [self showAlertWithTitle:exception.name message:exception.reason];
    }
    @catch (OutOfBoundsException *exception){
        [self showAlertWithTitle:exception.name message:exception.reason];
    }
    @catch (DivergenceException *exception){
        [self showAlertWithTitle:exception.name message:exception.reason];
    }
    @catch (UserNotFoundException *exception){
        [self showAlertWithTitle:exception.name message:exception.reason];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    
    if (textField.tag == 1) {
        [self.txtfPassword becomeFirstResponder];
        
    }else if (textField.tag == 2){
        [self doLogon:nil];
    }
    
    
    [textField resignFirstResponder];
    
    return YES;
    
}

@end
