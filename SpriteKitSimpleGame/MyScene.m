//
//  MyScene.m
//  SpriteKitSimpleGame
//
//  Created by Main Account on 9/4/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "MyScene.h"
#import "GameOverScene.h"

static const uint32_t projectileCategory     =  0x1 << 0;
static const uint32_t monsterCategory        =  0x1 << 2;
static const uint32_t playerCategory         =  0x1 << 1;

@interface MyScene () <SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode *player;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSInteger monstersDestroyed;
@property (nonatomic) NSInteger monstersKept;
@property (nonatomic) NSInteger monstersMissed;
@property (nonatomic) NSInteger monstersCount;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger second;
@property (nonatomic) SKLabelNode *difficultyNumberLabel;
@property (nonatomic) SKLabelNode *scoreNumberLabel;
@property (nonatomic) SKSpriteNode *heart1Node;
@property (nonatomic) SKSpriteNode *heart2Node;
@property (nonatomic) SKSpriteNode *heart3Node;

@end

static inline CGPoint rwAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}
 
static inline CGPoint rwSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}
 
static inline CGPoint rwMult(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}
 
static inline float rwLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}
 
// Makes a vector have a length of 1
static inline CGPoint rwNormalize(CGPoint a) {
    float length = rwLength(a);
    return CGPointMake(a.x / length, a.y / length);
}

@implementation MyScene
 
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
 
        NSLog(@"Size: %@", NSStringFromCGSize(size));

//        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        // 生成背景
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background.jpg"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        background.name = @"background";
        [self addChild:background];
        
        // 生成木材
        [self addChild:[self boardNode]];
        // 生成按鈕
        [self addChild:[self buttonNode]];
        // 生成標題名稱
        [self addChild:[self difficultyNameNode]];
        [self addChild:[self scoreNameNode]];
        // 生成標題數字
        self.difficultyNumberLabel = [self difficultyNumberNode];
        [self addChild:self.difficultyNumberLabel];
        self.scoreNumberLabel = [self scoreNumberNode];
        [self addChild:self.scoreNumberLabel];
        
        // 生成愛心
        self.heart1Node = [self heartNodeWithIndex:1];
        [self addChild:self.heart1Node];
        self.heart2Node = [self heartNodeWithIndex:2];
        [self addChild:self.heart2Node];
        self.heart3Node = [self heartNodeWithIndex:3];
        [self addChild:self.heart3Node];

        // 生成玩家
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"Pacman"];
        self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size]; // 1
        self.player.position = CGPointMake(self.frame.size.width/2, self.player.size.height/2);
        self.player.physicsBody.dynamic = NO;
        self.player.physicsBody.categoryBitMask = playerCategory;
        self.player.physicsBody.contactTestBitMask = monsterCategory;
        self.player.physicsBody.collisionBitMask = 0;
        [self addChild:self.player];
      
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;

        // 生成計時器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)addMonster {
 
    self.monstersCount++;
    // Create sprite
    SKSpriteNode *monster;
    switch (self.monstersCount%4) {
        case 0:
            monster = [SKSpriteNode spriteNodeWithImageNamed:@"Pacman1"];
            break;
        case 1:
            monster = [SKSpriteNode spriteNodeWithImageNamed:@"Pacman2"];
            break;
        case 2:
            monster = [SKSpriteNode spriteNodeWithImageNamed:@"Pacman3"];
            break;
        case 3:
            monster = [SKSpriteNode spriteNodeWithImageNamed:@"Pacman4"];
            break;
        default:
            break;
    }
    monster.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:monster.size]; // 1
    monster.physicsBody.dynamic = YES; // 2
    monster.physicsBody.categoryBitMask = monsterCategory; // 3
    monster.physicsBody.contactTestBitMask = projectileCategory; // 4
    monster.physicsBody.collisionBitMask = 0; // 5
  
    // Determine where to spawn the monster along the Y axis
