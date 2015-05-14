//
//  CloudKitException.h
//  SoundEarth
//
//  Created by Joao Sisanoski on 5/8/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudKitException : NSException
+ (NSString *)returnStringToError:(NSError *)error;
@end
