//
//  WeightException.h
//  Stamina
//
//  Created by Joao Sisanoski on 5/13/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeightException : NSException
+ (NSException *)initWithReason:(NSString *)reason;

@end
