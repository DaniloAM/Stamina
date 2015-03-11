//
//  ExercisesList.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 11/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "ExercisesList.h"


@implementation ExercisesList

+(ExercisesList *)sharedStore{
    static ExercisesList *sharedStore = nil;
    if(!sharedStore){
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
    
}

+(id) allocWithZone: (struct _NSZone *) zone{
    
    return [self sharedStore];
    
}


+(NSString *)returnCategoryNameWithId :(int )identifier{
    int index = (identifier / 1000);
    switch (index) {
        case 101:
            return @"Frontal - Abdominal";
            break;
        case 102:
            return @"Frontal - Ante-Braço";
            break;
        case 103:
            return @"Frontal - Biceps";
            break;
        case 104:
            return @"Frontal - Peitoral";
            break;
        case 105:
            return @"Frontal - Quadríceps";
            break;
        case 106:
            return @"Frontal - Ombros";
            break;
        case 107:
            return @"Frontal - Trapezio";
            break;
        case 108:
            return @"Frontal - Triceps";
            break;
        case 109:
            return @"Traseiro - Ante-Braço";
            break;
        case 110:
            return @"Traseiro - Biceps";
            break;
        case 111:
            return @"Traseiro - Dorsal";
            break;
        case 112:
            return @"Traseiro - Glúteos";
            break;
        case 113:
            return @"Traseiro - Lombar";
            break;
        case 114:
            return @"Traseiro - Ombros";
            break;
        case 115:
            return @"Traseiro - Panturrilha";
            break;
        case 116:
            return @"Traseiro - Posterior de Coxa";
            break;
        case 117:
            return @"Traseiro - Rombóides";
            break;
        case 118:
            return @"Traseiro - Trapézio";
            break;
        case 119:
            return @"Traseiro - Triceps";
            break;
            
        default:
            break;
    }
    return nil;
}

-(NSString *)getStringToIndex: (int )x{
    NSString *str = nil;
    switch (x) {
        case 0:
            str = @"fr_abdominal";
            break;
        case 1:
            str = @"fr_antebraco";
            break;
        case 2:
            str = @"fr_biceps";
            break;
        case 3:
            str = @"fr_ombro";
            break;
        case 4:
            str = @"fr_peitoral";
            break;
        case 5:
            str = @"fr_quadriceps";
            break;
        case 6:
            str = @"fr_trapezio";
            break;
        case 7:
            str = @"fr_triceps";
            break;
        case 9:
            str = @"tr_biceps";
            break;
        case  10:
            str = @"tr_dorsal";
            break;
        case 11:
            str = @"tr_gluteos";
            break;
        case 12:
            str = @"tr_lombar";
            break;
        case 13:
            str = @"tr_ombros";
            break;
        case 14:
            str = @"tr_panturrilha";
            break;
        case 15:
            str = @"tr_posteriorcoxa";
            break;
        case 16:
            str = @"tr_romboides";
            break;
        case 17:
            str = @"tr_trapezio";
            break;
        case 18:
            str = @"tr_triceps";
            break;
        case 8:
            str = @"tr_antebraco";
            break;
    }
    // trazeiro ante braco - 109
    // trazeiro biceps - 110
    // trazeiro dorsal - 111
    // trazeiro gluteos - 112
    // trazeiro lombar - 113
    // trazeiro ombros - 114
    // trazeiro panturrilha - 115
    // trazeiro posterior coxa - 116
    // trazeiro romboides - 117
    // trazeiro trapezio - 118
    // trazeiro triceps - 119

    return str;
}
-(NSMutableArray *)getArrayForCategory: (NSString *)string {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exercises"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"primaryMuscle = %@", string];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *obj = [context executeFetchRequest:request error:&error];
    return [NSMutableArray arrayWithArray:obj];
}



-(Exercises *)returnExerciseWithIdentifier: (int)identifier {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exercises"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"exerciseID = %d", identifier];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *obj = [context executeFetchRequest:request error:&error];
    if([obj count]==0)
        return nil;
    return [obj firstObject];
}



@end
