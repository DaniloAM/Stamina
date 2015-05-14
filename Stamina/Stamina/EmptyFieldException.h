//
//  EmptyFieldException.h
//  SoundEarth
//
//  Created by Henrique Pereira de Lima on 16/04/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmptyFieldException : NSException

+ (NSException *)initWithReason:(NSString *)reason;


@end
