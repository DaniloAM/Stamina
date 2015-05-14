//
//  UserDAONSDefaults.m
//  SoundEarth
//
//  Created by Henrique Pereira de Lima on 22/04/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import "UserDAONSDefaults.h"

#define NAME @"name"
#define PASSWORD @"password"
#define EMAIL @"email"
#define COUNTRY @"country"
#define PHOTO @"photo"
#define DESCRIPTION @"DESCRIPTION"
#define IDUSER @"idUser"

@implementation UserDAONSDefaults

-(void)saveUser:(User*)user{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user.email forKey:EMAIL];
    [defaults setObject:user.name forKey:NAME];
    [defaults setObject:user.password forKey:PASSWORD];
    NSString *idUser = user.idUser.recordName;
    [defaults setObject:idUser forKey:IDUSER];
    [defaults synchronize];
}


-(User *)getUserLogged{
    User *newUser = [[User alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    newUser.name = [defaults objectForKey:NAME];
    newUser.email = [defaults objectForKey:EMAIL];
    newUser.password = [defaults objectForKey:PASSWORD];
    CKRecordID *record = [[CKRecordID alloc] initWithRecordName:[defaults objectForKey:IDUSER]];
    newUser.idUser = record;
    return newUser;
}



@end
