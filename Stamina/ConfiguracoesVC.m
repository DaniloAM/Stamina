//
//  ConfiguracoesVC.m
//  Stamina
//
//  Created by João Lucas Sisanoski on 26/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "ConfiguracoesVC.h"
#define altura 1136
#define largura 640

@interface ConfiguracoesVC ()

@end

@implementation ConfiguracoesVC
-(void)preload{
    _scrollView = nil;
    [self.navigationItem setTitle:@"Configurações"];
    [self createTable];
       [self createSegAlerta];
    [self createSegIdioma];
    [self createSwiProx];
    [self createTxtAltura];
    [self createTxtPeso];
    [self createDatePicker];
    [self.view setBackgroundColor:[UIColor staminaBlackColor]];
}
-(void)createTable{
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.backgroundColor = [UIColor clearColor];
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.table.alwaysBounceVertical = NO;

}
-(void)createSegAlerta{
    UserData *user = [UserData alloc];

    [self setSegAlerta:[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Vibrar",@"Som",@"Ambos", nil]]];
    [[self segAlerta] setTintColor:[UIColor staminaYellowColor]];
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Lato" size:10], NSFontAttributeName, nil];

    [self.segAlerta setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    self.segAlerta.selectedSegmentIndex = user.alerta;

    [[self segAlerta] addTarget:self action:@selector(alertaSeg:) forControlEvents:UIControlEventAllEvents];

}
-(void)createSegIdioma{
    UserData *user = [UserData alloc];

    [[self segIdioma] addTarget:self action:@selector(idiomaSeg:) forControlEvents:UIControlEventAllEvents];
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Lato" size:10], NSFontAttributeName, nil];

    [self setSegIdioma:[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"PT",@"EN",@"ES", nil]]];
    [[self segIdioma] setTintColor:[UIColor staminaYellowColor]];
    [self.segIdioma setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    self.segIdioma.selectedSegmentIndex = user.language;

}
-(void)createSwiProx{
    UserData *user = [UserData alloc];

    [self setSwiProx:[[UISwitch alloc] init]];
    [self swiProx].onTintColor = [UIColor staminaYellowColor];
    [self swiProx].tintColor = [UIColor whiteColor];
    [self swiProx].on = [user nextExercise];
    [[self swiProx] addTarget:self action:@selector(proxSwi:) forControlEvents:UIControlEventAllEvents];

}
-(void)createTxtAltura{
    CGSize size = [UIScreen mainScreen].bounds.size;

    [self setTxtAltura:[[UITextField alloc] initWithFrame:CGRectMake(0,0+self.navigationController.navigationBar.frame.size.height, size.width*0.3, 73*size.height/altura)]];

    UserData *user = [UserData alloc];

    _txtAltura.delegate = self;
    [_txtAltura setBackgroundColor:[UIColor whiteColor]];
    _txtAltura.layer.cornerRadius = 7;
    _txtAltura.textAlignment = NSTextAlignmentCenter;
    [_txtAltura setFont:[UIFont fontWithName:@"Lato" size:18]];
    _txtAltura.text = [NSString stringWithFormat:@"%d CM", [user heightInCentimeters]];

}
-(void)createTxtPeso{
    CGSize size = [UIScreen mainScreen].bounds.size;

    [self setTxtPeso:[[UITextField alloc] initWithFrame:CGRectMake(0, 73*size.height/altura+15+self.navigationController.navigationBar.frame.size.height, size.width*0.3, 73*size.height/altura)]];

    UserData *user = [UserData alloc];
    _txtPeso.delegate = self;
    [_txtPeso setBackgroundColor:[UIColor whiteColor]];
    _txtPeso.layer.cornerRadius = 7;
    _txtPeso.textAlignment = NSTextAlignmentCenter;
    [_txtPeso setFont:[UIFont fontWithName:@"Lato" size:18]];
    _txtPeso.text = [NSString stringWithFormat:@"%d KG", [user weightInKilograms]];

}
-(void)createDatePicker{
    
    UIDatePicker *picker1   = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 21)];
    [picker1 setDatePickerMode:UIDatePickerModeCountDownTimer];
    picker1.backgroundColor = [UIColor whiteColor];
    [picker1 addTarget:self action:@selector(startDateSelected:) forControlEvents:UIControlEventValueChanged];
    _datePicker = picker1;
    _datePicker.layer.cornerRadius = 30;
}
- (void)startDateSelected:(id)sender
{   UserData *user = [UserData alloc];

    NSDate *date = [sender date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    [user setTimeAlarmBeforeTraining:hour*60+minute];
    [_lbl setText:[NSString stringWithFormat:@"  Lembrete                                         %02ldh:%02ldm",(long)hour,(long)minute]];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSString *newStr;
    
    newStr = [textField.text substringToIndex:[textField.text length]-3];
    textField.text = newStr;
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    UserData *data = [UserData alloc];
    NSString *newStr;

    if(textField == _txtAltura){
        if([textField.text intValue]>210)
            textField.text = @"210 KG";
        else
            textField.text = [NSString stringWithFormat:@"%@ KG", textField.text];
        newStr = [textField.text substringToIndex:[textField.text length]-3];

        [data setWeightInKilograms:[newStr intValue]];
    }

    if(textField == _txtPeso){
        if([textField.text intValue]>220)
            textField.text = @"220 CM";
        else
            textField.text = [NSString stringWithFormat:@"%@ CM", textField.text];
        newStr = [textField.text substringToIndex:[textField.text length]-3];

        [data setHeightInCentimeters:[newStr intValue]];
    }
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self preload];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)alertaSeg:(UISegmentedControl *)seg{
    UserData *user = [UserData alloc];
    [user setAlerta:(int)[seg selectedSegmentIndex]];
}
-(void)proxSwi:(UISwitch *)swi{
    UserData *user = [UserData alloc];
    [user setNextExercise: swi.on];

}
-(void)idiomaSeg:(UISegmentedControl *)seg{
    UserData *user = [UserData alloc];

    [user setLanguage:(int)[seg selectedSegmentIndex]];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGRect rect = [self.table  frame];
    rect.origin.y = self.navigationController.navigationBar.frame.size.height-44;
    [self.table setFrame:rect];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    UIView *vew = nil;
      if(indexPath.row==3+1){
        CGPoint p = [self swiProx].center;
        p.y = cell.frame.size.height/2;
        [self swiProx].center = p;
          vew = self.swiProx;
    }
    else if (indexPath.row ==1+1){
        CGPoint p = [self segIdioma].center;
        p.y = cell.frame.size.height/2;
        [self segIdioma].center = p;
        vew = self.segIdioma;
    }
    else if (indexPath.row ==2+1){
       // self.segAlerta.segmentedControlStyle = UISegmentedControlStyleBar;
        CGPoint p = [self segAlerta].center;
        p.y = cell.frame.size.height/2;
        [self segAlerta].center = p;
        
        vew = self.segAlerta;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    NSString *text = [self returnStringToIndex:(int)indexPath.row-1];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [lbl setText:text];
    lbl.font = [UIFont fontWithName:@"Lato" size:15.0];
    lbl.textColor=[UIColor staminaYellowColor];
    if(vew){
        [vew setFrame:CGRectMake(cell.frame.size.width*0.9-vew.frame.size.width, vew.frame.origin.y, vew.frame.size.width, vew.frame.size.height)];
        [cell addSubview:vew];
    
    }
    [cell addSubview:lbl];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row==1)
        _lbl=lbl;
    return cell;
}
-(void)criaScrollView: (UITableViewCell *)cell{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 7*cell.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-7*cell.frame.size.height)];
    CGPoint p = [self scrollView].center;
    CGPoint q = [self txtPeso].center;
    q.x = p.x;
    [_scrollView addSubview:[self txtPeso]];
    _txtPeso.center = q;
    q = [self txtAltura].center;
    q.x = p.x;
    [_scrollView addSubview:[self txtAltura]];
    _txtAltura.center = q;
    [self.view addSubview:_scrollView];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    [self.txtAltura resignFirstResponder];
    [self.txtPeso resignFirstResponder];
    if(indexPath.row==1){
        [self.datePicker setFrame:CGRectMake(0, self.view.frame.size.height-self.datePicker.frame.size.height, self.datePicker.frame.size.width, self.datePicker.frame.size.height)];
        [self.view addSubview:self.datePicker];
        return;
    }
    else if(indexPath.row==5){
        if(![self scrollView]){
            [self criaScrollView:[tableView cellForRowAtIndexPath:indexPath]];
        }
        
        [self clean];
        
        [self.view addSubview:self.scrollView];
        return;
    }
    else if (indexPath.row ==6){
        [self clean];
        
        return;
    }
    else if (indexPath.row ==7){
    [self clean];
    return;
    }
    [self clean];
}
-(void)clean{
    for(UIView *view in self.view.subviews){
        if(![view isKindOfClass:[UITableView class]])
            [view removeFromSuperview];
    }
}
-(NSString *)returnStringToIndex: (int)x{
    UserData *user = [UserData alloc];
    
    switch (x) {
        case 0:

            return [NSString stringWithFormat:@"  Lembrete                                         %02dh:%02dm", (int)[user timeAlarmBeforeTraining]/60,(int)[user timeAlarmBeforeTraining]%60];
        case 1:
            return @"  Idioma";
        case 2:
            return @"  Alerta";
        case 3:
            return @"  Próximo exercício";
        case 4:
            return @"  Atualizar Info. Físicas";
        case 5:
            return @"  Redefinir Info. Pessoais";
        case 6:
            return @"  Sugestão";
            
}
    return nil;
}
@end
