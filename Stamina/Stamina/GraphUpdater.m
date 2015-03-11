//
//  GraphUpdater.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 11/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "GraphUpdater.h"

@implementation GraphUpdater

-(id)initWithGraphFrame: (CGRect)frame {
    
    self = [super init];
    
    if(self) {
        
        [self standardSettings];
        [self setGraphFrame:frame];
        
    }
    
    return self;
    
}

-(id)init {
    
    self = [super init];
    
    if(self) {
        
        [self standardSettings];
        
    }
    
    return self;
}

-(void)standardSettings {
    
    [self setIsExpanded:true];
    [self setCalendar:[NSCalendar currentCalendar]];
    [self setGraphCenterDate:[NSDate date]];
    [self setDayIncreaser:DIDaysInWeeks];
    //[self setIntervalDatesArrayWithCenterDate];
    [self setNumberInView:7];
}

//------------------------------------------------------------------------------

-(NSArray *)currentNumberArray { return nil; }

-(NSArray *)nextNumberArray { return nil; }

-(NSArray *)previousNumberArray { return nil; }

//------------------------------------------------------------------------------

-(NSArray *)currentNumberArrayWithComponents: (NSMutableArray *)array {
    
    [self setCurrentComponents:[self generateGraphicPatternWithComponents:array]];
    return [self currentComponents];
}

-(NSArray *)nextNumberArrayWithComponents: (NSMutableArray *)array {
    
    [self advanceGraphicDate];
    
    [self setNextComponents:[self generateGraphicPatternWithComponents:array]];
    
    [self regressGraphicDate];
    
    return [self nextComponents];
}

-(NSArray *)previousNumberArrayWithComponents: (NSMutableArray *)array {

    [self regressGraphicDate];
    
    [self setPreviousComponents:[self generateGraphicPatternWithComponents:array]];
    
    [self advanceGraphicDate];
    
    return [self previousComponents];
}

//------------------------------------------------------------------------------

-(void)advanceGraphicDate {
    
    [self setGraphCenterDate:[self advanceDate:[self graphCenterDate] withFormat:0]];
    
}

-(void)regressGraphicDate {
    
    [self setGraphCenterDate:[self regressDate:[self graphCenterDate] withFormat:0]];
    
}

//------------------------------------------------------------------------------

