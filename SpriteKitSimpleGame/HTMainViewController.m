//
//  HTMainViewController.m
//  SpriteKitSimpleGame
//
//  Created by Jason on 2016/7/14.
//  Copyright © 2016年 Razeware LLC. All rights reserved.
//

#import "HTMainViewController.h"

@interface HTMainViewController ()

@end

@implementation HTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(IBAction)startButtonClicked:(UIButton *)button
{
    self.sceneVC = [[HTSceneViewController alloc] init];
    [self.navigationController pushViewController:self.sceneVC animated:YES];
}

@end
