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

// 1
@interface MyScene () <SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode * player;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSInteger monstersDestroyed;
@property (nonatomic) NSInteger monstersKept;
@property (nonatomic) NSInteger monstersMissed;
@property (nonatomic) NSInteger monstersCount;

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
 
        // 2
        NSLog(@"Size: %@", NSStringFromCGSize(size));
 
        // 3
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
 
        // 4
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
    int minX = - monster.size.width / 2;
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
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
 
    // Create the actions
//    SKAction * actionMove = [SKAction moveTo:CGPointMake(-monster.size.width/2, actualY) duration:actualDuration];
    //
    SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX, - monster.size.height/2) duration:actualDuration];

    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * loseAction = [SKAction runBlock:^{
        self.monstersMissed++;
        NSLog(@"Miss: %i", self.monstersMissed);
        // 錯過三個就輸了
        if (self.monstersMissed >= 3) {
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:NO];
            [self.view presentScene:gameOverScene transition: reveal];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 
//    [self runAction:[SKAction playSoundFileNamed:@"pew-pew-lei.caf" waitForCompletion:NO]];
// 
    // 1 - Choose one of the touches to work with
    UITouch * touch = [touches anyObject];
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
 
    //
    SKAction *move = [SKAction moveToX:location.x duration:0];
    
    [self.player runAction:[SKAction sequence:@[move]]];
}

- (void)projectile:(SKSpriteNode *)projectile didCollideWithMonster:(SKSpriteNode *)monster {
    [projectile removeFromParent];
    [monster removeFromParent];
    self.monstersDestroyed++;
    NSLog(@"Destory: %i", self.monstersDestroyed);
    if (self.monstersDestroyed > 30) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:YES];
        [self.view presentScene:gameOverScene transition: reveal];
    }
}

- (void)player:(SKSpriteNode *)player didCollideWithMonster:(SKSpriteNode *)monster {
    [monster removeFromParent];
}


- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // 1
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
 
    // 2
    if ((firstBody.categoryBitMask & projectileCategory) != 0 &&
        (secondBody.categoryBitMask & monsterCategory) != 0)
    {
        [self projectile:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
    }
    
    if ((firstBody.categoryBitMask & playerCategory) != 0 &&
        (secondBody.categoryBitMask & monsterCategory) != 0)
    {
        self.monstersKept++;
        NSLog(@"Keep: %i", self.monstersKept);
        [self player:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
        // 接到十個就贏了
        if (self.monstersKept > 10) {
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:YES];
            [self.view presentScene:gameOverScene transition: reveal];
        }
    }

}

@end
