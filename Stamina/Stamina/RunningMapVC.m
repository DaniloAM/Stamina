//
//  RunningMapVC.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 26/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "RunningMapVC.h"
#define MaxFactor 1.77

@interface RunningMapVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpace1;
@property NSLayoutConstraint *spaceTimeToMap;
@property NSLayoutConstraint *centerTimeToView;
@property NSLayoutConstraint *centerTimeToDistance;
@property NSLayoutConstraint *spaceTimeToView;
@property BOOL timeLabelChanged;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapHeight;


@end

@implementation RunningMapVC

#define reload 3

#pragma mark - Receiver


// This function is used when you are going to run a saved route.
// The method draws the route you selected on the map
-(void)receiveTrajectorySelected: (TrajectoryRoute *)route {
    
    if(route) {
        
        _userRoute = true;
        
        NSArray *locations = [NSKeyedUnarchiver unarchiveObjectWithData:[route arrayOfLocations]];
        
        CLLocationCoordinate2D coordinates[[locations count]];
        
        [[self mapRunningView] addOverlay:_routeLine];
        
        for(int x = 0; x < [locations count]; x++) {
            
            coordinates[x] = [[locations objectAtIndex:x] coordinate];
            
        }
        
        _routeLine = [MKPolyline polylineWithCoordinates:coordinates count:[locations count]];
        
    }
    
}



#pragma mark - ViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //Height factor based on screen size. Is used to the animations
    //of labels and buttons in the view, using auto layout constraints
    
    _heightFactorScreen = [self.view frame].size.height;
    _heightFactorScreen = _heightFactorScreen / 568.0;
    
    if(_heightFactorScreen < 0.98) {
        
        _verticalSpace1.constant *= _heightFactorScreen;
        _mapHeight.constant *= _heightFactorScreen;
    }
    
    _minHeight = _mapHeight.constant;
    _maxHeight = _minHeight * MaxFactor;
    
    //Start button inits
    [self setStartButton:[[UIButton alloc] initWithFrame:CGRectMake(32, 430 * _heightFactorScreen, 256, 36)]];
    
    [self setTimeLabel:[[UILabel alloc] init]];
    
    [[self startButton] setBackgroundColor:[UIColor blackColor]];
    [[self startButton] setTitle:NSLocalizedString(@"Iniciar", nil) forState:UIControlStateNormal];
    [[self startButton]setTitleColor:[UIColor staminaYellowColor] forState:UIControlStateNormal];
    [[[self startButton] titleLabel] setFont:[UIFont fontWithName:@"Lato-Regular" size:22.0]];
    [[self startButton] addTarget:self action:@selector(finishButton:) forControlEvents:UIControlEventTouchUpInside];
    [[self startButton] layer].cornerRadius = 7.0;
    
    //Time label inits
    [[self timeLabel] setTextColor:[UIColor staminaBlackColor]];
    [[self timeLabel] setTextAlignment:NSTextAlignmentCenter];
    [[self timeLabel] setText:@"0:00:00"];
    [[self timeLabel] setFont:[UIFont fontWithName:@"Lato-Regular" size:20.0]];
    
    
    //Auto layout preparations for animations
    [[self timeLabel] setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.view addSubview:[self startButton]];
    [self.view addSubview:[self timeLabel]];
    
    [[self timeLabel] addConstraint:[NSLayoutConstraint constraintWithItem:[self timeLabel] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:34.0]];
    
    [[self timeLabel] addConstraint:[NSLayoutConstraint constraintWithItem:[self timeLabel] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:110.0]];
    
    _timeLabelChanged = false;
    
    _centerTimeToView = [NSLayoutConstraint constraintWithItem:[self timeLabel] attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    _spaceTimeToMap = [NSLayoutConstraint constraintWithItem:[self timeLabel] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mapRunningView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:140.0];
    
    _centerTimeToDistance = [NSLayoutConstraint constraintWithItem:[self timeLabel] attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:[self distanceLabel] attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    
    _spaceTimeToView = [NSLayoutConstraint constraintWithItem:[self timeLabel] attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
    
    [self.view addConstraint:_centerTimeToView];
    [self.view addConstraint:_spaceTimeToMap];
    
    //Prepare the data for sharing with Apple Watch
    [self setSharingWK:[[WatchSharingData alloc] init]];
    [[self sharingWK] setRunningState:RSStopped];
    [[self sharingWK] setIsRunning:true];
    
    //Prepare the viewController to take pictures of places
    [self setPictureViewController:[[SocialSharingVC alloc] init]];
    [[self pictureViewController] setRoutePicture:true];
    
    [self.view setBackgroundColor:[UIColor staminaYellowColor]];
    [[UIApplication sharedApplication] setIdleTimerDisabled:true];
    
    //Arrays of references
    [self setOverlayArray:[NSMutableArray array]];
    [self setLocationsArray:[NSMutableArray array]];
    [self setPicturesArray:[NSMutableArray array]];
    
    //LocationManager init and delegates
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [[self mapRunningView] setDelegate:self];
    [[self mapRunningView] setShowsUserLocation:true];
    [[self locationManager] setDelegate:self];
    
    //Request always authorization
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[self locationManager] requestAlwaysAuthorization];
    }
    
    //Accuracy of GPS
    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //Add the overlay of route, if selected
    if([self userRoute] && [self routeLine]) {
        
        _userRouteIsDraw = true;
        [[self mapRunningView] addOverlay:_routeLine];
    }
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [super hideBarWithAnimation:true];
    
    //Settings of bottom bar
    [self barBlock];
    [self removeGesture];
    [self backViewBlock];
    
    //Check if can measure speed
    if(![CMMotionActivityManager isActivityAvailable]) {
        [[self speedLabel] setHidden:true];
        [[self speedIcon] setHidden:true];
    }
    
    //Swipe gesture to go back
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBack)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:swipe];
    
    //First distanceLabel value
    [[self distanceLabel] setText:[UnitConversion distanceFromMetric:_distanceInMeters]];
    
    //Change WKState
    if(_isRunning) {
        [[self sharingWK] setRunningState:RSRunning];
    }

}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Conexão" message:NSLocalizedString(@"Aviso003", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
        
        alertView.tag = 2;
        [alertView show];
    }
    
    
    [reachability stopNotifier];

    
    [[self locationManager] startUpdatingLocation];
    [[self mapRunningView] setShowsUserLocation:true];

    
    if([self isWaitingForPicture]) {
        [self setIsWaitingForPicture:false];
        
        if([[self pictureViewController] userPicture]) {
            [self savePictureOfRoutePlace:[[self pictureViewController] userPicture]];
        }
        
        [self setPictureViewController:[[SocialSharingVC alloc] init]];
        [[self pictureViewController] setRoutePicture:true];
    }
    
    [self performSelector:@selector(zoomToUserRegion) withObject:nil afterDelay:4.0];
}



