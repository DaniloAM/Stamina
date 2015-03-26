//
//  SeriesMapVC.m
//  Stamina
//
//  Created by Danilo Mative on 25/03/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "SeriesMapVC.h"

@interface SeriesMapVC ()

@end

@implementation SeriesMapVC

#define reload 3
#define frame_max 410.0
#define frame_min 225.0

#pragma mark - Receiver

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSerieType:-1];
    
    [[self skipIcon] setHidden:true];
    [[self skipButton] setHidden:true];
    [[self valueLabel] setHidden:true];
    [[self typeButton] setHidden:true];
    [[self typeIcon] setHidden:true];
    
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
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [super hideBarWithAnimation:true];
    
    [self barBlock];
    [self removeGesture];
    [self backViewBlock];
    
    [[self serieKit] startSeries];
    
    
//    if(![CMMotionActivityManager isActivityAvailable]) {
//        [[self speedLabel] setHidden:true];
//        [[self speedIcon] setHidden:true];
//    }
    
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    Reachability *reachability = [Reachability reachabilityForInternetConnection];
//    [reachability startNotifier];
//    
//    NetworkStatus status = [reachability currentReachabilityStatus];
//    
//    if (status == ReachableViaWWAN) {
//        
//        [self setUpdatingIsPossible:true];
//        [[self locationManager] startUpdatingLocation];
//        [[self mapRunningView] setShowsUserLocation:true];
//    }
//    else if (status == ReachableViaWiFi) {
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Conexão" message:@"A conexão wi-fi não permite o uso do mapa. Desabilite o Wifi e ligue os dados móveis." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        
//        alertView.tag = 3;
//        
//        [alertView show];
//    }
//    
//    else if(status == NotReachable)
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Conexão" message:@"Sem conexão com a internet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        
//        alertView.tag = 2;
//        
//        [alertView show];
//    }
    
    
    //[reachability stopNotifier];
    
    
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
    
//    if([newLocation speed] < 0) {
//        [[self speedLabel] setText:@""];
//    }
//    
//    else {
//        [[self speedLabel] setText:[NSString stringWithFormat:@"%.01f Km/h", ([newLocation speed] * 3.6)]];
//    }
    
    [self updateTextInDistanceLabel];
    
    if([self serieType] == STypeDistance && [self isRunning]) {
        
        if(_distanceInMeters - _startDistanceInMeters >= _serieValue) {
            
            int secondsNow = _seconds + (_minutes * 60);
            int secondsStart = _startSeconds + (_startMinutes * 60);
            
            [_seriePart setResultDistance:_distanceInMeters - _startDistanceInMeters];
            [_seriePart setResultTime:secondsNow - secondsStart];
            
            [self readyToNextSerie];
            
        }
    
    }
    
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
    
    _seconds++;
    [self updateTextInTimeLabel];
    
    if(_seconds >= 60) {
        _minutes++;
        _seconds = 0;
    }
    
    if([self serieType] == STypeTime) {
        int secondsNow = _seconds + (_minutes * 60);
        int secondsStart = _startSeconds + (_startMinutes * 60);
        
        if(secondsNow - secondsStart >= _serieValue) {
            
            [_seriePart setResultDistance:_distanceInMeters - _startDistanceInMeters];
            [_seriePart setResultTime:secondsNow - secondsStart];
            
            [self readyToNextSerie];
        }
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


-(IBAction)startSeries {
    
    if(![self isRunning]) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startReloadingUserPosition) userInfo:nil repeats:true];
        
        [self setIsRunning:true];
        
        [[self startButton] setHidden:true];
        [[self skipIcon] setHidden:false];
        [[self skipButton] setHidden:false];
        [[self valueLabel] setHidden:false];
        [[self typeButton] setHidden:false];
        [[self typeIcon] setHidden:false];
        [[self valueBackground] setHidden:false];
        
        [self prepareNewSeriePart];
    }
    
}

-(void)receiveSerieKit: (SerieKit *)serieKit {
    
    [self setSerieKit:serieKit];
    [[self serieKit] setCurrentSerie:0];
    
}

-(void)readyToNextSerie {
    
    [self setSerieType:-1];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ feito", _seriePart.name] message:@"Pressione ok para ir para a proxima." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    alert.tag = 1;
    
    [alert show];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self performSelector:@selector(secondVibration) withObject:nil afterDelay:0.5];
}


-(void)secondVibration {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if(alertView.tag == 1) {
        
        if(buttonIndex == 0) {
            [self prepareNewSeriePart];
        }
        
    }
    
}

-(void)prepareNewSeriePart {
    
    _seriePart = [[self serieKit] getNextSerie];
    
    if(![self seriePart]) {
        
        //**FINISHED RUNNING**//
        [self saveHistory];
        [self performSelector:@selector(popToRoot) withObject:nil afterDelay:2.5];
        
        return;
    }
    
    NSString *str = [NSString stringWithFormat:@"%d", (int)[_seriePart value]];
    
    if([_seriePart type] == STypeTime) {
        str = [NSString stringWithFormat:@"%@ s", str];
    }
    
    else if([_seriePart type] == STypeDistance) {
        str = [NSString stringWithFormat:@"%@ m", str];
    }
    
    [[self valueLabel] setText:str];
    [self setSerieType:[_seriePart type]];
    [self setSerieValue:[_seriePart value]];
    [[self serieNameLabel] setText:[NSString stringWithFormat:@"%d.%@", (int) _serieKit.currentSerie, _seriePart.name]];
    
    _serieType = _seriePart.type;
    _startSeconds = _seconds;
    _startMinutes = _minutes;
    _startDistanceInMeters = _distanceInMeters;
    
}


-(IBAction)skipSerie {
    
    _seriePart.skipped = true;
    
    [self prepareNewSeriePart];
    
}

-(void)saveHistory {
    
    UserData *user = [UserData alloc];
    
    [user setKilometers:[user kilometers] + (_distanceInMeters / 1000)];
    
    [user setTimeInSeconds:[user timeInSeconds] + _seconds + (_minutes  * 60)];
    
    //*********** MUST PUT CALORIES AND POINTS HERE ********//
    //*********** MUST PUT CALORIES AND POINTS HERE ********//
    //*********** MUST PUT CALORIES AND POINTS HERE ********//
    
    [user saveOnUserDefaults];
    
}

-(void)back {
    [self.navigationController popViewControllerAnimated:true];
    
}


@end
