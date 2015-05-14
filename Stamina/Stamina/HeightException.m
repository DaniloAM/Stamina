//
//  HeightException.m
//  Stamina
//
//  Created by Joao Sisanoski on 5/13/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "HeightException.h"

@implementation HeightException
+ (NSException *)initWithReason:(NSString *)reason{
    
    return [super exceptionWithName:NSLocalizedString(@"HeightInvalid", nil) reason:reason userInfo:nil];
    
}
@end
