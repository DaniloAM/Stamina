//
//  UIStaminaImages.m
//  Stamina
//
//  Created by João Lucas Sisanoski on 18/11/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "UIStaminaImages.h"

@implementation UIImage(StaminaImage)

+(UIImage *)staminaIconHome{
    return [UIImage imageNamed:@"icone_home_tab.png"];
}
+(UIImage *)staminaIconPlus{
    return [UIImage imageNamed:@"icone_adicionar_tab.png"];

}
+(UIImage *)staminaIconCancel{
    return [UIImage imageNamed:@"icone_cancelar_tab.png"];

}
+(UIImage *)staminaIconShare{
    return [UIImage imageNamed:@"icone_compartilhar_tab.png"];

}
+(UIImage *)staminaIconCalendarTabDay{
//    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
//    NSInteger day = [components day];

    NSString *str = [NSString stringWithFormat:@"icone_calendario_tab_06.png"];
    return [UIImage imageNamed:str];
    
}
+(UIImage *)staminaIconCalendarDay{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger day = [components day];
    NSString *str = [NSString stringWithFormat:@"icone_calendario_%02ld.png",(long)day];
    return [UIImage imageNamed:str];
}
+(UIImage *)staminaIconEdit{
    return [UIImage imageNamed:@"icone_editar_tab.png"];

}
+(UIImage *)staminaIconIdea{
    return [UIImage imageNamed:@"icone_ideia_tab.png"];

}
+(UIImage *)staminaIconOk{
    return [UIImage imageNamed:@"icone_ok_tab.png"];

}
+(UIImage *)staminaIconTrophy{
    return [UIImage imageNamed:@"icone_pontuacao_tab.png"];

    
}
+(UIImage *)staminaIconBack{
    return [UIImage imageNamed:@"icone_voltar_tab.png"];
    
}
+(UIImage *)staminaIconAlternar{
    return [UIImage imageNamed:@"icone_alternar.png"];
    
}
+(UIImage *)staminaIconSerie{
    return [UIImage imageNamed:@"icone_serie.png"];
    
}
+(UIImage *)staminaIconSerieSel{
    return [UIImage imageNamed:@"s_icone_serie.png"];
    
}
+(UIImage *)staminaIconTime{
    return [UIImage imageNamed:@"icone_tempo.png"];
    
}
+(UIImage *)staminaIconTimeSelected{
    return [UIImage imageNamed:@"s_icone_tempo.png"];
    
}


@end
