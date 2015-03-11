//
//  CalendarMath.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 15/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarMath : NSObject


// 2000 is the first year and its a leap year
// The first day of 2000 is a Saturday

//January - 31
//February - 28 or 29 (leap year)
//March - 31
//April - 30
//May - 31
//June - 30
//July - 31
//August - 31
//September - 30
//Octuber - 31
//November - 30
//December - 31

// 31 is months [ 1 , 3 , 5 , 7 , 8 , 10 , 12 ]
// 28 or 29 is [ 2 ]
// rest is 30

//Sunday is 1, Monday is 2 and so it goes until Saturday 7

//The first year available must be an leap year!


@property int firstYearAvailable;
@property int firstDayFromYearAvailable;

+(int)getWeekdayFromDay: (int)day month:(int)month andYear: (int)year;
+(int)getFirstWeekdayFromMonth: (int)month andYear: (int)year;
+(int)getDaysFromMonth: (int)x inYear:(int)year;
+(NSString *) returnMonthName: (int)month;


@end
