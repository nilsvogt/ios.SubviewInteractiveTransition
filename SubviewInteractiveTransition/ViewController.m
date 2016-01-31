//
//  ViewController.m
//  SubviewInteractiveTransition
//
//  Created by Nils Vogt on 28.12.14.
//  Copyright (c) 2014 Nils Vogt. All rights reserved.
//

#import "ViewController.h"
#import "ContainerViewController.h"
#import "ChildViewController.h"
#import "Animator.h"
#import "TileContainerViewController.h"

@interface ViewController (){
    NSMutableArray *viewControllers;
    NSMutableArray *viewControllersScrollview;
}

@end

@implementation ViewController

/*
 * Load all the ribbons and place them in the view
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    viewControllers = [[NSMutableArray alloc] init];
    
    // ribbon 1
    [self addTile:CGRectMake(0, 0, 256, 256)];
    [self addTile:CGRectMake(256, 0, 256, 256)];
    [self addTile:CGRectMake(256*2, 0, 256, 256)];
    [self addTile:CGRectMake(256*3, 0, 256, 256)];
    

    // ribbon 2
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 256, 1024, 128)];
    
    viewControllersScrollview = [[NSMutableArray alloc] init];
    for (int i = 0; i<10; i++) {
        TileContainerViewController *tileContainerViewController = [[TileContainerViewController alloc] init];
        tileContainerViewController.view.frame = CGRectMake(i * 128, 0, 128, 128);
        [viewControllersScrollview addObject:tileContainerViewController];
        [scrollView addSubview:tileContainerViewController.view];
    }
    
    scrollView.contentSize = CGSizeMake(10*128, 96);
    [self.view addSubview:scrollView];
    
    // ribbon 3
    [self addTile:CGRectMake(0, 384, 256, 256)];
    [self addTile:CGRectMake(256, 384, 256, 256)];
    [self addTile:CGRectMake(256*2, 384, 256, 256)];
    [self addTile:CGRectMake(256*3, 384, 256, 256)];
    
    // ribbon 4
    [self addTile:CGRectMake(0, 640, 256, 128)];
    [self addTile:CGRectMake(256, 640, 256, 128)];
    [self addTile:CGRectMake(256*2, 640, 256, 128)];
    [self addTile:CGRectMake(256*3, 640, 256, 128)];

    
    // add all tiles to view
    for (UIViewController *viewController in viewControllers) {
        [self.view addSubview:viewController.view];
    }
}

/*
 * Add a tile in a given frame to the view
 */
- (void) addTile:(CGRect)frame {
    TileContainerViewController *tileContainerViewController = [[TileContainerViewController alloc] init];
    tileContainerViewController.view.frame = frame;
    [viewControllers addObject:tileContainerViewController];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
