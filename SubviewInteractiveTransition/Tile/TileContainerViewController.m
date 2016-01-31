//
//  TileContainerViewController.m
//  SubviewInteractiveTransition
//
//  Created by Nils Vogt on 28.12.14.
//  Copyright (c) 2014 Nils Vogt. All rights reserved.
//

#import "TileContainerViewController.h"
#import "ChildViewController.h"
#import "Animator.h"
#import "PanGestureInteractiveTransition.h"
#import "ContainerViewController.h"

@interface TileContainerViewController () <ContainerViewControllerDelegate>

@property (nonatomic, strong) ContainerViewController *containerViewController;
@property (nonatomic, strong) UIView *privateButtonsView; /// The view hosting the buttons of the child view controllers.

@end

static CGFloat const kButtonSlotWidth = 64; // Also distance between button centers
static CGFloat const kButtonSlotHeight = 44;

@implementation TileContainerViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    
    // container view
    self.containerViewController = [[ContainerViewController alloc] initWithViewControllers:[self tileViewControllers]];
    [self.containerViewController setDelegate:self];
    [self.containerViewController.view setFrame: self.view.bounds];
    [self.containerViewController.view setClipsToBounds:YES];
    [self.view addSubview:self.containerViewController.view];
    
    // Container view fills out entire parent view.
    [self.containerViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerViewController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerViewController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerViewController.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    self.privateButtonsView = [[UIView alloc] init];
    [self.privateButtonsView setTintColor:[UIColor colorWithWhite:1 alpha:0.75f]];
    [self.privateButtonsView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.privateButtonsView];
    
    // Place buttons view in the top half, horizontally centered.
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[self.containerViewController.viewControllers count] * kButtonSlotWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.containerViewController.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kButtonSlotHeight]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.containerViewController.view attribute:NSLayoutAttributeCenterY multiplier:0.4f constant:0]];

    [self addChildViewControllerButtons];
}

#pragma mark - buttons

- (void)addChildViewControllerButtons {
    
    [self.containerViewController.viewControllers enumerateObjectsUsingBlock:^(UIViewController *childViewController, NSUInteger idx, BOOL *stop) {
        
        NSString *buttonTitle = [NSString stringWithFormat:@"%lu", (unsigned long)idx];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        
        button.tag = idx;
        
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.privateButtonsView addSubview:button];
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self.privateButtonsView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.privateButtonsView attribute:NSLayoutAttributeLeading multiplier:1 constant:(idx + 0.5f) * kButtonSlotWidth]];
        [self.privateButtonsView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.privateButtonsView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }];
}


- (void)buttonTapped:(UIButton *)button {
    
    UIViewController *selectedViewController = self.containerViewController.viewControllers[button.tag];
    
    NSUInteger fromIndex = [self.containerViewController.viewControllers indexOfObject:self.containerViewController.selectedViewController];
    NSUInteger toIndex = [self.containerViewController.viewControllers indexOfObject:selectedViewController];
    self.containerViewController.leftToRight = (fromIndex > toIndex);
    
    self.containerViewController.selectedViewController = selectedViewController;
    
}

- (void)updateButtonSelection {
    [self.privateButtonsView.subviews enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        button.selected = (self.containerViewController.viewControllers[idx] == self.containerViewController.selectedViewController);
    }];
}

#pragma mark -

- (NSArray *)tileViewControllers {
    
    // Set colors, titles and tab bar button icons which are used by the ContainerViewController class for display in its button pane.
    
    NSMutableArray *tileViewControllers = [[NSMutableArray alloc] initWithCapacity:3];
    NSArray *configurations = @[
                                @{@"title": @"Tile 1", @"color": [self randomColor]},
                                @{@"title": @"Tile 2", @"color": [self randomColor]},
                                ];
    
    for (NSDictionary *configuration in configurations) {
        ChildViewController *childViewController = [[ChildViewController alloc] init];
        childViewController.title = configuration[@"title"];
        childViewController.themeColor = configuration[@"color"];
        
        [tileViewControllers addObject:childViewController];
    }
    
    return tileViewControllers;
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

- (void) toggleTileController {
    
    NSUInteger fromIndex = [self.containerViewController.viewControllers indexOfObject:self.containerViewController.selectedViewController];
    UIViewController *selectedViewController;
    
    if(fromIndex == 0){
        selectedViewController = self.containerViewController.viewControllers[1];
    }else{
        selectedViewController = self.containerViewController.viewControllers[0];
    }
    
    NSUInteger toIndex = [self.containerViewController.viewControllers indexOfObject:selectedViewController];
    self.containerViewController.leftToRight = (fromIndex > toIndex);
    
    self.containerViewController.selectedViewController = selectedViewController;
}


#pragma mark - ContainerViewControllerDelegate Protocol implementation

- (id<UIViewControllerAnimatedTransitioning>)containerViewController:(ContainerViewController *)containerViewController animationControllerForTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    
    Animator *animator = [[Animator alloc] init];
    animator.delegate = self;
    animator.reverse = !self.containerViewController.leftToRight;
    return animator;
}

#pragma mark view transition

- (void) setupTransitionGestureRecognizer {
    /* // you can toggle the comment by adding a leading slash - try it
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleTileController)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    /*/
    // Add gesture recognizer and setup for interactive transition
    typeof(self.containerViewController) __weak containerViewController = self.containerViewController;
    self.containerViewController.defaultInteractionController = [[PanGestureInteractiveTransition alloc] initWithGestureRecognizerInView:containerViewController.view recognizedBlock:^(UIPanGestureRecognizer *recognizer) {
        containerViewController.leftToRight = [recognizer velocityInView:recognizer.view].x > 0;
        
        NSUInteger currentVCIndex = [containerViewController.viewControllers indexOfObject:containerViewController.selectedViewController];
        if (!containerViewController.leftToRight && currentVCIndex != containerViewController.viewControllers.count-1) {
            [containerViewController setSelectedViewController:containerViewController.viewControllers[currentVCIndex+1]];
        } else if (containerViewController.leftToRight && currentVCIndex > 0) {
            [containerViewController setSelectedViewController:containerViewController.viewControllers[currentVCIndex-1]];
        }
    }];
    //*/
}

- (id<UIViewControllerInteractiveTransitioning>)_interactionControllerForAnimator:(id<UIViewControllerAnimatedTransitioning>)animationController {
    //*
    if (self.containerViewController.defaultInteractionController.recognizer.state == UIGestureRecognizerStateBegan) {
        self.containerViewController.defaultInteractionController.animator = animationController;
        return self.containerViewController.defaultInteractionController;
    } else {
        return nil;
    }
    /*/
    return nil;
    //*/
}

#pragma mark animator delegate protocol implementation

- (void)animationStarted{
    [self.view setUserInteractionEnabled:NO];
}


- (void)animationEnded:(BOOL) transitionCompleted{
    [self.view setUserInteractionEnabled:YES];
    [self updateButtonSelection];
}

@end