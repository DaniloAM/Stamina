//
//  GraphicScroller.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 10/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "GraphicScroller.h"

//Graphic size constant
#define graphHeight 240.0
#define graphWidth 320.0
#define borderIncrease 60.0

//Graphic animation constant
#define animationDuration 0.8
#define expandFactor 1.1


@implementation GraphicScroller


#pragma mark - graphic init

-(id)init {
    self = [super init];
    
    if(self) {
        
        [self setFont:[UIFont fontWithName:@"Avenir" size:13.0]];
        [self setLineColor:[UIColor staminaBlackColor]];
    }
    
    return self;

}


-(void)initGraphic {
    
    [self setMonthDate:[NSDate date]];
    [self setGraphDrawer:[[GraphicDrawer alloc] init]];
    
    //Set graphic font
    [[self graphDrawer] setGraphFont:[self font]];
    [[self updater] setLabelFont:[self font]];
    
    //set graphic line color
    [[self graphDrawer] setLineColor:[self lineColor]];
    
    //set graphic frame
    [[self graphDrawer] setGraphicFrame:CGRectMake(0, 0, graphWidth, graphHeight)];
    
    //prepare month label
    [self setMonthLabel:[[UILabel alloc] initWithFrame:CGRectMake(20, 50, 140, 100)]];
    [[self monthLabel] setNumberOfLines:2];
    [[self monthLabel] setFont:[UIFont fontWithName:[[self font] fontName] size:20.0]];
    
    
    //basics inits
    [self setGraphLoadState:GSNormal];
    [self setGraphicFrame:CGRectMake(0, 0, graphWidth, graphHeight)];
    
    [self setGraphicScrollView:[[UIScrollView alloc] init]];
    
    [[self graphicScrollView] setBackgroundColor:[UIColor clearColor]];
    [[self graphicScrollView] setDelegate:self];
    [[self graphicScrollView] setFrame:[self graphicFrame]];
    [[self graphicScrollView] setContentSize:CGSizeMake(graphWidth * viewSizeNumber, graphHeight)];
    
    
    //[[self graphicScrollView] setShowsHorizontalScrollIndicator:NO];
    //[[self graphicScrollView] setShowsVerticalScrollIndicator:NO];
    
    
    
    //double tap gesture
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction)];

    [doubleTap setNumberOfTapsRequired:2];
    
    [[self graphicScrollView] addGestureRecognizer:doubleTap];
}


#pragma mark - graphic creation and customization


-(void)setGraphicFont:(UIFont *)font {
    
    [self setFont:font];
}


-(void)setGraphicLineColor: (UIColor *)color {
    
    [self setLineColor:color];
}


-(void)startNewGraphicScrollViewWithUpdater: (GraphUpdater *)updater expanded:(BOOL)expanded {
    
    [self setUpdater:updater];
    [self initGraphic];
    [[self updater] setIsExpanded:expanded];
    
    CGRect viewFrame = CGRectMake(0, 0, graphWidth * viewSizeNumber, graphHeight);
    
    [self setCurrentGraphicView:[[UIView alloc] initWithFrame:viewFrame]];
    [self setNextGraphicView:[[UIView alloc] initWithFrame:viewFrame]];
    [self setPreviousGraphicView:[[UIView alloc] initWithFrame:viewFrame]];
    
    [self prepareGraphicViews];
    [self reloadScrollViewGraphic];
    
    [[self graphicScrollView] setContentOffset:CGPointMake(graphWidth * 1.5, 0)];
    
}


#pragma mark - graphic preparation


-(void)prepareGraphicViews {
    
    //Number of data per view frame
    NSInteger number = [[self updater] numberInView];
    
    
    //Images of the graphics and month labels
    UIImageView *previous = [[self graphDrawer] generateGraphImageWithComponents:[[self updater] previousNumberArray] numberShowingInView:number];
    
    
    UIImageView *current = [[self graphDrawer] generateGraphImageWithComponents:[[self updater] currentNumberArray] numberShowingInView:number];
    
    
    UIImageView *next = [[self graphDrawer] generateGraphImageWithComponents:[[self updater] nextNumberArray] numberShowingInView:number];
    
    
    //Add the images inside the views
    [[self currentGraphicView] addSubview:current];
    [[self nextGraphicView] addSubview:next];
    [[self previousGraphicView] addSubview:previous];
    
    //Add bottom labels inside the views
    [[self graphDrawer] addGraphBottomImageWithLabelArray:[[self updater] currentBottomLabels] numberShowingInVier:[[self updater] numberInView] inView:[self currentGraphicView]];
    [[self graphDrawer] addGraphBottomImageWithLabelArray:[[self updater] nextBottomLabels] numberShowingInVier:[[self updater] numberInView] inView:[self nextGraphicView]];
    [[self graphDrawer] addGraphBottomImageWithLabelArray:[[self updater] previousBottomLabels] numberShowingInVier:[[self updater] numberInView] inView:[self previousGraphicView]];
    
    
    //set the array components so the graphic knows what month is current showing
    [self setGraphicComponents:[[self updater] currentComponents]];
    
}


