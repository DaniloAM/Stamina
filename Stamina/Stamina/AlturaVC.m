//
//  AlturaVC.m
//  Stamina
//
//  Created by Joao Sisanoski on 5/12/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "AlturaVC.h"
#import "IdadeVC.h"
@interface AlturaVC ()
@property (weak, nonatomic) IBOutlet UITextField *txtfAltura;

@end

@implementation AlturaVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    stringNextView = @"idadeVC";
}
-(IBAction)avancar{
    @try {
        [manager checkStringHasNumber:self.txtfAltura.text];
        [manager nameValidate:self.txtfAltura.text];
        [manager heightValidate:self.txtfAltura.text.integerValue];
        user.height = self.txtfAltura.text.integerValue ;
        [self callViewWithName:stringNextView];
    }
    @catch (HeightException *exception) {
        [self showAlertWithTitle:@"Erro" andMainText:@"Altura Errada" andButtonText:@"ok"];
    }
    @catch (EmptyFieldException *exception) {
        [self showAlertWithTitle:@"Erro" andMainText:@"Campo Vazio" andButtonText:@"ok"];
    }
    @catch (StringInvalidException *exception) {
        [self showAlertWithTitle:@"Erro" andMainText:@"Insira um numero" andButtonText:@"ok"];
    }
}
-(void)checkAndTakeDecision{
    [self callViewWithName:stringNextView];

}

@end
