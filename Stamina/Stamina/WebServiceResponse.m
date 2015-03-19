//
//  WebServiceResponse.m
//  TesteServidor
//
//  Created by João Lucas Sisanoski on 17/09/14.
//  Copyright (c) 2014 João Lucas Sisanoski. All rights reserved.
//

#import "WebServiceResponse.h"

@implementation WebServiceResponse
+(NSString*)cadastrarComNome: (NSString *)nome eSenha: (NSString *)password email: (NSString *)email sexo:(BOOL) sexo nickName: (NSString *)nickName {
    email = [email lowercaseString];
    nickName = [nickName lowercaseString];
    
    NSString *url = @"http://54.207.112.185/joao/cadastro.php";
    NSString *post = [NSString stringWithFormat:@"password=%@&nome=%@&email=%@&sexo=%d&nickname=%@",password, nome, email, sexo, nickName];
    return [WebServiceResponse doTheRequest:post andUrl:url];
}
+(NSString*)loginComEmailOuNickName: (NSString *)anything eSenha: (NSString *)password{
    anything = [anything lowercaseString];
    NSString *url = @"http://54.207.112.185/joao/login.php";
    NSString *post = [NSString stringWithFormat:@"password=%@&emailOrNick=%@",password, anything];
    return [WebServiceResponse doTheRequest:post andUrl:url];
}
+(NSString*)getJsonComNickName: (NSString *)anything eSenha: (NSString *)password{
    anything = [anything lowercaseString];
    NSString *url = @"http://54.207.112.185/joao/getJson.php";
    NSString *post = [NSString stringWithFormat:@"password=%@&emailOrNick=%@",password, anything];
    return [WebServiceResponse doTheRequest:post andUrl:url];
}
+(NSString*)inserirExercicioComId: (int )idExercicio serie: (int )serie repeticoes: (int )repeticoes treino: (int )treino emailOrNickName: (NSString *)anything{
    anything = [anything lowercaseString];
    NSString *url = @"http://54.207.112.185/joao/insereExercicio.php";
    NSString *post = [NSString stringWithFormat:@"emailOrNick=%@&id_exercicio=%d&series=%d&repeticoes=%d&treino=%d",anything, idExercicio,serie,repeticoes,treino];
    return [WebServiceResponse doTheRequest:post andUrl:url];
}
+ (BOOL)connected
{
    return [ServerSupport getConnectivity];
}
+(NSString *)doTheRequest :(NSString *)post andUrl: (NSString *)url{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"context-type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:17.32];
    NSError *error = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if(error==nil){

        NSString* s = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        
        return s;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

    return @"error";
}


+(NSString *)upToServerTrainingWithArrayOfRepetition: (NSArray *) arrayOfRepetitions withArrayOfSeries: (NSArray *) arrayOfSeries withArrayOfId: (NSArray *)arrayOfID withTrainingName: (NSString *)trainingName {
    NSMutableArray *trainingsArray = [NSMutableArray array];
    for (int x = 0; x < [arrayOfID count]; x++) {
        NSDictionary *trainingDictionary =[NSDictionary dictionaryWithObjectsAndKeys:
                                           [arrayOfID objectAtIndex:x], @"id_exercise",
                                           trainingName, @"trainingName",
                                           [arrayOfSeries objectAtIndex:x], @"series",
                                           [arrayOfRepetitions objectAtIndex:x], @"repetitions",
                                           nil];
        [trainingsArray addObject:trainingDictionary];
    }
    NSError *error = nil;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:trainingsArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    NSData *jsonData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    return [WebServiceResponse cadastrar:jsonData];
}
+(NSString*)cadastrar:(NSData*)jsonCadastro{
    NSString *url = @"http://54.207.112.185/joao/teste.php";
    UserData *u=[UserData alloc];
    NSString *strJson = [[NSString alloc] initWithData:jsonCadastro encoding:NSUTF8StringEncoding];
    NSString *post = [NSString stringWithFormat:@"id_aluno=%d&json=%@", [u userID], strJson];
    return [self doTheRequest:post andUrl:url];
}
+(NSString*)checkStart: (NSString *)email eSenha: (NSString *)password{
    email = [email lowercaseString];
    NSString *url = @"http://54.207.112.185/joao/startCheck.php";
    
    NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", email, password];
    return [self doTheRequest:post andUrl:url];
    
}
+(NSString*)atualizaComEmail: (NSString *)email peso: (float )peso_atual sexo: (BOOL )sexo altura: (int )altura idade: (int )idade{
    email = [email lowercaseString];
    NSString *url = @"http://54.207.112.185/joao/atualiza.php";
    
    NSString *post = [NSString stringWithFormat:@"email=%@&sexo=%d&idade=%d&peso_atual=%f&altura=%d", email, sexo, idade, peso_atual,altura];
    return [self doTheRequest:post andUrl:url];
    
}
+(NSString*)criaComEmail: (NSString *)email peso: (float )peso_atual sexo: (BOOL )sexo altura: (int )altura idade: (int )idade{
    NSString *url = @"http://54.207.112.185/joao/cadastra.php";
    email = [email lowercaseString];
    NSString *post = [NSString stringWithFormat:@"email=%@&sexo=%d&idade=%d&peso_atual=%f&altura=%d", email, sexo, idade, peso_atual,altura];
    return [self doTheRequest:post andUrl:url];
    
}
+(NSString *)stringToId: (int )iden{
    NSString *str = nil;
    if(iden==500 || iden ==501  || ((iden >511)&&(iden < 531))||((iden >300)&&(iden < 321))){
        str = @"icone_tempo_chuvisco.png";
    }
    else if (iden == 502 || iden == 531){
        str = @"icone_tempo_chuvoso.png";
    }
    else if (iden == 803 || iden == 802 || iden == 801){
        str = @"icone_tempo_nublado.png";
    }
    else if (iden ==  804 ){
        str=@"icone_tempo_nebulosidade.png";
    }
    else if (iden == 800){
        str =@"icone_tempo_sol.png";
    }
    else if (iden == 503 || iden == 504 || (iden< 232 && iden > 200)){
        str=@"icone_tempo_tempestade.png";
    }
    return str;
}
+(WeatherObject *)previsaoDoTempoNaLatitude : (float)lat eLongitude:(float)lon{
    NSString *url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f",lat, lon ];
    NSData *jsonDados = [[NSData alloc] initWithContentsOfURL:
                         [NSURL URLWithString:url]];
    
    if(!jsonDados) {
        return nil;
    }
    
    NSError *error;
    NSMutableDictionary *jsonDadosUsuario = [NSJSONSerialization
                                             JSONObjectWithData:jsonDados
                                             options:NSJSONReadingMutableContainers
                                             error:&error];
    
    
    NSDictionary *main = [[NSDictionary  alloc] initWithDictionary:[jsonDadosUsuario objectForKey:@"main"]];
    NSArray *array = [jsonDadosUsuario objectForKey:@"weather"];
    
    NSNumber *tempMin = [main objectForKey:@"temp_min"];
    NSNumber *humidity = [main objectForKey:@"temp_min"];
    NSNumber *tempMax = [main objectForKey:@"temp_max"];
    NSNumber *tempAtual = [main objectForKey:@"temp"];
    float temp_min = [tempMin floatValue];
    float temp_max = [tempMax floatValue];
    float temp = [tempAtual floatValue];
    float humidade = [humidity floatValue];
    WeatherObject *novo = [[WeatherObject alloc] init];
    [novo setTempAtual:temp];
    [novo setTempMin:temp_min];
    [novo setTempMax:temp_max];
    [novo setHumidade:humidade];
    NSDictionary *weatherCondition = [array firstObject];
    NSNumber *identification = [weatherCondition objectForKey:@"id"];
    [novo setDescricao:[WebServiceResponse stringToId: [identification intValue]]];
    
    return novo;
    
}

+(NSString *)insereTreinoWithName: (NSString *)str andDays: (NSArray *)array andstartDate:(NSDate *)dateStart andFinalDate:(NSDate *)finalDate andHour: (NSDate *)hour{
    NSString *url = @"http://54.207.112.185/joao/insereTreino.php";
    UserData *user = [UserData alloc];
    NSString *post = [NSString stringWithFormat:@"domingo=%d&segunda=%d&terca=%d&quarta=%d&quinta=%d&sexta=%d&sabado=%d&trainingName=%@&dataFinal=%@&dataInicial=%@&hora=%@&idUsuario=%d", [[array objectAtIndex:0] boolValue], [[array objectAtIndex:1] boolValue],[[array objectAtIndex:2] boolValue],[[array objectAtIndex:3] boolValue],[[array objectAtIndex:4] boolValue],[[array objectAtIndex:5] boolValue],[[array objectAtIndex:6] boolValue], str, dateStart , finalDate, hour, [user userID]];
    return [self doTheRequest:post andUrl:url];
}

@end
