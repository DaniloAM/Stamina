//
//  CreateTrainTemp.m
//  Stamina
//
//  Created by JOAO LUCAS BISCAIA SISANOSKI on 24/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "CreateTrainTemp.h"

@implementation CreateTrainTemp
+(CreateTrainTemp *)sharedStore{
    static CreateTrainTemp *sharedStore = nil;
    if(!sharedStore){
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
    
}
+(id) allocWithZone: (struct _NSZone *) zone{
    
    return [self sharedStore];
    
}

@end
