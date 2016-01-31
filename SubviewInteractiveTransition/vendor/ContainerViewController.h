//
//  ContainerViewController.m
//  Container Transitions
//
//  Created by Joachim Bondo on 30/04/2014.
//
//  Interactive transition support added by Alek Åström on 11/05/2014.
//
//  Encapsulation of transition responsibility added by Nils Vogt 30/12/2014

@import UIKit;
@import Foundation;

@class PanGestureInteractiveTransition;

@protocol ContainerViewControllerDelegate;

/** A very simple container view controller for demonstrating containment in an environment different from UINavigationController and UITabBarController.
 @discussion This class implements support for non-interactive custom view controller transitions.
 @note One of the many current limitations, besides not supporting interactive transitions, is that you cannot change view controllers after the object has been initialized.
 */
@interface ContainerViewController : UIViewController

/// The animation direction for animating views
@property (nonatomic, assign) BOOL leftToRight;

/// The container view controller delegate receiving the protocol callbacks.
@property (nonatomic, weak) id<ContainerViewControllerDelegate>delegate;

/// The view controllers currently managed by the container view controller.
@property (nonatomic, copy, readonly) NSArray *viewControllers;

/// The currently selected and visible child view controller.
@property (nonatomic, assign) UIViewController *selectedViewController;

/// The view hosting the child view controllers views.
@property (nonatomic, strong) UIView *containerView;

/// The default, pan gesture enabled interactive transition controller.
@property (nonatomic, strong) PanGestureInteractiveTransition *defaultInteractionController;

/** Designated initializer.
 @note The view controllers array cannot be changed after initialization.
 */
- (instancetype)initWithViewControllers:(NSArray *)viewControllers;


@end

@protocol ContainerViewControllerDelegate <NSObject>

- (void) setupTransitionGestureRecognizer;



/// Called on the delegate to obtain a UIViewControllerAnimatedTransitioning object which can be used to animate a non-interactive transition.
- (id <UIViewControllerAnimatedTransitioning>)containerViewController:(ContainerViewController *)containerViewController animationControllerForTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

@optional

- (void)finishTransitionToChildViewController:(UIViewController *)toViewController;

- (id<UIViewControllerInteractiveTransitioning>)_interactionControllerForAnimator:(id<UIViewControllerAnimatedTransitioning>)animationController;




/// Called on the delegate to obtain a UIViewControllerInteractiveTransitioning object which can be used to interact during a transition
- (id <UIViewControllerInteractiveTransitioning>)containerViewController:(ContainerViewController *)containerViewController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController;
@end
