//
//  gameOver.m
//  SpriteTest2
//
//  Created by johannes on 3/5/14.
//  Copyright (c) 2014 Sprite. All rights reserved.
//

#import "gameOver.h"
@interface gameOver ()
@property int score;
@property int highscore;


@end


@implementation gameOver

-(id)initWithSize:(CGSize)size score: (NSInteger)player_score highscore:(NSInteger)high_score;{
    _score = player_score;
    _highscore=high_score;
        if (self = [super initWithSize:size]) {
            [self addChild: [self newScoreList]];
        }
    return self;
}
- (SKLabelNode *)newScoreList

{
    
    
    SKLabelNode *scoreList = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    scoreList.name = @"scoreListLabel";
    
    scoreList.text = [NSString stringWithFormat:@"new score = %i \n highscore = %i",_score,_highscore];
    
    scoreList.fontSize = 42;
    
    scoreList.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    
    return scoreList;
    
}

-(void)didMoveToView:(SKView *)view {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(self.size.width/2, 100, 200, 40)];
    textField.center = CGPointMake(100.0,100.0);
    textField.borderStyle = UITextBorderStyleNone;
    textField.textColor = [UIColor blackColor];
    textField.font = [UIFont fontWithName:@"Chalkduster" size:42];
    textField.placeholder = @"NAME";
    textField.backgroundColor = [UIColor whiteColor];
    textField.autocorrectionType = UITextAutocorrectionTypeYes;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    [self.view addSubview:textField];
}




@end
