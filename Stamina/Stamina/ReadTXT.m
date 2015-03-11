//
//  ReadTXT.m
//  Stamina
//
//  Created by João Lucas Sisanoski on 07/12/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "ReadTXT.h"

@implementation ReadTXT
-(void)criaBancoDeDados{
    NSString* filePath = [NSString stringWithFormat:@"exercises"];
    NSString* fileRoot = [[NSBundle mainBundle]
                          pathForResource:filePath ofType:@"txt"];
    
    // Taca todo o arquivo numa string
    NSString* fileContents = [NSString stringWithContentsOfFile:fileRoot
                                                       encoding:NSUTF8StringEncoding error:nil];
    
    // Separa linhas num array
    NSArray* parsedFileText = [fileContents componentsSeparatedByCharactersInSet:
                               [NSCharacterSet newlineCharacterSet]];
    [self divideArraySalva:parsedFileText];
    
}
-(void)divideArraySalva: (NSArray *)array{
    NSNumber *exerciseId, *numberOfImages;
    NSString *name, *primMuscle, *secMuscle;
    for(int x = 0 ;x < [array count];x++){
        exerciseId = [self returnNumberFromString:[array objectAtIndex:x]];
        x++;
        numberOfImages = [self returnNumberFromString:[array objectAtIndex:x]];
        x++;
        for(int y = 0; y<[numberOfImages intValue];y++){
            NSString *tip = [array objectAtIndex:x];
            x++;
            [self addTipOnDatabaseWithExerciseId:exerciseId tip:tip];
        }
        name = [array objectAtIndex:x];
        x++;
        primMuscle = [array objectAtIndex:x];
        x++;
        secMuscle = [array objectAtIndex:x];
        [self addExerciseOnDatabaseWithExerciseId:exerciseId numberOfImages:numberOfImages name:name primMuscle:primMuscle secMuscle:secMuscle];
    }
}


-(void)addExerciseOnDatabaseWithExerciseId:(NSNumber *)exerciseId numberOfImages: (NSNumber *)numberOfImages name:
(NSString *)name primMuscle: (NSString *)primMuscle secMuscle: (NSString *)secMuscle{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    Exercises *exercise = [NSEntityDescription insertNewObjectForEntityForName:@"Exercises" inManagedObjectContext:context];
    
    [exercise setName:name];
    [exercise setExerciseID:exerciseId];
    [exercise setNumberImages:numberOfImages];
    [exercise setPrimaryMuscle:primMuscle];
    [exercise setSecondaryMuscle:secMuscle];
    
    NSError *error;
    
    [context save:&error];
    
}
-(NSNumber *)returnNumberFromString: (NSString *)str{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    return [f numberFromString:str];
}
-(void)addTipOnDatabaseWithExerciseId: (NSNumber *)exerciseId tip: (NSString *)str{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    ExerciseTip *exercise = [NSEntityDescription insertNewObjectForEntityForName:@"ExerciseTip" inManagedObjectContext:context];
    
    [exercise setExercise_id:exerciseId];
    [exercise setTip:str];
    NSError *error;
    
    [context save:&error];
    

}
@end
