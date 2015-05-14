//
//  UnconnectedToIcloud.h
//  SoundEarth
//
//  Created by Felipe Costa Nascimento on 4/25/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnconnectedIcloud : NSException

+ (NSException *)initWithReason:(NSString *)reason;

@end
