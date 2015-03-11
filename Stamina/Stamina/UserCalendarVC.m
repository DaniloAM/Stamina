//
//  UserCalendarVC.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 12/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "UserCalendarVC.h"

@interface UserCalendarVC ()

@end

@implementation UserCalendarVC


// X , Y
//
//Object at index X addObject:
//
// if
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


-(void)loadCalendarScrollView {
    
    NSArray *array = [CalendarPreparer getCalendarScrollViewWithLabelsButtons];
    
    [self setCalendarScrollView:[[array objectAtIndex:0] firstObject]];
    
    [[self calendarScrollView] setCenter:self.view.center];
    
    CGRect frame = [[self calendarScrollView] frame];
    
    frame.origin.y -= 60;
    
    [[self calendarScrollView] setFrame:frame];
    
    [self setLabelMatrix:[array objectAtIndex:1]];
    [self setButtonMatrix:[array objectAtIndex:2]];
    
    [self.view addSubview:[self calendarScrollView]];
    [[self calendarScrollView] setScrollEnabled:false];
    
    UISwipeGestureRecognizer *gestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextMonth)];
    [gestureUp setDirection:UISwipeGestureRecognizerDirectionUp];
    
    UISwipeGestureRecognizer *gestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousMonth)];
    [gestureDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    UISwipeGestureRecognizer *gestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(returnToView)];
    [gestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    
    [self.view addGestureRecognizer:gestureRight];
    [self.view addGestureRecognizer:gestureUp];
    [self.view addGestureRecognizer:gestureDown];
    
}



-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setInfoTableView: [[UITableView alloc] initWithFrame:CGRectMake(20, 335, 271, 148)]];
    [[self infoTableView] setRowHeight:35.0];
    
    [[self infoTableView] setDelegate:self];
    [[self infoTableView] setDataSource:self];
    [[self infoTableView]setBackgroundColor:[UIColor clearColor]];
    [[self infoTableView] setSeparatorColor:[UIColor blackColor]];
    
    [self setPreparer:[[CalendarPreparer alloc] init]];
    [self setCalendarScrollView:[[UIScrollView alloc]init]];
    
    NSDate *date = [NSDate date];
    NSDateComponents *comp = [[NSCalendar currentCalendar] components: NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    _calendarMonth = (int) comp.month;
    _calendarYear = (int) comp.year;
    _locationNextMonth = -1;
    
    [self.view addSubview:[self infoTableView]];
    
    [self loadCalendarScrollView];
    
    
    //TEST-ONLY
    [self addTrainingToListExample];
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self removeGesture];
    
    [self calendarWillChangeMonth];
    
    //[self removeGestureFromMenuVC];
    [super hideBarWithAnimation:NO];
}


