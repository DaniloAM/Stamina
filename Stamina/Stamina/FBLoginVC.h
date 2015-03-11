//
//  FBLoginVC.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 18/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <AVFoundation/AVFoundation.h>
#import "AVCamPreviewView.h"

@interface FBLoginVC : UIViewController <FBLoginViewDelegate>

@property FBLoginView *loginFB;
@property FBProfilePictureView *userPictureFB;

@property (weak, nonatomic) IBOutlet UILabel *labelLoginInfoFB;
@property (weak, nonatomic) IBOutlet UILabel *loginNameFB;
@property (weak, nonatomic) IBOutlet UILabel *labelErrorFB;

@property (weak, nonatomic) IBOutlet AVCamPreviewView *cameraView;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;

@property UIImage *userPicture;
@property UIImageView *imageView;

@property BOOL hasPicture;

@end
