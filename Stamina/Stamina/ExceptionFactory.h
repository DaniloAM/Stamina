//
//  ExceptionFactory.h
//  SoundEarth
//
//  Created by Henrique Pereira de Lima on 16/04/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserNotFoundException.h"
#import "DivergenceException.h"
#import "EmptyFieldException.h"
#import "OutOfBoundsException.h"
#import "UnconnectedIcloud.h"
#import "CloudKitException.h"
#import "EmailInvalidException.h"
#import "WeightException.h"
#import "HeightException.h"
#import "StringInvalidException.h"
#import "AgeException.h"
#import "DateException.h"
@interface ExceptionFactory : NSObject
+ (StringInvalidException *)getStringException: (NSString *)reason;
+ (WeightException *)getWeightException: (NSString *)reason;
+ (HeightException *)getHeightException: (NSString *)reason;
+ (AgeException *)getAgeException: (NSString *)reason;
+ (OutOfBoundsException *)getOutOfBoundsReason:(NSString *)reason;
+ (EmptyFieldException *)getEmptyFieldReason:(NSString *)reason;
+ (DivergenceException *)getDivergenceReason:(NSString *)reason;
+ (UserNotFoundException *)getUserNotFoundReason:(NSString *)reason;
+ (UnconnectedIcloud *)getUnconnectedIcloudReason:(NSString *)reason;
+ (EmailInvalidException *)getInvalidEmail: (NSString *)reason;
+ (DateException *)getDateException: (NSString *)reason;
+ (NSString *)getCloudKitError: (NSError *)error;
@end
