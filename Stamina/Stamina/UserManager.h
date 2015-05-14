//
//  SignInManager.h
//  SoundEarth
//
//  Created by Felipe Costa Nascimento on 4/14/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAOFactory.h"
#import "ExceptionFactory.h"
#import "DataValidator.h"

@protocol UserManagerDelegate <NSObject>
@optional
-(void)signInResult:(BOOL)result;
-(void)signUpResult:(BOOL)result;
-(void)getUserWithIDFinished:(User*)user;
-(void)errorThrowed:(NSError *)error;
-(void)cloudKitConnected:(BOOL)connected;
-(void)cloudKitCheckEmail:(BOOL)emailExist;

@end


@interface UserManager : NSObject<UserDAODelegate>
{
    UserDAOCloudKit *model;
    DataValidator *validator;
    UserDAONSDefaults *modelDefaults;
}


@property (weak, nonatomic) id<UserManagerDelegate> delegate;
-(void)emailValidate: (NSString *)email confirmEmail : (NSString *)emailConfirm;
-(void)saveUser:(User*)user withNewPhoto:(NSURL*)photoURL;
-(void)createUser:(User*)newUser;
-(void)passwordValidate:(NSString*)password confirmPassword:(NSString*)confirmPassword;
-(void)nameValidate:(NSString*)name;
-(void)signInValidate:(NSString*)email password:(NSString*)password;
-(void)getUserWithID:(CKRecordID*)userId;
-(void)weightValidate: (NSInteger)integer;
-(void)heightValidate: (NSInteger)integer;
-(void)ageValidate: (NSInteger)integer;
-(void)checkStringHasNumber:(NSString *)str;
-(User*)getLoggedUser;
-(void)dateDifference: (NSDate *)date1 andDate :(NSDate *)date2 isMinorOrEqualInYears: (NSInteger )integer;
-(void)cloudKitStatus;
-(void)checkEmail: (NSString *)email;
@end
