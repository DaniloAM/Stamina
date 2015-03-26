//
//  SocialSharingVC.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 01/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "SocialSharingVC.h"

@interface SocialSharingVC ()

@end

@implementation SocialSharingVC

#pragma mark - View and Camera Preview



- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    [self setCameraView:[[AVCamPreviewView alloc] initWithFrame:CGRectMake(-25, 12, 370, 495)]];
    
    
    [self setPictureButton:[[UIButton alloc] initWithFrame:CGRectMake(128, 427, 63, 63)]];
    [self setCameraButton:[[UIButton alloc] initWithFrame:CGRectMake(16, 427, 63, 63)]];
    [self setBackButton:[[UIButton alloc] initWithFrame:CGRectMake(241, 427, 63, 63)]];
    
    
    [[self pictureButton] setBackgroundImage:[UIImage imageNamed:@"icone_camerar_capturar.png"] forState:UIControlStateNormal];
    [[self cameraButton] setBackgroundImage:[UIImage imageNamed:@"icone_camera_girar.png"] forState:UIControlStateNormal];
    [[self backButton] setBackgroundImage:[UIImage imageNamed:@"icone_camera_voltar.png"] forState:UIControlStateNormal];

    
    [[self pictureButton] addTarget:self action:@selector(snapStillImage:) forControlEvents:UIControlEventTouchUpInside];
    [[self cameraButton] addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    [[self backButton] addTarget:self action:@selector(returnToPreviousView) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:[self cameraView]];
    [self.view addSubview:[self pictureButton]];
    [self.view addSubview:[self backButton]];
    [self.view addSubview:[self cameraButton]];
    
    
    [self setUserPictureView:[[UIImageView alloc] initWithFrame:_cameraView.frame]];
    [self.view addSubview:[self userPictureView]];
    
    
    AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
    [self setStillImageOutput:stillImageOutput];
    
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = AVCaptureSessionPresetMedium;
    [_session addOutput:[self stillImageOutput]];
    
    
}




- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [super hideBarWithAnimation:true];
    [self barBlock];
    [[self userPictureView] setHidden:true];
    
    [self bringButtonsToFront];
    
    //----- SHOW LIVE CAMERA PREVIEW -----
    _usingFrontCamera = true;
    [self startCameraPreviewWithCamera:[self frontCamera]];
    
}


-(void)bringButtonsToFront {
    [self.view bringSubviewToFront:[self pictureButton]];
    [self.view bringSubviewToFront:[self cameraButton]];
    [self.view bringSubviewToFront:[self backButton]];
}


-(void)startCameraPreviewWithCamera: (AVCaptureDevice *)camera {
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    
    captureVideoPreviewLayer.frame = self.cameraView.bounds;
    [self.cameraView.layer addSublayer:captureVideoPreviewLayer];
    
    AVCaptureDevice *device = camera;
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        
    }
    

    for(AVCaptureDeviceInput *inputFound in _session.inputs) {
        
        [_session removeInput:inputFound];
        
    }
    
    [_session addInput:input];
    [_session startRunning];
    
    [self bringButtonsToFront];

    
}

#pragma mark - Changing Camera

-(void)changeCamera {
    
    AVCaptureDevice *device;
    
    if(_usingFrontCamera) {
        device = [self backCamera];
        _usingFrontCamera = false;
    } else {
        _usingFrontCamera = true;
        device = [self frontCamera];
    }
    
    [_session stopRunning];
    
    [self startCameraPreviewWithCamera:device];
    
}


-(AVCaptureDevice *)backCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            return device;
        }
    }
    return nil;
}


-(AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}

#pragma mark - Take Picture

- (void)snapStillImage:(id)sender  {

    if(_isOnShareMenu) {
        return;
    }
    
    //Present share view
    if(_hasPicture) {
        
        if(_routePicture) {
            [self returnToPreviousView];
        }
        
        [self presentShareMenu];
        return;
    }
    
    
    //Perfom these selectors with delays to remove any noises from still images
    [self performSelector:@selector(takePicture) withObject:nil afterDelay:0.2];
    [self performSelector:@selector(takePicture) withObject:nil afterDelay:0.3];
    
}


-(void)takePicture {
    
    // Capture a still image.
    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer) {
            
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            _userPicture = [[UIImage alloc] initWithData:imageData];
            
            
            if(_usingFrontCamera) {
                
                _userPicture = [UIImage imageWithCGImage:_userPicture.CGImage
                                                   scale:_userPicture.scale orientation: UIImageOrientationLeftMirrored];
            }
            
            
            [[self userPictureView] setImage:[self userPicture]];
        
            [[self pictureButton] setBackgroundImage:[UIImage imageNamed:@"icone_camera_ok.png"] forState:UIControlStateNormal];
            
            [[self userPictureView] setHidden:false];
            
        }
    }];
    
    _hasPicture = true;
    
}


