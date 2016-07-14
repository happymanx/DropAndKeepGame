//
//  ViewController.h
//  SpriteKitSimpleGame
//

//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "MainScene.h"

@interface HTSceneViewController : UIViewController <MainSceneDelegate>

@property (nonatomic, retain) MainScene *mainScene;

//+ (instancetype)sharedInstance;

-(void)backAction;

@end
