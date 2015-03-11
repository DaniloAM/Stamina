//
//  MainVC.m
//  Estamina
//
//  Created by João Lucas Sisanoski on 11/09/14.
//  Copyright (c) 2014 João Lucas Sisanoski. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath{
    NSString *identifier;
    switch (indexPath.row) {
        case 0:
            identifier = @"firstSegue";
            break;
        case 1:
            identifier = @"secondSegue";
            break;

    }
    return identifier;
}
-(void)configureLeftMenuButton:(UIButton *)button{
    CGRect frame = button.frame;
    frame.origin = CGPointMake(0, 0);
    frame.size = CGSizeMake(40, 40);
    button.frame = frame;
    [button setImage:[UIImage imageNamed:@"icon-menu"] forState:UIControlStateNormal];
}
- (CGFloat)leftMenuWidth{
    return 200;
}
@end
