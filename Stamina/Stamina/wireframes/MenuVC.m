//
//  MenuVC.m
//  Stamina
//
//  Created by JOAO LUCAS BISCAIA SISANOSKI on 09/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "MenuVC.h"

@interface MenuVC ()

@end

@implementation MenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
  }
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    AMSlideMenuMainViewController *mainVC = [AMSlideMenuMainViewController getInstanceForVC:self];
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    _navigationStartSize =self.navigationController.navigationBar.frame.size;
    
    height = height*167.67/1137.11;
    //
    float red = 249.0/255.0;
    float green = 216.0/255.0;
    float blue = 0.0/255.0;
    CGFloat navBarHeight = height;
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    
    //UILabel *labelText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, navBarHeight /4)];
    
    CGRect frame = CGRectMake(0.0f, 0.0f, width, navBarHeight);
    [self.navigationController.navigationBar setFrame:frame];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:1]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -35+navBarHeight /4, width, navBarHeight /4+40)];
    [label setTextAlignment:NSTextAlignmentCenter]; //to center text in the UILabel
    
    [label setFont: [UIFont fontWithName:@"Helvetica" size:12]];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, label.frame.size.width, label.frame.size.height)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    UILabel *labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(0, navBarHeight /2, width, navBarHeight/2)];
    
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width*32/885, [[UIScreen mainScreen] bounds].size.height*143/1575, [[UIScreen mainScreen] bounds].size.width*80/885, [[UIScreen mainScreen] bounds].size.height*56/1575)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
    imageView.image =[UIImage imageNamed:@"icon_menu.png"];
    [btn addSubview:imageView];
    [btn addTarget:mainVC action:@selector(openLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [label setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:1]];
    [labelTwo setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:1]];
    [btn setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:1]];
    [self.navigationController.navigationBar addSubview:label];
 [self.navigationController.navigationBar addSubview:labelTwo];
    [self.navigationController.navigationBar addSubview:btn];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    _navigationSize = self.navigationController.navigationBar.frame.size;
    _navigationIncreased.height = _navigationSize.height- _navigationStartSize.height;
    _navigationIncreased.width = _navigationSize.width- _navigationStartSize.width;
}
-(void)viewWillAppear:(BOOL)animated{
    [self viewWillAppear:animated withGesture:1];
}
-(void)disableRight{
    _right.enabled = NO;
}
-(void)enableRight{
    _right.enabled = YES;
}

