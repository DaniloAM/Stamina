//
//  GraphicDrawer.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 03/12/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GNComponent.h"

@interface GraphicDrawer : NSObject

@property UIColor *lineColor;
@property UIFont *graphFont;
@property BOOL showZeroValue;
@property CGRect graphicFrame;

-(UIImageView *)generateGraphImageWithComponents: (NSArray *)array numberShowingInView: (NSInteger)numberView;
-(void)addGraphBottomImageWithLabelArray: (NSArray *)labelArray numberShowingInVier:(NSInteger)number inView: (UIView *)view;

@end
