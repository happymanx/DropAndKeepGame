//
//  ViewController.m
//  SpriteKitSimpleGame
//
//  Created by Main Account on 9/4/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"

@import AVFoundation;

@interface ViewController ()
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@end

@implementation ViewController

+ (instancetype)sharedInstance
{
    static ViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

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
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
//        skView.showsFields = YES;
//        skView.showsPhysics = YES;
//        skView.showsDrawCount = YES;
//        skView.showsQuadCount = YES;
      
      // Create and configure the scene.
      self.mainScene = [MyScene sceneWithSize:skView.bounds.size];
      self.mainScene.scaleMode = SKSceneScaleModeAspectFill;
      
      // Present the scene.
      [skView presentScene:self.mainScene];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

@end
