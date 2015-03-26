//
//  SerieKit.h
//  Stamina
//
//  Created by Danilo Mative on 23/03/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeriePart.h"

@interface SerieKit : NSObject

@property NSMutableArray *series;
@property NSInteger currentSerie;

-(void)addSeriePart: (SeriePart *)part;
-(void)removeLastSeriePart;
-(void)startSeries;
-(SeriePart *)getNextSerie;

@end
