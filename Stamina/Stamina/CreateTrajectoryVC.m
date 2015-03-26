//
//  CreateTrajectoryVC.m
//  Stamina
//
//  Created by Danilo Mative on 23/03/15.
//  Copyright (c) 2015 Danilo Augusto Mative. All rights reserved.
//

#import "CreateTrajectoryVC.h"

#define radius 12.0

@interface CreateTrajectoryVC ()

@end

@implementation CreateTrajectoryVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDistanceSelected:true];
    [self selectTime];
    [self setSerieKit:[[SerieKit alloc] init]];
    
    [[self serieTableView] setDelegate:self];
    [[self serieTableView] setDataSource:self];
    
    [[self valueTextField] setDelegate:self];
    [[self nameTextField] setDelegate:self];
    
    [[self timeBackground] layer].cornerRadius = radius;
    [[self timeBackground] setClipsToBounds:true];
    [[self distanceBackground] layer].cornerRadius = radius;
    [[self distanceBackground] setClipsToBounds:true];
    [[self valueBackground] layer].cornerRadius = radius;
    [[self valueBackground] setClipsToBounds:true];
    [[self valueTextField] setClipsToBounds:true];
    [[self valueTextField] layer].cornerRadius = radius;
    [[self nameTextField] setClipsToBounds:true];
    [[self nameTextField] layer].cornerRadius = radius;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)selectDistance {
    if([self distanceSelected]) {
        return;
    }
    
    [self setDistanceSelected:true];
    
    [[self valueTextField] setPlaceholder:@"100 m"];
    
    [[self timeBackground] setHidden:true];
    [[self timeRect] setHidden:true];
    
    [[self distanceBackground] setHidden:false];
    [[self distanceRect] setHidden:false];
    
    [[self distanceRect2] setHidden:false];
    [[self timeRect2] setHidden:true];
    
    [[self distanceIcon] setImage:[UIImage imageNamed:@"icone_tempo.png"]];
    [[self timeIcon] setImage:[UIImage imageNamed:@"s_icone_tempo.png"]];
    
}

-(IBAction)selectTime {
    if(![self distanceSelected]) {
        return;
    }
    
    [self setDistanceSelected:false];
    
    [[self valueTextField] setPlaceholder:@"10 s"];
    
    [[self timeBackground] setHidden:false];
    [[self timeRect] setHidden:false];
    
    [[self distanceBackground] setHidden:true];
    [[self distanceRect] setHidden:true];
    
    [[self distanceRect2] setHidden:true];
    [[self timeRect2] setHidden:false];
    
    [[self distanceIcon] setImage:[UIImage imageNamed:@"s_icone_tempo.png"]];
    [[self timeIcon] setImage:[UIImage imageNamed:@"icone_tempo.png"]];
    
}

-(IBAction)saveSerie {
    
    if([[[self valueTextField] text] integerValue] <= 0) {
        return;
    }
    
    NSString *name;
    
    if(![[[self nameTextField] text] isEqualToString:@""]) {
        name = [[self nameTextField] text];
    }
    
    else {
        if([self distanceSelected]) {
            name = [NSString stringWithFormat:@"Distancia %d",(int) ([[[self serieKit] series] count] + 1)];
        }
        
        else {
            name = [NSString stringWithFormat:@"Tempo %d",(int) ([[[self serieKit] series] count] + 1)];
        }
    }
    
    NSInteger value = [[[self valueTextField] text] integerValue];
    NSInteger type = [self distanceSelected];
    
    SeriePart *part = [[SeriePart alloc] initWithValue:value andName:name forType:type];
    
    [[self serieKit] addSeriePart:part];
    
    [[self nameTextField] setText:@""];
    [[self valueTextField] setText:@""];
    
    [[self serieTableView] reloadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[self serieKit] series] count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *secondString;
    
    SeriePart *part = [[[self serieKit]series] objectAtIndex:indexPath.row];
    
    if(part.type == 0) {
        secondString = [NSString stringWithFormat:@"%02d:%02d", (int) part.value / 60, (int) part.value % 60];
    }
    
    else if(part.type == 1) {
        secondString = [NSString stringWithFormat:@"%dm", (int) part.value];
    }
    
    NSString *text = [NSString stringWithFormat:@"%@ - %@", part.name, secondString];
    
    cell.textLabel.text = text;
    cell.textLabel.font = [UIFont fontWithName:@"Lato" size:20.0];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(IBAction)test {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SeriesMapVC *myVC = (SeriesMapVC *)[storyboard instantiateViewControllerWithIdentifier:@"seriesMap"];
    
    //Receive the route to draw it
    [myVC receiveSerieKit:[self serieKit]];
    [self.navigationController pushViewController:myVC animated:YES];
    
}

@end
