//
//  FinishedRunningVC.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 30/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "FinishedRunningVC.h"

@interface FinishedRunningVC ()

@end

@implementation FinishedRunningVC

#pragma mark - Receiver

-(void)receiveRunningRoute: (FinishedRoute *)runningRoute {
    
    _route = runningRoute;
    
}

#pragma mark - ViewController methods

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showBarWithAnimation:true];
    [self setIsGoingHome:true];
    [self removeGesture];
    
    [[self routeNameTextField] setDelegate:self];
    
    if(_route) {
        [self drawTrajectoryDone];
    }

    [super showBarWithAnimation:true];
    [self.view setBackgroundColor:[UIColor staminaYellowColor]];
    
    
    //Set bar button actions and images
    [self firstButtonMethod:@selector(goHome) fromClass:self  withImage:[UIImage staminaIconHome]];
    
    [self secondButtonMethod:@selector(goToCalendar)  fromClass:self withImage:[UIImage imageNamed:@"icone_calendario_tab_06.png"]];
    
    [self thirdButtonMethod:@selector(goToRankingPoints)  fromClass:self withImage:[UIImage staminaIconTrophy]];
    

    
    //Set buttons images and actions
    [self setButtonImageNameLeft:@"icone_add_trajeto.png" andRight:@"icone_compartilhar_trajeto.png"];
    
    [self setButtonActionLeft:@selector(enableRouteNameTextField) andRight:@selector(selectSharingOption)];
    
    UISwipeGestureRecognizer *rightSlide = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSlideAction)];
    
    rightSlide.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:rightSlide];
    
}




-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if([self isGoingHome] && ![self isWaitingPicture]) {
        [self saveUserInformations];
    }
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self routeNameTextField] resignFirstResponder];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
}


#pragma mark - Load Trajectory methods

-(void)drawTrajectoryDone {
    
    UIImageView *routeView = _route.routePoints.returnDrawedViewWithCurrentRoute;
    
    
    if(routeView == nil) {
        return;
    }
    
    double fator;
    
    if(routeView.frame.size.width > routeView.frame.size.height) {
        fator = ( 180 / routeView.frame.size.width );
        
    } else {
        fator = ( 180 / routeView.frame.size.height );
        
    }
    
    
    [routeView setFrame:CGRectMake(0, 0, routeView.frame.size.width * fator , routeView.frame.size.height * fator)];
    
    routeView.center = _routeImageView.center;
    
    [_routeImageView removeFromSuperview];
    [self.view addSubview:routeView];
    
    
    [self setTrajectoryInfo];
    
}


-(void)setTrajectoryInfo {
    
    if(_route.distanceInMeters >= 1000.0f) {
        [[self distanceLabel] setText:[NSString stringWithFormat:@"%.01f Km", _route.distanceInMeters / 1000]];
    }
    
    else {
        [[self distanceLabel] setText:[NSString stringWithFormat:@"%d m", (int) _route.distanceInMeters]];
    }
    
    [[self timeLabel] setText:[NSString stringWithFormat:@"%d:%02d:%02d", (_route.timeInMinutes / 60), (_route.timeInMinutes  % 60), _route.timeInSeconds]];
    
}


#pragma mark - Buttons actions


