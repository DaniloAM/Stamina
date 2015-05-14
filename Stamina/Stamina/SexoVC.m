//
//  SexoVC.m
//  Stamina
//
//  Created by Joao Sisanoski on 5/12/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "SexoVC.h"
#import "AlertViewLoading.h"
#import "JLSlideMenu.h"
@interface SexoVC ()
{
    AlertViewLoading *alertLoading;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmented;

@end

@implementation SexoVC
-(void)viewDidLoad{
    [super viewDidLoad];
    alertLoading = [[AlertViewLoading alloc] init];
}
-(IBAction)avancar{
    [alertLoading show];
    user.sex = _segmented.selectedSegmentIndex;
    [manager createUser:user];
    
}
-(void)errorGot:(NSError *)error{
    [alertLoading close];
    [self showAlertWithTitle:@"Errpr" andMainText:[ExceptionFactory getCloudKitError:error] andButtonText:@"Ok"];
}
-(void)errorThrowed:(NSError *)error{
    [self performSelectorOnMainThread:@selector(errorGot:) withObject:error waitUntilDone:NO];
}
-(void)signUpResult:(BOOL)result{
    if(result)
        [self performSelectorOnMainThread:@selector(signUpFinished) withObject:nil  waitUntilDone:NO];
    else
        return;
}
-(void)signUpFinished{
    NSLog(@"Succesfull");
    [alertLoading close];
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"homescreenVC"];
    JLSlideMenu *jl = [[JLSlideMenu alloc] init];
    [self.navigationController setViewControllers:@[jl,controller] animated:YES];
}
@end
