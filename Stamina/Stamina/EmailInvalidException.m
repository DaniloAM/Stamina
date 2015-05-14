//
//  EmailInvalidException.m
//  Stamina
//
//  Created by Joao Sisanoski on 5/12/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "EmailInvalidException.h"

@implementation EmailInvalidException
+ (NSException *)initWithReason:(NSString *)reason{
    
    return [super exceptionWithName:NSLocalizedString(@"EmailInvalid", nil) reason:reason userInfo:nil];
    
}
@end
