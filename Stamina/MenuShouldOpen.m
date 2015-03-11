//
//  MenuShouldOpen.m
//  Stamina
//
//  Created by JOAO LUCAS BISCAIA SISANOSKI on 13/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "MenuShouldOpen.h"

@implementation MenuShouldOpen
+(MenuShouldOpen *)sharedStore{
    static MenuShouldOpen *sharedStore = nil;
    if(!sharedStore){
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
    
}
+(id) allocWithZone: (struct _NSZone *) zone{
    
    return [self sharedStore];
    
}

@end
