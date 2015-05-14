//
//  UserNotFoundException.m
//  SoundEarth
//
//  Created by Henrique Pereira de Lima on 16/04/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import "UserNotFoundException.h"

@implementation UserNotFoundException

+ (NSException *)initWithReason:(NSString *)reason{
    
    return [super exceptionWithName:NSLocalizedString(@"UserNotFound", nil) reason:reason userInfo:nil];
    
}

@end