#pragma mark - Share View


-(void)presentShareMenu {
    
    _isOnShareMenu = true;
    
    //**************************************
    // Positions maths based on wireframe  *
    //**************************************
    
    _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width / 1.179, self.view.bounds.size.height / 4.15)];
    _shareView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9];
    _shareView.layer.cornerRadius = 14;
    _shareView.layer.masksToBounds = true;
    _shareView.center = self.view.center;
    
    CGRect frame = [[self shareView] frame];
    
    frame.origin.y -= 100;
    
    [[self shareView] setFrame:frame];
    
    UIButton *facebookBtn, *instagramBtn;
    UIImageView *facebookIcon, *instagramIcon;
    

    facebookBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _shareView.frame.size.width / 5, _shareView.frame.size.width / 5)];
    instagramBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _shareView.frame.size.width / 5, _shareView.frame.size.width / 5)];
    
    facebookBtn.center = CGPointMake(_shareView.frame.size.width / 2 / 2, _shareView.frame.size.height / 2);
    instagramBtn.center = CGPointMake((_shareView.frame.size.width / 2) + facebookBtn.center.x, _shareView.frame.size.height / 2);
    
    
    facebookIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icone_facebook.png"]];
    instagramIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icone_instagram.png"]];
    
    facebookIcon.frame = facebookBtn.frame;
    facebookIcon.center = facebookBtn.center;
    
    instagramIcon.frame = instagramBtn.frame;
    instagramIcon.center = instagramBtn.center;
    
    [facebookBtn addTarget:self action:@selector(sharePictureOnFacebook) forControlEvents:UIControlEventTouchUpInside];
    [instagramBtn addTarget:self action:@selector(sharePictureOnInstagram) forControlEvents:UIControlEventTouchUpInside];
    
    
    //Add on view
    [_shareView addSubview:facebookIcon];
    [_shareView addSubview:facebookBtn];
    [_shareView addSubview:instagramIcon];
    [_shareView addSubview:instagramBtn];
    
    //Add view
    [self.view addSubview:[self shareView]];
    
}


-(void)sharePictureOnFacebook {
    
    [SharingResponse sharePictureOnFacebook:_userPicture];
    
    [self returnToCamera];
    
}


-(void)returnToCamera {
    
    _isOnShareMenu = false;
    _hasPicture = false;
    [[self userPictureView] setHidden:true];
    
    [[self shareView] removeFromSuperview];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self pictureButton] setBackgroundImage:[UIImage imageNamed:@"icone_camerar_capturar.png"] forState:UIControlStateNormal];
    
    [self returnToCamera];
    
}

-(void)returnToPreviousView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sharePictureOnInstagram {
    
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.ig"];
    [UIImagePNGRepresentation(_userPicture) writeToFile:savePath atomically:YES];
    
    CGRect rect = CGRectMake(0 ,0 , 0, 0);
    NSString  *jpgPath = [NSHomeDirectory()     stringByAppendingPathComponent:@"Documents/Test.ig"];
    NSURL *igImageHookFile = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@", jpgPath]];
    self.dic.UTI = @"com.instagram.photo";
    self.dic = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
    self.dic=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
    [self.dic presentOpenInMenuFromRect: rect    inView: self.view animated: YES ];
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://media?id=MEDIA_ID"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        [self.dic presentOpenInMenuFromRect: rect    inView: self.view animated: YES ];
    }
    else
    {
    }
    
    
}

-(UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
        [self.navigationController.navigationBar setHidden:NO];
}
//- (UIImage *)screenSnapshot {
//    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
//
//    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
//
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return image;
//}
//
//
//
//- (UIImage *)darkenImageOfScreen {
//
//    UIImage *image = [self screenSnapshot];
//    UIColor *color = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
//
//    UIGraphicsBeginImageContext(image.size);
//
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
//
//    CGContextScaleCTM(context, 1, -1);
//    CGContextTranslateCTM(context, 0, -area.size.height);
//
//    CGContextSaveGState(context);
//    CGContextClipToMask(context, area, image.CGImage);
//
//    [color set];
//    CGContextFillRect(context, area);
//
//    CGContextRestoreGState(context);
//
//    CGContextSetBlendMode(context, kCGBlendModeMultiply);
//
//    CGContextDrawImage(context, area, image.CGImage);
//
//    UIImage *darkenImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    UIGraphicsEndImageContext();
//
//    return darkenImage;
//}



@end
