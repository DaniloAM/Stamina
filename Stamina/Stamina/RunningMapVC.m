//
//  RunningMapVC.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 26/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "RunningMapVC.h"

@interface RunningMapVC ()

@end

@implementation RunningMapVC

#define reload 3
//#define frame_max 410.0
//#define frame_min 225.0

#pragma mark - Receiver

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
    
    [self setSharingWK:[[WatchSharingData alloc] init]];
    [[self sharingWK] setRunningState:RSStopped];
    [[self sharingWK] setIsRunning:true];
    
    [self setPictureViewController:[[SocialSharingVC alloc] init]];
    [[self pictureViewController] setRoutePicture:true];
    
    [self.view setBackgroundColor:[UIColor staminaYellowColor]];
    [[UIApplication sharedApplication] setIdleTimerDisabled:true];
    
    [self setOverlayArray:[NSMutableArray array]];
    [self setLocationsArray:[NSMutableArray array]];
    [self setPicturesArray:[NSMutableArray array]];
    
    [[self mapRunningView] setDelegate:self];
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [[self locationManager] setDelegate:self];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[self locationManager] requestAlwaysAuthorization];
    }
    
    [[self mapRunningView] setShowsUserLocation:true];
    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    
    
    if([self userRoute] && [self routeLine]) {
        
        _userRouteIsDraw = true;
        [[self mapRunningView] addOverlay:_routeLine];
    }
    
    [[self startButton] setTitle:NSLocalizedString(@"Iniciar", nil) forState:UIControlStateNormal];
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [[self mapRunningView] layoutIfNeeded];
//    
//    CGRect frame = [[self mapRunningView] frame];
//    
//    frame.size.height = [[self view] frame].size.height * 0.4;
//    
//    [[self mapRunningView] setFrame:frame];
    
    [super hideBarWithAnimation:true];
    
    [self barBlock];
    [self removeGesture];
    [self backViewBlock];
    
    //Check if can measure speed
    if(![CMMotionActivityManager isActivityAvailable]) {
        [[self speedLabel] setHidden:true];
        [[self speedIcon] setHidden:true];
    }
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBack)];
    
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:swipe];
    
    [[self distanceLabel] setText:[UnitConversion distanceFromMetric:_distanceInMeters]];
    
    if(_isRunning) {
        [[self sharingWK] setRunningState:RSRunning];
    }
    
    _minHeight = [[self mapRunningView] frame].size.height;
    _maxHeight = _minHeight * 1.82;
    
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
    }
    
    [self performSelector:@selector(zoomToUserRegion) withObject:nil afterDelay:4.0];
}



-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:false];
    
    //[[self timer] invalidate];
    //_timer = nil;
}



#pragma mark - Map Delegates


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
    
    [[self bpsLabel] setText:[NSString stringWithFormat:@"%d bps",[[self sharingWK] beatsPerSecond]]];
    
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
            
            frame.size.height = _maxHeight;
        }
        
        else {
            
            frame.size.height += touchPoint.y - [self height];
            
        }
        
        [[self mapRunningView]setFrame:frame];
    }
    
    else if(touchPoint.y < [self height]) {
        
        if([[self mapRunningView] frame].size.height <= _minHeight) {
            
            frame.size.height = _minHeight;
        }
        
        else {
            
            frame.size.height -= [self height] - touchPoint.y;
        }
        
        [[self mapRunningView]setFrame:frame];
    }
    
    if(frame.size.height > _maxHeight) {
        frame.size.height = _maxHeight;
        [[self mapRunningView] setFrame:frame];
    }
    
    else if(frame.size.height < _minHeight) {
        frame.size.height = _minHeight;
        [[self mapRunningView] setFrame:frame];
    }
    
    
    [self setHeight:touchPoint.y];
    [self updateButtunsForm];
    
}

