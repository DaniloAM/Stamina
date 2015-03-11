//
//  MenuShouldOpen.h
//  Stamina
//
//  Created by JOAO LUCAS BISCAIA SISANOSKI on 13/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuShouldOpen : NSObject
+(MenuShouldOpen *)sharedStore;

@property BOOL open;
@end
