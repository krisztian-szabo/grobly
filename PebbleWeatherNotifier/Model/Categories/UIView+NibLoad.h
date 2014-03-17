//
//  UIView+NibLoad.h
//  LoudApp
//
//  Created by Szabó Krisztián on 10/31/13.
//  Copyright (c) 2013 Rubytribe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NibLoad)

+ (id)loadNibNamed:(NSString *)nibName ofClass:(Class)objClass;

@end
