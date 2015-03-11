//
//  StaminaExpandTV.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 03/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "StaminaExpandTV.h"

@interface StaminaExpandTV ()

@end

@implementation StaminaExpandTV


-(void)viewDidLoad {
    [super viewDidLoad];
    
    //Standard inits
    _expandHeight = 200;
    _openRowIndex = -1;
    _tableViewBackgroundColor = [UIColor staminaYellowColor];
    _rowFont = [UIFont fontWithName:@"Lato" size:fontLabelSize];
    _rowTextColor = [UIColor staminaBlackColor];
    
    
    [self setTableView:[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)]];
    [[self tableView] setRowHeight:tableViewRowHeight];
    [[self tableView] setDelegate:self];
    [[self tableView] setDataSource:self];
    [self reloadTableViewColors];
    
    [self setTitlesArray:[NSMutableArray array]];
    [self setCellContentsArray:[NSMutableArray array]];
    
}


-(void)reloadTableViewColors {
    
    [[self tableView] setBackgroundColor:_tableViewBackgroundColor];
    [[self tableView] setSeparatorColor:[UIColor staminaBlackColor]];
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    _expandHeight = [[UIScreen mainScreen] bounds].size.height - [self tabBarSize].height - [self navigationSize].height;
}


#pragma mark - tableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self titlesArray] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    //Standard cell properties
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor clearColor];
    
    
    
    //If the cell that is loading is the expanded one
    if(indexPath.row == _openRowIndex) {
        
        [self addContentToCell:cell];
        
    }
    
    
    //Else loads the title of the other routes
    else {
        
        cell.textLabel.text = [NSString stringWithFormat:@"     %@",[[self titlesArray] objectAtIndex:indexPath.row]];
        cell.textLabel.font = [UIFont fontWithName:@"Lato" size:20.0];
        cell.textLabel.textColor = _rowTextColor;
        
    }
    
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == _openRowIndex) {
        
        if(_expandHeight > tableViewRowHeight)
            return _expandHeight;
        
    }
    
    return tableViewRowHeight;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == _openRowIndex) {
        return;
    }
    
    _openTitle = [[self titlesArray] objectAtIndex:indexPath.row];
    _openRowIndex = indexPath.row;
    
    NSArray *cellArray;
    
    if([self openIndexPath]) {
        cellArray = @[[self openIndexPath], indexPath];
    }
    
    else cellArray = @[indexPath];
    
    
    [[self tableView] reloadRowsAtIndexPaths:cellArray withRowAnimation:UITableViewRowAnimationFade];
    [[self tableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
    
    [self setOpenIndexPath:indexPath];
    
}


-(UITableViewCell *)getOpenCell {
    
    return [[self tableView] cellForRowAtIndexPath:_openIndexPath];
    
}



-(void)addContentToCell: (UITableViewCell *)cell {
    
    //Add content
    for(int x = 0; x < [[self cellContentsArray] count]; x++) {
        
        [cell addSubview:[[self cellContentsArray] objectAtIndex:x]];

    }
    
    
    //Title of cell
    CGRect titleFrame = CGRectMake(0, 0, [self tableView].frame.size.width, tableViewRowHeight);
    UILabel *title = [UILabel staminaLabelWithFrame:titleFrame fontSize:22.0 color:[UIColor staminaYellowColor]];
    
    [title setText:[NSString stringWithFormat:@"     %@",[[self titlesArray] objectAtIndex:_openRowIndex]]];
    [title setBackgroundColor:[UIColor staminaBlackColor]];
    [title setTextAlignment:NSTextAlignmentLeft];
    
    
    //Closing gesture
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeExpandedRow)];
    [doubleTap setNumberOfTapsRequired:2];
    
    
    //Add to cell
    [cell addGestureRecognizer:doubleTap];
    [cell addSubview:title];
    
}


-(void)closeExpandedRow {
    
    _openRowIndex = -1;
    
    if([self openIndexPath])
        [[self tableView] reloadRowsAtIndexPaths:@[_openIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    _openIndexPath = nil;
    
}


@end
