//
//  LoginViewController.m
//  Stamina
//
//  Created by João Lucas Sisanoski on 19/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self moveView:[self logo] withPoint:CGPointMake([self logo].frame.origin.x, 222) withDuration:0];

       UserData *userData = [UserData alloc];
    if([userData email]==nil)
        [self anima];
    else
        [self checkConnection];

}
-(void)moveView: (UIView *)bigView withPoint: (CGPoint )point withDuration: (float)duration{
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:duration];
    bigView.frame = CGRectMake(point.x, point.y, bigView.frame.size.width, bigView.frame.size.height);
    [UIView commitAnimations];
}
-(void)preCarregamento{
    [self activity].hidden=YES;
    [self viewBlock].hidden = YES;
    [self password].hidden = YES;
    [self fbBTN].hidden = YES;
    [self cadastreSeBTN].hidden = YES;
    [self signInBTN].hidden = YES;
    [self login].delegate =self;
    self.login.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    self.login.layer.cornerRadius = 7;
    [self login].backgroundColor  = [UIColor whiteColor];
    [self.login endEditing:YES];
    [self errorLbl].hidden=YES;
    self.login.textColor = [UIColor blackColor]; //optional
    self.password.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [self password].backgroundColor  = [UIColor whiteColor];
    [self.password endEditing:YES];
    self.password.layer.cornerRadius = 7;
    
    [self signInBTN].layer.cornerRadius = 7 ;
    self.password.textColor = [UIColor blackColor]; //optional
    self.password.secureTextEntry = YES;

    [_login setLeftViewMode:UITextFieldViewModeAlways];
    UIImage *temp = [self cutImage:[UIImage imageNamed:@"icon_email.png"] :CGSizeMake(31.2, 15.6)];
    _login.leftView= [[UIImageView alloc] initWithImage:temp];
    [_password setLeftViewMode:UITextFieldViewModeAlways];
    temp = [self cutImage:[UIImage imageNamed:@"icon_cadeado.png"] :CGSizeMake(31.2, 24)];
    _password.leftView= [[UIImageView alloc] initWithImage:temp];
    
    [self login].hidden = YES;
    [self password].delegate =self;
    [self password].secureTextEntry = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self moveView:[self logo] withPoint:CGPointMake([self logo].frame.origin.x, 222) withDuration:0];
    

    [self preCarregamento];

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self moveView:[self logo] withPoint:CGPointMake([self logo].frame.origin.x, 222) withDuration:0];

   
}

-(UIImage *)cutImage : (UIImage *)myimage : (CGSize) size{
    CGSize itemSize = size;
    
    UIGraphicsBeginImageContext(itemSize);
    
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    
    [myimage drawInRect:imageRect];
    
    
    myimage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return myimage;
}

-(void)checkConnection{
    UserData *userData = [UserData alloc];
    [self activity].hidden=NO;
    [[self activity] startAnimating];
    if([userData email]!=nil)
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *myVC;
            if([self connected])
                str = [WebServiceResponse checkStart:[userData email] eSenha:[userData password]];
            while(1){
                if([str isEqualToString:@"1"]){
                    [self dismissViewControllerAnimated:NO completion:Nil];

                        myVC= (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
                    
                    [self dismissViewControllerAnimated:NO completion:Nil];
                    
                    [self presentViewController:myVC animated:YES completion:nil];
                    return;
                }
                else if ([str isEqualToString:@"0"]){
                    [self anima];
                    return;
                    
                    
                }
            }
        });
    

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

