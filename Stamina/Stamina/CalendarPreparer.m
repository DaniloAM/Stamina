//
//  CalendarPreparer.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 15/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "CalendarPreparer.h"

#define spacementDayLabelInX 10
#define spacementDayLabelInY 5
#define dayLabelSizeX 30
#define dayLabelSizeY 30
#define maxLines 17


@implementation CalendarPreparer


+(int)sizeInY {

    return (dayLabelSizeY + spacementDayLabelInY);
}

+(int)sizeInX {
    
    return (dayLabelSizeX + spacementDayLabelInX);
}


+(NSArray *)getCalendarScrollViewWithLabelsButtons {
    
    
    UIScrollView *calendarView = [[UIScrollView alloc] init];
    
    NSMutableArray *labelMatrix = [NSMutableArray array];
    NSMutableArray *buttonMatrix = [NSMutableArray array];
    
    
    CGSize calendarDayLabelSize = CGSizeMake(dayLabelSizeX, dayLabelSizeY);
    CGSize calendarScrollSize = CGSizeMake((calendarDayLabelSize.width * 7) + (spacementDayLabelInX * 6), maxLines * (calendarDayLabelSize.height + spacementDayLabelInY));
    
    int height = (calendarDayLabelSize.height * 6) + (spacementDayLabelInY * 5);
    
    
    [calendarView setFrame:CGRectMake(0, 0, calendarScrollSize.width, height)];
    [calendarView setContentSize:calendarScrollSize];
    
    
    
    int xPos = 0, yPos = 0, arrayIndexY = 0;
    
    for(int y = 0; y < maxLines; y++) {
        
        [labelMatrix addObject:[NSMutableArray array]];
        [buttonMatrix addObject:[NSMutableArray array]];
        
        for(int x = 0; x < 7; x++) {
            
            CGRect frame = CGRectMake(xPos, yPos, calendarDayLabelSize.width , calendarDayLabelSize.height);
            
            UILabel *label = [[UILabel alloc] initWithFrame:frame];
            UIButton *button = [[UIButton alloc]initWithFrame:frame];
            
            [label setFont:[UIFont fontWithName:@"Lato-Light" size:18.0]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setTextColor:[UIColor blackColor]];
            
            [[labelMatrix objectAtIndex:y] addObject:label];
            [[buttonMatrix objectAtIndex:y] addObject:button];
            
            [calendarView addSubview:label];
            [calendarView addSubview:button];
            
            xPos = xPos + calendarDayLabelSize.width + spacementDayLabelInX;
            
        }
        
        yPos = yPos + calendarDayLabelSize.height + spacementDayLabelInY;
        arrayIndexY++;
        xPos = 0;
    }
    
    
    /* return 3 arrays, the first with the view, the second with the labels 
     matrix and the last one with the buttons matrix  */
    return [NSArray arrayWithObjects:[NSArray arrayWithObject:calendarView], labelMatrix, buttonMatrix, nil];
    
}


+(NSArray *)getMatrixCalendarScrollInMonth: (int)month andYear : (int)year {
    
    month--;
    
    if(month < 1) {
        month = 12;
        year--;
    }
    
    //Checa os valores do mes anterior para saber seus ultimos dias
    int prevMonth, prevYear, day = 1, monthsInCalendar = 0, line = 0, position = 0, lastLine = 0;
    
    if(month == 1) {
        prevMonth = 12;
        prevYear = year - 1;
    }
    
    else {
        prevMonth = month - 1;
        prevYear = year;
    }
    
    
    //Descobre o ultimo dia do mes passado, em que dia da semana comeca o mes
    //atual e o ultimo dia do mes.
    int previousMonthDay = [CalendarMath getDaysFromMonth:prevMonth inYear:prevYear];
    int startWeekday = [CalendarMath getFirstWeekdayFromMonth:month andYear:year] - 1;
    int lastDay = [CalendarMath getDaysFromMonth:month inYear:year];
    
    previousMonthDay -= startWeekday;
    previousMonthDay++;
    
    
    
    CalendarObject *calendarObj = [CalendarObject alloc];
    
    NSMutableArray *calendar = [NSMutableArray array];
    NSMutableArray *trainings = [NSMutableArray arrayWithArray:[calendarObj getTrainingsInMonth:month andYear:year]];
    
    
    //Prepara o formato de data para salvar cada dia
    NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
    [dformat setDateFormat:@"yyyy/MM/dd - HH:mm"];
    NSString *str = @"";
    
    
    
    //Inicia a criacao dos DayObjects para cada dia dos meses
    //line é equivalente ao Y e guarda quantas linhas tem o calendario
    for(line = 0 ; ; line++) {
        
        
        //Necessary for the matrix creation
        [calendar addObject:[NSMutableArray array]];
        
        
        
        for(int x = 0; x < 7; x++) {
            
            /* Check if the you got to the next month.
               If so, sets the new lastDay and the trainings array of that month. */
            if(day > lastDay) {
                monthsInCalendar++;
                
                if(monthsInCalendar == 1) {
                    position = line;
                }
                
                day = 1;
                month++;
                
                if(month > 12) {
                    month = 1;
                    year++;
                }
                
                lastDay = [CalendarMath getDaysFromMonth:month inYear:year];
                trainings = [NSMutableArray arrayWithArray:[calendarObj getTrainingsInMonth:month andYear:year]];
                
            }
        
            
            
            
            DayObject *dayObj;
            
            //Checks if that day has training. If it has, the DayObject will be the one on the array;
            if([trainings count] > 0) {
                NSDate *trainingDate = [[trainings firstObject] date];
                NSDateComponents *comp = [[NSCalendar currentCalendar] components: NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:trainingDate];
                
                
                if((int) comp.day == day) {
                    dayObj = [trainings firstObject];
                    [trainings removeObjectAtIndex:0];
                    day++;
                }

            }
            

            
            if(!dayObj) {
                //If the dayObj is null, then it has no trainings, so it must be created a new DayObject.
                
                dayObj = [[DayObject alloc] init];
                
                
                if(line == 0 && x < startWeekday) {
                    //The last days of the month before the previous
                   
                    str = [NSString stringWithFormat:@"%04d/%02d/%02d - 12:00", prevYear, prevMonth, previousMonthDay];
                    previousMonthDay++;
                    
                }
                
                
                else {
                    //The other months
                    
                    str = [NSString stringWithFormat:@"%04d/%02d/%02d - 12:00", year, month, day];
                    day++;
                    
                }
            
                
                //Needed data of the new DayObject.
                
                NSDate *date = [dformat dateFromString:str];
                
                if (date)
                    [dayObj setDate:date];
                
            }
    
            //Add the DayObject on the array regardless if it has training or not.
            [[calendar objectAtIndex:line] addObject:dayObj];
            
        }
        
        //If all the three months and the last line has been inserted, it will end the loop.
        if(monthsInCalendar >= 3 && lastLine == 1) {
            break;
        }
        
        
        //Get ready for the last line
        else if(monthsInCalendar >= 3) {
            lastLine = 1;
        }
        
    }
    
    //The line position of the first day of the month
    [calendar addObject:[NSNumber numberWithInt:position]];
    
    return calendar;
    
}




@end