-(void)updateButtunsForm {
    
    //Data for math
    float height = [[self mapRunningView] frame].size.height;
    
    float percent = (height - _minHeight) / (_maxHeight - _minHeight);
    
    float iconY = 339.0, labelY = 376.0, distanceY = 258.0, centerY = 458.0, expandButton = 208.0;
    
    
    //Check button and change image and action by flag
    if(height > _minHeight + ((_maxHeight - _minHeight) / 2)) {
        [self setMapViewExpanded:true];
        [[self expandButton] setBackgroundImage:[UIImage imageNamed:@"drop_up_corrida.png"] forState:UIControlStateNormal];
    }
    
    else {
        [self setMapViewExpanded:false];
        [[self expandButton] setBackgroundImage:[UIImage imageNamed:@"drop_down_corrida.png"] forState:UIControlStateNormal];

    }
    
    
    //New values
    float newWidth, newRadius, newHeight = 36.0, fontSize, buttonY;
    
    
    //Return case
    if(percent > 1.0)
        return;
    
    
    //Info
    float alpha = 1.0, positionChange = 0.0;
    
    if(percent >= 0.0 && percent <= 0.2) {
        alpha -= percent * 5;
    }
    
    else {
        alpha = 0.0;
    }
    
    positionChange = height - _minHeight;
    
    //Distance Label Perform
    
    //distancePosition += height - frame_min;
    fontSize = 60.0 - (30.0 * percent);
    
    //Button Perform
    if(percent < 0.8) {
        newWidth = 256.0 - (percent * 232.5);
        newRadius = 7.0 + percent * 20;
    }
    
    else {
        newWidth = 70.0 - ((percent - 0.8) * 50.0);
        newRadius = 23.0 + ((percent - 0.8) * 35.0);
    }
    
    newHeight = 36.0 + (percent * 24.0);
    buttonY = 440.0 - (percent * 12.0);
    
    
    //---------[ Applies New Values ]---------//
    
    //Button
    //CGPoint buttonCenter = [[self startButton] center];
    CGRect frame = [[self startButton] frame];
    
    frame.size.width = newWidth;
    frame.size.height = newHeight;
    frame.origin.y = buttonY;
    
    [[self startButton] setFrame:frame];
    //[[self startButton] setCenter:buttonCenter];
    [[self startButton] layer].cornerRadius = newRadius;

    
    //Distance label
    [[self distanceLabel] setFont:[UIFont fontWithName:@"Lato-Regular" size:fontSize]];
    
    frame = [[self distanceLabel] frame];
    frame.origin.y = distanceY + positionChange;
    [[self distanceLabel] setFrame:frame];
    
    CGPoint center = [self distanceLabel].center;
    
    if(center.y > centerY) {
        center.y = centerY;
        [[self distanceLabel] setCenter:center];
    }
    
    
    //Time Label
    //[[self timeLabel] setFont:[UIFont fontWithName:@"Lato-Regular" size:timeFont]];
    
    if(percent < 0.4) {
        
        [[self timeLabel] setFont:[UIFont fontWithName:@"Lato-Regular" size:20.0]];
        
        frame = [[self timeLabel] frame];
        frame.origin.x = 116.0;
        frame.origin.y = labelY + positionChange;
        [[self timeLabel] setFrame:frame];
        [[self timeLabel] setAlpha:alpha];
    }
    
    else {
        
        frame = [[self timeLabel] frame];
        frame.origin.x = 220.0;

        [[self timeLabel] setFont:[UIFont fontWithName:@"Lato-Regular" size:22.0]];
        
        [[self timeLabel] setFrame:frame];
        
        center = [[self timeLabel] center];
        center.y = centerY;
        
        [[self timeLabel] setCenter:center];
        [[self timeLabel] setAlpha:((percent * 10) - 4.0)];
        
    }
    
    //Expand Button
    frame = [[self expandButton] frame];
    frame.origin.y = expandButton + positionChange;
    [[self expandButton] setFrame:frame];
    
    //Others labels and icons
    frame = [[self timeIcon] frame];
    frame.origin.y = iconY + positionChange;
    [[self timeIcon] setFrame:frame];
    [[self timeIcon] setAlpha:alpha];
    
    frame = [[self bpsIcon] frame];
    frame.origin.y = iconY + positionChange;
    [[self bpsIcon] setFrame:frame];
    [[self bpsIcon] setAlpha:alpha];
    
    frame = [[self bpsLabel] frame];
    frame.origin.y = labelY + positionChange;
    [[self bpsLabel] setFrame:frame];
    [[self bpsLabel] setAlpha:alpha];
    
    frame = [[self speedLabel] frame];
    frame.origin.y = labelY + positionChange;
    [[self speedLabel] setFrame:frame];
    [[self speedLabel] setAlpha:alpha];
    
    frame = [[self speedIcon] frame];
    frame.origin.y = iconY + positionChange;
    [[self speedIcon] setFrame:frame];
    [[self speedIcon] setAlpha:alpha];
    
    
}

-(IBAction)fullAnimateTo {
    if([self mapViewExpanded]) {
        [UIView animateWithDuration:0.4 animations:^{
            CGRect frame = [[self mapRunningView] frame];
            frame.size.height = _minHeight;
            [[self mapRunningView] setFrame:frame];
            [self updateButtunsForm];
        }];
    }
    
    else {
        [UIView animateWithDuration:0.4 animations:^{
            CGRect frame = [[self mapRunningView] frame];
            frame.size.height = _maxHeight;
            [[self mapRunningView] setFrame:frame];
            [self updateButtunsForm];
        }];
    }
}


@end