-(NSDate *)advanceDate: (NSDate *)date withFormat:(NSInteger)format  {
    
    if(!date) {
        return nil;
    }
    
    //Increase the date based on days in week views
    if([self dayIncreaser] == DIDaysInWeeks) {
        
        NSInteger increase = 60*60*24;
        NSInteger factor;
        
        if(format == 1) {
            factor = 1;
        }
        
        else {
            factor = [self numberInView] * VSDist;
        }
        
        date = [date dateByAddingTimeInterval:increase * factor];
    }
    
    
    //Increase the date based on weeks in month views
    else if([self dayIncreaser] == DIWeeksInMonths) {
        
        NSDateComponents *components;
        
        if(format == 1) {
            components = [_calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
            
            if(components.day >= 22) {
                [components setMonth:components.month + 1];
                [components setDay:1];
            }
            
            else {
                [components setDay:components.day + 7];
            }
            
            date = [_calendar dateFromComponents:components];
        }
        
        else {
            components = [[NSDateComponents alloc] init];
            [components setMonth:VSDist];
            
            date = [_calendar dateByAddingComponents:components toDate:date options:0];
        }
        
    }
    
    return date;
    
}

-(NSDate *)regressDate: (NSDate *)date withFormat:(NSInteger)format {
    
    if(!date) {
        return nil;
    }
    
    //Decrease the date based on days in week views
    if([self dayIncreaser] == DIDaysInWeeks) {
        NSInteger increase = -60*60*24;
        NSInteger factor;
        
        if(format == 1) {
            factor = 1;
        }
        
        else {
            factor = [self numberInView] * VSDist;
        }
        
        date = [date dateByAddingTimeInterval:increase * factor];
    }
    
    
    //Decrease the date based on weeks in month views
    else if([self dayIncreaser] == DIWeeksInMonths) {
        
        NSDateComponents *components;
        
        if(format == 1) {
            components = [_calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
            
            if(components.day <= 7) {
                
                NSInteger day = components.day;
                
                [components setMonth:components.month - 1];
                
                date = [_calendar dateFromComponents:components];
                components = [[NSDateComponents alloc] init];
                [components setDay:-day];
                date = [_calendar dateByAddingComponents:components toDate:date options:0];
            }
            
            else {
                [components setDay:components.day - 7];
                date = [_calendar dateFromComponents:components];
            }
            
        }
        
        else {
            components = [[NSDateComponents alloc] init];
            [components setMonth:-VSDist];
            
            date = [_calendar dateByAddingComponents:components toDate:date options:0];
        }
        
    }
    
    return date;
    
}

//------------------------------------------------------------------------------

-(NSArray *)currentBottomLabels {
    
    return [self getGraphBottomLabelByDate:[self graphCenterDate]];
}

-(NSArray *)nextBottomLabels {
    
    return [self getGraphBottomLabelByDate:[self advanceDate:[self graphCenterDate] withFormat:0]];
}

-(NSArray *)previousBottomLabels {
    
    return [self getGraphBottomLabelByDate:[self regressDate:[self graphCenterDate] withFormat:0]];
}

//------------------------------------------------------------------------------

-(NSArray *)customSubviews {
    
    return nil;
}

//------------------------------------------------------------------------------

-(void)expandGraphic {
    
    [self setIsExpanded:true];
    
    [self setDayIncreaser:DIDaysInWeeks];
    
}

-(void)contractGraphic {
    
    [self setIsExpanded:false];
    
    [self setDayIncreaser:DIWeeksInMonths];
    
    [self setGraphCenterDate:[_calendar dateBySettingUnit:NSCalendarUnitDay value:1 ofDate:[self graphCenterDate] options:0]];

}

//------------------------------------------------------------------------------



-(NSMutableArray *)generateGraphicPatternWithComponents: (NSMutableArray *)compArray{
    
    NSArray *dateArray = [self getIntervalDatesArrayWithCenterDate:[self graphCenterDate]];
    
    NSDate *initialDate = [dateArray firstObject];
    NSDate *finalDate = [dateArray lastObject];

    
    //Arrange the array by date
    NSMutableArray *graphicArray = [self arrangeComponentsArrayByDate:compArray];
    
    
    NSInteger arrayCount = [graphicArray count];

    
    //Removes the files with date that is not on the interval
    for(int x = 0; x < arrayCount; x++) {
        
        GNComponent *component = [graphicArray objectAtIndex:x];
        
        if([component GNDate]) {
            
            if([initialDate compare:[component GNDate]] == NSOrderedDescending || [finalDate compare:[component GNDate]] == NSOrderedAscending) {
                
                [graphicArray removeObjectAtIndex:x];
                
                x--;
                arrayCount--;
                
            }
        }
        
    }
    
    
    //Prepare the new array
    NSMutableArray *numberArray = [NSMutableArray array];
    
    NSDate *compDate = [NSDate dateWithTimeInterval:0 sinceDate:initialDate];
    
    for(int x = 0; x < ([self numberInView] *5) + 2; x++) {
        GNComponent *comp = [[GNComponent alloc] init];
        [comp setGraphicNumber:[NSNumber numberWithInteger:0]];
        [comp setGNDate:compDate];
        [numberArray addObject:comp];
        
        compDate = [self advanceDate:compDate withFormat:1];
    }
    
    
    //Add the values in the number array
    for(int x = 0; x < arrayCount; x++) {
        
        GNComponent *component = [graphicArray objectAtIndex:x];
        
        NSInteger index = [self getNumberArrayPositionWithInitialDate:initialDate andGNComponent:component];
        
        //Case of a serious error
        if(index < 0 || index >= [numberArray count]) {
            
            //Case of the initial reference of graphics, wich is the -1 array position
            if([self daysBetweenDate:initialDate andDate:component.GNDate] == 0 && index == -1) {
            
            }
            
            else {
            
                NSLog(@"Something went wrong and the index returned an invalid value. The method will cease for no further errors. Please check what's wrong with the indexes method (getNumberArrayPositionWithInitialDate:  andGNComponent: ).");
            
                break;
                
            }
           
        }
        
        if([self daysBetweenDate:initialDate andDate:component.GNDate] == 0 && index == -1) {
            
        }
        
        else {
        
            NSInteger newValue = component.GraphicNumber.integerValue + [[[numberArray objectAtIndex:index] GraphicNumber] integerValue];
            
            GNComponent *new = [[GNComponent alloc] init];
            [new setGraphicNumber:[NSNumber numberWithInteger:newValue]];
            [new setGNDate:component.GNDate];
            
            [numberArray replaceObjectAtIndex:index withObject:new];
            
        }

    }
    
    return [NSMutableArray arrayWithArray:numberArray];
    
}


-(NSInteger)getNumberArrayPositionWithInitialDate: (NSDate *)initialDate andGNComponent: (GNComponent *)component {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //*******************************
    //** DayIncreaser CASES below
    //*******************************
    
    if([self dayIncreaser] == DIDaysInWeeks) {
        
        return [self daysBetweenDate:initialDate andDate:component.GNDate] - 1;

    }
    
    
    else if([self dayIncreaser] == DIWeeksInMonths) {
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        
        NSInteger monthDifference = [self monthsBetweenDate:initialDate andDate:component.GNDate];
        
        [dateComponents setMonth:-monthDifference];
        
        NSDate *date = [calendar dateByAddingComponents:dateComponents toDate:component.GNDate options:0];
        
        NSInteger dayDifference = [self daysBetweenDate:initialDate andDate:date];
        
        return ((monthDifference * 4) + ((dayDifference / 7) + 1)) - 1;

    }
    
    //EXAMPLE:
    //
    //  else if([self dayIncreaser] == * NEW DayIncreaser enum value *) {
        
            //****************************************
            //**** INSERT HERE YOUR CODE TO INDEX ****
            //****************************************
        
    //  }
    
    
    
    //** Error case
    
    else return -1;
    
}


-(NSArray *)getIntervalDatesArrayWithCenterDate :(NSDate *)centerDate {
    
    NSInteger day = 60*60*24;
    NSInteger number = [self numberInView];
    
    NSDate *date, *initialDate, *finalDate;
    NSDateComponents *changeDate = [[NSDateComponents alloc] init];

    initialDate = [NSDate date];
    finalDate = [NSDate date];
    
    
    //*******************************
    //** DayIncreaser CASES below
    //*******************************
    
    if([self dayIncreaser] == DIDaysInWeeks) {
        
        //The initial date of data
        date = [centerDate dateByAddingTimeInterval:(-day * number * 2) - day];
        initialDate = [_calendar dateBySettingHour:0 minute:0 second:0 ofDate:date options:0];
        
        //The last date of data
        date = [centerDate  dateByAddingTimeInterval:day * number * 3];
        finalDate = [_calendar dateBySettingHour:23 minute:59 second:59 ofDate:date options:0];
        
    }
    
    
    else if([self dayIncreaser] == DIWeeksInMonths) {
        
        //The initial date of data
        [changeDate setMonth:-2];
        
        date = [_calendar dateByAddingComponents:changeDate toDate:centerDate  options:0];
        initialDate = [_calendar dateBySettingHour:0 minute:0 second:1 ofDate:date options:0];
        
        //The last date of data
        [changeDate setMonth:2];
        
        date = [_calendar dateByAddingComponents:changeDate toDate:centerDate  options:0];
        finalDate = [_calendar dateBySettingHour:23 minute:59 second:59 ofDate:date options:0];

    }
    
    //EXAMPLE:
    
    else if(1) {
        
        //****************************************
        //**** INSERT HERE YOUR CODE TO DATES ****
        //****************************************
    
    }
    
    return @[initialDate, finalDate];
    
}


-(NSMutableArray *)getGraphBottomLabelByDate: (NSDate *)dateFilter {
    
    NSDate *date = [self regressDate:dateFilter withFormat:0];
    
    NSMutableArray *labelArray = [NSMutableArray array];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //Create labels for the information arrayR
    if([self dayIncreaser] == DIDaysInWeeks) {
        
        for(int x = 0; x < ([self numberInView] * 5) + 2; x++) {
            
            NSDateComponents* comp = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:date];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            
            NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
            [weekday setDateFormat: @"EEE"];
            
            [label setText:[NSString stringWithFormat:@"%d\n%@", (int) comp.day, [weekday stringFromDate:date]]];
            [label setNumberOfLines:2];
            [label setTextAlignment:NSTextAlignmentCenter];
            
            [label setFont:[self labelFont]];
            
            date = [date dateByAddingTimeInterval:60*60*24];
            
            [labelArray addObject:label];
        }
        
    }
    
    
    else if([self dayIncreaser] == DIWeeksInMonths) {
        
        NSInteger count = 1;
        
        for(int x = 0; x < ([self numberInView] * 5) + 2; x++) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setFont:[UIFont fontWithName:@"Avenir" size:14.0]];
            
            switch (count) {
                    
                case 1: {
                    count++;
                    [label setText:@"01-07"];
                    break;
                }
                    
                case 2: {
                    count++;
                    [label setText:@"08-14"];
                    break;
                }
                    
                case 3: {
                    count++;
                    [label setText:@"15-21"];
                    break;
                }
                    
                case 4: {
                    count = 1;
                    
                    NSRange dayRange = [calendar rangeOfUnit:NSCalendarUnitDay
                                                      inUnit:NSCalendarUnitMonth
                                                     forDate:date];
                    
                    [label setText:[NSString stringWithFormat:@"22-%d", (int) dayRange.length]];
                    
                    NSDateComponents *changeDate = [[NSDateComponents alloc] init];
                    [changeDate setMonth:1];
                    
                    date = [_calendar dateByAddingComponents:changeDate toDate:date  options:0];
                    
                    break;
                }
                    
                default:
                    break;
            }
            
            [labelArray addObject:label];
        }
    }
    
    return labelArray;
    
}


-(NSMutableArray *)arrangeComponentsArrayByDate: (NSMutableArray *)array {
    
    [array sortUsingComparator:^NSComparisonResult(GNComponent *comp1, GNComponent *comp2) {
        
        return [comp1.GNDate compare:comp2.GNDate];
        
    }];
    
    return array;
    
}


-(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime {
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}


-(NSInteger)monthsBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime {
    
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitMonth
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference month];
}



-(void)t: (CGRect)frame {
    
}


@end
