//
//  UIView+NibLoad.m
//  LoudApp
//
//  Created by Szabó Krisztián on 10/31/13.
//  Copyright (c) 2013 Rubytribe. All rights reserved.
//

#import "UIView+NibLoad.h"

@implementation UIView (NibLoad)

+ (id)loadNibNamed:(NSString *)nibName ofClass:(Class)objClass {
    if (nibName && objClass) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
        
        for (id currentObject in objects ){
            if ([currentObject isKindOfClass:objClass])
                
                return currentObject;
        }
    }
    
    return nil;
}

@end
