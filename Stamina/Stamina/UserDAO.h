//
//  UserDAO.h
//  SoundEarth
//
//  Created by Felipe Costa Nascimento on 4/14/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//
#import "User.h"

@protocol UserDAO <NSObject>

@optional
-(void)saveUser:(User*)user;
-(void)saveUser:(User*)user newPhotoURL:(NSURL*)urlPhoto;
-(void)createUser:(User*)newUser;
-(void)getUserWithEmail:(NSString*)email password:(NSString*)password;
-(void)getUserWithID:(CKRecordID*)idUser;
@end



