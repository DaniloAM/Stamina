//
//  CalendarInformationVC.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 24/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercises.h"
#import "CalendarMath.h"
#import "CalendarObject.h"
#import "ExercisesList.h"
#import "UserData.h"
#import "HideBBVC.h"
#import "UserCalendarVC.h"
@interface CalendarInformationVC : HideBBVC <UITableViewDataSource , UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *restartTrainingButton;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *trainingNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *exercisesTableView;

@property CalendarObject *calendar;
@property DayObject *currentDayObject;
@property NSMutableArray *exercisesList;
@property NSDate *date;

-(void)receiveInitialDate: (NSDate *)date;

@end
