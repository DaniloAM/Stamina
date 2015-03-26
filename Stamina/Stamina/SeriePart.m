//
//  SeriePart.m
//  Stamina
//
//  Created by Danilo Mative on 23/03/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "SeriePart.h"

@implementation SeriePart

-(id)initWithValue: (NSInteger)value andName: (NSString *)name forType: (NSInteger)type {
    
    self = [super init];
    
    if(self) {
        [self setName:name];
        [self setValue:value];
        [self setType:type];
    }
    
    return self;
}

@end