-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:false];
    
}



#pragma mark - Map Delegates


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

    if(status == kCLAuthorizationStatusAuthorizedAlways) {
        
    }
    
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    
    if(!_oldLocation) {
        _firstLocation = [locations lastObject];
        _oldLocation = [locations lastObject];
        return;
    }
    
    if([_firstLocation isEqual:_oldLocation]) {
        _oldLocation = [locations lastObject];
        return;
    }
    
    CLLocation *newLocation;
    
    for(int i = 0; i < [locations count]; i++) {
        
        newLocation = [locations objectAtIndex:i];
        
        CLLocationDistance distance = [_oldLocation distanceFromLocation:newLocation];
        
        if([self isRunning]) {
            _distanceInMeters += distance;
        
            [self drawRouteLayerWithPointOne:_oldLocation andTwo:newLocation];
        
            [[self locationsArray] addObject:newLocation];
        }
        
        _oldLocation = newLocation;
    }
    
    if([newLocation speed] < 0) {
        [[self speedLabel] setText:@""];
    }
    
    else {
        //[[self speedLabel] setText:[NSString stringWithFormat:@"%.01f Km/h", ([newLocation speed] * 3.6)]];
        
        [[self speedLabel] setText:[UnitConversion speedFromKilometersPerHour:[newLocation speed] * 3.6]];
    }
    
    [self updateTextInDistanceLabel];
    
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayView* overlayView = nil;
    self.routeLineView = [[MKPolylineView alloc] initWithPolyline:[self routeLine]];
    
    if(_userRouteIsDraw) {
        
        [[self routeLineView] setFillColor:[UIColor colorWithRed:100/255.0f green:250/255.0f blue:100/255.0f alpha:1.0]];
        
        [[self routeLineView] setStrokeColor:[UIColor colorWithRed:100/255.0f green:250/255.0f blue:100/255.0f alpha:1.0]];
        
        _userRouteIsDraw = false;
    }
    
    else {
        
        [[self routeLineView] setFillColor:[UIColor colorWithRed:167/255.0f green:210/255.0f blue:244/255.0f alpha:1.0]];
        
        [[self routeLineView] setStrokeColor:[UIColor colorWithRed:106/255.0f green:151/255.0f blue:232/255.0f alpha:1.0]];
    }
    
    [[self routeLineView] setLineWidth:15.0];
    [[self routeLineView] setLineCap:kCGLineCapRound];
    overlayView = [self routeLineView];
    
    [[self overlayArray] addObject:overlayView];
    return overlayView;
}


