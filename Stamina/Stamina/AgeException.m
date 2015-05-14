//
//  AgeException.m
//  Stamina
//
//  Created by Joao Sisanoski on 5/13/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "AgeException.h"

@implementation AgeException
+ (NSException *)initWithReason:(NSString *)reason{
    
    return [super exceptionWithName:NSLocalizedString(@"AgeInvalid", nil) reason:reason userInfo:nil];
    
}
@end