#pragma mark - graphic reloaders


-(void)reloadScrollViewGraphic {
    
    [[self currentGraphicView] removeFromSuperview];
    
    if([self graphLoadState] == GSForwarding) {
        
        [[self updater] advanceGraphicDate];
        
        [self setPreviousGraphicView:[self currentGraphicView]];
        [self setCurrentGraphicView:[self nextGraphicView]];
        
        [self setGraphLoadState:GSLoadingNext];
        
        [self setMonthDate:[NSDate dateWithTimeInterval:0 sinceDate:[[[self graphicComponents] lastObject] GNDate]]];

    }
    
    else if([self graphLoadState] == GSBackwarding) {
        
        [[self updater] regressGraphicDate];
        
        [self setNextGraphicView:[self currentGraphicView]];
        [self setCurrentGraphicView:[self previousGraphicView]];
        
        [self setGraphLoadState:GSLoadingPrevious];
        
        [self setMonthDate:[NSDate dateWithTimeInterval:0 sinceDate:[[[self graphicComponents] objectAtIndex:1] GNDate]]];

    }
    
    
    [self checkMonthLabel];
    
    
    [[self graphicScrollView] addSubview:[self currentGraphicView]];
    
    if([self graphLoadState] == GSExpanding || [self graphLoadState] == GSContracting) {
        
        [self setPositionAfterAnimation];
        
    }
    
    else {
        [[self graphicScrollView] setContentOffset:CGPointMake(graphWidth * 2, 0)];
    }
    
    [self performSelectorInBackground:@selector(loadNewGraphicByState) withObject:nil];
    
}



-(void)loadNewGraphicByState {
    
    if([self graphLoadState] == GSLoadingNext) {
        
        [self setMonthDate:[NSDate dateWithTimeInterval:0 sinceDate:[[[self graphicComponents] lastObject] GNDate]]];
        
        [[self updater] setPreviousComponents:[NSMutableArray arrayWithArray:[self graphicComponents]]];
        [self setGraphicComponents:[NSMutableArray arrayWithArray:[[self updater] nextComponents]]];
        
        [self changeMonthLabelText];
        
        CGRect viewFrame = CGRectMake(0, 0, graphWidth * viewSizeNumber, graphHeight);
        [self setNextGraphicView:[[UIView alloc] initWithFrame:viewFrame]];
        
        [self removeAllSubviewsFromView:[self nextGraphicView]];
        
        UIImageView *next = [[self graphDrawer] generateGraphImageWithComponents:[[self updater] nextNumberArray] numberShowingInView:[[self updater] numberInView]];
        
        [[self nextGraphicView] addSubview:next];
        
        [[self graphDrawer] addGraphBottomImageWithLabelArray:[[self updater] nextBottomLabels] numberShowingInVier:[[self updater] numberInView] inView:[self nextGraphicView]];
        
        [self setGraphLoadState:GSNormal];
        
    }
    
    else if([self graphLoadState] == GSLoadingPrevious) {
        
        [self setMonthDate:[NSDate dateWithTimeInterval:0 sinceDate:[[[self graphicComponents] objectAtIndex:1] GNDate]]];
        
        [[self updater] setNextComponents:[NSMutableArray arrayWithArray:[self graphicComponents]]];
        [self setGraphicComponents:[NSMutableArray arrayWithArray:[[self updater] previousComponents]]];
        
        [self changeMonthLabelText];
        
        CGRect viewFrame = CGRectMake(0, 0, graphWidth * viewSizeNumber, graphHeight);
        [self setPreviousGraphicView:[[UIView alloc] initWithFrame:viewFrame]];
        
        UIImageView *previous = [[self graphDrawer] generateGraphImageWithComponents:[[self updater] previousNumberArray] numberShowingInView:[[self updater] numberInView]];
        
        [[self previousGraphicView] addSubview:previous];
        
        [[self graphDrawer] addGraphBottomImageWithLabelArray:[[self updater] previousBottomLabels] numberShowingInVier:[[self updater] numberInView] inView:[self previousGraphicView]];
        
        [self setGraphLoadState:GSNormal];
        
    }
    
    
    
    
}



