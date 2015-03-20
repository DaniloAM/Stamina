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
#define frame_max 410.0
#define frame_min 225.0

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
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [super hideBarWithAnimation:true];
    
    [self barBlock];
    [self removeGesture];
    [self backViewBlock];
    
    
    if(![CMMotionActivityManager isActivityAvailable]) {
        [[self speedLabel] setHidden:true];
        [[self speedIcon] setHidden:true];
    }
    
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if (status == ReachableViaWWAN) {
        [self setUpdatingIsPossible:true];
        [[self locationManager] startUpdatingLocation];
        [[self mapRunningView] setShowsUserLocation:true];
    }
    else if (status == ReachableViaWiFi)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Conexão" message:@"A conexão wi-fi não permite o uso do mapa. Habilite os dados móveis para uso do mapa." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        alertView.tag = 3;
        
        [alertView show];
    }
    
    if(status == NotReachable)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Conexão" message:@"Sem conexão com a internet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        alertView.tag = 2;
        
        [alertView show];
    }
    
    
    [reachability stopNotifier];

    
    //[[self locationManager] startUpdatingLocation];
    //[[self mapRunningView] setShowsUserLocation:true];

    
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
        [[self speedLabel] setText:[NSString stringWithFormat:@"%.01f Km/h", ([newLocation speed] * 3.6)]];
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
    
    [[self timeLabel] setText:[NSString stringWithFormat:@"%d:%02d:%02d", (_minutes / 60), (_minutes % 60), _seconds]];
    
}


-(void)updateTextInDistanceLabel {
    
    if(_distanceInMeters >= 1000.0f) {
        [[self distanceLabel] setText:[NSString stringWithFormat:@"%.01f Km", _distanceInMeters / 1000]];
    }
    
    else {
        [[self distanceLabel] setText:[NSString stringWithFormat:@"%d m", (int) _distanceInMeters]];
    }
    
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
        
        [sender setTitle:@"Terminar" forState:UIControlStateNormal];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startReloadingUserPosition) userInfo:nil repeats:true];
        
        [self setIsRunning:true];
    }
    
    
    else {
        
        //[sender setTitle:@"Iniciar" forState:UIControlStateNormal];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Parar" message:@"Deseja parar a corrida?" delegate:self cancelButtonTitle:@"Não" otherButtonTitles:@"Sim", nil];
        
        alertView.tag = 1;
        
        [alertView show];
        
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag > 1) {
        [self.navigationController popViewControllerAnimated:true];
    }
    
    if (buttonIndex == 0) {
        return;
    }
    if (buttonIndex == 1) {
        [self finishRunning];
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

-(void)back {
    [self.navigationController popViewControllerAnimated:true];
    
}

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
        
        if([[self mapRunningView] frame].size.height >= frame_max) {
            
            frame.size.height = frame_max;
        }
        
        else {
            
            frame.size.height += touchPoint.y - [self height];
            
        }
        
        [[self mapRunningView]setFrame:frame];
    }
    
    else if(touchPoint.y < [self height]) {
        
        if([[self mapRunningView] frame].size.height <= frame_min) {
            
            frame.size.height = frame_min;
        }
        
        else {
            
            frame.size.height -= [self height] - touchPoint.y;
        }
        
        [[self mapRunningView]setFrame:frame];
    }
    
    if(frame.size.height > frame_max) {
        frame.size.height = frame_max;
        [[self mapRunningView] setFrame:frame];
    }
    
    else if(frame.size.height < frame_min) {
        frame.size.height = frame_min;
        [[self mapRunningView] setFrame:frame];
    }
    
    
    [self setHeight:touchPoint.y];
    [self updateButtunsForm];
    
}

-(void)updateButtunsForm {
    
    //Data for math
    float height = [[self mapRunningView] frame].size.height;
    
    float percent = (height - frame_min) / (frame_max - frame_min);
    
    float iconY = 339.0, labelY = 376.0, distanceY = 258.0, centerY = 458.0, expandButton = 208.0;
    
    
    //Check button and change image and action by flag
    if(height > frame_min + ((frame_max - frame_min) / 2)) {
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
    
    positionChange = height - frame_min;
    
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
            frame.size.height = frame_min;
            [[self mapRunningView] setFrame:frame];
            [self updateButtunsForm];
        }];
    }
    
    else {
        [UIView animateWithDuration:0.4 animations:^{
            CGRect frame = [[self mapRunningView] frame];
            frame.size.height = frame_max;
            [[self mapRunningView] setFrame:frame];
            [self updateButtunsForm];
        }];
    }
}


@end
