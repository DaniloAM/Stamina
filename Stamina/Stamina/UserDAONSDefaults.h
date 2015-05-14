//
//  UserDAONSDefaults.h
//  SoundEarth
//
//  Created by Henrique Pereira de Lima on 22/04/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDAO.h"

@interface UserDAONSDefaults : NSObject <UserDAO>

-(User *)getUserLogged;





@end
