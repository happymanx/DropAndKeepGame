//
//  MyScene.h
//  SpriteKitSimpleGame
//

//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol MainSceneDelegate;

@interface MainScene : SKScene <UIAlertViewDelegate>

@property (nonatomic, weak) id<MainSceneDelegate> mainSceneDelegate;

@end

@protocol MainSceneDelegate <NSObject>
- (void)mainSceneDidFinish:(MainScene *)mainScene;
@end
