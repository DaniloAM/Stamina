//
//  CadastroVC.m
//  Stamina
//
//  Created by João Lucas Sisanoski on 03/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "CadastroVC.h"
#define ALTURA 1136
#define largura 640

@interface CadastroVC ()

@end

@implementation CadastroVC
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(IBAction)voltar{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _arrayView = [NSMutableArray array];
    _numberOfViews = 7;
    [self setPage:[[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 200)]];
    [[self page] setNumberOfPages:_numberOfViews];
    _numberOfViews = 8;
    CGSize size = [[UIScreen mainScreen] bounds].size;
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(179*size.width/largura, 212*size.height/ALTURA, 284*size.width/largura, 284*size.width/largura)];
    [image setImage:[UIImage imageNamed:@"stamina_logo.png"]];
    [self.view addSubview:image];
    [self setPage:[[UIPageControl alloc] initWithFrame:CGRectMake(0, 800*size.height/ALTURA, 100, 200)]];
    CGPoint p = [self page].frame.origin;
    p.x = size.width/2 - self.page.frame.size.width/2;
    CGRect rect = [self page].frame;
    rect.origin = p;
    [[self page] setFrame:rect];
    [[self page] setNumberOfPages:_numberOfViews];
    [self setScroll:[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)]];
    [[self scroll] setContentSize:CGSizeMake(_numberOfViews*size.width, 0)];
    _scroll.delegate = self;
    [self.view addSubview:[self scroll]];
    _currentIndex = 0;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.showsHorizontalScrollIndicator =NO;
    [self.view addSubview:_page];
    _scroll.delegate = self;
     [self loadTxt];
    [self createBackgroundColor];
    [self registerForKeyboardNotifications];
    [self lblError].hidden = YES;
    _logoStart = image.frame.origin;
    _logo = image;
    _page.userInteractionEnabled = NO;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = self.view.center;
    [activityIndicator startAnimating];
    _activity = activityIndicator;
    _temp = [[UIView alloc] initWithFrame:self.view.frame];
    _temp.alpha = 0.6;
    _temp.backgroundColor = [UIColor staminaBlackColor];
    _temp.opaque = NO;
}

