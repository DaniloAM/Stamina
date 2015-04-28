//
//  HomeInterface.h
//  Stamina
//
//  Created by Danilo Mative on 14/04/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "WatchSharingData.h"

@interface HomeInterface : WKInterfaceController {
    WatchSharingData *share;
}
@property (weak, nonatomic) IBOutlet WKInterfaceImage *staminaIcon;

@end
