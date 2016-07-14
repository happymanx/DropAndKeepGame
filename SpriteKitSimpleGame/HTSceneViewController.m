//
//  ViewController.m
//  SpriteKitSimpleGame
//
//  Created by Main Account on 9/4/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "HTSceneViewController.h"
#import "MainScene.h"

@import AVFoundation;

@interface HTSceneViewController ()
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@end

@implementation HTSceneViewController

//+ (instancetype)sharedInstance
//{
//    static HTSceneViewController *sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[self alloc] init];
//    });
//    return sharedInstance;
//}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"background-music-aac" withExtension:@"caf"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];

    // Configure the view.
    SKView *skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
//        skView.showsFields = YES;
//        skView.showsPhysics = YES;
//        skView.showsDrawCount = YES;
//        skView.showsQuadCount = YES;
      
        // Create and configure the scene.
        self.mainScene = [MainScene sceneWithSize:skView.bounds.size];
        self.mainScene.mainSceneDelegate = self;
        self.mainScene.scaleMode = SKSceneScaleModeResizeFill;
      
        // Present the scene.
        [skView presentScene:self.mainScene];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MainSceneDelegate
-(void)mainSceneDidFinish:(MainScene *)mainScene
{
    [self backAction];
}
    

@end