-(void)loadTxt{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    int yUp = 655;
    int yDown = 763;
    [self setTxtName:[[UITextField alloc] initWithFrame:CGRectMake(65*size.width/largura, yUp*size.height/ALTURA, 510*size.width/largura, 73*size.height/ALTURA)]];
    [self setTxtEmail:[[UITextField alloc] initWithFrame:CGRectMake(65*size.width/largura, yUp*size.height/ALTURA, 510*size.width/largura, 73*size.height/ALTURA)]];
    [self setTxtPassword:[[UITextField alloc] initWithFrame:CGRectMake(65*size.width/largura, yUp*size.height/ALTURA, 510*size.width/largura, 73*size.height/ALTURA)]];
    [self txtPassword].secureTextEntry =    YES;
    [self setTxtNick:[[UITextField alloc] initWithFrame:CGRectMake(65*size.width/largura, yDown*size.height/ALTURA, 510*size.width/largura, 73*size.height/ALTURA)]];
    [self setTxtConfPass:[[UITextField alloc] initWithFrame:CGRectMake(65*size.width/largura, yDown*size.height/ALTURA, 510*size.width/largura, 73*size.height/ALTURA)]];
        [self txtConfPass].secureTextEntry =    YES;
    [self setTxtConfEmail:[[UITextField alloc] initWithFrame:CGRectMake(65*size.width/largura, yDown*size.height/ALTURA, 510*size.width/largura, 73*size.height/ALTURA)]];
    [self setTxtKg:[[UITextField alloc] initWithFrame:CGRectMake(250*size.width/largura, yDown*size.height/ALTURA, 141*size.width/largura, 73*size.height/ALTURA)]];
    _txtKg.keyboardType = UIKeyboardTypeNumberPad;
    [self setTxtCm:[[UITextField alloc] initWithFrame:CGRectMake(250*size.width/largura, yDown*size.height/ALTURA, 141*size.width/largura, 73*size.height/ALTURA)]];
    _txtCm.keyboardType = UIKeyboardTypeNumberPad;

    [self setTxtAge:[[UITextField alloc] initWithFrame:CGRectMake(250*size.width/largura, yDown*size.height/ALTURA, 141*size.width/largura, 73*size.height/ALTURA)]];
    _txtNick.autocorrectionType =UITextAutocorrectionTypeNo;
    _txtAge.keyboardType = UIKeyboardTypeNumberPad;
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"H" , @"M", nil]];
    [seg setFrame:CGRectMake(216*size.width/largura, 763*size.height/ALTURA, 200*size.width/largura, 67*size.height/ALTURA)];
    seg.selectedSegmentIndex = 0;
    [[UISegmentedControl appearance] setTintColor:[UIColor staminaBlackColor]];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor staminaBlackColor]} forState:UIControlStateNormal];
    _btn = [[UIButton alloc] initWithFrame:CGRectMake(251*size.width/largura, 684*size.height/ALTURA, 137*size.width/largura, 137*size.width/largura)];
    [_btn setBackgroundColor:[UIColor staminaBlackColor]];
    [_btn addTarget:self action:@selector(cadastra) forControlEvents:UIControlEventTouchUpInside];
    _seg     = seg;
    _arrayOfViews = [NSMutableArray arrayWithObjects:_txtAge,_txtCm,_txtConfEmail,_txtConfPass,_txtEmail,_txtKg,_txtName,_txtNick,_txtPassword, nil];
    for(int x = 0 ; x < [[self arrayOfViews] count];x++){
        UITextField *view = [[self arrayOfViews] objectAtIndex:x];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.layer.cornerRadius = 7;
        view.textAlignment = NSTextAlignmentCenter;
        [view setFont:[UIFont fontWithName:@"Lato" size:18]];
        view.delegate = self;
    }
    
    
    
}
-(void)cadastraUsuario{
    NSString *str = [WebServiceResponse cadastrarComNome:[self txtName].text eSenha:[self txtPassword].text email:[self txtEmail].text sexo:[self seg].selectedSegmentIndex nickName:[self txtNick].text];
   
    if([str isEqualToString:@"Adicionado"]){
        [WebServiceResponse atualizaComEmail:[self txtEmail].text peso:[[self txtKg].text floatValue] sexo:[self seg].selectedSegmentIndex altura:[[[self txtCm] text] intValue] idade:[[[self txtAge] text] intValue]];
        [_temp removeFromSuperview];
        [_activity removeFromSuperview];
        UserData *user = [UserData alloc];
        [user setNickName:_txtNick.text];
        [user setEmail:_txtEmail.text];
        [user setPassword:_txtPassword.text];
        [user setHeightInCentimeters:[_txtCm.text intValue]];
        [user setSex:[self seg].selectedSegmentIndex];
        [user setName:_txtName.text];
        [user setWeightInKilograms:[[self txtKg].text intValue]];
        [self dismissViewControllerAnimated:YES completion:nil];
            }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:str delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [_temp removeFromSuperview];
        [_activity removeFromSuperview];
    }

}
-(void)cadastra{
    [self.view addSubview:_temp];
    [self.view addSubview:_activity];
    [_activity startAnimating];
    [self performSelectorInBackground:@selector(cadastraUsuario) withObject:self];
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _lastContentOffset = scrollView.contentOffset.x;
    [self.view endEditing:YES];

}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self checkWhichPosition:scrollView.contentOffset.x];
}
-(void)left{
    [self lblError].hidden = YES;
    int x = [self check];
    if (x) {
        [self presentError:x];
    }
    else {
        _currentIndex++;
        
    }
    [self callNextPageIndex:_currentIndex];

}
-(int)check{
    int error = 0;
    switch (_currentIndex) {
        case 0:
            if([self txtName].text.length==0){
                error = 1;
                return error;

            }
            if([self txtNick].text.length==0){
                error = 2;
                return error;

            }
            
            break;
        case 1:
            if([self txtEmail].text.length==0||![self validateEmail:[[self txtEmail] text]]){
                error = 3;
                return error;

            }
            if([self txtConfEmail].text.length==0){
                error = 4;
                return error;

            }
            if(![[self txtConfEmail].text isEqualToString:[self txtEmail].text]){
                error = 5;
                return error;

            }
            break;
        case 2:
            if([self txtPassword].text.length==0)
            {
                error = 6;
                return error;

            }
            if([self txtConfPass].text.length==0)
            {
                error = 7;
                return error;

            }
            if(![[self txtPassword].text isEqualToString:[self txtConfPass].text])
            {
                error = 8;
                return error;

            }
            break;
        case 3:
            if([self txtKg].text.length==0)
            {
                error = 9;
                return error;

            }
            break;
        case 4:
            if([self txtCm].text.length==0)
            {
                error = 10;
                return error;

            }
            break;
        case 5:
            if([self txtAge].text.length==0)
            {
                error = 11;
                return error;

            }
            break;
        case 6:
            
            break;
        ;
        default:
            break;
    }
    
    return error;
}
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}
-(void)presentError: (int )x{
    [self lblError].hidden = NO;
    switch (x) {
            
        case 1:
            [[self lblError] setText:@"Cheque seu nome"];
            break;
        case 2:
            [[self lblError] setText:@"Cheque seu nick"];

            break;
        case 3:
            [[self lblError] setText:@"Cheque seu email"];

            break;
        case 4:
            [[self lblError] setText:@"Cheque sua confirmacao"];

            break;
        case 5:
            [[self lblError] setText:@"Email diferentes"];

            break;
        case 6:
            [[self lblError] setText:@"Cheque sua senha"];

            break;
        case 7:
            [[self lblError] setText:@"Cheque sua confirmacao"];

            break;
        case 8:
            [[self lblError] setText:@"Senhas diferentes"];

            break;
        case 9:
            [[self lblError] setText:@"Cheque seu peso"];

            break;
        case 10:
            [[self lblError] setText:@"Cheque sua ALTURA"];

            break;
        case 11:
            [[self lblError] setText:@"Cheque sua idade"];

            break;
     
    }
    [self shakeView:[self lblError]];

}
-(void)shakeView : (UIView *)lockImage{
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.1];
    [shake setRepeatCount:2];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:
                         CGPointMake(lockImage.center.x - 5,lockImage.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:
                       CGPointMake(lockImage.center.x + 5, lockImage.center.y)]];
    [lockImage.layer addAnimation:shake forKey:@"position"];
}
-(void)right{
    [self lblError].hidden = YES;
    int x = [self check];
    if (x) {
        [self presentError:x];
    }
    else {
        _currentIndex--;
    }
    [self callNextPageIndex:_currentIndex];

}
-(void)checkWhichPosition:(float)x{
    _scroll.userInteractionEnabled = NO;

    if(x>_lastContentOffset)
        [self left];
    else
        [self right];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        [self checkWhichPosition:scrollView.contentOffset.x];
    }

}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    scrollView.userInteractionEnabled = YES;
}
-(void)blockViews{
    for(int x = 0 ; x < [[self arrayView] count];x++){
        UIView *v = [[self arrayView] objectAtIndex:x];
        if(!(x == _currentIndex))
            v.userInteractionEnabled = NO;
        else
            v.userInteractionEnabled = YES;
    }
}

