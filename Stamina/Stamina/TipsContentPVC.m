//
//  PageContentViewController.m
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "TipsContentPVC.h"

@interface TipsContentPVC ()

@end

@implementation TipsContentPVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:_exerciseName];
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    self.titleLabel.text = self.titleText;
    [self performSelector:@selector(changeImage) withObject:self afterDelay:0];

}
-(void)changeImage{
    NSString *str = [NSString stringWithFormat:@"%@_%02d.png", [self exe].exerciseID, _current];
    [[self backgroundImageView] setImage:[UIImage imageNamed:str]];
    _current++;
    if(_current >= [[_exe numberImages] intValue])
        _current=0;
    [self performSelector:@selector(changeImage) withObject:self afterDelay:0.3];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
