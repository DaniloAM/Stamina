//
//  AcademiaVC.m
//  Stamina
//
//  Created by JOAO LUCAS BISCAIA SISANOSKI on 09/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "AcademiaVC.h"

@interface AcademiaVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalSpace;

@end

@implementation AcademiaVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    [self firstButtonMethod:@selector(function1) fromClass:self withImage:[UIImage staminaIconHome]];
    [self secondButtonMethod:@selector(development) fromClass:self  withImage:[UIImage staminaIconPlus]];
    [self thirdButtonMethod:@selector(development) fromClass:self  withImage:[UIImage staminaIconTrophy]];
    [self showBarWithAnimation:1];
    
    [self performSelectorInBackground:@selector(showCurrentWeather) withObject:nil];
    
    [[self btn1] setTitle:NSLocalizedString(@"Iniciar", nil) forState:UIControlStateNormal];
    [[self btn2] setTitle:NSLocalizedString(@"Treino Livre", nil) forState:UIControlStateNormal];
    
    [[self btn1] addTarget:self action:@selector(development) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)development {
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *myVC = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"developmentScreen"];
//    
//    [self presentViewController:myVC animated:true completion:nil];
    [self callViewWithName:@"developmentScreen"];
}

-(void)function1{
    
    [self popToRoot];
}
-(void)function2{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *myVC;
    myVC= (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CriaTreino"];
    
    [self.navigationController pushViewController:myVC animated:YES];
}
-(void)function3{

}
-(IBAction)callCalendar{
    [self callViewWithName:@"Calendario"];
}
-(void)viewDidLoad{
    [super viewDidLoad];
 
    [self.navigationItem setTitle:NSLocalizedString(@"Academia", nil)];
    [[self btnCalendar] setBackgroundImage:[UIImage staminaIconCalendarDay] forState:UIControlStateNormal];
    [self btn1].backgroundColor = [UIColor staminaBlackColor];
    [self btn2].backgroundColor = [UIColor staminaBlackColor];
    [[self btn1].titleLabel setFont:[UIFont fontWithName:@"Lato-Semibold" size:22.0]];
    [[self btn2].titleLabel setFont:[UIFont fontWithName:@"Lato-Semibold" size:22.0]];
    [[self btn1].titleLabel setTextColor:[UIColor staminaYellowColor]];
    [[self btn2].titleLabel setTextColor:[UIColor staminaYellowColor]];
}


-(void)showCurrentWeather {
    
    WeatherCondition *condition = [[WeatherCondition alloc] init];
    
    NSInteger temperature = [condition returnTemperatureInCurrentLocation];
    [[self temperatureImage] setImage:[UIImage imageNamed:[condition strOfWeather]]];
    if(temperature <= 0) {
        [[self temperatureLabel] setHidden:true];
        [[self temperatureImage] setHidden:true];
        
    }
    
    else {
        
        temperature -= 273;

        
        [UIView animateWithDuration:0.3 animations:^{
            
            if(!_hasMoved) {
                [[self horizontalSpace] setConstant:[[self horizontalSpace] constant] - 60];
                
                [[self btnCalendar] layoutIfNeeded];
            }
            
            [[self temperatureLabel] setHidden:false];
            [[self temperatureImage] setHidden:false];
            

            NSString *temp = [UnitConversion temperatureFromCelsius:temperature];
            [[self temperatureLabel] setText:temp];
            
        }];
        
        _hasMoved = true;
    }
    
    
}


@end