#pragma mark - Map drawing


-(void)drawRouteLayerWithPointOne: (CLLocation *)locationOne andTwo: (CLLocation *)locationTwo  {
    
    if (!locationOne || !locationTwo)
    {
        return;
    }
    
    
    CLLocationCoordinate2D coordinates[2];
    
    coordinates[0] = locationOne.coordinate;
    coordinates[1] = locationTwo.coordinate;
    
    
    _routeLine = [MKPolyline polylineWithCoordinates:coordinates count:2];
    
    [[self mapRunningView] addOverlay:_routeLine];
    
}



#pragma mark - Reloads Timer


-(void)startReloadingUserPosition {
    
    if(_seconds % reload == 1) {
        [self zoomToUserRegion];
    }
    [self updateTextInTimeLabel];
    _seconds++;
    
    if(_seconds >= 60) {
        _minutes++;
        _seconds = 0;
    }
    
}


-(void)zoomToUserRegion {
    
    MKCoordinateRegion region;
    region.center.latitude = self.mapRunningView.userLocation.coordinate.latitude;
    region.center.longitude = self.mapRunningView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = 0.002;
    region.span.longitudeDelta = 0.002;
    
    [self.mapRunningView setRegion:region animated:true];
    
}



-(void)updateTextInTimeLabel {
    
    NSString *timerString = [NSString stringWithFormat:@"%d:%02d:%02d", (_minutes / 60), (_minutes % 60), _seconds];
    
    [[self timeLabel] setText:timerString];
    [[self sharingWK] setTimerString:timerString];
    
    [[self bpsLabel] setText:[[self sharingWK] beatsPerSecond]];
    
}


-(void)updateTextInDistanceLabel {
    
    [[self distanceLabel] setText:[UnitConversion distanceFromMetric:_distanceInMeters]];
    [[self sharingWK] setDistanceString:[[self distanceLabel] text]];
    
}


#pragma mark - Gesture methods

-(void)swipeBack {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Parar", nil) message:NSLocalizedString(@"Aviso001", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Não", nil) otherButtonTitles:NSLocalizedString(@"Sim", nil), nil];
    
    alert.tag = 4;
    
    [alert show];
    
}

-(void)goBack {
    
    
    if(self.distanceInMeters > 0.0) {
        UserData *user = [UserData alloc];
        
        [user setMeters:[user meters] + self.distanceInMeters];
        
        [user setTimeInSeconds:[user timeInSeconds] + self.seconds + (self.minutes  * 60)];
        
        //*********** MUST PUT CALORIES AND POINTS HERE ********//
        //*********** MUST PUT CALORIES AND POINTS HERE ********//
        //*********** MUST PUT CALORIES AND POINTS HERE ********//
        
        [user saveOnUserDefaults];
        
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [app managedObjectContext];
        NSError *error = nil;
        
        TrajectoryFile *file = [NSEntityDescription insertNewObjectForEntityForName:@"TrajectoryFile" inManagedObjectContext:context];
        
        
        [file setTrajectoryName:@""];
        [file setDateDone:[NSDate date]];
        [file setDuration:[NSNumber numberWithInt:([self seconds] + [self minutes] * 60)]];
        [file setDistance:[NSNumber numberWithDouble:[self distanceInMeters]]];
        
        
        [context save:&error];
        
        
    }
    
    
    [self.navigationController popViewControllerAnimated:true];
    
}


#pragma mark - Buttons methods



-(IBAction)takePlacePicture {
    
    if(![self isRunning]) {
        return;
    }
    
    [self setIsWaitingForPicture:YES];
    [self callView:[self pictureViewController]];
  

}