//    int minY = monster.size.height / 2;
//    int maxY = self.frame.size.height - monster.size.height / 2;
//    int rangeY = maxY - minY;
//    int actualY = (arc4random() % rangeY) + minY;
    //
    int minX = 100;
    int maxX = self.frame.size.width + monster.size.width / 2;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
 
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
//    monster.position = CGPointMake(self.frame.size.width + monster.size.width/2, actualY);
//    [self addChild:monster];
    //
    monster.position = CGPointMake(actualX, self.frame.size.height + monster.size.height/2);
    [self addChild:monster];
 
    // Determine speed of the monster
//    int minDuration = 2.0;
//    int maxDuration = 4.0;
//    int rangeDuration = maxDuration - minDuration;
//    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    NSInteger actualDuration = 10;
    actualDuration = actualDuration - (self.second / 10);
    if (actualDuration <= 0) {
        actualDuration = 1;
    }
    self.difficultyNumberLabel.text = [@(10 - actualDuration) description];
 
    // Create the actions
//    SKAction * actionMove = [SKAction moveTo:CGPointMake(-monster.size.width/2, actualY) duration:actualDuration];
    //
    SKAction *actionMove = [SKAction moveTo:CGPointMake(actualX, - monster.size.height/2) duration:actualDuration];

    SKAction *actionMoveDone = [SKAction removeFromParent];
    SKAction *loseAction = [SKAction runBlock:^{
        self.monstersMissed++;
        NSLog(@"Miss: %li", (long)self.monstersMissed);
        // 失去愛心
        if (self.monstersMissed == 1) {
            self.heart1Node.texture = [SKTexture textureWithImageNamed:@"heart_empty.png"];
        }
        if (self.monstersMissed == 2) {
            self.heart2Node.texture = [SKTexture textureWithImageNamed:@"heart_empty.png"];
        }
        if (self.monstersMissed == 3) {
            self.heart3Node.texture = [SKTexture textureWithImageNamed:@"heart_empty.png"];
        }

        // 錯過三個就輸了
        if (self.monstersMissed >= 3) {
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:NO];
            [self.view presentScene:gameOverScene transition: reveal];
            [self.timer invalidate];
        }

    }];
    [monster runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
 
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
 
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        [self addMonster];
    }
}

- (void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
 
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
 
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
//    CGPoint previousPosition = [touch previousLocationInNode:self];
    
    // 移動小精靈
    SKAction *move = [SKAction moveToX:positionInScene.x duration:0.1];
    [self.player runAction:[SKAction sequence:@[move]]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 
//    [self runAction:[SKAction playSoundFileNamed:@"pew-pew-lei.caf" waitForCompletion:NO]];
// 
    // 1 - Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
// 
//    // 2 - Set up initial location of projectile
//    SKSpriteNode * projectile = [SKSpriteNode spriteNodeWithImageNamed:@"projectile"];
//    projectile.position = self.player.position;
//    projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
//    projectile.physicsBody.dynamic = YES;
//    projectile.physicsBody.categoryBitMask = projectileCategory;
//    projectile.physicsBody.contactTestBitMask = monsterCategory;
//    projectile.physicsBody.collisionBitMask = 0;
//    projectile.physicsBody.usesPreciseCollisionDetection = YES;
//
//    // 3- Determine offset of location to projectile
//    CGPoint offset = rwSub(location, projectile.position);
// 
//    // 4 - Bail out if you are shooting down or backwards
////    if (offset.x <= 0) return;
// 
//    // 5 - OK to add now - we've double checked position
//    [self addChild:projectile];
// 
//    // 6 - Get the direction of where to shoot
//    CGPoint direction = rwNormalize(offset);
// 
//    // 7 - Make it shoot far enough to be guaranteed off screen
//    CGPoint shootAmount = rwMult(direction, 1000);
// 
//    // 8 - Add the shoot amount to the current position       
//    CGPoint realDest = rwAdd(shootAmount, projectile.position);
// 
//    // 9 - Create the actions
//    float velocity = 480.0/1.0;
//    float realMoveDuration = self.size.width / velocity;
//    SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
//    SKAction * actionMoveDone = [SKAction removeFromParent];
//    [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    // 點擊按鈕
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"buttonNode"]) {
        NSLog(@"press button");
        // 暫停遊戲
        self.scene.view.paused = !self.scene.view.paused;
    }
}

