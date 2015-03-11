//
//  FBLoginVC.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 18/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "FBLoginVC.h"

@interface FBLoginVC ()

@end

@implementation FBLoginVC

- (void)viewDidLoad  {
	
    [super viewDidLoad];
    
    [self setImageView:[[UIImageView alloc]init]];
    [self setLoginFB:[[FBLoginView alloc] init]];
    [[self imageView] setFrame:_cameraView.frame];
    [[self imageView] setHidden:true];
    
    [self loginFB].center = CGPointMake(150, 100);
    
    [self setUserPictureFB:[[FBProfilePictureView alloc] initWithFrame:CGRectMake(20, 72, 70, 70)]];
    
    [[self loginFB] setDelegate:self];
    
    [self.view addSubview:[self loginFB]];
    [self.view addSubview:[self userPictureFB]];
    AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
    [self setStillImageOutput:stillImageOutput];
    

    
}


- (void)viewDidAppear:(BOOL)animated {
	
    [super viewDidAppear:animated];
    
	//----- SHOW LIVE CAMERA PREVIEW -----
	AVCaptureSession *session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetMedium;
	
    [session addOutput:[self stillImageOutput]];

	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
	
	captureVideoPreviewLayer.frame = self.cameraView.bounds;
	[self.cameraView.layer addSublayer:captureVideoPreviewLayer];
	
	AVCaptureDevice *device = [self frontCamera];
	
	NSError *error = nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!input) {
		// Handle the error appropriately.
	}
	[session addInput:input];
	
	[session startRunning];
    
    [self.view addSubview:[self imageView]];

}

- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}


-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    
    [[self userPictureFB] setProfileID:[user objectID]];
    [[self loginNameFB] setText:[user name]];
    
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    [[self labelErrorFB] setHidden:true];
    [[self labelLoginInfoFB] setText:@"Você esta logado como"];
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    [[self userPictureFB] setProfileID:nil];
    [[self labelErrorFB] setHidden:true];
    [[self loginNameFB] setText:@""];
    [[self labelLoginInfoFB] setText:@"Você não esta logado."];
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    [[self labelErrorFB] setHidden:false];
    [[self labelErrorFB] setText:@"Erro. Tente novamente"];
}

-(BOOL)checkPhotoSharingPossible {
    if ([FBDialogs canPresentShareDialogWithPhotos]) {
        
        return true;
        
    } else {
        return false;
    }
}

- (IBAction)snapStillImage:(id)sender  {
    
    if(![[self imageView] isHidden]) {
        [self sharePictureOnFB];
        return;
    }
    
    [self performSelector:@selector(takePicture) withObject:nil afterDelay:0.2];
    [self performSelector:@selector(takePicture) withObject:nil afterDelay:0.3];
    [self performSelector:@selector(changeImageView) withObject:nil afterDelay:0.4];

}


-(void)changeImageView {
    
    [[self imageView] setImage:_userPicture];
    [[self imageView] setHidden:false];
    [[self pictureButton] setTitle:@"Share" forState:UIControlStateNormal];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self imageView] setHidden:true];
    [[self pictureButton] setTitle:@"Take It" forState:UIControlStateNormal];
}

-(void)takePicture {

    // Capture a still image.
    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer)
        {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            _userPicture = [[UIImage alloc] initWithData:imageData];
            
            _userPicture = [UIImage imageWithCGImage:_userPicture.CGImage
                                               scale:_userPicture.scale orientation: UIImageOrientationLeftMirrored];
            
        }
    }];
    
}

-(void)sharePictureOnFB {
    
    if(![self checkPhotoSharingPossible]) {
        return;
    }
    
    FBPhotoParams *params = [[FBPhotoParams alloc] init];
    
    // Note that params.photos can be an array of images.  In this example
    // we only use a single image, wrapped in an array.
    params.photos = @[_userPicture];
    
    [FBDialogs presentShareDialogWithPhotoParams:params
                                     clientState:nil
                                         handler:^(FBAppCall *call,
                                                   NSDictionary *results,
                                                   NSError *error) {
                                             if (error) {
                                                 NSLog(@"Error: %@",
                                                       error.description);
                                             } else {
                                                 NSLog(@"Success!");
                                             }
                                         }];
}

@end
