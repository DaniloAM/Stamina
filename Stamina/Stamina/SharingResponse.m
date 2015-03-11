//
//  SharingResponse.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 08/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "SharingResponse.h"

@implementation SharingResponse

+(void)sharePictureOnFacebook: (UIImage *)image {
    
    if([FBDialogs canPresentShareDialogWithPhotos]) {
        
        
        
        FBPhotoParams *params = [[FBPhotoParams alloc] init];
        params.photos = @[image];
        
        
        [FBDialogs presentShareDialogWithPhotoParams:params
                                         clientState:nil
                                             handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                 if (error) {
                                                     NSLog(@"Error: %@", error.description);
                                                 } else {
                                                     NSLog(@"Success!");
                                                 }
                                             }];
        
    }
    
    else {
        //The user doesn't have the Facebook for iOS app installed, so we can't present the Share Dialog
        
    }
    
}



@end
