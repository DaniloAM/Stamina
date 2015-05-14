//
//  NameVC.m
//  Stamina
//
//  Created by Joao Sisanoski on 5/12/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "NameVC.h"
#import "EmailVC.h"
@interface NameVC ()

@property User *createUser;
@property (weak, nonatomic) IBOutlet UITextField *txtfName;
@property (weak, nonatomic) IBOutlet UITextField *txtfNickname;

@end

@implementation NameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    [self setTitle:@"Parte 1/7"];
    [self setTxt1:[self txtfName]];
    [self setTxt2:[self txtfNickname]];
    stringNextView = @"emailVC";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)checkAndTakeDecision{
    
    @try {
        [manager nameValidate:[[self txtfName] text]];
        [manager nameValidate:[[self txtfNickname] text]];
        user = [[User alloc] init];
        user.name = [self txtfName].text;
        user.nickname = [self txtfNickname].text;
        
        [self callViewWithName:stringNextView];
    }
    @catch (EmptyFieldException *exception) {
        [self showAlertWithTitle:@"Campo vazio" andMainText:@"ok" andButtonText:@"erro"];
    }

}
-(IBAction)avancar{
    [self checkAndTakeDecision];
}
@end
