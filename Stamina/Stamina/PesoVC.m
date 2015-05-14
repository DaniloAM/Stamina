//
//  PesoVC.m
//  Stamina
//
//  Created by Joao Sisanoski on 5/12/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "PesoVC.h"
#import "AlturaVC.h"
@interface PesoVC ()
@property (weak, nonatomic) IBOutlet UITextField *txtfPeso;

@end

@implementation PesoVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setTxt1:_txtfPeso];
    stringNextView = @"alturaVC";
}
-(IBAction)avancar{
   
    
   [self checkAndTakeDecision];
}
-(void)checkAndTakeDecision{
    @try {
        [manager checkStringHasNumber:self.txtfPeso.text];
        [manager nameValidate:self.txtfPeso.text];
        [manager weightValidate:self.txtfPeso.text.integerValue];
        user.weight = self.txtfPeso.text.integerValue;
        [self callViewWithName:stringNextView];
    }
    @catch (WeightException *exception) {
        [self showAlertWithTitle:@"Erro" andMainText:@"Peso Errada" andButtonText:@"ok"];
    }
    @catch (EmptyFieldException *exception) {
        [self showAlertWithTitle:@"Erro" andMainText:@"Campo Vazio" andButtonText:@"ok"];
    }
    @catch (StringInvalidException *exception) {
        [self showAlertWithTitle:@"Erro" andMainText:@"Insira um numero" andButtonText:@"ok"];
    }
    
}
@end
