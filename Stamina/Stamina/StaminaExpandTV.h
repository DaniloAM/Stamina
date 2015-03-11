//
//  StaminaExpandTV.h
//  Stamina
//
//  Created by Danilo Augusto Mative on 03/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "HideBBVC.h"
#import "UIStaminaColor.h"
#import "UIStaminaLabel.h"

#define tableViewRowHeight 45.0
#define fontLabelSize 22.0

@interface StaminaExpandTV : HideBBVC <UITableViewDataSource, UITableViewDelegate>


@property NSMutableArray *cellContentsArray;
@property NSMutableArray *titlesArray;
@property NSIndexPath *openIndexPath;
@property NSInteger openRowIndex;
@property NSString *openTitle;

@property UITableView *tableView;
@property UITableViewCell *openCell;
@property UIFont *rowFont;
@property UIColor *rowTextColor;
@property UIColor *tableViewBackgroundColor;

@property double expandHeight;

-(UITableViewCell *)getOpenCell;
-(void)closeExpandedRow;
-(void)reloadTableViewColors;

@end
