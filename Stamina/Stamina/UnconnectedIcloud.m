//
//  UnconnectedToIcloud.m
//  SoundEarth
//
//  Created by Felipe Costa Nascimento on 4/25/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import "UnconnectedIcloud.h"

@implementation UnconnectedIcloud

+ (NSException *)initWithReason:(NSString *)reason{
    
    return [super exceptionWithName:NSLocalizedString(@"UnconnectedIcloud", nil) reason:reason userInfo:nil];
    
}

@end
