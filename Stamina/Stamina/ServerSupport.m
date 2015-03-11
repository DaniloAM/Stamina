//
//  ServerSupport.m
//  Stamina
//
//  Created by João Lucas Sisanoski on 10/12/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "ServerSupport.h"

@implementation ServerSupport
+ (BOOL)getConnectivity {
    return [[Reachability reachabilityWithHostName:@"google.com"] currentReachabilityStatus] != NotReachable;
}

+ (BOOL)getConnectivityViaWiFiNetwork {
    return [[Reachability reachabilityWithHostName:@"google.com"] currentReachabilityStatus] == ReachableViaWiFi;
}

+ (BOOL)getConnectivityViaCarrierDataNetwork {
    return [[Reachability reachabilityWithHostName:@"google.com"] currentReachabilityStatus] == ReachableViaWWAN;
}
@end
