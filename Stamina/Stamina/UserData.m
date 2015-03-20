//
//  UserData.m
//  Projeto Final iOS Academia
//
//  Created by Danilo Augusto Mative on 25/07/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "UserData.h"

@implementation UserData

+(UserData *)sharedStore{
    static UserData *sharedStore = nil;
    if(!sharedStore){
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
    
}
+(id) allocWithZone: (struct _NSZone *) zone{
    
    return [self sharedStore];
    
}

//exercise_id index 0
//repetitions index 1
//series index 2
-(void)eraseData{
    _trainingsArray = nil;
    _routesArray = nil;
    _name = nil;
    _heightInCentimeters=0;
    _weightInKilograms = 0;
    _currentObjective = 0;
    _completedTrainings = 0;
    _bestSequence = 0;
    _currentSequence = 0;
    _userPoints = 0;
    _burnedCalories = 0;
    _lostWeight = 0;
    _initialWeight = 0;
    _groupID = 0;
    _userID = 0;
    _age = 0;
    _language = 0;
    _alerta = 0;
    _timeAlarmBeforeTraining = 0;
    _sex = 0 ;
    _nextExercise = 0;
    _lastTrainName = nil;
    _lastTrainDate = nil;
    _startAppUse = nil;
    _nickName = nil;
    _email = nil;
    _password = nil;
    _offlineMode = 1;
    [self deleteAllObjects:@"TrainingExercises"];
    [self deleteAllObjects:@"TrainingDayObject"];
    [self deleteAllObjects:@"TrajectoryFile"];
    [self deleteAllObjects:@"TrajectoryRoute"];
    [self deleteAllObjects:@"Training"];
    [self saveOnUserDefaults];

}
-(void)addExerciseWithTrainingExercise: (TrainingExercises *)newExercise {

    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    
    NSError *error;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TrainingExercises"];
    NSArray *array = [context executeFetchRequest:request error:&error];
    
    for (int x = 0 ; x < [array count]; x++){
        
        TrainingExercises* ex = [array objectAtIndex:x];
        
        
        if([[ex training_name] isEqualToString:newExercise.training_name] && [[ex id_exercise] integerValue]==[newExercise.id_exercise integerValue]) {
            return;
        }
    }
    
    TrainingExercises *exercise = [NSEntityDescription insertNewObjectForEntityForName:@"TrainingExercises" inManagedObjectContext:context];
    
    [exercise setTime:newExercise.time];
    [exercise setTraining_name:newExercise.training_name];
    [exercise setId_exercise:newExercise.id_exercise];
    [exercise setRepetitions:newExercise.repetitions];
    [exercise setSeries:newExercise.series];
    
    
    [context save:&error];
    
}




-(void)clearTrainingFromCoreData{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *myContext = [app managedObjectContext];
    NSFetchRequest * allCars = [[NSFetchRequest alloc] init];
    [allCars setEntity:[NSEntityDescription entityForName:@"TrainingExercises" inManagedObjectContext:myContext]];
    [allCars setIncludesPropertyValues:NO];
    
    NSError * error = nil;
    NSArray * cars = [myContext executeFetchRequest:allCars error:&error];
    //error handling goes here
    for (NSManagedObject * car in cars) {
        [myContext deleteObject:car];
    }
    NSError *saveError = nil;
    [myContext save:&saveError];
}



-(NSArray *)returnTrainingWithName : (NSString *)trainingName{
    NSMutableArray *exercisesArray = [NSMutableArray array];
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TrainingExercises"];
    NSError *error = nil;
    
    NSArray *coreArray = [context executeFetchRequest:request error:&error];
    
    for(TrainingExercises *ex in coreArray) {
        
        if([ex.training_name isEqualToString:trainingName]) {
            [exercisesArray addObject:ex];
        }
        
    }
    
    return exercisesArray;
}



-(void)removeTraning: (NSString *)trainingName {
    
    BOOL success = false;
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Trainings"];
    
    NSError *error = nil;
    
    NSArray *array = [context executeFetchRequest:request error:&error];
    
    for(NSManagedObject *obj in array) {
        
        if ([[obj valueForKey:@"name"] isEqualToString:trainingName]) {
            
            success = true;
            
            [context deleteObject:obj];
            break;
        }
    }
    
    if(!success) {
    }
    
}

-(void)allocArray {
    [self setTrainingsArray:[NSMutableArray array]];
    [self setRoutesArray:[NSMutableArray array]];
}

-(void)saveOnUserDefaults {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:[self timeInSeconds] forKey:@"ud_timeinseconds"];
    [defaults setFloat:[self kilometers] forKey:@"ud_kilometers"];
    [defaults setInteger:[self timeAlarmBeforeTraining] forKey:@"ud_timebefore"];
    [defaults setInteger:[self currentObjective] forKey:@"ud_co"];
    [defaults setInteger:[self completedTrainings] forKey:@"ud_ct"];
    
    [defaults setInteger:[self age] forKey:@"ud_age"];
    [defaults setInteger:[self initialWeight] forKey:@"ud_initialweight"];
    [defaults setInteger:[self weightInKilograms] forKey:@"ud_weight"];
    [defaults setInteger:[self heightInCentimeters] forKey:@"ud_height"];
    [defaults setInteger:[self language] forKey:@"ud_language"];
    [defaults setInteger:[self alerta] forKey:@"ud_alerta"];
    [defaults setBool:[self sex] forKey:@"ud_sex"];
    [defaults setBool:[self nextExercise] forKey:@"ud_next"];
    [defaults setBool:[self offlineMode] forKey:@"ud_offlineMode"];
    [defaults setObject:[self startAppUse] forKey:@"ud_sap"];
    [defaults setObject:[self password] forKey:@"ud_pass"];
    [defaults setObject:[self nickName] forKey:@"ud_nickname"];
    [defaults setObject:[self email] forKey:@"ud_email"];
    [defaults setObject:[self name] forKey:@"ud_name"];
    [defaults setInteger:(NSInteger)[self userID] forKey:@"ud_id"];
    
    [defaults synchronize];
    
}

