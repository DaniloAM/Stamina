//
//  JLSlideMenu.m
//  Stamina
//
//  Created by João Lucas Sisanoski on 07/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "JLSlideMenu.h"
#define shadowPer 80/100
#define perOfLeftMenu 80.0/100
#define heightLeftMenu 100.0/100
#define perYStart 0/100
#define tabBarHeightPer 10.0/100
#define cellMenuHeight 11.3/100
#define cellSubMenuHeight 8.3/100
#define perMenuOpen 10.0/100.0
#define perBackView 20.0/100.0
#define perBarOpen 14.0/100.0
#define M1 0
#define M2 0
#define M3 0
#define M4 0

@interface JLSlideMenu ()

@end

@implementation JLSlideMenu
//start will/did appear and something like that
-(void)viewDidLoad{
    [super viewDidLoad];
    _str = @"Inicio";
    [self.navigationItem setTitle:@"Início"];
    if([self tabBar]==nil){
        [self createOpaqueView];
        [self createBarButton];
        [self createNavigationBar];
        [self createButtonUp];
        [self createLeftView];
        [self createPanGesture];
        [self createViewsToPresent];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideBarWithAnimation:1];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self cleanButtons];
    [self.navigationItem setLeftBarButtonItem:nil];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setHidesBackButton:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    
    [self.panLeft setEnabled:1];
    _recognized = UNDEFINED;
    _open = -1;
    [self callViewWithName:_str];
    
}
//end will/did appear and something like that
//start initializing methods
-(void)createButtonUp{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGSize tabBarSize = [self tabBar].frame.size;
    CGFloat size = 0.5*tabBarSize.height;
    _btnUp = [[UIButton alloc] initWithFrame:CGRectMake(screenSize.width/2-size/2, screenSize.height-tabBarSize.height, size, size)];

    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenSize.height-tabBarSize.height, screenSize.height-tabBarSize.height)];
    [_btnUp setBackgroundImage:[UIImage imageNamed:@"icone_up_tabbar.png"] forState:UIControlStateNormal];
    [_btnUp addSubview:view];
    [_btnUp addTarget:self action:@selector(addButtonUp) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_btnUp];
    [self.navigationController.view addSubview:_tabBar];
}
-(void)createOpaqueView{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideLeftMenuAnimated:)];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGPoint p = [self.navigationController.navigationBar frame].origin;
    CGSize navigationSize = [self.navigationController.navigationBar frame].size;
    float fatorDeCorrecao = navigationSize.height + p.y;
    _viewOpaque = [[UIView alloc] initWithFrame:CGRectMake(0, fatorDeCorrecao - screenSize.height*perYStart, screenSize.width, screenSize.height)];\
    _viewOpaque.backgroundColor = [UIColor blackColor];
    [self.navigationController.view addSubview:_viewOpaque];
    _viewOpaque.opaque=NO;
    [_viewOpaque addGestureRecognizer:tap];
}
-(void)createBarButton{
    CGSize screenSize= [[UIScreen mainScreen] bounds].size;
    [self setTabBar:[[UIView alloc] initWithFrame:CGRectMake(0, screenSize.height-screenSize.height*tabBarHeightPer , screenSize.width, screenSize.height*tabBarHeightPer )]];
    [self tabBar].backgroundColor = [UIColor staminaBlackColor];
    
    _tabHeightSize = _tabBar.frame.size.height;
    NSMutableArray *array = [NSMutableArray array];
    for(int x = 0 ; x < 3; x++){
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(x*self.tabBar.frame.size.width/3, 0, self.tabBar.frame.size.width/3, self.tabBar.frame.size.height)];
        [self.tabBar addSubview:btn1];
        [btn1 setBackgroundColor:[UIColor staminaBlackColor]];
        [array addObject:btn1];
    }
    _arrayTabBar = [NSArray arrayWithArray:array];
    
}
-(void)createLeftView{
    CGSize sizeScreen = [[UIScreen mainScreen] bounds].size;
    CGSize navigationSize = [self.navigationController.navigationBar frame].size;
    CGPoint p = [self.navigationController.navigationBar frame].origin;
    float fatorDeCorrecao = navigationSize.height + p.y;
    _leftMenu= [[UIView alloc] initWithFrame:CGRectMake(-sizeScreen.width* perOfLeftMenu , fatorDeCorrecao - sizeScreen.height*perYStart, sizeScreen.width*perOfLeftMenu, sizeScreen.height*(heightLeftMenu- perYStart)- fatorDeCorrecao)];
    _leftMenu.backgroundColor = [UIColor staminaBlackColor];
    [self.navigationController.view addSubview:_leftMenu];
    _leftWidthSize = _leftMenu.frame.size.width;
}
-(void)createPanGesture{
    _panLeft = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
    _panLeft.delegate = self;
    [self.navigationController.view addGestureRecognizer:_panLeft];
}
-(void)createNavigationBar{
    self.navigationController.navigationBar.barTintColor = [UIColor staminaYellowColor];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.navigationController.navigationBar.translucent = NO;
    float btnXStart =screenSize.width*32/885;
    float btnWidth =screenSize.width*80/885*1.5;
    float btnyStart =-20+self.navigationController.navigationBar.frame.size.height/2+btnWidth/10;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnXStart,btnyStart, btnWidth, btnWidth)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0.7*btn.frame.size.width, 0.7*btn.frame.size.height)];
    imageView.image =[UIImage imageNamed:@"icone_hamburguer.png"];
    [btn addSubview:imageView];
    [self.navigationController.navigationBar addSubview:btn];
    [btn addTarget:self action:@selector(leftMenuOpen) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBar.tintColor = [UIColor staminaYellowColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height-3, self.navigationController.navigationBar.frame.size.width,5)];
    [view setBackgroundColor:[UIColor staminaYellowColor]];
    [self.navigationController.navigationBar addSubview:view];
    UIView *statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, -100, screenSize.width, 100)];
    [statusBar setBackgroundColor:[UIColor staminaYellowColor]];
    [self.navigationController.navigationBar addSubview:statusBar];
}
//end initializing methods
//start gesture recognizers
-(void)horizontalRecognizedWithStartPoint : (CGPoint)start withCurrentPoint: (CGPoint)currentPoint{
    if(self.botBarBlock)
        return;
    if(![self upBar])
        return;
    CGSize screenSize= [[UIScreen mainScreen] bounds].size;
    float newMenuPoint = _tabBar.frame.origin.y - (start.y - currentPoint.y);
    _firstTouch = currentPoint;
    if(newMenuPoint>screenSize.height)
        return;
    if(newMenuPoint<screenSize.height-_tabHeightSize)
        return;
    [self changePositionView:_tabBar toPoint:CGPointMake(0, newMenuPoint)];
    _btnUp.alpha =1-abs(screenSize.height- newMenuPoint)/_btnUp.frame.size.height;
}
-(void)panRecognized :(UIPanGestureRecognizer *)sender{
    CGPoint velocity = [sender velocityInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self checkWhichMoviment:velocity withGesture:sender];
        _firstTouch = [sender locationInView:self.navigationController.view];
        [self.navigationController.presentingViewController.view setUserInteractionEnabled:NO];
        if(self.view.frame.size.height-_firstTouch.y>self.view.frame.size.height*perBarOpen){
            [self setUpBar:NO];
        }
        else{
            [self setUpBar:YES];
        }
        if(_firstTouch.x<self.view.frame.size.width*perMenuOpen)
            [self setOpenMenu:YES];
        
        else if(_firstTouch.x>self.view.frame.size.width*(1.0/2.0-perBackView)&&_firstTouch.x<self.view.frame.size.width*(1.0/2.0+perBackView))
            [self setBackView:YES];
        
        return;
    }
    CGPoint currentPoint = [sender locationInView:self.navigationController.view];
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        if(self.isMovingToParentViewController == YES)
            return;
        if(_recognized==UP || _recognized ==DOWN){
            if([self menuOpen])
                return;
            [self horizontalRecognizedWithStartPoint:_firstTouch withCurrentPoint:currentPoint];
        }
        else if((_recognized == LEFT || _recognized ==RIGHT )){
            _currentPoint = currentPoint;
            [self performSelectorInBackground:@selector(sideSlide:) withObject:nil];
        }
        
        return;
    }
    if(sender.state == UIGestureRecognizerStateEnded){
        _openMenu = NO;
        _backView = NO;
        _recognized =-1;
        if(_direction == VERTICAL)
            [self checkPositionLeftMenu];
        else if(_direction == HORIZONTAL){
            [self checkPositionTabBar];
            [self.navigationController.presentingViewController.view setUserInteractionEnabled:YES];
        }
        
    }
}
-(void)checkWhichMoviment: (CGPoint)velocity withGesture: (UIPanGestureRecognizer *)sender{
    if(fabs(velocity.x) > fabs(velocity.y)){
        if(velocity.x>0){
            _recognized = RIGHT;
        }
        else {
            _recognized = LEFT;
        }
        _direction =VERTICAL;
    }
    else {
        if(velocity.y>0){
            _recognized = DOWN;
        }
        else {
            _recognized = UP;
        }
        _direction =HORIZONTAL;
        
    }
}
-(void)changePositionView: (UIView *)view toPoint : (CGPoint)p{
    [self calcShadow];
    CGRect rect = [view frame];
    rect.origin.x = p.x;
    rect.origin.y = p.y;
    [view setFrame:rect];
}
-(void)calcShadow{
    
    CGRect rect = self.leftMenu.frame;
    CGFloat result = ((rect.size.width+rect.origin.x)/rect.size.width)*shadowPer;
    _viewOpaque.alpha = result;
}
-(void)sideRecognizedWithStartPoint : (CGPoint)start withCurrentPoint: (CGPoint)currentPoint{
    
    float barNewPoint = _leftMenu.frame.origin.x - (start.x - currentPoint.x);
    
    _firstTouch = currentPoint;
    if(barNewPoint>0)
        return;
    if(barNewPoint<-_leftWidthSize)
        return;
    [self changePositionView:_leftMenu toPoint:CGPointMake(barNewPoint, _leftMenu.frame.origin.y)];
    
}
-(void)checkPositionTabBar{
    CGSize screenSize= [[UIScreen mainScreen] bounds].size;
    
    float pos = _tabBar.frame.origin.y;
    if(fabs(pos)>screenSize.height -  0.5*_tabBar.frame.size.height){
        [self hideBarWithAnimation:1];
    }
    else {
        [self showBarWithAnimation:1];
        
    }
}
-(void)removeGesture{
    [self.navigationController.view removeGestureRecognizer:_panLeft];
}
-(void)addGesture{
    [self.navigationController.view addGestureRecognizer:_panLeft];
}
-(void)hideBarWithAnimation : (BOOL)animated{
    CGSize screenSize= [[UIScreen mainScreen] bounds].size;
    if(animated){
        [self moveView:_tabBar withPoint:CGPointMake(0, screenSize.height) withDuration:0.3];
        
    }
    else{
        [self moveView:_tabBar withPoint:CGPointMake(0, screenSize.height) withDuration:0];
        
    }
}
-(void)showBarWithAnimation : (BOOL)animated{
    CGSize screenSize= [[UIScreen mainScreen] bounds].size;
    [self moveView:_tabBar withPoint:CGPointMake(0, screenSize.height - _tabHeightSize) withDuration:0.3];
    
}
-(void)showLeftMenuWithAnimation: (BOOL)animated{
    [self showLeftMenuWithAnimation:animated withDuration:0.3];
    
}
-(void)showLeftMenuWithAnimation: (BOOL )animated withDuration: (float)pos{
    
    if(animated)
        [self moveView:_leftMenu withPoint:CGPointMake(0, _leftMenu.frame.origin.y) withDuration:pos];
    else
        [self moveView:_leftMenu withPoint:CGPointMake(0, _leftMenu.frame.origin.y) withDuration:0];
    [self  setMenuOpen:YES];
    [self hideBarWithAnimation:1];
    [self.view setUserInteractionEnabled:NO];
    [self calcShadow];
    //[self.navigationController.presentingViewController]
    
}
-(void)hideLeftMenuAnimated: (BOOL)animated{
    [self hideLeftMenu:animated withDuration:0.3];
}
-(void)hideLeftMenu: (BOOL )animated withDuration : (float)pos{
    
    if(animated)
        [self moveView:_leftMenu withPoint:CGPointMake(-_leftWidthSize, _leftMenu.frame.origin.y) withDuration:pos];
    else
        [self moveView:_leftMenu withPoint:CGPointMake(-_leftWidthSize, _leftMenu.frame.origin.y) withDuration:0];
    [self setMenuOpen:NO];
    [self.view setUserInteractionEnabled:YES];
    [self calcShadow];
    
}
-(void)leftMenuOpen{
    if(![self menuOpen])
        [self showLeftMenuWithAnimation:1  withDuration:0.2];
    else
        [self hideLeftMenu:1 withDuration:0.2];
}
//end show or hide bar and left menu

