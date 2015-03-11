//
//  AddExerciseVC.m
//  Stamina
//
//  Created by João Lucas Sisanoski on 18/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "AddExerciseVC.h"

@interface AddExerciseVC ()

@end

@implementation AddExerciseVC
-(void)preload{
    Exercises *temp = [self.arrayOfExercises firstObject];
    [self carregaCom:temp];
    [self.bigView setBackgroundColor:[UIColor staminaBlackColor]];
    [self.bigView layer].cornerRadius = 7;
    [self changeBarNameWith:[temp name]];
    [self setFullArray:[NSMutableArray array]];
    [self setSelected:TIMER];
    [self changeCronometerImage];
    [self txt1].font = [UIFont fontWithName:@"Lato" size:30];
    [self txt2].font = [UIFont fontWithName:@"Lato" size:30];
    [self txt3].font = [UIFont fontWithName:@"Lato" size:30];
    [self setStack:[NSMutableArray array]];
    [[self stack] addObject:@"0"];
    [[self stack] addObject:@"0"];
    [[self stack] addObject:@"0"];
    [[self stack] addObject:@"0"];
    
    _txt1.keyboardType = UIKeyboardTypeNumberPad;
    _txt2.keyboardType = UIKeyboardTypeNumberPad;
    _txt3.keyboardType = UIKeyboardTypeNumberPad;

    [self.txt1 setDelegate:self];
    [self.txt2 setDelegate:self];
    [self.txt3 setDelegate:self];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.txt1 setPlaceholder:@"Ser"];
    [self.txt2 setPlaceholder:@"Rep"];
    [self.txt3 setPlaceholder:@"Seg"];
    [self.txt1 setTextAlignment:NSTextAlignmentCenter];
    [self.txt2 setTextAlignment:NSTextAlignmentCenter];
    [self.txt3 setTextAlignment:NSTextAlignmentCenter];
    [self.lblX setTextColor:[UIColor staminaYellowColor]];
    [_txt3 addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self performSelectorInBackground:@selector(changeImage) withObject:self];
    [self carregaTime];
}
-(void)changeImage{
    NSString *str = [NSString stringWithFormat:@"%@_%02d.png",[self exeCurrent].exerciseID,_currentPic];
    [[self imageExplain] setImage:[UIImage imageNamed:str]];
    _currentPic++;
    if(_currentPic >= [_exeCurrent.numberImages intValue])
        _currentPic=0;
    [self performSelector:@selector(changeImage) withObject:self afterDelay:0.2];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self preload];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];

    int isBackSpace = strcmp(_char, "\b");
    if(textField==_txt3){
        if (isBackSpace == -8) {
            [self setHasSpace:YES];
        }
        else{
            [self setHasSpace:NO];
        }
        return YES;
    }
    return YES;

}
-(void)textFieldDidChange{
    NSString *code = [_txt3.text substringFromIndex: [_txt3.text length] - 1];

    if(_hasSpace){
        [[self stack]replaceObjectAtIndex:3 withObject:[[self stack] objectAtIndex:2]];
        [[self stack]replaceObjectAtIndex:2 withObject:[[self stack] objectAtIndex:1]];
        [[self stack]replaceObjectAtIndex:1 withObject:[[self stack] objectAtIndex:0]];
        [[self stack]replaceObjectAtIndex:0 withObject:@"0"];
        
    }
    else{
        [[self stack] addObject:code];
        [[self stack] removeObjectAtIndex:0];
    
    }_hasSpace = 0;
    [self carregaTime];
   }
