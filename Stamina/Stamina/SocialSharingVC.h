//
//  SocialSharingVC.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 01/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "AVCamPreviewView.h"
#import "SharingResponse.h"
#import "AppDelegate.h"
#import "HideBBVC.h"

@interface SocialSharingVC : HideBBVC  <UIDocumentInteractionControllerDelegate>


@property (nonatomic, retain) UIDocumentInteractionController *dic;
@property AVCamPreviewView *cameraView;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property AVCaptureSession *session;

@property UIButton *pictureButton;
@property UIButton *cameraButton;
@property UIButton *backButton;

@property UIImage *userPicture;
@property UIImageView *userPictureView;
@property UIView *shareView;


@property BOOL hasPicture;
@property BOOL isOnShareMenu;
@property BOOL usingFrontCamera;
@property BOOL routePicture;



@end