// start effects view
-(void)moveView: (UIView *)bigView withPoint: (CGPoint )point withDuration: (float)duration{
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:duration];
    bigView.frame = CGRectMake(point.x, point.y, bigView.frame.size.width, bigView.frame.size.height);
    [self calcShadow];
    
    [UIView commitAnimations];
}

// end effects view
-(void)checkPositionLeftMenu{
    float pos = _leftMenu.frame.origin.x;
    if(fabs(pos)<0.5*_leftMenu.frame.size.width){
        [self showLeftMenuWithAnimation:1 withDuration:pos/_leftWidthSize];
        
    }
    else {
        [self hideLeftMenu:1 withDuration:pos/_leftWidthSize];
        
    }
    
}
-(void)cleanButtons{
    for(int x = 0 ; x < [[self arrayTabBar] count];x++){
        
        UIButton *btn = [[self arrayTabBar] objectAtIndex:x];
        [self buttonClean:btn];
        
        [btn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    }
}
//start accordion and its methods
-(NSString *)returnStringToButton : (int )x{
    switch (x) {
        case 0:
            return @"    Stamina";
        case 1:
            return @"    Calendário";
        case 2:
            return @"    Trajetos";
        case 3:
            return @"    Exercícios";
        case 4:
            return @"    Compartilhar";
        case 5:
            return @"    Resultados";
            
    }
    return nil;
}
-(void *)returnSelectorToButton :(int )x{
    switch (x) {
        case 0:
            return @selector(firstButton);
        case 1:
            return @selector(secondButton);
        case 2:
            return @selector(thirdButton);
        case 3:
            return @selector(fourthButton);
        case 4:
            return @selector(fifthButton);
        case 5:
            return @selector(logout);
            
    }
    return nil;
}
-(void)logout{
    [self closeEverything];
    [self hideLeftMenuAnimated:1];
    [self hideBarWithAnimation:1];
    UserData *user = [UserData alloc];
    [user eraseData];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *myVC;
    myVC= (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    
    [self presentViewController:myVC animated:YES completion:nil];
}
-(void)openfirst{
    [self rearruma:M1 : 1 ];
    [self mostraConteudoDoArray:[self arrayFirstButton]];
    _open = 0;
    
}
-(void)opensencond{
    [self rearruma:M2 : 2];
    [self mostraConteudoDoArray:[self secondFirstButton]];
    _open = 1;
    
}
-(void)openthird{
    [self rearruma:M3 : 3];
    [self mostraConteudoDoArray:[self thirdFirstButton]];
    _open = 2;
    
}
-(void)openfourth{
    [self rearruma:M4 :4];
    [self mostraConteudoDoArray:[self fourthFirstButton]];
    _open = 3;
}
-(void)rearruma: (int )x : (int )z{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    for(int y = z; y < [[self arrayOfButtons] count];y++){
        UIButton *button = [[self arrayOfButtons] objectAtIndex:y];
        CGRect rect = button.frame;
        rect.origin.y += x*cellSubMenuHeight*screenSize.height;
        [self moveView:button withPoint:rect.origin withDuration:0.1];
        
    }
    
}
-(void)mostraConteudoDoArray: (NSArray *)array{
    for (int x = 0 ; x < [array count];x++){
        UIButton *button = [array objectAtIndex:x];
        button.alpha =0;
        [_leftMenu addSubview:button];
        
        [UIView animateWithDuration:0.15 animations:^{
            button.alpha = 1;
        }];
        
    }
}
-(void)closeEverything{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    for(int x = 0 ; x < [[self arrayOfButtons] count];x++){
        UIButton *button = [[self arrayOfButtons] objectAtIndex:x];
        CGRect rect = CGRectMake(0, x*cellMenuHeight*size.height, _leftWidthSize, cellMenuHeight*size.height);
        [self moveView:button withPoint:rect.origin withDuration:0.1];
    }
    for (int x = 0 ; x < [[self arrayFirstButton] count];x++){
        UIButton *button = [[self arrayFirstButton] objectAtIndex:x];
        [button removeFromSuperview];
    }
    for (int x = 0 ; x < [[self secondFirstButton] count];x++){
        UIButton *button = [[self secondFirstButton] objectAtIndex:x];
        [button removeFromSuperview];
    }
    for (int x = 0 ; x < [[self thirdFirstButton] count];x++){
        UIButton *button = [[self thirdFirstButton] objectAtIndex:x];
        [button removeFromSuperview];
    }
    for (int x = 0 ; x < [[self fourthFirstButton] count];x++){
        UIButton *button = [[self fourthFirstButton] objectAtIndex:x];
        [button removeFromSuperview];
    }
}
-(void)close : (int )x{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    _open = -1;
    for(int x = 0 ; x < [[self arrayOfButtons] count];x++){
        UIButton *button = [[self arrayOfButtons] objectAtIndex:x];
        CGRect rect = CGRectMake(0, x*cellMenuHeight*size.height, _leftWidthSize, cellMenuHeight*size.height);
        [self moveView:button withPoint:rect.origin withDuration:0.1];
    }
    switch (x) {
        case 0:
            for (int x = 0 ; x < [[self arrayFirstButton] count];x++){
                UIButton *button = [[self arrayFirstButton] objectAtIndex:x];
                [button removeFromSuperview];
            }
            break;
        case 1:
            
            
            for (int x = 0 ; x < [[self secondFirstButton] count];x++){
                UIButton *button = [[self secondFirstButton] objectAtIndex:x];
                [button removeFromSuperview];
            }
            break;
            
        case 2:
            for (int x = 0 ; x < [[self thirdFirstButton] count];x++){
                UIButton *button = [[self thirdFirstButton] objectAtIndex:x];
                [button removeFromSuperview];
            }
            break;
            
        case 3:
            for (int x = 0 ; x < [[self fourthFirstButton] count];x++){
                UIButton *button = [[self fourthFirstButton] objectAtIndex:x];
                [button removeFromSuperview];
            }
            break;
    }
    
    
}
-(void)firstButton{
    if( _open==0){
        [self close:_open];
    }
    else if(_open !=-1){
        [self close:_open];
        [self openfirst];
    }
    else {
        [self openfirst];
        _open   = 0;
    }
}
-(void)secondButton{
    
    if( _open==1){
        [self close:_open];
    }
    else if(_open !=-1){
        [self close:_open];
        [self opensencond];
    }
    else {
        [self opensencond];
        _open   = 1;
    }
}
-(void)thirdButton{
    if( _open==2){
        [self close:_open];
    }
    else if(_open !=-1){
        [self close:_open];
        [self openthird];
    }
    else {
        [self openthird];
        _open   = 2;
    }
}
-(void)fourthButton{
    if( _open==3){
        [self close:_open];
    }
    else if(_open !=-1){
        [self close:_open];
        [self openfourth];
    }
    else {
        [self openfourth];
        _open   = 3;
    }
}
-(void)fifthButton{
    
}
-(NSString *)returnStringFirstArray: (int )x{
    switch (x) {
        case 0:
            return @"           Início";
            break;
        case 1:
            return @"           Calendário";
            
            break;
        case 2:
            return @"           Trajetos";
            
            break;
        case 3:
            return @"           Exercícios";
            
            break;
            
        default:
            break;
    }
    return nil;
    
}
-(NSString *)returnStringSecondArray: (int )x{
    switch (x) {
        case 0:
            return @"           Resultado";
            break;
        case 1:
            return @"           Foto agora";
            
            break;
        case 2:
            return @"           Foto da galeria";
            
            break;
            
        default:
            break;
    }
    return nil;
    
}
-(NSString *)returnStringThirdArray: (int )x{
    switch (x) {
        case 0:
            return @"           Criar desafio";
            break;
        case 1:
            return @"           Exercício realizado";
            
            break;
        default:
            break;
    }
    return nil;
    
}
-(NSString *)returnStringFourthArray: (int )x{
    switch (x) {
        case 0:
            return @"           Físicos";
            break;
        case 1:
            return @"           Pontuações";
            
            break;
        case 2:
            return @"           Premiações";
            
            break;
            
        default:
            break;
    }
    return nil;
    
}
-(NSArray *)alocaAndReturn: (int )x : (int)m{
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    NSMutableArray *array = [NSMutableArray array];
    for(int y = 0 ; y< m;y++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, (x*cellMenuHeight +y*cellSubMenuHeight)*size.height,  _leftWidthSize, cellSubMenuHeight   *size.height)];
        NSString *strBtn;
        switch (x) {
            case 1:
                strBtn = [self returnStringFirstArray:y];
                break;
            case 2:
                strBtn = [self returnStringSecondArray:y];
                break;
            case 3:
                strBtn = [self returnStringThirdArray:y];
                break;
            case 4:
                strBtn = [self returnStringFourthArray:y];
                break;
                
            default:
                break;
        }
        [btn setTitleColor:[UIColor staminaYellowColor] forState:UIControlStateNormal];
        [btn setTitle:strBtn forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn addTarget:self action:[self returnSelectorToButton:x :y] forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
        [[btn titleLabel] setFont:[UIFont fontWithName:@"Lato-Light" size:18]];
    }
    return [NSArray arrayWithArray:array];
    
}
//end accordion and its methods
-(void)createViewsToPresent{
    CGSize size = [UIScreen mainScreen].bounds.size;
    NSMutableArray *array = [NSMutableArray array];
    for(int x = 0 ; x < 6;x++){
        UIButton *startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, x*cellMenuHeight*size.height, _leftWidthSize, cellMenuHeight*size.height)];
        [[startButton titleLabel] setFont:[UIFont fontWithName:@"Lato" size:18]];
        [startButton setTitleColor:[UIColor staminaYellowColor] forState:UIControlStateNormal];
        [startButton setTitle:[self returnStringToButton:x] forState:UIControlStateNormal];
        startButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_leftMenu addSubview:startButton];
        startButton.titleEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0);
        //[startButton addTarget:self action:[self returnSelectorToButton:x] forControlEvents:UIControlEventTouchUpInside];
        [array addObject:startButton];
        
    }    [self setArrayOfButtons:[NSArray arrayWithArray:array]];
    UIButton *btn  = [array objectAtIndex:0];
    [btn addTarget:self action:@selector(inicioButton) forControlEvents:UIControlEventTouchUpInside];
    btn = [array objectAtIndex:1];
    [btn addTarget:self action:@selector(calendarioButton) forControlEvents:UIControlEventTouchUpInside];
    btn = [array objectAtIndex:2];
    [btn addTarget:self action:@selector(trajetosButton) forControlEvents:UIControlEventTouchUpInside];
    btn = [array objectAtIndex:3];
    [btn addTarget:self action:@selector(exerciciosButton) forControlEvents:UIControlEventTouchUpInside];
    btn = [array objectAtIndex:4];
    [btn addTarget:self action:@selector(fotoAgoraButton) forControlEvents:UIControlEventTouchUpInside];
    btn = [array objectAtIndex:5];
    [btn addTarget:self action:@selector(resultadoButton) forControlEvents:UIControlEventTouchUpInside];