-(void)removeAllSubviewsFromView: (UIView *)view {
    
    NSInteger subviewCount = [[view subviews] count];
    
    for(int x = 0; x < subviewCount; x++) {
        
        [[[view subviews] objectAtIndex:x] removeFromSuperview];
        
    }
    
}


-(void)addSubviews: (NSArray *)subviews inView: (UIView *)view {
    
    for(int x = 0; x < [subviews count]; x++) {
        [view addSubview:[subviews objectAtIndex:x]];
    }
}



#pragma mark - graphic transitions



-(void)performAnimationByGraphState {
    
    [self storePositionBeforeAnimation];
    
    UIView *view = [self copyOfView:[self currentGraphicView]];
    
    
    if([self graphLoadState] == GSContracting) {
        
        [self setIsAnimating:true];
        
        [[self graphicScrollView] addSubview:view];
        
        [self performSelectorInBackground:@selector(prepareNewGraphicForm) withObject:nil];
        
        [UIView animateWithDuration:animationDuration animations:^{
            
            for(UIView *sub in [view subviews]) {
                
                CGRect frame = sub.frame;
                
                double leftSize = [self graphicScrollView].contentOffset.x;
                double rightSize = (graphWidth * 4) - leftSize;
                
                if(leftSize > rightSize) {
                    frame.size.width = frame.size.width - (rightSize / 2);
                    frame.origin.x = frame.origin.x + (rightSize / 3);
                }
                
                else {
                    frame.origin.x = frame.origin.x + (leftSize / 4);
                    frame.size.width = frame.size.width - (leftSize / 2);
                }
                
                [sub setFrame:frame];
                [sub setAlpha:0.0];
                
            }
            
        } completion:^(BOOL finished) {
            
            if(finished) {
                [view removeFromSuperview];
                [self setIsAnimating:false];
            }
        }];
        
    }
    
    else if([self graphLoadState] == GSExpanding) {
        
        [self setIsAnimating:true];
        
        [[self graphicScrollView] addSubview:view];
        
        [self performSelectorInBackground:@selector(prepareNewGraphicForm) withObject:nil];
        
        
        [UIView animateWithDuration:animationDuration animations:^{
            
            for(UIView *sub in [view subviews]) {
                
                CGRect frame = sub.frame;
                
                double originChange = ((frame.size.width * expandFactor) - frame.size.width) / 2;
                frame.size.width = frame.size.width * expandFactor;
                frame.origin.x = frame.origin.x - originChange;
                
                [sub setFrame:frame];
                [sub setAlpha:0.0];
                
            }
            
        } completion:^(BOOL finished) {
            
            if(finished) {
                [view removeFromSuperview];
                [self setIsAnimating:false];
            }
        }];
    }
}

-(void)prepareNewGraphicForm {
    
    [[self currentGraphicView] removeFromSuperview];
    
    if([self graphLoadState] == GSContracting) {
        
        [[self updater] contractGraphic];
        
    }
    
    else if([self graphLoadState] == GSExpanding) {
        
        [[self updater] expandGraphic];
        
    }
    
    CGRect viewFrame = CGRectMake(0, 0, graphWidth * viewSizeNumber, graphHeight);
    
    [self setCurrentGraphicView:[[UIView alloc] initWithFrame:viewFrame]];
    [self setNextGraphicView:[[UIView alloc] initWithFrame:viewFrame]];
    [self setPreviousGraphicView:[[UIView alloc] initWithFrame:viewFrame]];
    
    [self prepareGraphicViews];
    
    [[self graphicScrollView] setAlpha:0.0];
    
    [self reloadScrollViewGraphic];
    
    
    while([self isAnimating]) {
        
    }
    
    [self setGraphLoadState:GSNormal];
    
    [UIView animateWithDuration:animationDuration/2 animations:^{
        
        [[self graphicScrollView] setAlpha:1.0];
        
    }];
    
}


-(UIView*)copyOfView: (UIView *)viewToCopy {
    
    NSData* viewCopyData = [NSKeyedArchiver archivedDataWithRootObject:viewToCopy];
    return [NSKeyedUnarchiver unarchiveObjectWithData:viewCopyData];
    
}