-(void)createBackgroundColor{
    CGSize size = [[UIScreen mainScreen] bounds].size;

    
    for(int x = 0 ; x < _numberOfViews;x++){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(65*size.width/largura, 655*size.height/ALTURA, 510*size.width/largura, 73*size.height/ALTURA)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont fontWithName:@"Lato" size:22]];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x*size.width, 0, size.width, size.height)];
        [_arrayView addObject:view];
        [self.scroll addSubview:view];
        switch (x) {
            case 1:
                [view addSubview:[self txtEmail]];
                [[self txtEmail] setPlaceholder:@"Email"];
                [view addSubview:[self txtConfEmail]];
                [[self txtConfEmail] setPlaceholder:@"Confirme o email"];
                
                break;
            case 2:
                [view addSubview:[self txtPassword]];
                [[self txtPassword] setPlaceholder:@"Senha"];

                [view addSubview:[self txtConfPass]];
                [[self txtConfPass] setPlaceholder:@"Confirme a senha"];

                
                break;
            case 3:
                [label setText:@"Peso:"];
                [view addSubview:label];
                [view addSubview:[self txtKg]];
                [[self txtKg] setPlaceholder:@"Kg"];

                
                break;
            case 4:
                [label setText:@"ALTURA:"];
                [view addSubview:label];
                [view addSubview:[self txtCm]];
                [[self txtCm] setPlaceholder:@"Cm"];

                
                break;
            case 5:
                [label setText:@"Idade:"];
                [view addSubview:label];
                [view addSubview:[self txtAge]];
                [[self txtAge] setPlaceholder:@"An"];

                
                break;
            case 6:
                [view  addSubview:_seg];
                [label setText:@"Sexo:"];
                [view addSubview:label];


                break;
            case 7:
                [view  addSubview:_btn];
                
                
                break;
            case 0:
                [view addSubview:[self txtName]];
                [[self txtName] setPlaceholder:@"Nome"];

                [view addSubview:[self txtNick]];
                [[self txtNick] setPlaceholder:@"Nickname"];

                

                break;
                
            default:
                break;
        }
        
    }
        
}

-(void)callNextPageIndex : (int )x{
    
    if(x == _numberOfViews)
        _currentIndex--;
    if(x <0)
        _currentIndex = 0;
    if(x == _numberOfViews|| x < 0)
        return;
    [self blockViews];
    [UIView animateWithDuration:0.4
                     animations:^{
                        _page.currentPage = x;
                     }];
    CGPoint p = CGPointMake(x*_scroll.frame.size.width, 0);
    [_scroll setContentOffset:p animated:YES];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
-(void)moveView: (UIView *)bigView withPoint: (CGPoint )point withDuration: (float)duration{
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:duration];
    bigView.frame = CGRectMake(point.x, point.y, bigView.frame.size.width, bigView.frame.size.height);
    [UIView commitAnimations];
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    [self.lblError setHidden:YES];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGSize keyboardSize = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight ) {
        CGSize origKeySize = keyboardSize;
        keyboardSize.height = origKeySize.width;
        keyboardSize.width = origKeySize.height;
    }
    [self moveView:_scroll withPoint:CGPointMake(0,-keyboardSize.height/2) withDuration:0.2];
    [self moveView:_logo withPoint:CGPointMake(_logoStart.x,1.7*_logoStart.y-keyboardSize.height/2) withDuration:0.2];

}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGSize keyboardSize = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight ) {
        CGSize origKeySize = keyboardSize;
        keyboardSize.height = origKeySize.width;
        keyboardSize.width = origKeySize.height;
    }
    [self moveView:_scroll withPoint:CGPointMake(0,0) withDuration:0.2];
    [self moveView:_logo withPoint:_logoStart withDuration:0.2];
    
    [self.lblError setHidden:YES];
    _keyboardUp = NO;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_scroll endEditing:YES];
}
- (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    return duration;
}
@end
