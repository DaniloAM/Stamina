//
//  UserConfigurations.h
//  Stamina
//
//  Created by Danilo Mative on 15/04/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserConfigurations : NSObject


@property BOOL offlineMode;
@property int language;
@property int measureDistance;
@property int measureTemperature;
@property int measureHeight;
@property int measureWeight;
@property int alerta;
@property NSInteger timeAlarmBeforeTraining;


+(UserConfigurations *)sharedStore;
-(void)loadConfigurations;
-(void)saveConfigurations;

@end
