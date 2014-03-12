//
//  spaceShipScene.m
//  SpriteTest2
//
//  Created by johannes on 2/25/14.
//  Copyright (c) 2014 Sprite. All rights reserved.
//



#import "spaceShipScene.h"
#import "gameOver.h"

@interface spaceShipScene ()

@property BOOL contentCreated;
@property int player_score;

@end



@implementation spaceShipScene

static const uint32_t fruitCat     =  0x1 << 0;
static const uint32_t playerCat        =  0x1 << 1;

static int level=1;

- (void)didMoveToView:(SKView *)view

{
    
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents

{
    
    self.backgroundColor = [SKColor blackColor];
    
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsWorld.contactDelegate = self;
        //self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    SKSpriteNode *player = [self newPlayer];
    player.position = CGPointMake(CGRectGetMidX(self.frame),player.size.height);
    [self addChild:player];
    
    [self runMakeFruits:2];

    [self addChild:[self newScoreLabel]];
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.size=self.size;
    background.zPosition=-1;
    [self addChild:background];
    
}
-(SKLabelNode *) newScoreLabel
{
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.name = @"score";
    scoreLabel.text = [NSString stringWithFormat: @"%d",_player_score];
    scoreLabel.fontSize = 50;
    scoreLabel.position = CGPointMake(scoreLabel.fontSize,self.size.height-scoreLabel.fontSize);
    scoreLabel.zPosition=2;
    
    return scoreLabel;
}

-(void) runMakeFruits:(int) waitDuration
{
    SKAction *makeFruits = [SKAction sequence: @[
                                                 
                                                 [SKAction performSelector:@selector(addFruit) onTarget:self],
                                                 
                                                 [SKAction waitForDuration:waitDuration withRange:0.15]
                                                 
                                                 ]];
    
    [self runAction: [SKAction repeatActionForever:makeFruits] withKey:@"makeFruits" ];
    
}
- (SKSpriteNode *) newPlayer
{
    SKSpriteNode *player = [SKSpriteNode spriteNodeWithImageNamed:@"basket"];
    player.size=CGSizeMake(80,80)
    ;//[[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(64,64)];
    player.name = @"player";
    
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
    player.physicsBody.dynamic = NO;
    player.physicsBody.categoryBitMask=playerCat;

    player.physicsBody.usesPreciseCollisionDetection = YES;
    //player.zPosition=1;
    
    return player;
}

-(void) addFruit
{
    SKSpriteNode *fruit = [self newApple];
    
    fruit.physicsBody.categoryBitMask=fruitCat;

    fruit.position = CGPointMake(skRand(fruit.size.width, self.size.width-fruit.size.width), self.size.height-fruit.size.height);
    fruit.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:fruit.size];
    fruit.physicsBody.usesPreciseCollisionDetection = YES;
    fruit.physicsBody.dynamic=YES;
    fruit.physicsBody.contactTestBitMask=fruitCat | playerCat;

    int speed = 10-(level/2);
    
    SKAction *fall = [SKAction sequence:@[
                                          [SKAction moveToY:-5 duration:speed]]];
    
    [fruit runAction: [SKAction repeatActionForever:fall]];
    fruit.physicsBody.affectedByGravity = NO;
    
    [self addChild:fruit];
}

- ( SKSpriteNode *) newApple
{
    SKSpriteNode *apple  = [SKSpriteNode spriteNodeWithImageNamed:@"apple"];
    apple.size=CGSizeMake(50,50);
    apple.name =@"apple";
    
    return apple;
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    SKNode *player = [self childNodeWithName:@"player"];
    
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    // Determine speed
    int minDuration = 0.3;
    int maxDuration = 1.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(positionInScene.x,player.position.y) duration:actualDuration];
    
    
    [player runAction:actionMove];
    
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
    
    if((firstBody.categoryBitMask & playerCat)!=0
       && (secondBody.categoryBitMask & fruitCat)!=0){
        SKSpriteNode *tmp = secondBody.node;
        [self catchedApple:tmp];
    }
}

-(void)catchedApple:(SKSpriteNode *)apple
{
    NSLog(@"removing apple");
    _player_score=_player_score+1;
    if ( _player_score % 5 == 0)
    {
        [self newLevel];
    }
    SKLabelNode *scoreLabel = [self childNodeWithName:@"score"];
    scoreLabel.text = [NSString stringWithFormat:@"%d",_player_score];

    NSLog(@"score%d",_player_score);
    [apple removeFromParent];
}


-(void) newLevel
{
    level = level +1;

    [self  removeActionForKey:(@"makeFruits")];
    [self runMakeFruits:2-(level/10)];
    NSLog(@"new level");
    if (level > 9)
    {
        level=10;
    }

    
}

-(void) gameOver
{
    NSLog(@"inside gameover");

    SKScene * gameOverScene = [[gameOver alloc] initWithSize:self.size score:_player_score ];
        SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0];
        [self.view presentScene:gameOverScene transition:doors];
    

}


static inline CGFloat skRandf() {
    
    return rand() / (CGFloat) RAND_MAX;
    
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    
    return skRandf() * (high - low) + low;
    
}


-(void)didSimulatePhysics

{
    [self enumerateChildNodesWithName:@"apple" usingBlock:^(SKNode *node, BOOL *stop) {
        
        if (node.position.y < 0 )
        {
            [self removeAllChildren];
            [self gameOver];
        }
        }];
}
@end