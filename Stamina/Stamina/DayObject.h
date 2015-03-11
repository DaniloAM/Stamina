//
//  DayObject.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 16/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//
//---------------------------------------------------------------------//
//
//  DayObject class for calendar.
//
//---------------------------------------------------------------------//
//

#import <Foundation/Foundation.h>

@interface DayObject : NSObject

@property NSDate *date;
@property NSDate *dateDone;
@property NSNumber *doneState;
@property NSNumber *hasTraining;
@property NSString *trainingName;

@end
