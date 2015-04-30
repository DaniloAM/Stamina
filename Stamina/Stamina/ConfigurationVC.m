//
//  ConfigurationVC.m
//  Stamina
//
//  Created by Danilo Mative on 30/04/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "ConfigurationVC.h"
#import "UserConfigurations.h"

@interface ConfigurationVC ()

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *distanceSegment;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *temperatureSegment;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *heightSegment;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *weightSegment;

@end

@implementation ConfigurationVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserConfigurations *conf = [UserConfigurations alloc];
    
    [conf loadConfigurations];
    
    [[self distanceSegment] setSelectedSegmentIndex:conf.measureDistance];
    [[self temperatureSegment] setSelectedSegmentIndex:conf.measureTemperature];
    [[self heightSegment] setSelectedSegmentIndex:conf.measureHeight];
    [[self weightSegment] setSelectedSegmentIndex:conf.measureWeight];
    
    [[self distanceLabel] setText:NSLocalizedString(@"Distância", nil)];
    [[self temperatureLabel] setText:NSLocalizedString(@"Temperatura", nil)];
    [[self heightLabel] setText:NSLocalizedString(@"Altura", nil)];
    [[self weightLabel] setText:NSLocalizedString(@"Peso", nil)];
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    UserConfigurations *conf = [UserConfigurations alloc];
    
    conf.measureDistance = (int)[[self distanceSegment] selectedSegmentIndex];
    conf.measureTemperature = (int)[[self temperatureSegment] selectedSegmentIndex];
    conf.measureHeight = (int)[[self heightSegment] selectedSegmentIndex];
    conf.measureWeight = (int)[[self weightSegment] selectedSegmentIndex];
    
    [conf saveConfigurations];
    
}



@end
