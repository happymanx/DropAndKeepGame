//
//  HTMainViewController.m
//  SpriteKitSimpleGame
//
//  Created by Jason on 2016/7/14.
//  Copyright © 2016年 Razeware LLC. All rights reserved.
//

#import "HTMainViewController.h"
#import "HTSceneViewController.h"

@interface HTMainViewController ()

@end

@implementation HTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(IBAction)startButtonClicked:(UIButton *)button
{
    HTSceneViewController *vc = [[HTSceneViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
