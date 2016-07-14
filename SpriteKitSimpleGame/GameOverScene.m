//
//  GameOverScene.m
//  SpriteKitSimpleGame
//
//  Created by Main Account on 9/4/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "GameOverScene.h"
#import "MainScene.h"
#import "HTSceneViewController.h"
#import "AppDelegate.h"

@interface GameOverScene ()

@property (nonatomic) SKSpriteNode *backButton;
@property (nonatomic) SKSpriteNode *againButton;
@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) SKLabelNode *greatestScoreLabel;

@end

@implementation GameOverScene

-(id)initWithSize:(CGSize)size won:(BOOL)won {
    if (self = [super initWithSize:size]) {

//        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0];
//
//        NSString *message;
//        if (won) {
//            message = @"You Won! Happy~";
//        } else {
//            message = @"You Lose :[ Sad~";
//        }
//
//        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//        label.text = message;
//        label.fontSize = 40;
//        label.fontColor = [SKColor blackColor];
//        label.position = CGPointMake(self.size.width/2, self.size.height/2);
//        [self addChild:label];
//
//        [self runAction:
//            [SKAction sequence:@[
//                [SKAction waitForDuration:3.0],
//                [SKAction runBlock:^{
//
//                    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
//                    MainScene *mainScene = [[MainScene alloc] initWithSize:self.size];
//                    mainScene.mainSceneDelegate = self;
//                    [self.view presentScene:mainScene transition:reveal];
//                }]
//            ]]
//        ];
        
        // 生成背景
        [self setupBackground];
        // 生成板塊
        [self setupBoard];
        // 生成分數背景
        [self setupScoreBackground];
        // 生成分數標題
        [self setupScoreTitle];
        // 生成最佳分數標題
        [self setupGreatestScoreTitle];
        
        // 生成返回首頁
        self.backButton = [self backButtonNode];
        [self addChild:self.backButton];
        // 生成再玩一次
        self.againButton = [self againButtonNode];
        [self addChild:self.againButton];
        
        // 生成分數
        self.scoreLabel = [self scoreNode];
        [self addChild:self.scoreLabel];
        // 生成最佳分數
        self.greatestScoreLabel = [self greatestScoreNode];
        [self addChild:self.greatestScoreLabel];
    }
    return self;
}

-(void)setupBackground
{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"bg_result03.jpg"];
    background.size = self.frame.size;
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.name = @"bg_result03";
    [self addChild:background];
}

-(void)setupBoard
{
    SKSpriteNode *board = [SKSpriteNode spriteNodeWithImageNamed:@"bg_dialog_brown.png"];
    board.size = CGSizeMake(self.frame.size.width - 50, self.frame.size.height - 50);
    board.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    board.name = @"bg_dialog_brown";
    [self addChild:board];
}

-(void)setupScoreBackground
{
    SKSpriteNode *board = [SKSpriteNode spriteNodeWithImageNamed:@"bg_score_brown.png"];
    board.size = CGSizeMake(self.frame.size.width - 100, 80);
    board.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+40);
    board.name = @"bg_score_brown";
    [self addChild:board];
}

-(void)setupScoreTitle
{
    SKSpriteNode *board = [SKSpriteNode spriteNodeWithImageNamed:@"word_score_brown.png"];
    board.size = CGSizeMake(66, 36);
    board.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)-55);
    board.name = @"word_score_brown";
    [self addChild:board];
}

-(void)setupGreatestScoreTitle
{
    SKSpriteNode *board = [SKSpriteNode spriteNodeWithImageNamed:@"word_best_time_brown.png"];
    board.size = CGSizeMake(110, 30);
    board.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-20);
    board.name = @"word_best_time_brown";
    [self addChild:board];
}

- (SKSpriteNode *)backButtonNode
{
    SKSpriteNode *buttonNode = [SKSpriteNode spriteNodeWithImageNamed:@"button_back_home_on.png"];
    buttonNode.size = CGSizeMake(204, 56);
    buttonNode.texture = [SKTexture textureWithImageNamed:@"button_back_home_on.png"];
    buttonNode.position = CGPointMake(CGRectGetMaxX(self.frame)/4*1, CGRectGetMaxY(self.frame)/4*1);
    buttonNode.name = @"button_back_home_on";
    buttonNode.zPosition = 0.0;
    return buttonNode;
}

- (SKSpriteNode *)againButtonNode
{
    SKSpriteNode *buttonNode = [SKSpriteNode spriteNodeWithImageNamed:@"button_play_again_on.png"];
    buttonNode.size = CGSizeMake(204, 56);
    buttonNode.texture = [SKTexture textureWithImageNamed:@"button_play_again_on.png"];
    buttonNode.position = CGPointMake(CGRectGetMaxX(self.frame)/4*3, CGRectGetMaxY(self.frame)/4*1);
    buttonNode.name = @"button_play_again_on";
    buttonNode.zPosition = 0.0;
    return buttonNode;
}

- (SKLabelNode *)scoreNode
{
    // 讀取分數
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *nowScore = [ud objectForKey:@"HTNowScore"];

    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    label.zPosition = 0.5;
    label.text = [nowScore description];
    label.fontSize = 80;
    label.fontColor = [SKColor colorWithRed:255.0/255 green:204.0/255 blue:51.0/255 alpha:1];
    label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+15);
    return label;
}

- (SKLabelNode *)greatestScoreNode
{
    // 讀取最佳分數
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *greatestScore = [ud objectForKey:@"HTGreatestScore"];
    if (!greatestScore) {
        greatestScore = @(0);
    }
    
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    label.zPosition = 0.5;
    label.text = [greatestScore description];
    label.fontSize = 30;
    label.fontColor = [SKColor colorWithRed:255.0/255 green:230.0/255 blue:204.0/255 alpha:1];
    label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-60);
    return label;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];

    // 點擊按鈕
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"button_back_home_on"]) {
        NSLog(@"press button_back_home_on");
        self.backButton.texture = [SKTexture textureWithImageNamed:@"button_back_home_off.png"];
        
        [[AppDelegate sharedAppDelegate].mainVC.sceneVC backAction];
    }
    if ([node.name isEqualToString:@"button_play_again_on"]) {
        NSLog(@"press button_play_again_on");
        self.againButton.texture = [SKTexture textureWithImageNamed:@"button_play_again_off.png"];
        
        // 進入下一場
        SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
        MainScene *mainScene = [[MainScene alloc] initWithSize:self.size];
        [self.view presentScene:mainScene transition:reveal];
    }
}


@end
