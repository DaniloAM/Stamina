//
//  UIStaminaLabel.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 31/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "UIStaminaLabel.h"

@implementation UILabel(StaminaLabel)

+(UILabel *)staminaLabelWithFrame: (CGRect)frame fontSize: (double)size color:(UIColor *)color {
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setFont:[UIFont fontWithName:@"Lato" size:size]];
    [label setTextColor:color];
    
    return label;
    
}


@end