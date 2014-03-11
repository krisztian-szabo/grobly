//
//  UIView+FirstAvailableViewController.h
//  Elho
//
//  Created by Szabó Krisztián on 3/10/14.
//  Copyright (c) 2014 Krisztian Szabo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FirstAvailableViewController)

- (UIViewController *)firstAvailableUIViewController;
- (id)traverseResponderChainForUIViewController;

@end
