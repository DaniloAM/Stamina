//
//  GraphicDrawer.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 03/12/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "GraphicDrawer.h"

#define viewSizeNumber 5
#define borderIncrease 55
#define bottomSize 1.0

#define labelHeight 25.0

#define lineSizeFactor 1.15

@implementation GraphicDrawer

-(void)addGraphBottomImageWithLabelArray: (NSArray *)labelArray numberShowingInVier:(NSInteger)number inView: (UIView *)view {
    
    UIImage *image;
    
    double graphWidth = [self graphicFrame].size.width;
    double graphHeight = [self graphicFrame].size.height;
    double widthFactor = graphWidth / number;
    
    CGSize contextSize = CGSizeMake(_graphicFrame.size.width * viewSizeNumber, borderIncrease * bottomSize);
    
    UIGraphicsBeginImageContextWithOptions(contextSize, NO, 0.0);
    
    CGRect frame = CGRectMake(-widthFactor / 2, 0, widthFactor, (borderIncrease * bottomSize) / 1.5);
    
    for(int x = 0; x < [labelArray count]; x++) {
        
        UILabel *label = [labelArray objectAtIndex:x];
        [label drawTextInRect:frame];
        frame.origin.x += widthFactor;
        
        if(frame.origin.x > (graphWidth * 5) + widthFactor) {
            break;
        }
        
    }
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, graphHeight - borderIncrease, graphWidth * 5, borderIncrease)];
    
    bottomImage.image = image;
    
    [view addSubview:bottomImage];
    
}


-(UIImageView *)generateGraphImageWithComponents: (NSArray *)array numberShowingInView: (NSInteger)numberView {
    
    
    if([array count] < numberView * viewSizeNumber) {
        return nil;
    }
    
    
    //the max value
    NSInteger max = 0;
    
    
    for(GNComponent *number in array) {
        
        if(number.GraphicNumber.integerValue > max) {
            max = number.GraphicNumber.integerValue;
        }
        
    }
    
    
    //Factors for the graphic
    double graphHeight = _graphicFrame.size.height - (borderIncrease / 2);
    //double graphWidth = _graphicFrame.size.width;
    
    double heightFactor = (graphHeight - borderIncrease) / max;
    double widthFactor = _graphicFrame.size.width / numberView;
    double radius = _graphicFrame.size.width / 25.0;
    double lineSize = ((graphHeight - borderIncrease) / 40.0) * lineSizeFactor;
    
    
    
    //Case of math error (X / 0)
    if(max == 0) {
        heightFactor = 0;
    }
    
    
    /*  Increase the frame by the size of the line,
     so the line doesnt cross the frame limit.    */
    
    //**********_graphicFrame.size.height += borderIncrease;
    
    

    //Prepare image
    UIImage *image;
    
    CGSize contextSize = CGSizeMake(_graphicFrame.size.width * viewSizeNumber, _graphicFrame.size.height);
    
    //Begin context for retina displays
    UIGraphicsBeginImageContextWithOptions(contextSize, NO, 0.0);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [[self lineColor] CGColor]);
    
    
    // ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
    //
    //Finished all the preparations, time to start drawing the graphic!
    //
    // ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
    
    
    //Start drawing all the points
    for(NSInteger index = 0; index < [array count]; index++) {
        
        
        //Set point (A)
        NSInteger valueA = [[[array objectAtIndex:index] GraphicNumber] integerValue];
        
        CGPoint pointA = CGPointMake(index * widthFactor,(graphHeight - borderIncrease) - (valueA * heightFactor) + (graphHeight / 20));
        
        
        //Draw the point (A)
        CGContextFillEllipseInRect (UIGraphicsGetCurrentContext(), CGRectMake(pointA.x - (radius / 2), pointA.y - (radius / 2), radius, radius));
        
        
        
        if(index + 1 >= [array count]) {
            break;
        }
        
        //Set point (B)
        NSInteger valueB = [[[array objectAtIndex:index+1] GraphicNumber] integerValue];
        
        CGPoint pointB = CGPointMake((index + 1) * widthFactor, (graphHeight - borderIncrease) - (valueB * heightFactor) + (graphHeight / 20));
        
        //Set point (C) *** only for angle checking
        CGPoint pointC;
        
        if(index == 0)
            pointC = pointA;
        
        else pointC = CGPointMake((index - 1) * widthFactor,(graphHeight - borderIncrease) - ([[[array objectAtIndex:index-1] GraphicNumber] integerValue] * heightFactor) + (graphHeight / 20));
        
        
        //Check if the value is different from zero
        if([[[array objectAtIndex:index] GraphicNumber] integerValue] > 0.0 || _showZeroValue) {
            
            //Prepare the label value
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, radius * 8, radius * 8)];
            [label setFont:[self graphFont]];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setText:[NSString stringWithFormat:@"%dm",[[[array objectAtIndex:index] GraphicNumber] intValue]]];
            
            //Get angle of points to determine position of label
            CGPoint labelPoint = pointA;

            
            //Check angle to position label
            
            //CASE 1
            if([self getLineAngleForPointA:pointA andPointB:pointB] >= 30.0) {

                labelPoint.y -= labelHeight * 0.5;
                labelPoint.x += radius * 1;
                
                [label setTextAlignment:NSTextAlignmentLeft];
               
            }
            
            //CASE 2
            else if([self getLineAngleForPointA:pointA andPointB:pointC] <= 30.0) {

                labelPoint.y -= labelHeight * 1.5;
                labelPoint.x -= widthFactor / 2;
                
                [label setTextAlignment:NSTextAlignmentCenter];
            }
            
            //CASE 3
            else {

                labelPoint.y += labelHeight * 0.5;
                labelPoint.x -= widthFactor / 2;
                
                [label setTextAlignment:NSTextAlignmentCenter];

            }
            
            
            //*********CGRect labelRect = CGRectMake(labelPoint.x, labelPoint.y, widthFactor * 2, labelHeight);
            
            CGRect labelRect = CGRectMake(labelPoint.x, labelPoint.y, widthFactor * 2, labelHeight);

            
            //Draw the label text in the context
            [label drawTextInRect:labelRect];
        }
        
        //Draw the line from point (A)
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), pointA.x, pointA.y);
        //to point (B)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), pointB.x, pointB.y);
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineSize);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        
    }
    
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    //**********_graphicFrame.size.height -= borderIncrease;
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(_graphicFrame.origin.x, _graphicFrame.origin.y, _graphicFrame.size.width * viewSizeNumber, _graphicFrame.size.height)];
    
    [view setImage:image];
    
    return view;
    
}


-(double)getLineAngleForPointA: (CGPoint)pointA andPointB: (CGPoint)pointB {
    
    double l = fmax(pointA.x, pointB.x) - fmin(pointA.x, pointB.x);
    double h = fmax(pointA.y, pointB.y) - fmin(pointA.y, pointB.y);
    
    //Not a triangle
    if(l == 0 || h == 0) {
        return 0.0;
    }
    
    double hip = sqrt((l*l) + (h*h));
    
    double arc = asin(h / hip);
    
    return 180 * arc / M_PI;
    
}

@end