-(void)anima{
    [self activity].hidden=YES;
    [[self activity] stopAnimating];
    CGRect size = [self logo].frame;

    [self moveView:[self logo] withPoint:CGPointMake(size.origin.x, 85) withDuration:0.45];
    [self performSelector:@selector(mostra) withObject:nil afterDelay:0.5];

}
-(void)mostra{
    [self password].hidden = NO;
    [self login].hidden = NO;
    [self fbBTN].hidden = NO;
    [self cadastreSeBTN].hidden = NO;
    [self signInBTN].hidden = NO;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(BOOL)hasJson: (NSString *)str{
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSArray *peso_atual = [json valueForKeyPath:@"peso_atual"];
    if([peso_atual count]==0)
        return 0;
    NSArray *altura = [json valueForKeyPath:@"altura"];
    NSArray *nome = [json valueForKeyPath:@"nome"];
    NSArray *peso_inicial = [json valueForKeyPath:@"peso_inicial"];
    NSArray *idade = [json valueForKeyPath:@"idade"];
    NSArray *sexo = [json valueForKeyPath:@"sexo"];
    NSArray *nick = [json valueForKeyPath:@"nickname"];
    NSArray *email = [json valueForKeyPath:@"email"];
    NSArray *userId = [json valueForKeyPath:@"id"];
    UserData *userData = [UserData alloc];
    [userData setName:[nome objectAtIndex:0]];
    [userData setWeightInKilograms:[[peso_atual objectAtIndex:0] intValue]];
    [userData setInitialWeight:[[peso_inicial objectAtIndex:0] intValue]];
    [userData setHeightInCentimeters:[[altura objectAtIndex:0] intValue]];
    [userData setAge:[[idade objectAtIndex:0] intValue]];
    [userData setEmail:[email objectAtIndex:0]];
    [userData setNickName:[nick objectAtIndex:0]];
    [userData setSex:[[sexo objectAtIndex:0] boolValue]];
    [userData setUserID:[[userId objectAtIndex:0] intValue]];
    return 1;

}

-(IBAction)loginUser{
            self.errorLbl.hidden=   YES;
    CGRect size = [self logo].frame;
    
    [self moveView:[self logo] withPoint:CGPointMake(size.origin.x,85) withDuration:0.2];

    [self setDown:NO];

    [[self view] endEditing:YES];
    [self resignFirstResponder];
    dispatch_async(dispatch_get_main_queue(), ^{

        [self activity].hidden=NO;
        [self viewBlock].hidden=NO;
    [[self activity] startAnimating];
        if([self login].text.length>0&&[self password].text.length>0){
    if ([self connected]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self buscaJson];
        });
        
    }
    else {
        UserData *usr = [UserData alloc];
        [usr setEmail:nil];
        [usr setName:nil];
        [usr setPassword:nil];
        [self presentError:0 :@"Verifique a conexão com a internet"];
        return;
    }
        }
        else{
            [self presentError:0 :@"Verifique seu email e/ou senha"];
            return;
        }

    });
    
}
-(void)buscaJson{
  NSString *str =  [WebServiceResponse loginComEmailOuNickName:[[self login] text] eSenha:[[self password] text]];
    
   if(![self hasJson:str])
    if(![str isEqualToString:@""]){
        [self presentError:0 :str];
        return;
    }
    
    UserData *userData = [UserData alloc];
    [userData setPassword:[[self password] text]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *myVC = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
    [self dismissViewControllerAnimated:NO completion:Nil];
    [self presentViewController:myVC animated:YES completion:nil];
}

-(void)presentError: (int) error : (NSString *)strError{
    [[self activity] stopAnimating];
    [self  activity].hidden=YES;
    [self viewBlock].hidden = YES;
    [self errorLbl].hidden=NO;
    [self errorLbl].text=strError;
    [self shakeView:[self errorLbl]];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGRect size = [self viewTotal].frame;
    [self moveView:[self viewTotal] withPoint:CGPointMake(size.origin.x, -216) withDuration:0.25];
    [self setDown:YES];
    return YES;
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
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
        [self setDown:NO];
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if(![self down]){
        CGRect size = [self viewTotal].frame;

        [self moveView:[self viewTotal] withPoint: CGPointMake(size.origin.x,0) withDuration:0.2];
    }

    return YES;
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self setDown:NO];

    [[self view] endEditing:YES];
    [self resignFirstResponder];
}

- (BOOL)connected
{
    return [ServerSupport getConnectivity];
}


@end
