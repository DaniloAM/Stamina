//
//  WebServiceResponse.h
//  TesteServidor
//
//  Created by João Lucas Sisanoski on 17/09/14.
//  Copyright (c) 2014 João Lucas Sisanoski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserTraining.h"
#import "TrainingExercises.h"
#import "AppDelegate.h"
#import "UserData.h"
#import "WeatherObject.h"
#import "ServerSupport.h"
@interface WebServiceResponse : NSObject <NSURLConnectionDelegate>
@property NSMutableData *receivedData;

+(NSString*)cadastrarComNome: (NSString *)nome eSenha: (NSString *)password email: (NSString *)email sexo:(BOOL) sexo nickName: (NSString *)nickName;
+(NSString*)loginComEmailOuNickName: (NSString *)anything eSenha: (NSString *)password;
+(NSString*)inserirExercicioComId: (int )idExercicio serie: (int )serie repeticoes: (int )repeticoes treino: (int )treino emailOrNickName: (NSString *)anything;
+(NSString *)upToServerTrainingWithArrayOfRepetition: (NSArray *) arrayOfRepetitions withArrayOfSeries: (NSArray *) arrayOfSeries withArrayOfId: (NSArray *)arrayOfID withTrainingName: (NSString *)trainingName;
+(NSString*)getJsonComNickName: (NSString *)anything eSenha: (NSString *)password;
+(NSString*)checkStart: (NSString *)email eSenha: (NSString *)password;
+(NSString*)atualizaComEmail: (NSString *)email peso: (float )peso_atual sexo: (BOOL )sexo altura: (int )altura idade: (int )idade;
+(NSString*)criaComEmail: (NSString *)email peso: (float )peso_atual sexo: (BOOL )sexo altura: (int )altura idade: (int )idade;

+(WeatherObject *)previsaoDoTempoNaLatitude : (float)lat eLongitude:(float)lon;
+(NSString *)insereTreinoWithName: (NSString *)str andDays: (NSArray *)array andstartDate:(NSDate *)dateStart andFinalDate:(NSDate *)finalDate andHour: (NSDate *)hour;
@end
