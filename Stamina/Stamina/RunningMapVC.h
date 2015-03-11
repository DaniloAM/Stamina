//
//  RunningMapVC.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 26/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FinishedRoute.h"
#import "UIStaminaColor.h"
#import "FinishedRunningVC.h"

@interface RunningMapVC : HideBBVC <MKMapViewDelegate , CLLocationManagerDelegate, UIAlertViewDelegate>

@property (weak , nonatomic) IBOutlet MKMapView *mapRunningView;
@property MKPolyline *routeLine;
@property MKPolylineView *routeLineView;
@property CLLocationManager *locationManager;
@property CLLocation *oldLocation;
@property CLLocation *firstLocation;

@property BOOL userRoute;
@property BOOL isRunning;
@property BOOL userRouteIsDraw;
@property BOOL isWaitingForPicture;

@property SocialSharingVC *pictureViewController;

@property IBOutlet UILabel *timeLabel;
@property IBOutlet UILabel *speedLabel;
@property IBOutlet UILabel *distanceLabel;

@property float distanceInMeters;
@property NSMutableArray *picturesArray;
@property NSMutableArray *locationsArray;
@property NSMutableArray *overlayArray;
@property int seconds, minutes;
@property NSTimer *timer;

-(void)receiveTrajectorySelected: (TrajectoryRoute *)route;

@end
