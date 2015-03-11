//
//  CreateTrainTemp.h
//  Stamina
//
//  Created by JOAO LUCAS BISCAIA SISANOSKI on 24/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CreateTrainTemp : NSObject
+(CreateTrainTemp *)sharedStore;
@property NSMutableArray *arrayOfExercises;
@property NSMutableArray *exercise;
@end
