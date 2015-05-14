//
//  UserDAOCloudKit.h
//  SoundEarth
//
//  Created by Felipe Costa Nascimento on 4/14/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDAO.h"

@protocol UserDAODelegate <NSObject>
-(void)getUserWithPasswordFinished:(User*)user password:(NSString*)password;
-(void)saveUserFinished:(BOOL)result user:(User*)user;
-(void)getUserFinished:(User*)user;
-(void)errorThrowed:(NSError *)error;
-(void)cloudKitConnected:(BOOL)connected;
-(void)cloudKitCheckEmail:(BOOL)emailExist;
@end


@interface UserDAOCloudKit : NSObject <UserDAO>


@property (weak, nonatomic) id<UserDAODelegate> delegate;
-(void)checkCloudKitConnection;
-(void)checkEmail: (NSString *)email;
@end