//    [self setArrayFirstButton:[self alocaAndReturn:1 :M1]];
//    [self setSecondFirstButton:[self alocaAndReturn:2 :M2]];
//    [self setThirdFirstButton:[self alocaAndReturn:3 :M3]];
//    [self setFourthFirstButton:[self alocaAndReturn:4 :M4]];
}
-(void)callViewWithName: (NSString *)str{
    [self closeEverything];
    [self hideBarWithAnimation:1];
    [self hideLeftMenuAnimated:1];
    
    _str = str;
    UIViewController *viewController = [self createViewWithName:str];
    _presenting = viewController;
    MenuShouldOpen *menu = [MenuShouldOpen alloc];
    NSString *currentSelectedCViewController = NSStringFromClass(viewController.class);

    if([str isEqualToString:@"Inicio"]){
        [menu setRoot:viewController];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self.navigationController pushViewController:viewController animated:NO];
        return;
    }
    for (int x = 0 ; x < self.navigationController.viewControllers.count;x++ ) {
        UIViewController *ctr = [self.navigationController.viewControllers objectAtIndex:x];
        NSString *class = NSStringFromClass(ctr.class);

        if([class isEqualToString:currentSelectedCViewController]){
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [array removeObject:[self.navigationController.viewControllers objectAtIndex:x]];
            [array addObject:viewController];
            [self.navigationController setViewControllers:array animated:YES];
            return;
        }
    
    }
    [self.navigationController pushViewController:viewController animated:YES];
}
-(UIViewController *)createViewWithName: (NSString *)str{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *myVC= (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:str];
    return myVC;
}
-(void)addImage :(UIImage *)image to:(UIButton *)btn{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,  btn.frame.size.height*16/122, btn.frame.size.height*88/122,btn.frame.size.height*88/122)];
    [imgView  setImage:image];
    [imgView setFrame:CGRectMake(btn.frame.size.width/2- btn.frame.size.height*88/244,  btn.frame.size.height*16/122, btn.frame.size.height*88/122,btn.frame.size.height*88/122)];
    [btn addSubview:imgView];
    
}
-(void)buttonClean : (UIButton *)btn{
    NSArray *viewsToRemove = [btn subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    [btn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
}
//start create method to add to a button
-(void)firstButtonMethod: (void *)metodo fromView:(UIViewController *)view{
    UIButton *btn = [[self arrayTabBar] firstObject];
    [self buttonClean:btn];
    [btn addTarget:view action:metodo forControlEvents:UIControlEventTouchUpInside];
}
-(void)secondButtonMethod: (void *)metodo fromView:(UIViewController *)view{
    UIButton *btn = [[self arrayTabBar] objectAtIndex:1];
    [self buttonClean:btn];
    
    [btn addTarget:view action:metodo forControlEvents:UIControlEventTouchUpInside];
}
-(void)thirdButtonMethod: (void *)metodo fromView:(UIViewController *)view{
    UIButton *btn = [[self arrayTabBar] lastObject];
    [self buttonClean:btn];
    
    [btn addTarget:view action:metodo forControlEvents:UIControlEventTouchUpInside];
}
-(void)firstButtonMethod: (void *)metodo fromClass:(UIViewController *)view withImage: (UIImage *)image{
    JLSlideMenu *temp = [self.navigationController.viewControllers objectAtIndex:0];
    UIButton *btn = [[temp arrayTabBar] firstObject];
    if(!(metodo ==nil))
        [self firstButtonMethod:metodo fromView:view];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width - btn.frame.size.height*88/122-btn.frame.size.width*33/213, btn.frame.size.height*16/122, btn.frame.size.height*88/122,btn.frame.size.height*88/122)];
    [imgView  setImage:image];
    [btn addSubview:imgView];
}
-(void)secondButtonMethod: (void *)metodo fromClass:(UIViewController *)view  withImage: (UIImage *)image{
    JLSlideMenu *temp = [self.navigationController.viewControllers objectAtIndex:0];
    UIButton *btn = [[temp arrayTabBar] objectAtIndex:1];
    if(!(metodo ==nil))
        [self secondButtonMethod:metodo fromView:view];
    [self addImage:image to:btn];
}
-(void)thirdButtonMethod: (void *)metodo fromClass:(UIViewController *)view withImage: (UIImage *)image{
    JLSlideMenu  *temp = [self.navigationController.viewControllers objectAtIndex:0];
    UIButton *btn = [[temp arrayTabBar] lastObject];
    if(!(metodo ==nil))
        [self thirdButtonMethod:metodo fromView:view];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width*33/213, btn.frame.size.height*16/122, btn.frame.size.height*88/122,btn.frame.size.height*88/122)];
    [imgView  setImage:image];
    [btn addSubview:imgView];
    
}
//finish create method to add to a button
//start create @selector to add to left menu
-(void *)returnSelectorToStamina: (int )x{
    switch (x) {
        case 0:
            return @selector(inicioButton);
            break;
        case 1:
            return @selector(calendarioButton);
            break;
        case 2:
            return @selector(trajetosButton);
            break;
            
        case 3:
            return @selector(exerciciosButton);
            break;
            
        default:
            break;
    }
    return nil;
}
-(void *)returnSelectorToCompartilhar: (int )x{
    switch (x) {
        case 0:
            return @selector(resultadoButton);
            break;
        case 1:
            return @selector(fotoAgoraButton);
            break;
        case 2:
            return @selector(galeriaButton);
            break;
        default:
            break;
    }
    return nil;
}
-(void *)returnSelectorToDesafiar: (int )x{
    switch (x) {
        case 0:
            return @selector(criarButton);
            break;
        case 1:
            return @selector(exercicioRealizadoButton);
            break;
        default:
            break;
    }
    return nil;
}
-(void *)returnSelectorToResultado: (int )x{
    switch (x) {
        case 0:
            return @selector(fisicosButton);
            break;
        case 1:
            return @selector(pontuacoesButton);
            break;
        case 2:
            return @selector(premiacoesButton);
            break;
        default:
            break;
    }
    return nil;
}
-(void *)returnSelectorToButton: (int ) x : (int)y{
    x--;
    
    switch (x) {
        case 0:
            return [self returnSelectorToStamina:y];
            break;
        case 1:
            return [self returnSelectorToCompartilhar:y];
            break;
        case 2:
            return [self returnSelectorToDesafiar:y];
            break;
        case 3:
            return [self returnSelectorToResultado:y];
            break;
            
        default:
            break;
    }
    return nil;
    
}
-(void)calendarioButton{
    [self callViewWithName:@"Calendario"];
}
-(void)inicioButton{
    [self callViewWithName:@"Inicio"];
}
-(void)trajetosButton{
    [self callViewWithName:@"trajectory"];
}
-(void)exerciciosButton{
    [self callViewWithName:@"CategoriaTVC"];

}
-(void)resultadoButton{
    [self callViewWithName:@"graphicView"];

}
-(void)fotoAgoraButton{
    [self callViewWithName:@"shareScreen"];
}
-(void)galeriaButton{
    [self callViewWithName:@"graphicView"];

}
-(void)fisicosButton{
    [self callViewWithName:@"graphicView"];
}
-(void)pontuacoesButton{
    [self callViewWithName:@"graphicView"];
}
-(void)premiacoesButton{
    [self callViewWithName:@"graphicView"];
}
-(void)criarButton{
    
}
-(void)exercicioRealizadoButton{
    
}
-(void)configuracoes{
    [self callViewWithName:@"Configuracoes"];
}
-(void)addButtonUp{
    [self showBarWithAnimation:1];
}
-(void)sideSlide: (CGPoint )currentPoint{
    currentPoint = _currentPoint;
    if(_menuOpen){
        [self sideRecognizedWithStartPoint:_firstTouch withCurrentPoint:currentPoint];
    }
    else{
        if([self openMenu]){
            if(self.menuBlock)
                return;
            [self sideRecognizedWithStartPoint:_firstTouch withCurrentPoint:currentPoint];
            
        }
        else if(![self stop] && _recognized == RIGHT){
            _stop = YES;
            NSInteger count = [self.navigationController.viewControllers count];
            if(count==2)
                return;
            if(self.backViewBlock)
                return;
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    return;
}
-(void)menuMove: (CGPoint )currentPoint startPoint: (CGPoint)startPoint {
    if(startPoint.x<self.view.frame.size.width*perMenuOpen)
        [self setOpenMenu:YES];
    if([self menuOpen])
        return;
    [self horizontalRecognizedWithStartPoint:startPoint withCurrentPoint:currentPoint];
}
@end
