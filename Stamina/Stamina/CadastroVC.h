//
//  CadastroVC.h
//  Stamina
//
//  Created by João Lucas Sisanoski on 03/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "HideBBVC.h"
#import "UIStaminaColor.h"
@interface CadastroVC : HideBBVC <UIScrollViewDelegate, UITextFieldDelegate>
@property UIScrollView *scroll;
@property float lastContentOffset;
@property int currentIndex;
@property int numberOfViews;
@property UITextField *txtName, *txtNick, *txtEmail, *txtConfEmail, *txtPassword, *txtConfPass, *txtKg, *txtCm, *txtAge;
@property UIView *temp;
@property NSMutableArray *arrayOfViews;
@property UIPageControl *page;
@property BOOL keyboardUp;
@property NSMutableArray *arrayView;
@property CGPoint logoStart;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property UIImageView *logo;
@property UISegmentedControl *seg;
@property UIButton *btn;
@property UIActivityIndicatorView *activity;
@property UIViewController *viewController;
@end
