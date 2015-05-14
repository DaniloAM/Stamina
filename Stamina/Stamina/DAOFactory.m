//
//  DAOFactory.m
//  SoundEarth
//
//  Created by Felipe Costa Nascimento on 4/14/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import "DAOFactory.h"


@implementation DAOFactory


+(UserDAOCloudKit*)getUserDAOCloudKit{
    return [[UserDAOCloudKit alloc] init];
}

+(UserDAONSDefaults*)getUserDAONSDefaults{
    return [[UserDAONSDefaults alloc]init];
}

@end