-(void)savePictureOfRoutePlace: (UIImage *)pic {
    
    UIImageView *view = [[UIImageView alloc] init];
    view.tag = [[self locationsArray] count] - 1;
    
    [[self picturesArray] addObject:view];
    
    [self setPictureViewController:[[SocialSharingVC alloc] init]];
    [[self pictureViewController] setRoutePicture:true];
}



-(IBAction)finishButton: (UIButton *)sender {
    
    if(![self isRunning]) {
        
        [sender setTitle:NSLocalizedString(@"Terminar", nil) forState:UIControlStateNormal];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startReloadingUserPosition) userInfo:nil repeats:true];
        
        [self setIsRunning:true];
        
        [[self sharingWK] setRunningState:RSRunning];
    }
    
    
    else {
        
        //[sender setTitle:@"Iniciar" forState:UIControlStateNormal];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Parar", nil) message:NSLocalizedString(@"Aviso001", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Não", nil) otherButtonTitles:NSLocalizedString(@"Sim", nil), nil];
        
        alertView.tag = 1;
        
        [alertView show];
        
    }
    
}

-(void)finishRunning {
    
    FinishedRoute *route = [[FinishedRoute alloc] init];
    
    [route setArrayOfLocations:[self locationsArray]];
    
    
    //Create a new RoutePointsCartesian
    
    RoutePointsCartesian *cartesian =[[RoutePointsCartesian alloc] init];
    
    //Add the location points to cartesian
    for(int x = 0; x < [[self locationsArray] count]; x++) {
        
        MKMapPoint point = MKMapPointForCoordinate([[[self locationsArray] objectAtIndex:x] coordinate]);
        
        [cartesian addPointToRouteInX:point.x andY:point.y];
    }
    
    
    //Prepare the cartesian system for the map points
    [cartesian prepareForCartesian];
    
    [route setTimeInSeconds:_seconds];
    [route setTimeInMinutes:_minutes];
    [route setDistanceInMeters:_distanceInMeters];
    [route setRoutePoints:cartesian];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FinishedRunningVC *myVC = (FinishedRunningVC *)[storyboard instantiateViewControllerWithIdentifier:@"finishedRunning"];
    
    //Receive the route to draw it
    [myVC receiveRunningRoute:route];
    
    [self.navigationController pushViewController:myVC animated:YES];
    
}


#pragma mark - AlertView Delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if(alertView.tag >= 2 && alertView.tag <= 3) {
        [self.navigationController popViewControllerAnimated:true];
    }
    
    
    else if(alertView.tag == 4) {
        
        if(buttonIndex == 0) {
            return;
        }
        
        if(buttonIndex == 1) {
            [WatchSharingData clearAllData];
            [self goBack];
        }
    }
    
    else {
        
        if (buttonIndex == 0) {
            return;
        }
        if (buttonIndex == 1) {
            [[self sharingWK] setRunningState:RSReviewing];
            [self finishRunning];
        }
        
    }
}


#pragma mark - Animations methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    [self setHeight:touchPoint.y];
    
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    CGRect frame = [[self mapRunningView] frame];
    
    if(touchPoint.y > [self height]) {
        
        if([[self mapRunningView] frame].size.height >= _maxHeight) {
            
            _heightFactor = MaxFactor;
            [[self mapHeight] setConstant:_minHeight * _heightFactor];
        }
        
        else {
            
            frame.size.height += touchPoint.y - [self height];
            
            _heightFactor = frame.size.height / _minHeight;
            [[self mapHeight] setConstant:_minHeight * _heightFactor];
            
        }
        
        [[self mapRunningView]setFrame:frame];
    }
    
    else if(touchPoint.y < [self height]) {
        
        if([[self mapRunningView] frame].size.height <= _minHeight) {
            
            _heightFactor = 1.0;
            [[self mapHeight] setConstant:_minHeight * _heightFactor];
            
        }
        
        else {
            
            frame.size.height -= [self height] - touchPoint.y;
            
            _heightFactor = frame.size.height / _minHeight;
            [[self mapHeight] setConstant:_minHeight * _heightFactor];
        }
        
    }
    
    if(frame.size.height > _maxHeight) {
        _heightFactor = MaxFactor;
        [[self mapHeight] setConstant:_minHeight * _heightFactor];
        
    }
    
    else if(frame.size.height < _minHeight) {
        _heightFactor = 1.0;
        [[self mapHeight] setConstant:_minHeight * _heightFactor];
        
    }
    
    
    [self setHeight:touchPoint.y];
    [self newUpdateButtonsForm];
    
}