-(void)loadFromUserDefaults {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    _timeInSeconds = (int)[defaults integerForKey:@"ud_timeinseconds"];
    _kilometers = [defaults floatForKey:@"ud_kilometers"];
    _name = [defaults objectForKey:@"ud_name"];
    _currentObjective = (int)[defaults integerForKey:@"ud_co"];
    _completedTrainings = (int)[defaults integerForKey:@"ud_ct"];
    _startAppUse = [defaults objectForKey:@"ud_sap"];
    _email = [defaults objectForKey:@"ud_email"];
    _nickName = [defaults objectForKey:@"ud_nickname"];
    _password = [defaults objectForKey:@"ud_pass"];
    _language = (int)[defaults integerForKey:@"ud_language"];
    _alerta = (int)[defaults integerForKey:@"ud_alerta"];
    _nextExercise  = [defaults boolForKey:@"ud_next"];
    _initialWeight = (int)[defaults integerForKey:@"ud_initialweight"];
    _heightInCentimeters = (int)[defaults integerForKey:@"ud_height"];
    _weightInKilograms =(int)[defaults integerForKey:@"ud_weight"];
    _sex  = [defaults boolForKey:@"ud_sex"];
    _offlineMode  = [defaults boolForKey:@"ud_offlineMode"];

    _age  = (int)[defaults integerForKey:@"ud_age"];
    _timeAlarmBeforeTraining = (int)[defaults integerForKey:@"ud_timebefore"];
    _userID = (int)[defaults integerForKey:@"ud_id"];
}

- (void) deleteAllObjects: (NSString *) entityDescription  {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityDescription);
    }
    if (![context save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}
@end
