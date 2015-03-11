//
//  GraphicScroller.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 10/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GraphUpdater.h"
#import "UIStaminaLabel.h"
#import "UIStaminaColor.h"
#import "GraphicDrawer.h"

@interface GraphicScroller : NSObject <UIScrollViewDelegate>

typedef enum GraphicState {
    GSNormal,
    GSBackwarding,
    GSForwarding,
    GSLoadingNext,
    GSLoadingPrevious,
    GSExpanding,
    GSContracting
}GraphicState;

@property GraphicState state;

@property UILabel *monthLabel;
@property NSDate *monthDate;

@property UIFont *font;
@property UIColor *lineColor;

@property UIView *nextGraphicView;
@property UIView *previousGraphicView;
@property UIView *currentGraphicView;

@property NSMutableArray *graphicComponents;

@property double leftLabelInterval;
@property double rightLabelInterval;

@property UIImageView *graphicImage;
@property UIImageView *nextGraphicImage;
@property UIScrollView *graphicScrollView;

@property NSInteger maxValue;
@property NSInteger minValue;
@property NSInteger graphLoadState;

@property CGRect graphicFrame;
@property GraphUpdater *updater;
@property GraphicDrawer *graphDrawer;

@property BOOL isAnimating;
@property BOOL showZeroValue;

-(void)startNewGraphicScrollViewWithUpdater: (GraphUpdater *)updater expanded:(BOOL)expanded;
-(void)setGraphicLineColor: (UIColor *)color;
-(void)setGraphicFont:(UIFont *)font;

@end
