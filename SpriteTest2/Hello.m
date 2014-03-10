//
//  Hello.m
//  SpriteTest2
//
//  Created by johannes on 2/25/14.
//  Copyright (c) 2014 Sprite. All rights reserved.
//

#import "Hello.h"
#import "spaceShipScene.h"

@interface Hello ()

@property BOOL contentCreated;

@end



@implementation Hello

- (void)didMoveToView: (SKView *) view

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
    
    [self addChild: [self newHelloNode]];
    
    SKSpriteNode *backgroundBack = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundSTARTback"];
    backgroundBack.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    backgroundBack.size=self.size;
    backgroundBack.zPosition=-3;
    [self addChild:backgroundBack];
    
    SKSpriteNode *backgroundFront = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundSTARTfront"];
    backgroundFront.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    backgroundFront.size=self.size;
    backgroundFront.zPosition=-1;
    [self addChild:backgroundFront];
    
    [self runMakeFruits:2];
    
    
    
}

- (SKLabelNode *)newHelloNode

{
    
    
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    helloNode.name = @"helloNode";
    
    helloNode.text = @"start";
    
    helloNode.fontSize = 42;
    
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame),100);
    
    return helloNode;
    
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event

{
    
    SKNode *helloNode = [self childNodeWithName:@"helloNode"];
    
    if (helloNode != nil)
        
    {
        
        helloNode.name = nil;
        
        SKAction *moveUp = [SKAction moveByX: 0 y: 100.0 duration: 0.5];
        
        SKAction *zoom = [SKAction scaleTo: 2.0 duration: 0.25];
        
        SKAction *pause = [SKAction waitForDuration: 0.5];
        
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
        
        SKAction *remove = [SKAction removeFromParent];
        
        SKAction *moveSequence = [SKAction sequence:@[moveUp, zoom, pause, fadeAway, remove]];
        
        [helloNode runAction: moveSequence completion:^{
            
            SKScene *spaceshipScene  = [[spaceShipScene alloc] initWithSize:self.size];
            
            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
            
            [self.view presentScene:spaceshipScene transition:doors];
            
        }];
    }
    
}

-(void) runMakeFruits:(int) waitDuration
{
    SKAction *makeFruits = [SKAction sequence: @[
                                                 
                                                 [SKAction performSelector:@selector(addFruit) onTarget:self],
                                                 
                                                 [SKAction waitForDuration:waitDuration withRange:0.15]
                                                 
                                                 ]];
    
    [self runAction: [SKAction repeatActionForever:makeFruits] withKey:@"makeFruits" ];
    
}

-(void) addFruit
{
    
    SKSpriteNode *apple  = [SKSpriteNode spriteNodeWithImageNamed:@"apple"];
    apple.size=CGSizeMake(50,50);
    apple.name =@"apple";
    
    apple.position = CGPointMake(skRand(apple.size.width, self.size.width-apple.size.width), self.size.height-apple.size.height);
    apple.zPosition=-2;
    apple.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:apple.size];
    apple.physicsBody.usesPreciseCollisionDetection = YES;
    apple.physicsBody.dynamic=YES;
    
    
    SKAction *fall = [SKAction sequence:@[
                                          [SKAction moveToY:-5 duration:8]]];
    
    [apple runAction: [SKAction repeatActionForever:fall]];
    apple.physicsBody.affectedByGravity = NO;
    
    [self addChild:apple];
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
            [node removeFromParent];
        }
    }];
}

@end


