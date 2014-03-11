//
//  SwipeableUITextField.m
//  FittingRoom
//
//  Created by Szabó Krisztián on 3/10/14.
//  Copyright (c) 2014 Krisztian Szabo. All rights reserved.
//

#import "SwipeableUITextField.h"
#import "UIView+FirstAvailableViewController.h"

@interface SwipeableUITextField ()
@property (nonatomic, strong) UISwipeGestureRecognizer* swipeDownGestureRecognizer;
@end
@implementation SwipeableUITextField 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    _swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
    _swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    _swipeDownGestureRecognizer.delegate = self;
    
    UIViewController *ctrl = [self firstAvailableUIViewController];
    if (ctrl) {
        [ctrl.view addGestureRecognizer:_swipeDownGestureRecognizer];
        
    }
}

-(void)dealloc
{
    UIViewController *ctrl = [self firstAvailableUIViewController];
    if (ctrl) {
        [ctrl.view removeGestureRecognizer:_swipeDownGestureRecognizer];
        
    }
}

#pragma mark - UIGestureRecognizers

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    if ([self isFirstResponder]) {
        [self resignFirstResponder];
    }
}

@end
