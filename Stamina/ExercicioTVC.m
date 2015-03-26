//
//  CategoriaVC.m
//  Stamina
//
//  Created by JOAO LUCAS BISCAIA SISANOSKI on 10/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "ExercicioTVC.h"

@interface ExercicioTVC ()

@end

@implementation ExercicioTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.table.delegate = self;
    self.table.dataSource=self;
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.table setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.table];
    CreateTrainTemp *exe = [CreateTrainTemp alloc];
    if(![exe arrayOfExercises]){
        [exe setArrayOfExercises:[NSMutableArray array]];
    }
    
    //[self firstButtonMethod:@selector(function1) fromClass:self withImage:nil];
    [super hideBarWithAnimation:1];
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.4; //seconds
    lpgr.delegate = self;

    [self.table addGestureRecognizer:lpgr];
    if(_createTraining)
    [self showBarWithAnimation:YES];
    [self changeBarNameWith:[self strMuscle]];
}

-(void)firstButton{
    [self popToRoot];
}
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{   if(![self createTraining])
        return;
    CGPoint p = [gestureRecognizer locationInView:self.table];
    CreateTrainTemp *temp = [CreateTrainTemp alloc];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:p];
    if (indexPath == nil) {
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [super showBarWithAnimation:YES];
        UITableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
        Exercises *exe = [self returnExerciseWithIdentifier:cell.textLabel.text];
        
        if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
            cell.accessoryType = UITableViewCellAccessoryNone;
            [[temp arrayOfExercises]removeObject:exe];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;     
            [[temp arrayOfExercises] addObject:exe];
        }
    }else {
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.table.delegate = self;
    self.table.dataSource=self;
    [self firstButtonMethod:@selector(firstButton) fromClass:self withImage:[UIImage staminaIconHome]];
    [self secondButtonMethod:@selector(secondButton) fromClass:self withImage:[UIImage staminaIconPlus]];
    [self thirdButtonMethod:@selector(thirdButton) fromClass:self withImage:[UIImage staminaIconCancel]];
    [self barBlock];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_createTraining)
        return [[self arrayOfExercises] count]+2;
    return [[self arrayOfExercises] count];
}
-(void)thirdButton{
         [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:3] animated:YES];   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    
    
    CreateTrainTemp *te = [CreateTrainTemp alloc];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
   
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if(indexPath.row >=[[self arrayOfExercises] count])
        return cell;
    Exercises *temp =[[self arrayOfExercises] objectAtIndex:indexPath.row];
        cell.textLabel.text = [temp name];
    for (Exercises *exe in [te arrayOfExercises]) {
        if(exe == temp){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            return cell;
        }
    }
    cell.textLabel.textColor = [UIColor staminaBlackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
}
-(Exercises *)returnExerciseWithIdentifier: (NSString *)str {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exercises"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name=%@", str];
    [request setPredicate:pred];
    NSError *error;
    NSArray *obj = [context executeFetchRequest:request error:&error];

    return [obj firstObject];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row>[[self arrayOfExercises] count])
        return;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *str = cell.textLabel.text;
    Exercises *temp =[self returnExerciseWithIdentifier:str];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TipsVC *myVC=(TipsVC *)[storyboard instantiateViewControllerWithIdentifier:@"TipsVC"];
    [myVC setExercise:temp];
    [self.navigationController pushViewController:myVC animated:YES];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(_createTraining)
    [self hideBarWithAnimation:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(_createTraining)
    [self showBarWithAnimation:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:0];
    [super hideBarWithAnimation:1];
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    lpgr.delegate = self;
    [self.table addGestureRecognizer:lpgr];
    if(_createTraining)
    [self showBarWithAnimation:YES];
}
-(void)secondButton{
    AddExerciseVC *add = (AddExerciseVC *)[self returnViewWithName:@"AddExercise"];

    CreateTrainTemp *temp = [CreateTrainTemp alloc];
    if([[temp arrayOfExercises] count]==0)
        return;
    [add setArrayOfExercises:[temp arrayOfExercises]];
    
    [self callView:add];
}
@end
