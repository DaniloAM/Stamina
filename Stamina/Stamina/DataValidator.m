//
//  DataValidator.m
//  SoundEarth
//
//  Created by Henrique Pereira de Lima on 16/04/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import "DataValidator.h"

@implementation DataValidator


- (BOOL)isNotEmptyString:(NSString *)string{
    
    NSString *trimString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (trimString.length == 0) {
        @throw [ExceptionFactory getEmptyFieldReason:NSLocalizedString(@"EmptyNameForUser", nil)];
        
        return NO;
    }
    return YES;
}
-(void)checkStringHasNumber:(NSString *)str{
    NSScanner *scanner = [NSScanner scannerWithString:str];
    BOOL isNumeric = [scanner scanDouble:NULL] && [scanner isAtEnd];
    if(!isNumeric)
        @throw [ExceptionFactory getStringException:NSLocalizedString(@"StringError", nil)];

}
-(void)weightValidate: (NSInteger)integer{
    if(integer<30||integer>250){
        @throw [ExceptionFactory getWeightException:NSLocalizedString(@"WeightWrong", nil)];
    }
}
-(void)heightValidate: (NSInteger)integer{
    if(integer<100||integer>250){
        @throw [ExceptionFactory getHeightException:NSLocalizedString(@"HeightWrong", nil)];
    }
}
-(void)ageValidate: (NSInteger)integer{
    if(integer<12||integer>80){
        @throw [ExceptionFactory getAgeException:NSLocalizedString(@"WeightWrong", nil)];
    }
}


-(void)passwordValidate:(NSString*)password confirmPassword:(NSString*)confirmPassword limit:(int)length{
    
    if(!password.length){
        @throw [ExceptionFactory getEmptyFieldReason:NSLocalizedString(@"EmptyNameForUser", nil)];
    }else if ([self shortPasswordValidate:password limit:length]){
        @throw [ExceptionFactory getOutOfBoundsReason:NSLocalizedString(@"MinimumPasswordSize", nil)];
    }

    else if (![password isEqualToString:confirmPassword]) {
            @throw [ExceptionFactory getDivergenceReason:NSLocalizedString(@"DifferencesBetweenPasswords", nil)];
            
        }
    
}
-(NSInteger)getNumberOfDaysBetween: (NSDate *)date1 andDate: (NSDate *)date2{
    NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];
    return  secondsBetween / 86400;

}
-(void)dateDifference: (NSDate *)date1 andDate :(NSDate *)date2 isMinorOrEqualInYears: (NSInteger )integer{
    NSInteger numberOfYears =[self getNumberOfDaysBetween:date1 andDate:date2]/365;

        if(numberOfYears <= integer)
            @throw [ExceptionFactory getDateException:NSLocalizedString(@"DifferencesBetweenPasswords", nil)];

}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
-(void)emailValidate: (NSString *)email confirmEmail : (NSString *)emailConfirm{
    if(![email isEqualToString:emailConfirm] || !email.length)
        @throw [ExceptionFactory getDivergenceReason:NSLocalizedString(@"DifferencesBetweenEmails", nil)];
    if(![self validateEmail:email])
        @throw [ExceptionFactory getInvalidEmail:NSLocalizedString(@"InvalidEmail", nil)];
}

-(BOOL)shortPasswordValidate:(NSString*)password limit:(int)length{
    NSString *passTrimm = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (passTrimm.length < length){
        return true;
    }
    
    return false;
}



@end
