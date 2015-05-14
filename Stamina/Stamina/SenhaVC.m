//
//  SenhaVC.m
//  Stamina
//
//  Created by Joao Sisanoski on 5/12/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "SenhaVC.h"
#import "PesoVC.h"
@interface SenhaVC ()
@property (weak, nonatomic) IBOutlet UITextField *txtfSenha;
@property (weak, nonatomic) IBOutlet UITextField *txtfConfirmarSenha;

@end

@implementation SenhaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTxt1:[self txtfSenha]];
    [self setTxt2:[self txtfConfirmarSenha]];
    stringNextView = @"pesoVC";

}
-(void)checkAndTakeDecision{
    @try {
        
        [manager passwordValidate:[[self txtfSenha] text] confirmPassword:[[self txtfConfirmarSenha] text]];
        user.password = self.txtfSenha.text;
        [self callViewWithName:stringNextView];
        
    }
    @catch (OutOfBoundsException *exception) {
        [self showAlertWithTitle:@"Erro" andMainText:@"Tamanho Invalido" andButtonText:@"Ok"];
        
    }@catch (EmptyFieldException *exception){
        [self showAlertWithTitle:@"Erro" andMainText:@"Campos Vazios" andButtonText:@"Ok"];
    }@catch (DivergenceException *exception){
        [self showAlertWithTitle:@"Erro" andMainText:@"Senhas diferentes" andButtonText:@"Ok"];
        
    }

}
-(IBAction)avancar{
    [self checkAndTakeDecision];
}
@end