-(void)viewWillAppear:(BOOL)animated withGesture: (BOOL)gesture{
    [super viewWillAppear:animated];
    [self cleanAllBtn];
    _lastDirection =-1;
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pop)];
    [right setDirection:UISwipeGestureRecognizerDirectionRight];
    _right = right;
    UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mecheu:)];
    _gesture = pangesture;

    [self cleanAllBtn];
    if(gesture){
        [self.navigationController.view addGestureRecognizer:pangesture];
    }
    else {
       
        [self.navigationController.view addGestureRecognizer:right];
    }
}
-(void)viewTouched{
    
}
-(void)cleanAllBtn{
    if(![self tab])
        [self criaBarButton];
    else {
        for (int x = 0 ; x < [[self arrayOfButtons] count];x++){
            UIButton *btn = [[self arrayOfButtons] objectAtIndex:x];
            [btn removeTarget:nil
                       action:NULL
             forControlEvents:UIControlEventAllEvents];
            [btn.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
            
        }
    }

}
-(void)hideBarWithAnimation:(BOOL)animation{
    if(animation){
        [self hideBar];
    }
    else {
        [self moveView:[self tab] withPoint:CGPointMake(0, self.startPointBar.y+self.tab.frame.size.height) withDuration:0];

    }
}
-(void)showBarWithAnimation: (BOOL)animation{
    if(animation){
        [self showBar];
    }
    else {
        [self moveView:[self tab] withPoint:CGPointMake(0, self.startPointBar.y) withDuration:0];
        
    }
}
-(void)moveView: (UIView *)bigView withPoint: (CGPoint )point withDuration: (float)duration{
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:duration];
    bigView.frame = CGRectMake(point.x, point.y, bigView.frame.size.width, bigView.frame.size.height);
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)hideBar{
    [self moveView:[self tab] withPoint:CGPointMake(0, self.startPointBar.y+self.tab.frame.size.height) withDuration:0.45];
    
}
-(void)removeGestureFromMenuVC{
    MenuVC *temp = [self.navigationController.viewControllers objectAtIndex:0];
    
    [self.navigationController.view removeGestureRecognizer:[temp gesture]];
    [self.navigationController.view addGestureRecognizer:_right];
    
}
-(void)addGestureFromMenuVC{
    MenuVC *temp = [self.navigationController.viewControllers objectAtIndex:0];
    
    [self.navigationController.view removeGestureRecognizer:[temp right]];
    [self.navigationController.view addGestureRecognizer:[temp gesture]];
    
}
-(void)buttonClean : (UIButton *)btn{
    NSArray *viewsToRemove = [btn subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    [btn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
}
-(void)firstButtonMethod: (void *)metodo{
    UIButton *btn = [[self arrayOfButtons] firstObject];
    [self buttonClean:btn];
    [btn addTarget:self action:metodo forControlEvents:UIControlEventTouchUpInside];
}
-(void)secondButtonMethod: (void *)metodo{
    UIButton *btn = [[self arrayOfButtons] objectAtIndex:1];
    [self buttonClean:btn];

    [btn addTarget:self action:metodo forControlEvents:UIControlEventTouchUpInside];
}
-(void)thirdButtonMethod: (void *)metodo{
    UIButton *btn = [[self arrayOfButtons] lastObject];
    [self buttonClean:btn];

    [btn addTarget:self action:metodo forControlEvents:UIControlEventTouchUpInside];
}
-(NSArray *)criaBarButton{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    NSMutableArray *array = [NSMutableArray array];
    [self setTab:[[UIView alloc] initWithFrame:CGRectMake(0, screenSize.height-screenSize.height*150/1332 , screenSize.width, screenSize.height*150/1332 )]];
    [[self tab] setBackgroundColor:[UIColor staminaBlackColor]];
    [self.navigationController.view addSubview:self.tab];
    [self setStartPointBar:self.tab.frame.origin];
    UISwipeGestureRecognizer *gest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideBar)];

    [gest setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.tab addGestureRecognizer:gest];
    for(int x = 0 ; x < 3; x++){
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(x*self.tab.frame.size.width/3, 0, self.tab.frame.size.width/3, self.tab.frame.size.height)];
        [self.tab addSubview:btn1];
               [btn1 setBackgroundColor:[UIColor staminaBlackColor]];
        [array addObject:btn1];
    }
    _arrayOfButtons = array;
    return array;
}
-(void)showBar{
    [self moveView:[self tab] withPoint:CGPointMake(0, self.startPointBar.y) withDuration:0.45];

}
-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)mecheu :(UIPanGestureRecognizer *)sender{
    CGPoint velocity = [sender velocityInView:self.view];
    CGPoint stopLocation = [sender locationInView:self.view];

    if (sender.state == UIGestureRecognizerStateBegan) {
        if(fabs(velocity.x) > fabs(velocity.y)){
            if(velocity.x>0){
                [self setLastDirection:0];
            }
            else {
                _lastDirection = -1;
            }

        }
        else {
                _lastDirection = 1;
            self.point = stopLocation;

        }
    }

    if (sender.state == UIGestureRecognizerStateBegan) {

    }
    if(_lastDirection==0){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    else if(_lastDirection==1&&self.tab!=nil){
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;

    CGFloat dy = stopLocation.y - self.point.y;
    CGPoint new;

    if (dy<0) {
        if (self.tab.frame.origin.y < self.startPointBar.y) {

        }
        else {
            new = self.tab.frame.origin;
            new.y = new.y +dy;
            [self.tab setFrame:CGRectMake(0, new.y, self.tab.frame.size.width, self.tab.frame.size.height)];

        }

    }
    else {
        if (self.tab.frame.origin.y >screenSize.height + self.tab.frame.size.height ) {

        }
        else {
            new = self.tab.frame.origin;
            new.y = new.y +dy;
            [self.tab setFrame:CGRectMake(0, new.y, self.tab.frame.size.width, self.tab.frame.size.height)];

        }

    }
    self.point = stopLocation;





    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.tab.frame.origin.y < screenSize.height + self.tab.frame.size.height && self.tab.frame.origin.y > self.startPointBar.y) {
            if(self.tab.frame.origin.y>self.startPointBar.y+self.tab.frame.size.height/2){
                [self hideBar];

            }
            else {
                [self showBar];
            }
        }
        _lastDirection = -1;
    }
    if (self.tab.frame.origin.y < self.startPointBar.y) {
        [self.tab setFrame:CGRectMake(0, self.startPointBar.y, self.tab.frame.size.width, self.tab.frame.size.height)];
    }
    }
}

-(void)firstButtonMethod: (void *)metodo withImage: (UIImage *)image{
    MenuVC *temp = [self.navigationController.viewControllers objectAtIndex:0];
    UIButton *btn = [[temp arrayOfButtons] firstObject];
    if(!(metodo ==nil))
        [self firstButtonMethod:metodo];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width - btn.frame.size.height*88/122-btn.frame.size.width*33/213, btn.frame.size.height*16/122, btn.frame.size.height*88/122,btn.frame.size.height*88/122)];
    [imgView  setImage:image];
    [btn.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [btn addSubview:imgView];
}
-(void)addImage :(UIImage *)image to:(UIButton *)btn{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,  btn.frame.size.height*16/122, btn.frame.size.height*88/122,btn.frame.size.height*88/122)];
    [imgView  setImage:image];
    [imgView setFrame:CGRectMake(btn.frame.size.width/2- btn.frame.size.height*88/244,  btn.frame.size.height*16/122, btn.frame.size.height*88/122,btn.frame.size.height*88/122)];
    [btn addSubview:imgView];

}
-(void)secondButtonMethod: (void *)metodo  withImage: (UIImage *)image{
    MenuVC *temp = [self.navigationController.viewControllers objectAtIndex:0];
    UIButton *btn = [[temp arrayOfButtons] objectAtIndex:1];
    if(!(metodo ==nil))
        [self secondButtonMethod:metodo];
    [btn.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self addImage:image to:btn];
}
-(void)thirdButtonMethod: (void *)metodo  withImage: (UIImage *)image{
    MenuVC *temp = [self.navigationController.viewControllers objectAtIndex:0];
    UIButton *btn = [[temp arrayOfButtons] lastObject];
    if(!(metodo ==nil))
        [self thirdButtonMethod:metodo];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width*33/213, btn.frame.size.height*16/122, btn.frame.size.height*88/122,btn.frame.size.height*88/122)];
    [imgView  setImage:image];
    [btn.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [btn addSubview:imgView];

}
@end
