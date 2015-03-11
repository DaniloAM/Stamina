//
//  CalendarInformationVC.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 24/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "CalendarInformationVC.h"

@interface CalendarInformationVC ()

@end

@implementation CalendarInformationVC


-(void)receiveInitialDate: (NSDate *)date {
    
    _date = date;
    
}


-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setCalendar:[[CalendarObject alloc] init]];
    
    [[self exercisesTableView] setDelegate:self];
    [[self exercisesTableView] setDataSource:self];
    [[self exercisesTableView] setRowHeight:35.0];
    
    UISwipeGestureRecognizer *gestUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextDayInformation)];
    
    UISwipeGestureRecognizer *gestDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousDayInformation)];
    
    //UISwipeGestureRecognizer *gestRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backToCalendar)];
    
    gestUp.direction = UISwipeGestureRecognizerDirectionUp;
    gestDown.direction = UISwipeGestureRecognizerDirectionDown;
    //gestRight.direction = UISwipeGestureRecognizerDirectionRight;

    [self.view addGestureRecognizer:gestUp];
    [self.view addGestureRecognizer:gestDown];
    //[self.view addGestureRecognizer:gestRight];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self removeGesture];
    [self loadDayInformation];
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //[super criaBarButton];
    [super showBarWithAnimation:YES];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self exercisesList] count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *text = [NSString stringWithFormat:@"%d. %@", (int)indexPath.row + 1, [[[self exercisesList] objectAtIndex:indexPath.row] name]];
    
    cell.textLabel.text = text;
    cell.textLabel.font = [UIFont fontWithName:@"Lato" size:20.0];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


-(void)loadDayInformation {
    
    UserData *user = [UserData alloc];
    _currentDayObject = [[self calendar] getDayObjectForDate:_date];
    
    
    //If has training, get the DayObject
    if([self currentDayObject]) {
        
        NSArray *trainingArray = [user returnTrainingWithName:_currentDayObject.trainingName];
        [self setExercisesList:[self getExerciseInfoWithTrainingExercises:trainingArray]];
        [[self trainingNameLabel] setText:_currentDayObject.trainingName];
        
        
        //Check if this training is after the today date
        NSTimeInterval time = [[self date] timeIntervalSinceNow];
        
        if(time < 0) {
            [[self restartTrainingButton] setHidden:false];
        }
        
        else {
            [[self restartTrainingButton] setHidden:true];
        }
        
    }
    
    else {
        
        [[self trainingNameLabel] setText:@""];
        [[self restartTrainingButton] setHidden:true];
        [self setExercisesList:[NSMutableArray array]];
    }
    
    
    [[self exercisesTableView] reloadData];
    
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components: NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[self date]];
    
    [[self dayLabel] setText:[NSString stringWithFormat:@"%d", (int)comp.day]];
    [[self yearLabel] setText:[NSString stringWithFormat:@"%d", (int)comp.year]];
    [[self monthLabel] setText:[CalendarMath returnMonthName:(int)comp.month]];
    
    
}


-(NSMutableArray *)getExerciseInfoWithTrainingExercises: (NSArray *)array {
    
    NSMutableArray *newArray = [NSMutableArray array];
    
    ExercisesList *list = [ExercisesList alloc];
    
    int identifier = 0;
    
    for(int x = 0; x < [array count]; x++) {
        
        identifier = [[[array objectAtIndex:x] id_exercise] intValue];
        Exercises *ex = [list returnExerciseWithIdentifier:identifier];
        
        [newArray addObject:ex];
        
    }
    
    return newArray;
    
}



-(void)nextDayInformation {
    
    _date = [[self date] dateByAddingTimeInterval:86400];
    
    [self loadDayInformation];
    
}

-(void)previousDayInformation {
    
    _date = [[self date] dateByAddingTimeInterval:-86400];
    
    [self loadDayInformation];
}


-(void)backToCalendar {
    
    UserCalendarVC *calendar = [self.navigationController.viewControllers objectAtIndex:0];
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components: NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[self date]];
    
    
    calendar.calendarMonth = (int) comp.month;
    calendar.calendarYear = (int) comp.year;
    [self popToRoot];
}






@end
