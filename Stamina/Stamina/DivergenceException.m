//
//  DivergenceException.m
//  SoundEarth
//
//  Created by Henrique Pereira de Lima on 16/04/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import "DivergenceException.h"

@implementation DivergenceException

+ (NSException *)initWithReason:(NSString *)reason{
    
    return [super exceptionWithName:NSLocalizedString(@"Divergence", nil) reason:reason userInfo:nil];
    
}



@end
