//
//  InterfaceRunning.h
//  Stamina
//
//  Created by Danilo Mative on 15/04/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "WatchSharingData.h"
#import "UnitConversion.h"

@interface InterfaceRunning : WKInterfaceController {
    WatchSharingData *sharing;
    BOOL labelsHidden;
    BOOL willLeave;
}

@property IBOutlet WKInterfaceLabel *distanceLabel;
@property IBOutlet WKInterfaceLabel *timeLabel;
@property IBOutlet WKInterfaceLabel *bpsLabel;

@end