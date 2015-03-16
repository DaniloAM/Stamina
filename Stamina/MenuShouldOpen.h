//
//  MenuShouldOpen.h
//  Stamina
//
//  Created by JOAO LUCAS BISCAIA SISANOSKI on 13/10/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MenuShouldOpen : NSObject
+(MenuShouldOpen *)sharedStore;
@property UIViewController *root;
@end
