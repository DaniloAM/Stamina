//
//  ViewController.m
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "TipsVC.h"

@interface TipsVC ()

@end

@implementation TipsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Create the data model
    [self loadTips];
    
    [self loadImages];
    [self hideBarWithAnimation:1];
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PVC"];
    self.pageViewController.dataSource = self;
    
    TipsContentPVC *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    [self.navigationItem setTitle:_exercise.name];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(NSArray *)returnExerciseWithIdentifier: (int)identifier {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ExerciseTip"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"exercise_id = %d", identifier];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *obj = [context executeFetchRequest:request error:&error];
    NSMutableArray *arr = [NSMutableArray array];
    
    for(ExerciseTip *str in obj){
        [arr addObject:str.tip];
    }
    return [NSArray arrayWithArray:arr];
}
-(void)hideBarWithAnimation: (BOOL)animation{
    JLSlideMenu *temp = [self.navigationController.viewControllers objectAtIndex:0];
    [temp hideBarWithAnimation:animation];
}
-(void)loadTips{
    _pageTitles = [self returnExerciseWithIdentifier:[[[self exercise] exerciseID] intValue]];
}
-(void)loadImages{
    NSString *str;
    NSMutableArray *array = [NSMutableArray array];
    for(int x = 0 ; x < [[[self exercise] numberImages] intValue];x++){
        str = [NSString stringWithFormat:@"%@_%d.png",[self exercise].exerciseID,x];
        [array addObject:str];
    }
    _pageImages = array;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startWalkthrough:(id)sender {
    TipsContentPVC *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (TipsContentPVC *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    TipsContentPVC *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PCVC"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    pageContentViewController.exerciseName = _exercise.name;
    pageContentViewController.exe = _exercise;
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TipsContentPVC*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TipsContentPVC*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
