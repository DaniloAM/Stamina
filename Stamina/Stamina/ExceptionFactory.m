//
//  ExceptionFactory.m
//  SoundEarth
//
//  Created by Henrique Pereira de Lima on 16/04/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import "ExceptionFactory.h"


@implementation ExceptionFactory
+ (DateException *)getDateException: (NSString *)reason{
    return (DateException *) [DateException initWithReason:reason];
}
+ (StringInvalidException *)getStringException: (NSString *)reason{
    return (StringInvalidException *) [StringInvalidException initWithReason:reason];
}
+ (WeightException *)getWeightException: (NSString *)reason{
    return (WeightException *) [WeightException initWithReason:reason];
    
}
+ (HeightException *)getHeightException: (NSString *)reason{
    return (HeightException *) [HeightException initWithReason:reason];
    
}
+ (AgeException *)getAgeException: (NSString *)reason{
    return (AgeException *) [AgeException initWithReason:reason];
    
}
+ (OutOfBoundsException *)getOutOfBoundsReason:(NSString *)reason{
    return (OutOfBoundsException *) [OutOfBoundsException initWithReason:reason];
    
}

+ (EmptyFieldException *)getEmptyFieldReason:(NSString *)reason{
    return (EmptyFieldException *) [EmptyFieldException initWithReason:reason];
    
}

+ (DivergenceException *)getDivergenceReason:(NSString *)reason{
    return (DivergenceException *) [DivergenceException initWithReason:reason];
    
}

+ (UserNotFoundException *)getUserNotFoundReason:(NSString *)reason{
    return (UserNotFoundException *) [UserNotFoundException initWithReason:reason];
    
}

+ (UnconnectedIcloud *)getUnconnectedIcloudReason:(NSString *)reason{
    return (UnconnectedIcloud *) [UnconnectedIcloud initWithReason:reason];
    
}

+ (NSString *)getCloudKitError: (NSError *)error{
    return [CloudKitException returnStringToError:error];
}
+ (EmailInvalidException *)getInvalidEmail: (NSString *)reason{
    return (EmailInvalidException *) [EmailInvalidException initWithReason:reason];

}

@end
