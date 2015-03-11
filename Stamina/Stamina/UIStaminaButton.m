//
//  UIStaminaButton.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 10/12/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "UIStaminaButton.h"

@implementation UIStaminaButton : UIButton



-(id)initWithStaminaImageName:(NSString *)imageName {
    
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(self) {
        
        UIButton *btn = self;
        
        UIImage *normal = [UIImage imageNamed:imageName];
        UIImage *selected = [UIImage imageNamed:[NSString stringWithFormat:@"s_%@", imageName]];
        
        [btn setImage:normal forState:UIControlStateNormal];
        [btn setImage:selected forState:UIControlStateHighlighted];
        
    }
    
    return self;
    
}


-(void)setStaminaImageName: (NSString *)imageName {
    
    UIImage *normal = [UIImage imageNamed:imageName];
     UIImage *selected = [UIImage imageNamed:[NSString stringWithFormat:@"s_%@", imageName]];
    
    [self setImage:normal forState:UIControlStateNormal];
    [self setImage:selected forState:UIControlStateHighlighted];
    
}


@end
