//
//  TrainingDayObject.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 17/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//
//---------------------------------------------------------------------//
//
//  TrainingDayObject class for entity in CoreData.
//
//---------------------------------------------------------------------//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TrainingDayObject : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * dateDone;
@property (nonatomic, retain) NSNumber * doneState;
@property (nonatomic, retain) NSNumber * hasTraining;
@property (nonatomic, retain) NSString * trainingName;
@property (nonatomic, retain) NSNumber * validDay;
@property (nonatomic, retain) NSNumber * wasDone;
@property (nonatomic, retain) NSNumber * weekdayNumber;

@end
