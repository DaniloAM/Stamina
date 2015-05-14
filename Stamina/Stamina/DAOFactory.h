//
//  DAOFactory.h
//  SoundEarth
//
//  Created by Felipe Costa Nascimento on 4/14/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDAOCloudKit.h"
#import "UserDAONSDefaults.h"


@interface DAOFactory : NSObject


+(UserDAOCloudKit*)getUserDAOCloudKit;
+(UserDAONSDefaults*)getUserDAONSDefaults;

@end
