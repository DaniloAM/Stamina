//
//  User.h
//  SoundEarth
//
//  Created by Felipe Costa Nascimento on 4/14/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import <UIKit/UIKit.h>
@interface User : NSObject

//REQUIRED
@property (nonatomic) CKRecordID *idUser;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *nickname;
@property (nonatomic) NSString *password;
@property (nonatomic) NSInteger weight;
@property (nonatomic) NSDate *birthday;
@property (nonatomic) NSInteger height;
@property (nonatomic) BOOL sex;

//OPTIONAL

@end
