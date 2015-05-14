//
//  SignInManager.m
//  SoundEarth
//
//  Created by Felipe Costa Nascimento on 4/14/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//


#import "UserManager.h"

@implementation UserManager

-(id)init{
    self = [super init];
    
    if (self) {
        model = [DAOFactory getUserDAOCloudKit];
        model.delegate = self;
        modelDefaults = [DAOFactory getUserDAONSDefaults];
        
        
        validator = [[DataValidator alloc]init];
        
    }
    
    return self;
}

-(void)weightValidate: (NSInteger)integer{
    [validator weightValidate:integer];
}
-(void)heightValidate: (NSInteger)integer{
    [validator heightValidate:integer];
}
-(void)ageValidate: (NSInteger)integer{
    [validator ageValidate:integer];
}
-(void)checkStringHasNumber:(NSString *)str{
    [validator checkStringHasNumber:str];
}

#pragma mark - Validate Methods

-(void)nameValidate:(NSString*)name{
    
    [validator isNotEmptyString:name];
}

-(void)passwordValidate:(NSString*)password confirmPassword:(NSString*)confirmPassword{
    
    
    [validator passwordValidate:password confirmPassword:confirmPassword limit:6];
    
}
-(void)emailValidate: (NSString *)email confirmEmail : (NSString *)emailConfirm{
    [validator emailValidate:email confirmEmail:emailConfirm];
}
-(void)dateDifference: (NSDate *)date1 andDate :(NSDate *)date2 isMinorOrEqualInYears: (NSInteger )integer{
    [validator dateDifference:date1 andDate:date2 isMinorOrEqualInYears:integer];
}


#pragma mark - CRUD Method

-(void)createUser:(User*)newUser{
    [model createUser:newUser];
}


-(void)saveUser:(User*)user withNewPhoto:(NSURL*)photoURL{
    if (photoURL) {
        [model saveUser:user newPhotoURL:photoURL];
        return;
    }
    
    //VERIFICA SE HOUVE ALTERAÇÕES NOS DADOS DO USUÁRIO
    BOOL noChanges = NO;
    User *lastUserConfiguration = [self getLoggedUser];
    NSInteger x = 0;
    noChanges = [user.name isEqualToString:lastUserConfiguration.name];
    x +=noChanges;
    noChanges = [user.email isEqualToString:lastUserConfiguration.email];
    x +=noChanges;
    if (!x) {
        [model saveUser:user newPhotoURL:photoURL];
    }
}
-(void)cloudKitStatus{
    [model checkCloudKitConnection];
}
-(User*)getLoggedUser{
    return [modelDefaults getUserLogged];
}


-(void)getUserWithID:(CKRecordID*)userId{
    [model getUserWithID:userId];
}

-(void)getUserFinished:(User *)user{
    [self.delegate getUserWithIDFinished:user];
}

#pragma mark - Sign In Method

-(void)signInValidate:(NSString*)email password:(NSString*)password{
    [model getUserWithEmail:email password:password];
}
-(void)cloudKitConnected:(BOOL)connected{
    [self.delegate cloudKitConnected:connected];
}
-(void)errorThrowed:(NSError *)error{
    [self.delegate errorThrowed:error];
}

-(void)getUserWithPasswordFinished:(User *)user password:(NSString *)password{
    if (!user) {
        [self.delegate signInResult:NO];
        return;
        
    }else{
        if (![user.password isEqualToString:password]) {
            [self.delegate signInResult:NO];
            return;
        }
    }
    [modelDefaults saveUser:user];
    [self.delegate signInResult:YES];
}
-(void)checkEmail: (NSString *)email{
    [model checkEmail:email];
}
-(void)cloudKitCheckEmail:(BOOL)emailExist{
    [self.delegate cloudKitCheckEmail:emailExist];
}
-(void)saveUserFinished:(BOOL)result user:(User *)user{
    [self.delegate signUpResult:result];
    [modelDefaults saveUser:user];
}




#pragma mark - Private Methods



@end
