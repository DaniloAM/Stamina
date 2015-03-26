//
//  CriaTreinoVC.m
//  Stamina
//
//  Created by JOAO LUCAS BISCAIA SISANOSKI on 21/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "CriaTreinoVC.h"

@interface CriaTreinoVC ()

@end

@implementation CriaTreinoVC

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    UserData *user = [UserData alloc];
    
    
    if([user offlineMode]){
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Modo Offlinne" message:@"Não é possível criar treino no modo Offilne" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.navigationItem setTitle:@"Criar Treino"];
    _indexPath = Nil;
    _selected =1;
    [self setInicio:nil];
    [self.view setBackgroundColor:[UIColor staminaYellowColor]];
    _trainoNomeTxt.delegate = self;
    _tableExercicios.rowHeight = 30;
    _tableExercicios.delegate = self;
    _tableExercicios.dataSource = self;
    _tableExercicios.backgroundColor = [UIColor clearColor];
    _arrayOfDays = [NSMutableArray array];
    for(int x = 0 ; x < 7; x++){
        NSNumber *num = [NSNumber numberWithInt:0];
        [_arrayOfDays addObject:num];
    }
    [_btnDias setBackgroundColor:[UIColor staminaBlackColor]];
    [_btnExercicio setBackgroundColor:[UIColor staminaBlackColor]];
    [[self viewDays] setBackgroundColor:[UIColor staminaBlackColor]];
    [self viewDays].layer.cornerRadius =7;
    for(UIView *btn in [[self viewDays] subviews]){
        if([btn isKindOfClass:[UIButton class]]){
            [btn layer].cornerRadius = 7;
            [btn.layer setBorderWidth:1.0f];
            [btn layer].borderColor = [UIColor staminaYellowColor].CGColor;
        }
    }
    //    _inicioHoraTxt.layer.cornerRadius =7;
    //    _trainoNomeTxt.layer.cornerRadius = 7;
    _tableExercicios.backgroundColor = [UIColor staminaBlackColor];
    [self.tableExercicios layer].cornerRadius = 10;
    [self preload];

}
-(void)function2{
    CreateTrainTemp *temp = [CreateTrainTemp alloc];
    [[temp arrayOfExercises] removeAllObjects];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ExercicioTVC *myVC;
    myVC= (ExercicioTVC *)[storyboard instantiateViewControllerWithIdentifier:@"CategoriaTVC"];
    [myVC setCreateTraining:1];
    [self.navigationController pushViewController:myVC animated:YES];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(NSNumber *)checkAndChange: (NSNumber *)number andButton :(UIButton *)btn{
    int x = [number intValue];
    if(x ==1){
        [btn setBackgroundColor:[UIColor staminaBlackColor]];
        [btn layer].borderColor = [UIColor staminaYellowColor].CGColor;
        [btn setTitleColor:[UIColor staminaYellowColor] forState:UIControlStateNormal];
        return [NSNumber numberWithInt:0];
        
    }
    else{
        [btn setBackgroundColor:[UIColor staminaYellowColor]];
        [btn layer].borderColor = [UIColor staminaBlackColor].CGColor;
        [btn setTitleColor:[UIColor staminaBlackColor] forState:UIControlStateNormal];
        return [NSNumber numberWithInt:1];
    }
}
-(IBAction)seg : (UIButton *)sender{
    [[self arrayOfDays] replaceObjectAtIndex:1 withObject:[self checkAndChange:[[self arrayOfDays] objectAtIndex:1] andButton:sender]];
    
    
}
-(IBAction)ter: (UIButton *)sender{
    [[self arrayOfDays] replaceObjectAtIndex:2 withObject:[self checkAndChange:[[self arrayOfDays] objectAtIndex:2] andButton:sender]];
    ;
    
}
-(IBAction)qua: (UIButton *)sender{
    [[self arrayOfDays] replaceObjectAtIndex:3 withObject:[self checkAndChange:[[self arrayOfDays] objectAtIndex:3] andButton:sender]];
    
    
}
-(IBAction)qui: (UIButton *)sender{
    [[self arrayOfDays] replaceObjectAtIndex:4 withObject:[self checkAndChange:[[self arrayOfDays] objectAtIndex:4] andButton:sender]];
    
    
}
-(IBAction)sex: (UIButton *)sender{
    [[self arrayOfDays] replaceObjectAtIndex:5 withObject:[self checkAndChange:[[self arrayOfDays] objectAtIndex:5] andButton:sender]];
    
    
}
-(IBAction)sab: (UIButton *)sender{
    [[self arrayOfDays] replaceObjectAtIndex:6 withObject:[self checkAndChange:[[self arrayOfDays] objectAtIndex:6] andButton:sender]];
    
    
}
-(IBAction)dom: (UIButton *)sender{
    [[self arrayOfDays] replaceObjectAtIndex:0 withObject:[self checkAndChange:[[self arrayOfDays] objectAtIndex:0] andButton:sender]];
    
    
}
-(void)displayAlertWithString: (NSString *)str comCabecalho: (NSString *)cabe{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:cabe message:str delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)function1{
    CreateTrainTemp *create = [CreateTrainTemp alloc];
    
    if([[create exercise] count]==0){
        [self displayAlertWithString:@"Adicione algum exercício na lista" comCabecalho:@"Erro"];
        return;
    }
    if([self trainoNomeTxt].text.length==0){
        [self displayAlertWithString:@"Seu treino precisa de algum nome" comCabecalho:@"Erro"];

        return;
    }
    if([self hasTrainingWithName:[self trainoNomeTxt].text]){
        [self displayAlertWithString:@"Ja existe um treino com esse nome" comCabecalho:@"Escolha outro nome"];
        return;
    }
    BOOL hasDay = false;
    for (int x =0 ; x< [[self arrayOfDays] count]; x++) {
        if([[[self arrayOfDays] objectAtIndex:x] boolValue]){
            hasDay=true;
            break;
        }
    }
    if(!hasDay){
        [self displayAlertWithString:@"Adicione algum dia para fazer o exercicio" comCabecalho:@"Erro"];
        return;
    }
    [self performSelectorInBackground:@selector(saveTraining) withObject:self];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)saveTraining{
    CalendarObject *calendarObject = [CalendarObject alloc];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    CreateTrainTemp *create = [CreateTrainTemp alloc];
    NSError *error;
    for (int x = 0 ; x < [[create exercise] count];x++){
        TrainingExercises *newTraining = [NSEntityDescription insertNewObjectForEntityForName:@"TrainingExercises" inManagedObjectContext:context];
        ExerciseTemporary *exerc = [[create exercise] objectAtIndex:x];
        Exercises *exercise = [exerc exercicio];
        int x = [[exercise  exerciseID] intValue];
        NSNumber *number = [NSNumber numberWithInt:x];
        [newTraining setId_exercise:number];
        [newTraining setTraining_name:[self.trainoNomeTxt text]];
        [newTraining setSeries:[NSNumber numberWithInteger:exerc.serie]];
        [newTraining setTime:[NSNumber numberWithInteger:exerc.segundos+exerc.minutos*60]];
        [newTraining setRepetitions:[NSNumber numberWithInteger:exerc.repeticoes]];
        [context save:&error];
    }
   [WebServiceResponse insereTreinoWithName:[self trainoNomeTxt].text andDays:[self arrayOfDays] andstartDate:[self startDate].date andFinalDate:[self finalDate].date andHour:[self datepicker].date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date = [NSDate dateWithTimeInterval:0 sinceDate:[self startDate].date];
    
    NSDateComponents *comp = [calendar components:NSCalendarUnitWeekday fromDate:date];
    NSDateComponents *addDay = [[NSDateComponents alloc] init];
    comp = comp;
    [addDay setDay:1];
    [create setExercise:Nil];
    for(;;) {
        
        comp = [calendar components:NSCalendarUnitWeekday fromDate:date];
        
        if([[[self arrayOfDays] objectAtIndex:comp.weekday-1] boolValue]) {
            [calendarObject scheduleTrainingNamed:[self trainoNomeTxt].text inDate:date];
        }
        
        date = [calendar dateByAddingComponents:addDay toDate:date options:0];
        
        if([[self finalDate].date compare:date] == NSOrderedAscending)
            break;
        
    }
    
}
-(void)veTodosOsTreinosSalvos: (NSString *)str{
//    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = [delegate managedObjectContext];
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TrainingExercises"];
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"training_name=%@",str];
//    [request setPredicate:pred];
//    NSError *error;
//    NSArray *obj = [context executeFetchRequest:request error:&error];
//    
//    for(int x=0 ; x < [obj count];x++){
//        TrainingExercises  *str = [obj objectAtIndex:x];
//        
//    }
}
-(BOOL)hasTrainingWithName: (NSString *)str{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Training"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(trainingName = %@)", str];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if([array count]!=0)
        return YES;
    return NO;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.trainoNomeTxt resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}
