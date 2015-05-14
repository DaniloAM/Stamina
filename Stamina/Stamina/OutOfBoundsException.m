//
//  OutOfBoundsException.m
//  SoundEarth
//
//  Created by Henrique Pereira de Lima on 16/04/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import "OutOfBoundsException.h"

@implementation OutOfBoundsException


+ (NSException *)initWithReason:(NSString *)reason{
    
    return [super exceptionWithName:NSLocalizedString(@"OutOfBounds",nil) reason:reason userInfo:nil];
    
}



@end
