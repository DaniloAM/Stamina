//
//  SeriesMapVC.h
//  Stamina
//
//  Created by Danilo Mative on 25/03/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreMotion/CoreMotion.h>
#import "FinishedRoute.h"
#import "UIStaminaColor.h"
#import "FinishedRunningVC.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SerieKit.h"

@interface SeriesMapVC : HideBBVC <MKMapViewDelegate , CLLocationManagerDelegate, UIAlertViewDelegate>

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

@property SocialSharingVC *pictureViewController;
@property SerieKit *serieKit;
@property SeriePart *seriePart;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *expandButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;

@property IBOutlet UILabel *timeLabel;
@property IBOutlet UILabel *distanceLabel;
@property IBOutlet UILabel *bpsLabel;
@property (weak, nonatomic) IBOutlet UILabel *serieNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *skipIcon;
@property (weak, nonatomic) IBOutlet UILabel *valueBackground;

@property (weak, nonatomic) IBOutlet UIImageView *speedIcon;
@property (weak, nonatomic) IBOutlet UIImageView *timeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *bpsIcon;

@property float height;
@property float distanceInMeters;

@property NSMutableArray *picturesArray;
@property NSMutableArray *locationsArray;
@property NSMutableArray *overlayArray;
@property int seconds, minutes;
@property NSTimer *timer;

//For series running
@property float startDistanceInMeters;
@property int startSeconds, startMinutes;
@property NSInteger serieType;
@property NSInteger serieValue;

-(void)receiveSerieKit: (SerieKit *)serieKit;

@end