-(void)prepareCalendarScrollViewWithCurrentMonth {
    
    _locationNextMonth = -1;
    
    [self setCalendarMatrix:[NSArray arrayWithArray:[CalendarPreparer getMatrixCalendarScrollInMonth:_calendarMonth andYear:_calendarYear]]];
    
    CGSize calendarScrollSize = CGSizeMake(7 * [CalendarPreparer sizeInX], ([[self calendarMatrix] count] - 1) * [CalendarPreparer sizeInY]);
    [[self calendarScrollView] setContentSize:calendarScrollSize];
    
    //Set to start on the center of the content
    [[self calendarScrollView] setContentOffset:CGPointMake(0, [[[self calendarMatrix] lastObject] intValue] * [CalendarPreparer sizeInY])];
    
    
    for(int y = 0; ([[self calendarMatrix] count] - 1) > y; y++) {
        
        for(int x = 0; x < 7; x++) {
            
            UILabel *label = [[[self labelMatrix] objectAtIndex:y] objectAtIndex:x];
            UIButton *button = [[[self buttonMatrix] objectAtIndex:y] objectAtIndex:x];
            NSDate *date = [[[[self calendarMatrix] objectAtIndex:y] objectAtIndex:x] date];
            
            //remove actions of the button.
            [button removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [label setFont:[UIFont fontWithName:@"Lato-Light" size:18.0]];
            
            
            if(date) {
                NSDateComponents *comp = [[NSCalendar currentCalendar] components: NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
                [label setText:[NSString stringWithFormat:@"%d", (int) comp.day]];
                
                if(comp.month != _calendarMonth) {
                    [label setAlpha:0.3];
                    [label setTextColor:[UIColor blackColor]];
                    
                    
                    //Next or previous month button action
                    if(comp.month < _calendarMonth && comp.year == _calendarYear) {
                        [button addTarget:self action:@selector(previousMonth) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                    else if(comp.month > _calendarMonth && comp.year == _calendarYear) {
                        [button addTarget:self action:@selector(nextMonth) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                    else if(comp.year < _calendarYear) {
                        [button addTarget:self action:@selector(previousMonth) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                    else {
                        [button addTarget:self action:@selector(nextMonth) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                    
                    
                    if(_locationNextMonth == 0) {
                        _locationNextMonth = y;
                    }
                    
                }
                
                else {
                    _locationNextMonth = 0;
                    [label setAlpha:1.0];
                    
                    [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
                    [button setTag:(y * 10) + x];
                    
                    //Check if this day has training.
                    if([[[[[self calendarMatrix] objectAtIndex:y] objectAtIndex:x] hasTraining] boolValue]) {
                        
                        //This tag represents the Y and X position to get the correct training based on the DayObjects
                        //[label setTextColor:[UIColor redColor]];
                        [label setFont:[UIFont fontWithName:@"Lato" size:18.0]];
                        
                        
                    }
                    
                    else {
                        //[label setTextColor:[UIColor blackColor]];
                    }
                    
                }
            }
            
        }
        
    }
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self deselectButtons];
}



-(void)selectButton : (UIButton *)sender {
    
    BOOL secondTap = [sender isEqual:_pressedButton];
    
    if(!secondTap) {
        [self deselectButtons];
    }
    
    UserData *user = [UserData alloc];
    
    int y = (int) sender.tag / 10;
    int x = (int) sender.tag - (y * 10);
    
    UILabel *label = [[[self labelMatrix] objectAtIndex:y] objectAtIndex:x];
    
    label.textColor = [UIColor colorWithRed:249.0/255.0 green:216.0/255.0 blue:0.0 alpha:1.0];
    label.backgroundColor = [UIColor blackColor];
    label.layer.cornerRadius = label.frame.size.height / 2;
    label.layer.masksToBounds = true;
    
    if([[[[[self calendarMatrix] objectAtIndex:y] objectAtIndex:x] hasTraining] boolValue]) {
        
        
        NSString *trainingName = [[[[self calendarMatrix] objectAtIndex:y] objectAtIndex:x] trainingName];
        NSArray *trainingArray = [user returnTrainingWithName:trainingName];
        
        
        if(secondTap) {
            [self goToCalendarInformationinDate:[[[[self calendarMatrix] objectAtIndex:y] objectAtIndex:x] date]];
            
            return;
        }
        
        [self setExercisesArray:[self getExerciseInfoWithTrainingExercises:trainingArray]];
        [[self infoTableView] reloadData];
        
    }
    
    _pressedButton = sender;
    
}



-(void)deselectButtons {
    
    if(_pressedButton) {
        
        int y = (int) _pressedButton.tag / 10;
        int x = (int) _pressedButton.tag - (y * 10);
        
        UILabel *label = [[[self labelMatrix] objectAtIndex:y] objectAtIndex:x];
        
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.layer.masksToBounds = false;
        
        _pressedButton = nil;
        
    }
    
    [[self exercisesArray] removeAllObjects];
    [[self infoTableView] reloadData];
    
}



-(void)nextMonth {
    
    _calendarMonth++;
    
    if(_calendarMonth > 12) {
        
        _calendarMonth = 1;
        _calendarYear++;
        
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [[self calendarScrollView] setContentOffset:CGPointMake(0, _locationNextMonth * [CalendarPreparer sizeInY])];
    }];
    
    [self calendarWillChangeMonth];
    
}


-(void)previousMonth {
    
    _calendarMonth--;
    
    if(_calendarMonth < 1) {
        
        if(_calendarYear != 2000) {
            
            _calendarMonth = 12;
            _calendarYear--;
            
        }
        
        else {
            
            _calendarMonth = 1;
            
            return;
        }
        
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [[self calendarScrollView] setContentOffset:CGPointMake(0, 0)];
    }];
    
    [self calendarWillChangeMonth];
}


-(void)calendarWillChangeMonth {
    
    [self performSelector:@selector(prepareCalendarScrollViewWithCurrentMonth) withObject:nil afterDelay:0.2];
    [[self yearLabel] setText:[NSString stringWithFormat:@"%d", _calendarYear]];
    [[self monthLabel] setText:[CalendarMath returnMonthName:_calendarMonth]];
    [self deselectButtons];
    
}


-(NSMutableArray *)getExerciseInfoWithTrainingExercises: (NSArray *)array {
    
    NSMutableArray *newArray = [NSMutableArray array];
    
    ExercisesList *list = [ExercisesList alloc];
    
    int identifier = 0;
    
    for(int x = 0; x < [array count]; x++) {
        TrainingExercises *temp= [array objectAtIndex:x];
        NSLog(@"%@", temp.id_exercise);
        NSLog(@"%@", temp.training_name);
        
        identifier = [[[array objectAtIndex:x] id_exercise] intValue];
        Exercises *ex = [list returnExerciseWithIdentifier:identifier];
        
        [newArray addObject:ex];
        
    }
    
    return newArray;
    
}


-(void)goToCalendarInformationinDate: (NSDate *)date {
    
    [self deselectButtons];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CalendarInformationVC *view = (CalendarInformationVC *)[storyboard instantiateViewControllerWithIdentifier:@"calendarInfo"];
    
    //Receive the route to draw it
    [view receiveInitialDate:date];
    [self.navigationController pushViewController:view animated:YES];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self exercisesArray] count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *text = [NSString stringWithFormat:@"%d. %@", (int)indexPath.row + 1, [[[self exercisesArray] objectAtIndex:indexPath.row] name]];
    
    cell.textLabel.text = text;
    cell.textLabel.font = [UIFont fontWithName:@"Lato" size:20.0];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


-(void)returnToView {
    [self.navigationController popViewControllerAnimated:YES];
}


//**************************************
// Example of how to add a new training
//**************************************

-(void)addTrainingToListExample {
//    
//   // UserData *data = [UserData alloc];
//    CalendarObject *calendar = [CalendarObject alloc];
//    
//    NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
//    [dformat setDateFormat:@"yyyy/MM/dd - HH:mm"];
//    
//    
//    NSString *str = [NSString stringWithFormat:@"%04d/%02d/%02d - 12:00", 2014, 10, 15];
//    NSDate *date = [dformat dateFromString:str];
//    
//    
//    //TrainingExercises *ex;
//    
//    //Make a loop and add all exercises from training needed
//   // [data addExerciseWithTrainingExercise:ex];
//    
//    
//    //Then a second loop of schedules in dates
//    //[calendar scheduleTrainingNamed:@"Treino Chavão" inDate:date];
//    
}


@end