-(IBAction)btn1 : (UIButton *)sender{
    _selected = 0;
    
    [self atualiza];
}
-(IBAction)btn2 : (UIButton *)sender{
    _selected = 1;
    [self atualiza];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CreateTrainTemp *tem = [CreateTrainTemp alloc];
    
    return [[tem exercise] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier;
    CreateTrainTemp *temp = [CreateTrainTemp  alloc];
    ExerciseTemporary *exerc = [[temp exercise] objectAtIndex:indexPath.row];
    Exercises *exercise = [exerc exercicio];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSString *str;
    if([exerc time]){
        str = [NSString stringWithFormat:@"%d. %@ - %02d:%02d",(int)indexPath.row+1,[exercise name],(int)[exerc minutos],(int)[exerc segundos]];
        
    }
    else {
        str = [NSString stringWithFormat:@"%d. %@ - %02d x %02d",(int)indexPath.row+1,[exercise name] ,(int)[exerc serie],(int)[exerc repeticoes]];
        
    }
    cell.textLabel.text = str;
    [cell.textLabel setFont:[UIFont fontWithName:@"Lato" size:16]];
    cell.textLabel.textColor = [UIColor staminaYellowColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}
-(UIDatePicker *)criaRetornaPicker{
    UIDatePicker *temp = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 250, 200)];
    return temp;
}
-(void)preload{
    [[self trainoNomeTxt] layer].cornerRadius = 7;
    [[self btnDias] layer].cornerRadius =7;
    [[self btnExercicio] layer].cornerRadius =7;
    [[self inicioHoraTxt] layer].cornerRadius =7;
    [[self trainoNomeTxt] setPlaceholder:@"     Qual o nome do treino ?"];
    _datepicker =[self criaRetornaPicker];
    _datepicker.datePickerMode = UIDatePickerModeTime;
    _startDate = [self criaRetornaPicker];
    _finalDate = [self criaRetornaPicker];
    _startDate.datePickerMode = UIDatePickerModeDate;
    _finalDate.datePickerMode = UIDatePickerModeDate;
    [[self.buttonFinalDay titleLabel] setFont:[UIFont fontWithName:@"Lato" size:18]];
    [[self.buttonStartDate titleLabel] setFont:[UIFont fontWithName:@"Lato" size:18]];
    NSDate *currentDate = [NSDate date];
    _startDate.minimumDate = currentDate;
    _finalDate.minimumDate = currentDate;
    
    [_tableExercicios reloadData];
    
        [self atualiza];
    
}
-(void)function3{
    if(_indexPath==nil)
        return;
    CreateTrainTemp *temp = [CreateTrainTemp alloc];
    [[temp exercise] removeObjectAtIndex:_indexPath.row];
    _indexPath=nil;
    [_tableExercicios reloadData];
    [self hideBarWithAnimation:1];
}
-(void)viewWillAppear:(BOOL)animated{
    [self hideBarWithAnimation:1];
    
    [super viewWillAppear:animated];
    [self firstButtonMethod:@selector(function1)  fromClass:self withImage:[UIImage staminaIconOk]];
    [self secondButtonMethod:@selector(function2) fromClass:self  withImage:[UIImage staminaIconPlus]];
    [self thirdButtonMethod:@selector(function3) fromClass:self withImage:[UIImage staminaIconCancel]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(IBAction)horaInicial: (id)sender{
    [self launchDialog:sender];
}
-(IBAction)diaInicio: (id)sender{
    [self launchDialog:sender];
}
-(IBAction)diaFim: (id)sender{
    [self launchDialog:sender];
}


- (void)launchDialog:(id)sender
{   CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [alertView setContainerView:[self createDemoViewWithSender:sender]];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"OK",nil]];
    [alertView setDelegate:self];
        [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    [alertView show];
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSDate *myDate;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    UIButton *btn;
    switch (_whichView) {
        case 0:
            myDate = _datepicker.date;
            [dateFormat setDateFormat:@"HH:mm"];
            btn = _inicioHoraTxt;
            break;
        case 1:
            myDate = _finalDate.date;
            [dateFormat setDateFormat:@"dd/MM/yyyy"];
            btn = _buttonFinalDay;
            break;
        case 2:
            myDate = _startDate.date;
            [dateFormat setDateFormat:@"dd/MM/yyyy"];
            btn = _buttonStartDate;
            
            break;
            
        default:
            break;
    }
    NSString *dateString = [dateFormat stringFromDate:myDate];
    
    if([_startDate.date compare:_finalDate.date]==NSOrderedDescending){
        if(_whichView==1){
            [_buttonStartDate setTitle:dateString forState:UIControlStateNormal];
        }
        else {
            [_buttonFinalDay setTitle:dateString forState:UIControlStateNormal];
        }
    }
    [btn setTitle:dateString forState:UIControlStateNormal];
    [alertView close];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showBarWithAnimation:1];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath!=nil){
        UITableViewCell *cell2 = [tableView cellForRowAtIndexPath:_indexPath];
        cell2.alpha = 1;
    }
    _indexPath = indexPath;
    cell.alpha = 0.5;
    
}
-(void)atualiza{
    
    
    
    if(!_selected){
        [self viewDays].hidden = NO;
        [self btnDias].backgroundColor = [UIColor staminaBlackColor];
        [[self btnDias] setTitleColor:[UIColor staminaYellowColor] forState:UIControlStateNormal];
        
        [self btnExercicio].backgroundColor = [UIColor staminaYellowColor];
        [[self btnExercicio] setTitleColor:[UIColor staminaBlackColor] forState:UIControlStateNormal];
        [self tableExercicios].hidden = YES;
        [self viewAux2].backgroundColor = [UIColor staminaBlackColor];
        [self viewAux3].backgroundColor = [UIColor staminaYellowColor];
        self.viewAux5.hidden = NO;
        self.viewAux4.hidden = YES;
    }
    
    else {
        
        [self btnExercicio].backgroundColor = [UIColor staminaBlackColor];
        [[self btnExercicio] setTitleColor:[UIColor staminaYellowColor] forState:UIControlStateNormal];
        [self btnDias].backgroundColor = [UIColor staminaYellowColor];
        [[self btnDias] setTitleColor:[UIColor staminaBlackColor] forState:UIControlStateNormal];
        [self viewDays].hidden = YES;
        [self tableExercicios].hidden = NO;
        [self viewAux3].backgroundColor = [UIColor staminaBlackColor];
        [self viewAux2].backgroundColor = [UIColor staminaYellowColor];
        self.viewAux5.hidden = YES;
        self.viewAux4.hidden = NO;
    }
    
}
- (UIView *)createDemoViewWithSender:(UIButton *)btn
{
    if(btn==_inicioHoraTxt){
        _whichView = 0;
        return _datepicker;
    }
    else if (btn == _buttonFinalDay){
        _whichView = 1;
        return _finalDate;
    }
    else if (btn == _buttonStartDate){
        _whichView = 2;
        return _startDate;
        
    }
    
    return _datepicker;
}



@end
