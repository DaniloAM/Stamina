//
//  TrajectorySelectionVC.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 29/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "TrajectorySelectionVC.h"



@interface TrajectorySelectionVC ()

@end

@implementation TrajectorySelectionVC



-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUser:[UserData alloc]];
    
    [self setRouteTableView:[super tableView]];
    [[self routeTableView] setDelegate:self];
    [[self routeTableView] setDataSource:self];

    [self setTableViewTitles];
    [self.view addSubview:[self routeTableView]];
    
    [[self routeTableView] reloadData];
}



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showBarWithAnimation:true];
    [self barBlock];
    
    
    [self firstButtonMethod:@selector(goHome) fromClass:self withImage:[UIImage imageNamed:@"icone_home_tab.png"]];
    [self secondButtonMethod:@selector(development) fromClass:self  withImage:[UIImage imageNamed:@"icone_info_user_tab.png"]];
    [self thirdButtonMethod:@selector(development)  fromClass:self withImage:[UIImage imageNamed:@"icone_adicionar_tab.png"]];
    
    
    
    CGRect frame = CGRectMake(
                              
                              // origin X
                              0,
                              
                              //origin Y
                              0,
                              
                              //size width
                              [[UIScreen mainScreen] bounds].size.width,
                              
                              //size height
                              [[UIScreen mainScreen] bounds].size.height - [self tabBarSize].height - ([self navigationSize].height * 1.5));

        
    [[self routeTableView] setFrame:frame];
    
}

-(void)development {
    [self callViewWithName:@"developmentScreen"];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

-(void)goHome {
    [self popToRoot];
}

-(void)createTrajectory {
    [self callViewWithName:@"CreateTrajectory"];
}


-(void)setTableViewTitles {
    
    for(int x = 0; x < [[[self user] routesArray] count]; x++) {
        [[super titlesArray] addObject:[[[[self user] routesArray] objectAtIndex:x] trajectoryName]];
    }
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    _openRoute = [[[self user] routesArray] objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [super getOpenCell];
    [self addContentOfRoutetoCell:cell];
    
}



-(void)addContentOfRoutetoCell: (UITableViewCell *)cell {
    
    [[super cellContentsArray] removeAllObjects];
    
    NSLog(@"%f", cell.frame.size.height);
    
    //Image of the route
    RoutePointsCartesian *cartesian = [[RoutePointsCartesian alloc] init];
    
    NSArray *locations = [NSKeyedUnarchiver unarchiveObjectWithData:[_openRoute arrayOfLocations]];
    
    NSMutableArray *xPoints = [NSMutableArray array];
    NSMutableArray *yPoints = [NSMutableArray array];
    
    for(int x = 0; x < [locations count]; x++) {
        MKMapPoint point = MKMapPointForCoordinate([[locations objectAtIndex:x] coordinate]);
        
        [xPoints addObject:[NSNumber numberWithInt:point.x]];
        [yPoints addObject:[NSNumber numberWithInt:point.y]];
    }
    
    
    if(!locations || [locations count] <= 0) {
        return;
    }
        
    
    
    UIImageView *imageView = [cartesian returnDrawedViewWithXArray:xPoints yArray:yPoints InSize:CGSizeMake(cell.frame.size.width * 0.9, tableViewRowHeight * 3.0)];
    
    
    imageView.center = cell.center;
    
    [imageView setFrame:CGRectMake(imageView.frame.origin.x, tableViewRowHeight * 2, imageView.frame.size.width, imageView.frame.size.height)];

    
    UIButton *goToRoute = [[UIButton alloc] initWithFrame:imageView.frame];
    
    [goToRoute addTarget:self action:@selector(performSelectedRoute:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    NSArray *array = [self getHistoryOfThisRoute];
    
    
    
    CGRect infoFrame = CGRectMake(cell.frame.size.width / 5, [[UIScreen mainScreen] bounds].size.height - [self tabBarSize].height - [self navigationSize].height - (tableViewRowHeight * 5), cell.frame.size.width / 3, tableViewRowHeight);
    
    CGRect imageFrame = CGRectMake(0, 0, infoFrame.size.height * 0.75, infoFrame.size.height  * 0.75);
    
    
    for(int x = 0; x < 4; x++) {
        
        
        if(x == 1 || x == 3) {
            infoFrame.origin.x = cell.frame.size.width / 1.5;
        }
        
        else {
            infoFrame.origin.x = cell.frame.size.width / 5;
            infoFrame.origin.y += tableViewRowHeight * 1.5;
        }
        
        
        imageFrame.origin.y = infoFrame.origin.y;
        
        
        UILabel *infoLabel = [UILabel staminaLabelWithFrame:infoFrame fontSize:19.0 color:[UIColor staminaBlackColor]];
        
        int value = [[array objectAtIndex:x] intValue];
        
        
        NSString *imageName;
        
        switch (x) {
            case 0:{
                imageName = @"icone_calorias.png";
                infoLabel.text = [NSString stringWithFormat:@"%03d cal", value];
            }
                break;
            case 1:
                imageName = @"icone_km.png";
                infoLabel.text = [UnitConversion distanceFromMetric:value];
//                if(value >= 1000) {
//                    float val = value / 1000.0;
//                    infoLabel.text = [NSString stringWithFormat:@"%.01f Km",val];
//                }
//                else {
//                    infoLabel.text = [NSString stringWithFormat:@"%03d m", value];
//                }
                
                break;
            case 2:
                imageName = @"icoen_tempo.png";
                infoLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", value/60/60, value/60, value%60];
                break;
            case 3:
                imageName = @"icone_pontuacao.png";
                infoLabel.text = [NSString stringWithFormat:@"%04d pts", value];
                break;
            default:
                break;
        }
        
        
        [[super cellContentsArray] addObject:infoLabel];
        
        
        UIImageView *iconView = [[UIImageView alloc]
                                  initWithImage:[UIImage imageNamed:imageName]];
        
        imageFrame.origin.x = infoLabel.frame.origin.x - (imageFrame.size.width * 1.3);
        
        iconView.frame = imageFrame;
        
        [[super cellContentsArray] addObject:iconView];
        
    }
    

    [[super cellContentsArray] addObject:imageView];
    [[super cellContentsArray] addObject:goToRoute];
    
    [[self routeTableView] reloadData];
    
}


-(NSArray *)getHistoryOfThisRoute {
    
    int timeInSeconds = 0, calories = 0, points = 0, timesDone = 0;
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TrajectoryFile"];
    NSError *error;
    
    NSArray *routesHistory = [context executeFetchRequest:request error:&error];
    
    for(TrajectoryFile *file in routesHistory) {
        
        if([file.trajectoryName isEqualToString:[[self openRoute] trajectoryName]]) {
            
            timesDone++;
            
            //INSERT HERE CALORIES AND POINTS
            //*******************************
            timeInSeconds += file.duration.intValue;
            
        }
        
    }
    
    if(timesDone != 0) {
        
        timeInSeconds /= timesDone;
        calories /= timesDone;
        points /= timesDone;
    }
    
    
    //Return an array with calories, distance, time and points
    return @[[NSNumber numberWithInt:calories],[[self openRoute] trajectoryDistance],[NSNumber numberWithInt:timeInSeconds],[NSNumber numberWithInt:points]];
    
}


-(void)performSelectedRoute: (UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RunningMapVC *myVC = (RunningMapVC *)[storyboard instantiateViewControllerWithIdentifier:@"runningMap"];
    
    //Receive the route to draw it
    [myVC receiveTrajectorySelected:[self openRoute]];
    [self.navigationController pushViewController:myVC animated:YES];
    
}

@end
