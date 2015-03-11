//
//  Traning.h
//  Stamina
//
//  Created by João Lucas Sisanoski on 23/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Traning : NSManagedObject

@property (nonatomic, retain) NSNumber * domingo;
@property (nonatomic, retain) NSNumber * quarta;
@property (nonatomic, retain) NSNumber * quinta;
@property (nonatomic, retain) NSNumber * sabado;
@property (nonatomic, retain) NSNumber * seg;
@property (nonatomic, retain) NSNumber * sexta;
@property (nonatomic, retain) NSNumber * terca;
@property (nonatomic, retain) NSString * trainingName;
@property (nonatomic, retain) NSDate * dataFinal;
@property (nonatomic, retain) NSDate * dataInicial;
@property (nonatomic, retain) NSDate * hora;

@end