-(void)newUpdateButtonsForm {
    
    float percent = (_heightFactor - 1.0) * (1 / (MaxFactor - 1.0));
    
    //Check button and change image and action by flag
    if(percent >= 0.5) {
        [self setMapViewExpanded:true];
        [[self expandButton] setBackgroundImage:[UIImage imageNamed:@"drop_up_corrida.png"] forState:UIControlStateNormal];
    }
    
    else {
        [self setMapViewExpanded:false];
        [[self expandButton] setBackgroundImage:[UIImage imageNamed:@"drop_down_corrida.png"] forState:UIControlStateNormal];
        
    }
    
    //Return case
    if(percent > 1.0 || percent < 0.0)
        return;
    
    //Alpha changes
    float alpha = 1.0;
    
    if(percent >= 0.0 && percent <= 0.2) {
        alpha -= percent * 5;
    }
    
    else {
        alpha = 0.0;
    }
    
    [[self timeIcon] setAlpha:alpha];
    [[self bpsIcon] setAlpha:alpha];
    [[self bpsLabel] setAlpha:alpha];
    [[self speedLabel] setAlpha:alpha];
    [[self speedIcon] setAlpha:alpha];
    
    
    //Font size
    float fontSize = 60.0 - (30.0 * percent);
    [[self distanceLabel] setFont:[UIFont fontWithName:@"Lato-Regular" size:fontSize]];
    
    
    //Button Start Perform
    float newWidth, newRadius, newHeight, buttonY;
    
    if(percent < 0.8) {
        newWidth = 256.0 - (percent * 232.5);
        newRadius = 7.0 + percent * 20;
    }
    
    else {
        newWidth = 70.0 - ((percent - 0.8) * 50.0);
        newRadius = 23.0 + ((percent - 0.8) * 35.0);
    }
    
    newHeight = 36.0 + (percent * 24.0);
    buttonY = (430.0 * _heightFactorScreen) - (percent * 8.0);
    
    CGRect frame = [[self startButton] frame];
    
    frame.size.width = newWidth;
    frame.size.height = newHeight;
    frame.origin.y = buttonY;
    [[self startButton] setFrame:frame];
    [[self startButton] layer].cornerRadius = newRadius;
    
    
    //Time label perform
    if(percent < 0.5) {
        
        if([self timeLabelChanged]) {
            [self.view removeConstraints:@[_spaceTimeToView,_centerTimeToDistance]];
            
            [self.view addConstraints:@[_spaceTimeToMap,_centerTimeToView]];
        }
        
        [self setTimeLabelChanged:false];
        
        
        [[self timeLabel] setFont:[UIFont fontWithName:@"Lato-Regular" size:20.0]];
        [[self timeLabel] setAlpha:alpha];
    }
    
    else {
        
        if(![self timeLabelChanged]) {
            [self.view removeConstraints:@[_spaceTimeToMap,_centerTimeToView]];
            
            [self.view addConstraints:@[_spaceTimeToView,_centerTimeToDistance]];
        }
        
        [self setTimeLabelChanged:true];
        
        
        [[self timeLabel] setFont:[UIFont fontWithName:@"Lato-Regular" size:22.0]];
        [[self timeLabel] setAlpha:((percent * 10) - 7.0)];
    }
    
}


-(IBAction)fullAnimateTo {
    if([self mapViewExpanded]) {
        [UIView animateWithDuration:0.4 animations:^{
            _heightFactor = 1.0;
            [[self mapHeight] setConstant:_minHeight];
            [[self mapRunningView] layoutIfNeeded];
            [self newUpdateButtonsForm];
            [self.view layoutIfNeeded];
        }];
    }
    
    else {
        [UIView animateWithDuration:0.4 animations:^{
            _heightFactor = MaxFactor;
            [[self mapHeight] setConstant:_minHeight * _heightFactor];
            [[self mapRunningView] layoutIfNeeded];
            [self newUpdateButtonsForm];
            [self.view layoutIfNeeded];
        }];
    }
}


@end
