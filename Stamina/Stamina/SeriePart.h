//
//  SeriePart.h
//  Stamina
//
//  Created by Danilo Mative on 23/03/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//
//
// Types:
//
// 0 - Time type
//
// 1 - Distance type
//

#import <Foundation/Foundation.h>

@interface SeriePart : NSObject

typedef enum SerieType{
    STypeTime,
    STypeDistance
}SerieType;

@property SerieType serieType;

@property NSInteger type;
@property NSInteger value;
@property NSString *name;
@property NSInteger resultDistance;
@property NSInteger resultTime;
@property BOOL skipped;

-(id)initWithValue: (NSInteger)value andName: (NSString *)name forType: (NSInteger)type;

@end
