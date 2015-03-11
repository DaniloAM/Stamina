//
//  JLSlideMenu.h
//  Stamina
//
//  Created by João Lucas Sisanoski on 07/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIStaminaColor.h"
#import "UserData.h"
@interface JLSlideMenu : UIViewController
typedef enum gestureRecognizedTypes
{   LEFT,
    RIGHT,
    UP,
    DOWN,
    VERTICAL,
    HORIZONTAL,
    UNDEFINED
} GestureRecognized;
@property UIView *tabBar;
@property UIView *leftMenu;

@property UIPanGestureRecognizer *panLeft;

@property CGSize startSizeBar;
@property CGPoint firstTouch;
@property NSArray *arrayOfButtons;

@property BOOL menuOpen, stop;
@property BOOL openMenu, backView;
@property int open;
@property int recognized, direction;

@property float leftWidthSize, tabHeightSize;

@property NSArray *arrayFirstButton;
@property NSArray *secondFirstButton;
@property NSArray *thirdFirstButton;
@property NSArray *fourthFirstButton;
@property NSArray *arrayOfViewsControllers;
@property NSMutableArray *arrayOfViews;

@property NSString *str;
@property UIViewController *presenting;
@property NSArray *arrayTabBar;






-(void)showBarWithAnimation : (BOOL)animated;
-(void)hideBarWithAnimation : (BOOL)animated;
-(void)removeGesture;
-(void)addGesture;
-(void)firstButtonMethod: (void *)metodo fromClass:(UIViewController *)view  withImage: (UIImage *)image;
-(void)secondButtonMethod: (void *)metodo fromClass:(UIViewController *)view withImage: (UIImage *)image;
-(void)thirdButtonMethod: (void *)metodo  fromClass:(UIViewController *)view withImage: (UIImage *)image;
-(void)hideLeftMenuAnimated: (BOOL)animated;
-(void)cleanButtons;
-(UIViewController *)createViewWithName: (NSString *)str;
@end
