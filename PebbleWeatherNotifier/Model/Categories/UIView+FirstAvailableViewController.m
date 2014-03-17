//
//  UIView+FirstAvailableViewController.m
//  Elho
//
//  Created by Dick Verbunt on 26-07-12.
//  Copyright (c) 2012 Idreams. All rights reserved.
//

#import "UIView+FirstAvailableViewController.h"

@implementation UIView (FirstAvailableViewController)

- (UIViewController *)firstAvailableUIViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id)traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

@end