-(void)setButtonActionLeft: (void *)left andRight: (void *)right {
    
    if([[self leftButton] allTargets] != nil) {
    
    [[self leftButton] removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    
    [[self rightButton] removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];

    }
        
    [[self leftButton] addTarget:self action:left forControlEvents:UIControlEventTouchUpInside];
    
    [[self rightButton] addTarget:self action:right forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)setButtonImageNameLeft: (NSString *)left andRight: (NSString *)right {
    
    [[self leftButton] setStaminaImageName:left];
    [[self rightButton] setStaminaImageName:right];
    
}


-(void)enableRouteNameTextField {
    
    _state = 1;
    
    [[self routeNameTextField] setHidden:false];
    
    [[self leftButton] setHidden:true];
    [[self rightButton] setHidden:true];
    
    [self thirdButtonMethod:@selector(confirmRouteName) fromClass:self  withImage:[UIImage staminaIconOk]];
}


-(void)confirmRouteName {
    
    _state = 0;
    [[self routeNameTextField] setHidden:true];
    
    [[self leftButton] setHidden:false];
    [[self rightButton] setHidden:false];
    
    if(![[[self routeNameTextField] text] isEqualToString:@""]) {
        [self saveRouteWithName:[[self routeNameTextField] text]];
    }
    
    [self thirdButtonMethod:@selector(goToRankingPoints) fromClass:self  withImage:[UIImage staminaIconTrophy]];
    
}


-(void)selectSharingOption {
    
    _state = 2;
    [self setButtonImageNameLeft:@"icone_trajeto_compartilhar.png" andRight:@"icone_foto.png"];
    [self setButtonActionLeft:nil andRight:@selector(goSharePicture)];
    
}


-(void)rightSlideAction {
    
    //Back to the mapView
    if(_state == 0) {
        [self setIsGoingHome:false];
        [self.navigationController popViewControllerAnimated:YES];
    }

    //Back to original button state
    if(_state == 1 || _state == 2) {
        
        _state = 0;
        
        [self firstButtonMethod:@selector(goHome) fromClass:self  withImage:[UIImage staminaIconHome]];
        
        [self secondButtonMethod:@selector(goToCalendar)  fromClass:self withImage:[UIImage imageNamed:@"icone_calendario_tab_06.png"]];
        
        [self thirdButtonMethod:@selector(goToRankingPoints)  fromClass:self withImage:[UIImage staminaIconTrophy]];
       
        [self setButtonImageNameLeft:@"icone_add_trajeto.png" andRight:@"icone_compartilhar_trajeto.png"];
        
        [[self leftButton] setHidden:false];
        [[self rightButton] setHidden:false];
        
        [[self routeNameTextField] setHidden:true];
        
        [self setButtonActionLeft:@selector(enableRouteNameTextField) andRight:@selector(selectSharingOption)];
        
    }
    

}

-(void)goToCalendar {
    [self setIsGoingHome:false];
    [self callViewWithName:@"Calendario"];
}

-(void)goToRankingPoints {
    //[self setIsGoingHome:false];
    //[self callViewWithName:@"Ranking"];
}

-(void)goSharePicture {
    
    [self setIsWaitingPicture:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *myVC = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"shareScreen"];
    
    [self.navigationController pushViewController:myVC animated:YES];
    
}



-(void)goHome {
    
    [self popToRoot];
}

-(void)saveRouteWithName: (NSString *)routeName {
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSError *error = nil;
    
    TrajectoryRoute *saveRoute = [NSEntityDescription insertNewObjectForEntityForName:@"TrajectoryRoute" inManagedObjectContext:context];
    
    [saveRoute setPicturesArray:[NSKeyedArchiver archivedDataWithRootObject:_route.arrayOfPictures]];
    [saveRoute setArrayOfLocations:[NSKeyedArchiver archivedDataWithRootObject:_route.arrayOfLocations]];
    
    [saveRoute setTrajectoryName:[[self routeNameTextField] text]];
    [saveRoute setTrajectoryDistance:[NSNumber numberWithDouble:[_route distanceInMeters]]];
    
    UserData *userData = [UserData alloc];
    [[userData routesArray] addObject:saveRoute];
    
    
    TrajectoryFile *file = [NSEntityDescription insertNewObjectForEntityForName:@"TrajectoryFile" inManagedObjectContext:context];
    
    
    [file setTrajectoryName:routeName];
    [file setDateDone:[NSDate date]];
    [file setDuration:[NSNumber numberWithInt:([_route timeInSeconds] + [_route timeInMinutes] * 60)]];
    [file setDistance:[NSNumber numberWithDouble:[_route distanceInMeters]]];
    
    
    [context save:&error];
    
}

-(void)saveUserInformations {
    
    UserData *user = [UserData alloc];
    
    [user setKilometers:[user kilometers] + (_route.distanceInMeters / 1000)];
    
    [user setTimeInSeconds:[user timeInSeconds] + _route.timeInSeconds + (_route.timeInMinutes  * 60)];
    
    //*********** MUST PUT CALORIES AND POINTS HERE ********//
    //*********** MUST PUT CALORIES AND POINTS HERE ********//
    //*********** MUST PUT CALORIES AND POINTS HERE ********//
    
    [user saveOnUserDefaults];
    
}

@end
