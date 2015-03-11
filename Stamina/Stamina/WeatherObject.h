//
//  WeatherObject.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 08/12/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherObject : NSObject
@property float tempMax;
@property float tempMin;
@property float humidade;
@property float tempAtual;
@property NSString *descricao;

@end
