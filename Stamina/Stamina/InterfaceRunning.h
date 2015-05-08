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
#import "UIStaminaColor.h"

typedef enum  StaminaRunning{
    SRTime,
    SRHeartbeat,
    SRSpeed,
}StaminaRunning;

@interface InterfaceRunning : WKInterfaceController {
    WatchSharingData *sharing;
    BOOL labelsHidden;
    BOOL willLeave;
    NSString *timeText;
    NSString *bpsText;
    NSString *speedText;
    StaminaRunning staminaRunning;
    NSInteger dataType;
    NSInteger runningState;
}

//@property IBOutlet WKInterfaceLabel *distanceLabel;
//@property IBOutlet WKInterfaceLabel *timeLabel;
//@property IBOutlet WKInterfaceLabel *bpsLabel;


@property (weak, nonatomic) IBOutlet WKInterfaceButton *mapButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *distanceButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *infoButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *runningStatusButton;

@end