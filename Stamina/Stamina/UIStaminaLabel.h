//
//  UIStaminaLabel.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 31/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIStaminaColor.h"

@interface UILabel(StaminaLabel)

+(UILabel *)staminaLabelWithFrame: (CGRect)frame fontSize: (double)size color:(UIColor *)color;

@end
