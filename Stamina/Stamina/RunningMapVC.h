//
//  RunningMapVC.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 26/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreMotion/CoreMotion.h>
#import "FinishedRoute.h"
#import "UIStaminaColor.h"
#import "FinishedRunningVC.h"
#import "UnitConversion.h"
#import "WatchSharingData.h"

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
@property BOOL updatingIsPossible;
@property BOOL mapViewExpanded;

@property WatchSharingData *sharingWK;

@property SocialSharingVC *pictureViewController;

@property UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *expandButton;

@property UILabel *timeLabel;
@property IBOutlet UILabel *speedLabel;
@property IBOutlet UILabel *distanceLabel;
@property IBOutlet UILabel *bpsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *speedIcon;
@property (weak, nonatomic) IBOutlet UIImageView *timeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *bpsIcon;

@property float height;
@property float heightFactorScreen;

@property float distanceInMeters;
@property NSMutableArray *picturesArray;
@property NSMutableArray *locationsArray;
@property NSMutableArray *overlayArray;
@property int seconds, minutes;
@property NSTimer *timer;

@property float minHeight;
@property float maxHeight;
@property float heightFactor;

-(void)receiveTrajectorySelected: (TrajectoryRoute *)route;

@end
