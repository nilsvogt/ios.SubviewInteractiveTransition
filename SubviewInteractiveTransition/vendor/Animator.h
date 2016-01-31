//
//  Animator.h
//  NavigationTransitionTest
//
//  Created by Chris Eidhof on 9/27/13.
//  Copyright (c) 2013 Chris Eidhof. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AnimatorDelegate;

@interface Animator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak) id<AnimatorDelegate>delegate;

@property (nonatomic, assign) NSTimeInterval presentationDuration;

@property (nonatomic, assign) NSTimeInterval dismissalDuration;

@property (nonatomic, assign) BOOL isPresenting;

@property (nonatomic, assign) BOOL reverse;

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;

@end


@protocol AnimatorDelegate <NSObject>
@optional
- (void)animationStarted;
- (void)animationEnded:(BOOL) transitionCompleted;

@end