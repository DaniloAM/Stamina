//
//  IdadeVC.m
//  Stamina
//
//  Created by Joao Sisanoski on 5/12/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "IdadeVC.h"
#import "SexoVC.h"
@interface IdadeVC ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation IdadeVC
-(void)viewDidLoad{
    [super viewDidLoad];
    [[self datePicker] setMaximumDate:[NSDate date]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    stringNextView = @"sexoVC";
}
-(IBAction)avancar{
    [self checkAndTakeDecision];
}
-(void)checkAndTakeDecision{
    @try {
        [manager dateDifference:[self datePicker].date andDate:[NSDate date] isMinorOrEqualInYears:14];
        user.birthday = _datePicker.date;
        [self callViewWithName:stringNextView];

    }
    @catch (DateException *exception) {
        [self showAlertWithTitle:@"Erro" andMainText:@"idade invalida" andButtonText:@"ok"];
    }
  
}
@end
