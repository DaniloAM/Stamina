//
//  AcademiaVC.m
//  Stamina
//
//  Created by JOAO LUCAS BISCAIA SISANOSKI on 09/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "AcademiaVC.h"

@interface AcademiaVC ()

@end

@implementation AcademiaVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    [self firstButtonMethod:@selector(function1) fromClass:self withImage:[UIImage staminaIconHome]];
    [self secondButtonMethod:@selector(function2) fromClass:self  withImage:[UIImage staminaIconPlus]];
    [self thirdButtonMethod:@selector(function3) fromClass:self  withImage:[UIImage staminaIconTrophy]];
    [self showBarWithAnimation:1];
    
    [self performSelectorInBackground:@selector(showCurrentWeather) withObject:nil];
    
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
 
    [self.navigationItem setTitle:@"Academia"];
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
    
    if(temperature <= 0) {
        CGRect frame = [[self btnCalendar] frame];
        frame.origin.x = 118;
        [[self btnCalendar] setFrame:frame];
        [[self temperatureLabel] setHidden:true];
        [[self temperatureImage] setHidden:true];
        
    }
    
    else {
        
        temperature -= 273;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = [[self btnCalendar] frame];
            frame.origin.x = 60;
            [[self btnCalendar] setFrame:frame];
            [[self temperatureLabel] setHidden:false];
            [[self temperatureImage] setHidden:false];
            
            
            
            NSString *temp = [NSString stringWithFormat:@"%d °C", (int) temperature];
            [[self temperatureLabel] setText:temp];
            
        }];
    }
    
    //[self performSelector:@selector(showCurrentWeather) withObject:nil afterDelay:30.0];
    
}


@end
