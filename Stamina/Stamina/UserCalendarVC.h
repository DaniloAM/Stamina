//
//  UserCalendarVC.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 12/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//


// X , Y
//
//Object at index Y addObject:
//

//
//   for(y = 0; y < 6; y++)
//
//       for(x = 0; x < 7; x++)
//
//
//
//        X   (0)   (1)   (2)   (3)   (4)   (5)   (6)
//             V     V     V     V     V     V     V
//             V     V     V     V     V     V     V
////////////////////////////////////////////////////////
//    Y    //     |     |     |     |     |     |     //
// (0) > > // 0,0 | 1,0 | 2,0 | 3,0 | 4,0 | 5,0 | 6,0 //
//         //-----|-----|-----|-----|-----|-----|-----//
// (1) > > // 0,1 | 1,1 | 2,1 | 3,1 | 4,1 | 5,1 | 6,1 //
//         //-----|-----|-----|-----|-----|-----|-----//
// (2) > > // 0,2 | 1,2 | 2,2 | 3,2 | 4,2 | 5,2 | 6,2 //
//         //-----|-----|-----|-----|-----|-----|-----//
// (3) > > // 0,3 | 1,3 | 2,3 | 3,3 | 4,3 | 5,3 | 6,3 //
//         //-----|-----|-----|-----|-----|-----|-----//
// (4) > > // 0,4 | 1,4 | 2,4 | 3,4 | 4,4 | 5,4 | 6,4 //
//         //-----|-----|-----|-----|-----|-----|-----//
// (5) > > // 0,5 | 1,5 | 2,5 | 3,5 | 4,5 | 5,5 | 6,5 //
//         //     |     |     |     |     |     |     //
////////////////////////////////////////////////////////

// 205 HEIGHT X3 = 615 px
//
// 270 WIDTH  X3 = 810 px


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CalendarPreparer.h"
#import "CalendarInformationVC.h"
#import "ExercisesList.h"
#import "UserData.h"
#import "Exercises.h"
#import "HideBBVC.h"

@interface UserCalendarVC : HideBBVC <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@property CalendarPreparer *preparer;
@property UIScrollView *calendarScrollView;
@property UIButton *pressedButton;
@property UITableView *infoTableView;

@property NSMutableArray *dayMatrix;
@property NSMutableArray *labelMatrix;
@property NSMutableArray *buttonMatrix;
@property NSArray *calendarMatrix;
@property NSMutableArray *exercisesArray;

@property int calendarMonth;
@property int calendarYear;
@property int locationNextMonth;

@end