#pragma mark - graphic action


-(void)doubleTapAction {
    
    if([self graphLoadState] == GSExpanding || [self graphLoadState] == GSContracting) {
        return;
    }
    
    if([[self updater] isExpanded]) {
        [self setGraphLoadState:GSContracting];
    }
    
    else [self setGraphLoadState:GSExpanding];
    
    [self performAnimationByGraphState];
    
}


#pragma mark - scrollview delegate


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    [self checkMonthLabel];
    
    if(scrollView.contentOffset.x <= 0 && _graphLoadState == GSNormal) {
        
        _graphLoadState = GSBackwarding;
        [self reloadScrollViewGraphic];
    }
    
    
    else if(scrollView.contentOffset.x >= graphWidth * 4 && _graphLoadState == GSNormal){
        
        _graphLoadState = GSForwarding;
        [self reloadScrollViewGraphic];
    }
    
}


#pragma mark - graphic month label



-(void)checkMonthLabel {
    
    NSLog(@"%f", [[self graphicScrollView] contentOffset].x);
    
    if([self graphLoadState] == GSLoadingNext || [self graphLoadState] ==  GSLoadingPrevious || [self transitionDate] != nil) {
        return;
    }
    
    double widthFactor = [self graphicFrame].size.width / [[self updater] numberInView];
    double point = [[self graphicScrollView] contentOffset].x + (graphWidth / 2);
    
    
    if([[self updater] numberInView] % 2 != 0) {
        point += widthFactor;
    }

    NSInteger componentIndex = point / widthFactor;
    
    GNComponent *component = [[self graphicComponents] objectAtIndex:componentIndex];
    
    NSInteger currentMonth = [[NSCalendar currentCalendar] component:NSCalendarUnitMonth fromDate:[self monthDate]];
    NSInteger compMonth = [[NSCalendar currentCalendar] component:NSCalendarUnitMonth fromDate:component.GNDate];
    
    if(currentMonth != compMonth) {
        [self setMonthDate:component.GNDate];
        [self changeMonthLabelText];
    }
    
}



-(void)changeMonthLabelText {
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[self monthDate]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    
    //set label text with month and year
    [[self monthLabel] setText:[NSString stringWithFormat: @"%@\n%d", [formatter stringFromDate:[self monthDate]],(int) comp.year]];
    
    
}


#pragma mark - position from animation


-(void)storePositionBeforeAnimation {
    
    double widthFactor = [self graphicFrame].size.width / [[self updater] numberInView];
    double point = [[self graphicScrollView] contentOffset].x + (graphWidth / 2);
    
    
    if([[self updater] numberInView] % 2 != 0) {
        point += widthFactor;
    }
    
    double pointIndex = point / widthFactor;
    
    NSInteger componentIndex = pointIndex;
    
    if(pointIndex - componentIndex >= 0.5) {
        componentIndex++;
    }


    GNComponent *component = [[self graphicComponents] objectAtIndex:componentIndex];
    
    [self setTransitionDate:[NSDate dateWithTimeInterval:0.0 sinceDate:component.GNDate]];
    
    
}

-(void)setPositionAfterAnimation {
    
    double widthFactor = [self graphicFrame].size.width / [[self updater] numberInView];
    double point = [[self graphicScrollView] contentOffset].x + (graphWidth / 2.0);
    
    
    if([[self updater] numberInView] % 2 != 0) {
        point += widthFactor;
    }
    
    double index = point / widthFactor;
    
    NSInteger componentIndex = index;
    
    if(index - componentIndex >= 0.5) {
        componentIndex++;
    }
    
    
    GNComponent *component = [[self graphicComponents] objectAtIndex:componentIndex];
    
    NSInteger days = [self daysBetweenDate:component.GNDate andDate:[self transitionDate]];
    
    if([[self updater] dayIncreaser] == DIWeeksInMonths) {
        double dif = days / 7.0;
        days = dif;
        if(dif - days >= 0.5) {
            days++;
        }
        //point += widthFactor / 2.0;
        //point -= graphWidth;
    }
    
    point += (widthFactor * days);
    //point += widthFactor;
    point -= graphWidth / 2;
    
    [[self graphicScrollView] setContentOffset:CGPointMake(point, 0)];
    
    [self setTransitionDate:nil];
    
    NSLog(@"SET: %f", [[self graphicScrollView] contentOffset].x);
    //[self performSelector:@selector(test) withObject:nil afterDelay:5.0];
    
}


-(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime {
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}


@end
