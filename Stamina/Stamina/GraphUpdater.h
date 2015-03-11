//
//  GraphUpdater.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 11/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "GNComponent.h"
#import <UIKit/UIKit.h>

#define viewSizeNumber 5
#define VSDist 2
#define day_sec 86400

@interface GraphUpdater : NSObject

typedef enum DateIncreaser {
    DIDaysInWeeks,
    DIWeeksInMonths
}DateIncreaser;

@property DateIncreaser increaser;

@property NSInteger numberInView;
@property NSInteger dayIncreaser;
@property BOOL isExpanded;

@property NSCalendar *calendar;
@property NSDate *graphCenterDate;
@property CGRect graphFrame;

@property UIFont *labelFont;

@property NSMutableArray *currentComponents;
@property NSMutableArray *previousComponents;
@property NSMutableArray *nextComponents;

-(id)initWithGraphFrame: (CGRect)frame;

-(NSArray *)currentNumberArrayWithComponents: (NSMutableArray *)array;
-(NSArray *)nextNumberArrayWithComponents: (NSMutableArray *)array;
-(NSArray *)previousNumberArrayWithComponents: (NSMutableArray *)array;

-(NSArray *)currentNumberArray;
-(NSArray *)nextNumberArray;
-(NSArray *)previousNumberArray;

-(void)advanceGraphicDate;
-(void)regressGraphicDate;

-(void)expandGraphic;
-(void)contractGraphic;

-(NSArray *)currentBottomLabels;
-(NSArray *)nextBottomLabels;
-(NSArray *)previousBottomLabels;


@end
