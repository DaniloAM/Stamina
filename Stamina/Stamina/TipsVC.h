//
//  ViewController.h
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipsContentPVC.h"
#import "Exercises.h"
#import "AppDelegate.h"
#import "ExerciseTip.h"
#import "HideBBVC.h"
@interface TipsVC: UIViewController <UIPageViewControllerDataSource>

- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@property Exercises *exercise;
@end
