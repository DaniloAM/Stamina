//
//  UIStaminaButton.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 10/12/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIStaminaButton : UIButton {

    NSString *buttonImageName;
    
}

-(id)initWithStaminaImageName:(NSString *)imageName;
-(void)setStaminaImageName: (NSString *)imageName;

@end
