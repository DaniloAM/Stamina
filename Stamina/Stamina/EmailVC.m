//
//  EmailVC.m
//  Stamina
//
//  Created by Joao Sisanoski on 5/12/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "EmailVC.h"
#import "SenhaVC.h"
#import "AlertViewLoading.h"
@interface EmailVC ()
{
    AlertViewLoading *alertLoading;
}
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *confirmarEmail;

@end

@implementation EmailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTxt1:[self email]];
    [self setTxt2:[self confirmarEmail]];
    stringNextView = @"senhaVC";
    alertLoading = [[AlertViewLoading alloc] init];

}
-(void)checkAndTakeDecision{
    @try {
        [manager nameValidate:[[self email] text]];
        [manager emailValidate:[[[self email] text] lowercaseString] confirmEmail:[[[self confirmarEmail] text] lowercaseString]];
        [alertLoading show];
        [manager checkEmail:[[self email] text]];

    }
    @catch (DivergenceException *exception) {
        [self showAlertWithTitle:@"Erro" andMainText:@"Emails não conferem" andButtonText:@"Ok"];
        
    }@catch (EmptyFieldException *exception){
        [self showAlertWithTitle:@"Erro" andMainText:@"Campos Vazios" andButtonText:@"Ok"];
    }@catch (EmailInvalidException *exception){
        [self showAlertWithTitle:@"Erro" andMainText:@"Email Invalido" andButtonText:@"Ok"];
        
    }

}
-(void)cloudKitResult: (NSNumber *)result{
    [alertLoading close];
    if([result boolValue]){
        [self showAlertWithTitle:@"Erro" andMainText:@"Email ja cadastrado" andButtonText:@"Ok"];
        
    }
    else{
        user.email = self.email.text;
        [self callViewWithName:stringNextView];
    }

}
-(void)cloudKitCheckEmail:(BOOL)emailExist{
    [self performSelectorOnMainThread:@selector(cloudKitResult:) withObject:[NSNumber numberWithBool:emailExist] waitUntilDone:NO];
  }
-(IBAction)avancar{
    [self checkAndTakeDecision];
}

@end