- (void)projectile:(SKSpriteNode *)projectile didCollideWithMonster:(SKSpriteNode *)monster {
    [projectile removeFromParent];
    [monster removeFromParent];
    self.monstersDestroyed++;
    NSLog(@"Destory: %li", (long)self.monstersDestroyed);
    if (self.monstersDestroyed > 30) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:YES];
        [self.view presentScene:gameOverScene transition: reveal];
        [self.timer invalidate];
    }
}

- (void)player:(SKSpriteNode *)player didCollideWithMonster:(SKSpriteNode *)monster {
    [monster removeFromParent];
}


- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
 
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }

    if ((firstBody.categoryBitMask & projectileCategory) != 0 &&
        (secondBody.categoryBitMask & monsterCategory) != 0)
    {
        [self projectile:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
    }
    
    // 小精靈與鬼相撞
    if ((firstBody.categoryBitMask & playerCategory) != 0 &&
        (secondBody.categoryBitMask & monsterCategory) != 0)
    {
        self.monstersKept++;
        NSLog(@"Keep: %li", (long)self.monstersKept);
        [self player:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
        [self runAction:[SKAction playSoundFileNamed:@"pew-pew-lei.caf" waitForCompletion:NO]];
        self.scoreNumberLabel.text = [@(self.monstersKept) description];
        // 接到十個就贏了
        if (self.monstersKept > 10) {
//            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
//            SKScene *gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:YES];
//            [self.view presentScene:gameOverScene transition: reveal];
//            [self.timer invalidate];
        }
    }
}

-(void)updateTime:(NSTimer *)timer
{
    self.second++;
    NSLog(@"second: %li", (long)self.second);
}

- (SKSpriteNode *)buttonNode
{
    SKSpriteNode *buttonNode = [SKSpriteNode spriteNodeWithImageNamed:@"button.png"];
    buttonNode.position = CGPointMake(50,50);
    buttonNode.name = @"buttonNode";
    buttonNode.zPosition = 0.0;
    return buttonNode;
}

- (SKSpriteNode *)boardNode
{
    SKSpriteNode *boardNode = [SKSpriteNode spriteNodeWithImageNamed:@"board.png"];
    boardNode.position = CGPointMake(CGRectGetMaxX(boardNode.frame),CGRectGetMidY(self.frame));
    boardNode.name = @"boardNode";
    boardNode.zPosition = 0.0;
    return boardNode;
}

- (SKLabelNode *)difficultyNameNode
{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    label.zPosition = 0.5;
    label.text = @"難度";
    label.fontSize = 20;
    label.fontColor = [SKColor blueColor];
    label.position = CGPointMake(50, 230);
    return label;
}

- (SKLabelNode *)scoreNameNode
{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    label.zPosition = 0.5;
    label.text = @"分數";
    label.fontSize = 20;
    label.fontColor = [SKColor greenColor];
    label.position = CGPointMake(50, 170);
    return label;
}


- (SKLabelNode *)difficultyNumberNode
{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    label.zPosition = 0.5;
    label.text = @"0";
    label.fontSize = 20;
    label.fontColor = [SKColor blueColor];
    label.position = CGPointMake(50, 200);
    return label;
}

- (SKLabelNode *)scoreNumberNode
{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    label.zPosition = 0.5;
    label.text = @"0";
    label.fontSize = 20;
    label.fontColor = [SKColor greenColor];
    label.position = CGPointMake(50, 140);
    return label;
}


- (SKSpriteNode *)heartNodeWithIndex:(NSUInteger)index
{
    SKSpriteNode *boardNode = [SKSpriteNode spriteNodeWithImageNamed:@"heart_full.png"];
    boardNode.texture = [SKTexture textureWithImageNamed:@"heart_full.png"];
    float x = 0;
    if (index == 1) {
        x = 20;
    }
    if (index == 2) {
        x = 50;
    }
    if (index == 3) {
        x = 80;
    }
    
    boardNode.position = CGPointMake(x,120);
    boardNode.name = @"heartNode";
    boardNode.zPosition = 0.0;
    return boardNode;
}

@end
