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
#import "MenuShouldOpen.h"
@interface JLSlideMenu : UIViewController <UIGestureRecognizerDelegate>
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
@property UIView *viewOpaque;
@property UIButton *btnUp;
@property UIPanGestureRecognizer *panLeft;

@property CGSize startSizeBar;
@property CGPoint firstTouch;
@property NSArray *arrayOfButtons;
//menuOpen tell me if the menu is already opened
//stop prevents to pop twice or more
//openMenu and backView is to check wich gesture we recognized first
//upBar tell me if the user have touched the allowed area
//alertBeforeOpen tell me if i've to open the menu with or without an alert
@property BOOL menuOpen, stop;
@property BOOL openMenu, backView, upBar;
@property BOOL alertBeforeOpen;
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
@property BOOL menuBlock, botBarBlock, backViewBlock;





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
