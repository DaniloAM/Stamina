//
//  CalendarMath.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 15/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "CalendarMath.h"

@implementation CalendarMath

-(id)init {
    self = [super init];
    
    if(self) {
        
        //The first year available must be an leap year!
        [self setFirstYearAvailable:2000];
        [self setFirstDayFromYearAvailable:7];
    }
    
    return self;
}


+(int)getFirstWeekdayFromDaysNeeded: (int)daysNeeded {
    int weekDay = (daysNeeded + 7) % 7;
    if(weekDay == 0) {
        weekDay = 7;
    }
    
    return weekDay;
}


+(int)getWeekdayFromDay: (int)day month:(int)month andYear: (int)year {
    int daysNeeded = [CalendarMath daysNeededForYear:year andMonth:month];
    int firstDayWeekday = [CalendarMath getFirstWeekdayFromDaysNeeded:daysNeeded];
    
    int weekDay = (firstDayWeekday + (day - 1)) % 7;
    if(weekDay == 0) {
        weekDay = 7;
    }
    
    return weekDay;
    
}


+(int)getFirstWeekdayFromMonth: (int)month andYear: (int)year {
    int days = [CalendarMath daysNeededForYear:year andMonth:month];
    return [CalendarMath getFirstWeekdayFromDaysNeeded:days];
}


+(int)daysNeededForYear: (int)year andMonth: (int)month {
    int advanceDays = 0;
    int advanceYears = year - 2000;
    
    int teste = 0;
    
    int leapYears = (advanceYears / 4) + 1;
    advanceDays += (advanceYears * 365) + leapYears;
    
    
    for(int x=1; x < month; x++) {
        advanceDays += [CalendarMath getDaysFromMonth:x inYear:year];
        teste += [CalendarMath getDaysFromMonth:x inYear:year];
    }
    
    if(((year - 2000) % 4) == 0) {
        advanceDays--;
    }
    
    return advanceDays;
}

+(int)getDaysFromMonth: (int)x inYear:(int)year {
    if(x==1||x==3||x==5||x==7||x==8||x==10||x==12) {
        return 31;
    }
    else if(x==2) {
        if(((year - 2000) % 4) == 0) {
            //Its a leap year
            return 29;
        }
        
        else return 28;
        
    }
    
    else return 30;
}

+(NSString *) returnMonthName: (int)month {
    
    switch (month) {
        case 1:
            return @"Janeiro";
            break;
        case 2:
            return @"Fevereiro";
            break;
        case 3:
            return @"Março";
            break;
        case 4:
            return @"Abril";
            break;
        case 5:
            return @"Maio";
            break;
        case 6:
            return @"Junho";
            break;
        case 7:
            return @"Julho";
            break;
        case 8:
            return @"Agosto";
            break;
        case 9:
            return @"Setembro";
            break;
        case 10:
            return @"Outubro";
            break;
        case 11:
            return @"Novembro";
            break;
        case 12:
            return @"Dezembro";
            break;
        default:
            return nil;
            break;
    }
}

+(void)checkValidYear: (int)year {
    if(year < 2000) {
        
        
        exit(EXIT_FAILURE);
    }
}

@end