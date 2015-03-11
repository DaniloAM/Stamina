//
//  ConfiguracoesVC.h
//  Stamina
//
//  Created by João Lucas Sisanoski on 26/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "HideBBVC.h"
#import "UserData.h"
@interface ConfiguracoesVC : HideBBVC <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property UISegmentedControl *segIdioma, *segAlerta;
@property UISwitch *swiProx;
@property UITextField *txtPeso, *txtAltura;
@property UIView *scrollView;
@property UIDatePicker *datePicker;
@property UILabel *lbl;
@end
