//
//  DataValidator.h
//  SoundEarth
//
//  Created by Henrique Pereira de Lima on 16/04/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExceptionFactory.h"

@interface DataValidator : NSObject

- (BOOL)isNotEmptyString:(NSString *)string;
-(void)passwordValidate:(NSString*)password confirmPassword:(NSString*)confirmPassword limit:(int)length;
-(void)emailValidate: (NSString *)email confirmEmail : (NSString *)emailConfirm;
-(void)weightValidate: (NSInteger)integer;
-(void)heightValidate: (NSInteger)integer;
-(void)ageValidate: (NSInteger)integer;
-(void)checkStringHasNumber:(NSString *)str;
-(void)dateDifference: (NSDate *)date1 andDate :(NSDate *)date2 isMinorOrEqualInYears: (NSInteger )integer;
@end