-(void)carregaTime{
    NSString *strFormar = [NSString stringWithFormat:@"%d%d:%d%d", [[[self stack] objectAtIndex:0] intValue],[[[self stack] objectAtIndex:1] intValue],[[[self stack] objectAtIndex:2] intValue],[[[self stack] objectAtIndex:3] intValue]];
    [[self txt3] setText:strFormar];

}
-(void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    [self moveView:self.view withPoint:CGPointMake(0, -keyboardFrameBeginRect.size.height) withDuration:0.3];
}
-(void)keyboardWillHide:(NSNotification*)notification{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    NSLog(@"pro %f", self.view.frame.origin.y+keyboardFrameBeginRect.size.height);

    [self moveView:self.view withPoint:CGPointMake(0,64) withDuration:0.3];
    
}
-(void)moveView: (UIView *)bigView withPoint: (CGPoint )point withDuration: (float)duration{
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:duration];
    bigView.frame = CGRectMake(point.x, point.y, bigView.frame.size.width, bigView.frame.size.height);
    [UIView commitAnimations];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setTranslucent:NO];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self firstButtonMethod:@selector(callStart) fromClass:self withImage:[UIImage staminaIconHome]];
    [self secondButtonMethod:@selector(explain) fromClass:self withImage:[UIImage staminaIconIdea]];
    [self thirdButtonMethod:@selector(addExercise) fromClass:self withImage:[UIImage staminaIconPlus]];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)callStart{
    [self.navigationController.navigationBar setTranslucent:NO];
    CreateTrainTemp *temp = [CreateTrainTemp alloc];
    [temp setArrayOfExercises:nil];
    [temp setExercise:Nil];
    [self popToRoot];
}
-(void)explain{
    TipsVC *temp = (TipsVC *)[self returnViewWithName:@"TipsVC"];
    [temp setExercise:_exeCurrent];
    [self callView:temp];
}
-(void)addExercise{
    ExerciseTemporary *new = [[ExerciseTemporary alloc] init];
    if(!_selected== TIMER){
        if(self.txt3.text.length==0|| [self.txt3.text isEqualToString:@"00:00"])
            return;
        [new setRepeticoes:0];
        [new setSerie:0];
        NSString *horas = [NSString stringWithFormat:@"%@%@", [[self stack] objectAtIndex:0],[[self stack] objectAtIndex:1]];
        [new  setMinutos:[horas integerValue]];
        NSString *min = [NSString stringWithFormat:@"%@%@", [[self stack] objectAtIndex:2],[[self stack] objectAtIndex:3]];
        [new  setSegundos:[min integerValue]];

    }
    else {
        
        if(self.txt2.text.length==0)
            return;
        if(self.txt1.text.length==0)
            return;
        [new setRepeticoes:[[self.txt2 text] integerValue]];
        [new setSerie:[[self.txt1 text] integerValue]];
        [new setSegundos:0];
        [new setMinutos:0];
        
    }
    
    [new setExercicio:[self.arrayOfExercises firstObject]];
    [self.arrayOfExercises removeObject:[self.arrayOfExercises firstObject]];
    [new setTime:_selected];
    [self.fullArray addObject:new];
    if([self.arrayOfExercises count]==0){
        CreateTrainTemp *cre = [CreateTrainTemp alloc];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[cre exercise]];
        [array addObjectsFromArray:[self fullArray]];
        [cre setExercise:[NSMutableArray arrayWithArray:array]];
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:3] animated:YES];
        return;
    }
    [self carregaCom:[self.arrayOfExercises firstObject]];
    [self cleanTxt];
}
-(void)cleanTxt{
    [self.txt1 setText:nil];
    [self.txt2 setText:nil];
    [self.txt3 setText:@"00:00"];
    
}
-(void)carregaCom: (Exercises *)exe{
    _exeCurrent = exe;
    [self.labelCategory setText:[ExercisesList returnCategoryNameWithId:[[exe exerciseID] intValue]]];
    [self.labelExercise setText:[exe name]];

}
-(void)changeCronometerImage{
    [self.imageCronometer setBackgroundColor:[UIColor staminaBlackColor]];
    [self addImage:[UIImage staminaIconTime] toButton:self.imageCronometer];
    [self.imageSeries setBackgroundColor:[UIColor staminaYellowColor]];
    [self addImage:[UIImage staminaIconSerieSel] toButton:self.imageSeries];
    [self setSelected:TIMER];
    [self addRightSideViewToBtn:self.imageCronometer];
    [self addLeftSideViewToBtnAttTop:self.bigView];
    [self.txt2 setHidden:NO];
    [self.txt1 setHidden:NO];
    [self.txt3 setHidden:YES];
    [self.lblX setHidden:NO];


}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField ==_txt1||textField ==_txt2){
        if([[textField text] integerValue]>50)
            [textField setText:@"50"];
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%d%d", [[[self stack] objectAtIndex:2] intValue],[[[self stack] objectAtIndex:3] intValue]];
    if([str intValue]>=60){
        [[self stack] replaceObjectAtIndex:2 withObject:@"5"];
        [[self stack] replaceObjectAtIndex:3 withObject:@"9"];
        [self carregaTime];
    }
    
}
-(IBAction)cronometer{
    [self changeCronometerImage];
}
-(void)addRightSideViewToBtn: (UIButton *)btn{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(btn.frame.size.width-6, 0, 6, btn.frame.size.height)];
    [view setBackgroundColor:[UIColor staminaBlackColor]];
    [btn addSubview:view];
}
-(IBAction)ser{
    [self.imageCronometer setBackgroundColor:[UIColor staminaYellowColor]];
    [self addImage:[UIImage staminaIconSerie] toButton:self.imageSeries];
    [self.imageSeries setBackgroundColor:[UIColor staminaBlackColor]];
    [self addImage:[UIImage staminaIconTimeSelected] toButton:self.imageCronometer];
    [self setSelected:SERIES];
    [self addRightSideViewToBtn:self.imageSeries];
    [self addLeftSideViewToBtnAttBot:self.bigView];
    [self.txt2 setHidden:YES];
    [self.txt1 setHidden:YES];
    [self.lblX setHidden:YES];
    [self.txt3 setHidden:NO];
}
-(void)addLeftSideViewToBtnAttTop: (UIView *)btn{
    for(UIView *vi in btn.subviews)
        [vi removeFromSuperview];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, btn.frame.size.height/2)];
    [view setBackgroundColor:[UIColor staminaBlackColor]];
    [btn addSubview:view];
}
-(void)addLeftSideViewToBtnAttBot: (UIView *)btn{
    for(UIView *vi in btn.subviews)
        [vi removeFromSuperview];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height/2, 15, btn.frame.size.height/2)];
    [view setBackgroundColor:[UIColor staminaBlackColor]];
    [btn addSubview:view];
}

@end
