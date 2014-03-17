//
//  UIView+FirstAvailableViewController.h
//  Elho
//
//  Created by Dick Verbunt on 26-07-12.
//  Copyright (c) 2012 Idreams. All rights reserved.
//

/* 
 DESCRIPTION
 Gets the first viewController of an UIView
 */

#import <UIKit/UIKit.h>

@interface UIView (FirstAvailableViewController)

- (UIViewController *)firstAvailableUIViewController;
- (id)traverseResponderChainForUIViewController;

@end
