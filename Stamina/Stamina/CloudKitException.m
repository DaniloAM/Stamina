//
//  CloudKitException.m
//  SoundEarth
//
//  Created by Joao Sisanoski on 5/8/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import "CloudKitException.h"

@implementation CloudKitException
+ (NSString *)returnStringToError:(NSError *)error{
    NSString *exceptionName;
    switch (error.code){
        case 3:
        case 4:
            exceptionName = NSLocalizedString(@"InternetProblem", nil);
            break;
        case 6:
            exceptionName = NSLocalizedString(@"ServiceUnavailable", nil);
            break;
        case 7:
            exceptionName = NSLocalizedString(@"RequestRateLimited", nil);
            break;
        default:
            exceptionName = NSLocalizedString(@"InternalError", nil);
            break;
            
    }
    
    return exceptionName;
}
@end
