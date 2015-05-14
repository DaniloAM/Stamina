
//
//  UserDAOCloudKit.m
//  SoundEarth
//
//  Created by Felipe Costa Nascimento on 4/14/15.
//  Copyright (c) 2015 Joao Sisanoski. All rights reserved.
//

#import "UserDAOCloudKit.h"
#define USER_TABLE @"USER"
#import "ExceptionFactory.h"
@implementation UserDAOCloudKit

-(id)init{
    self = [super init];
    
    if (self) {
        
        
        //IF THE USER DOESN'T EXIST
    }
    
    return self;
}


-(void)saveUser:(User*)user newPhotoURL:(NSURL*)urlPhoto{
    [self caseSensitiveFix:user];
    [self updateUser:user withPhotoURL:urlPhoto];
}

-(void)checkCloudKitConnection{
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        if (accountStatus == CKAccountStatusNoAccount) {
            [self.delegate cloudKitConnected:0];
        }
        else {
            [self.delegate cloudKitConnected:1];
        }
    }];

}
-(void)checkEmail: (NSString *)email{
    CKContainer *defaultContainer = [CKContainer defaultContainer];
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"EMAIL = %@",[email lowercaseString]];
    CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:USER_TABLE predicate:predicate];
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if (!error) {
            if (results.count > 0) {
                [self.delegate cloudKitCheckEmail:1];
            }else{
                [self.delegate cloudKitCheckEmail:0];
            }
            
            
        }else{
            [self.delegate errorThrowed:error];
        }
        
    }];

}
-(void)createUser:(User*)newUser{
    [self caseSensitiveFix:newUser];
     
    CKContainer *defaultContainer = [CKContainer defaultContainer];
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"EMAIL = %@",newUser.email];
    CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:USER_TABLE predicate:predicate];
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if (!error) {
            if (results.count > 0) {
                [self.delegate saveUserFinished:NO user:nil];
                
            }else{
                [self insertUser:newUser];
            }
            
            
        }else{
            [self.delegate errorThrowed:error];
        }
        
    }];
    
    
}


-(void)caseSensitiveFix: (User *)users{
    users.email = [users.email lowercaseString];
}


-(void)insertUser:(User*)user{
    CKContainer *defaultContainer = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    //CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:uuid];
    CKRecord *record = [[CKRecord alloc] initWithRecordType:USER_TABLE];
    [record setObject:user.name forKey:@"FULL_NAME"];
    [record setObject:user.email forKey:@"EMAIL"];
    [record setObject:user.password forKey:@"PASSWORD"];
    [record setObject:user.nickname forKey:@"NICKNAME"];
    [record setObject:[NSNumber numberWithDouble:user.height] forKey:@"HEIGHT"];
    [record setObject:[NSNumber numberWithDouble:user.weight] forKey:@"WEIGHT"];
    [record setObject:[NSNumber numberWithDouble:user.sex] forKey:@"SEX"];
    [record setObject:user.birthday forKey:@"BIRTHDAY"];
    CKModifyRecordsOperation *modify  = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:[NSArray arrayWithObject:record] recordIDsToDelete:nil];
    modify.perRecordProgressBlock = ^(CKRecord *record, double progress) {
        if (progress <= 1) {
            NSLog(@"Save progress is: %f", progress);
        }
    };
    [modify setSavePolicy:CKRecordSaveAllKeys];
    modify.modifyRecordsCompletionBlock =  ^(NSArray *savedRecords, NSArray *deletedRecordIDs, NSError *error) {
        if(!error){
            
            user.idUser = record.recordID;
            
            [self.delegate saveUserFinished:YES user:user];
            NSLog(@"updated id: %@", user.idUser.recordName);
            
        }
        else {
            [self.delegate errorThrowed:error];
        }
        
    };
    [publicDatabase addOperation:modify];

    
}


-(void)getUser: (NSString *)identifier password:(NSString*)password{

    CKContainer *defaultContainer = [CKContainer defaultContainer];
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"EMAIL == %@ && PASSWORD == %@",identifier, password];
    CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:USER_TABLE predicate:predicate];

    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {

        if (!error) {
            if (results.count > 0) {
                CKRecord *queryResult = [results objectAtIndex:0];
                User *user = [[User alloc] init];
                user.idUser = queryResult.recordID;
                user.name = [queryResult objectForKey:@"FULL_NAME"];
                user.email = [queryResult objectForKey:@"EMAIL"];
                user.password = [queryResult objectForKey:@"PASSWORD"];
                [self.delegate getUserWithPasswordFinished:user password:password];
            
            }else{

                [self.delegate getUserWithPasswordFinished:nil password:password ];
            }
            

        }else{
            [self.delegate errorThrowed:error];
        }
        
        

    }];
}


-(void)getUserWithID:(CKRecordID*)idUser{
        CKContainer *defaultContainer = [CKContainer defaultContainer];
        //NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"ID_USER = %@",userId];
        CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
       // CKQuery *query = [[CKQuery alloc] initWithRecordType:PROJECT_TABLE predicate:predicate];
    
    [publicDatabase fetchRecordWithID:idUser completionHandler:^(CKRecord *record, NSError *error) {
        if (!error) {
            User *user = [[User alloc] init];
            user.idUser = record.recordID;
            user.name = [record objectForKey:@"FULL_NAME"];
            user.email = [record objectForKey:@"EMAIL"];
            user.password = [record objectForKey:@"PASSWORD"];
          
            
            [self.delegate getUserFinished:user];
            
        }else{
            [self.delegate errorThrowed:error];
        }
        
    }];
    
}


-(void)getUserWithEmail:(NSString*)email password:(NSString*)password{
    [self getUser:email password:password];
}


-(void)updateUser:(User *)user withPhotoURL:(NSURL*)photoURL{
    CKContainer *defaultContainer = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    

    [publicDatabase fetchRecordWithID:user.idUser completionHandler:^(CKRecord *record, NSError *error) {
        if(!error){
            NSLog(@"%@", error);
            
            
            [record setObject:user.name forKey:@"FULL_NAME"];
            [record setObject:user.email forKey:@"EMAIL"];
            
            
            //users.idUser = record.recordID;
            [publicDatabase saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
                [self.delegate saveUserFinished:YES user:user];
            }];
            
            NSLog(@"updated id: %@", user.idUser.recordName);
        }
        else {
            [self.delegate errorThrowed:error];
        }

    }];
      
}

@end
