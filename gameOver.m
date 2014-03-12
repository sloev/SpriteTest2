//
//  gameOver.m
//  SpriteTest2
//
//  Created by johannes on 3/5/14.
//  Copyright (c) 2014 Sprite. All rights reserved.
//

#import "gameOver.h"
#import "Hello.h"
@interface gameOver ()
@property int score;
@property bool readyToReturn;


@end


@implementation gameOver

-(id)initWithSize:(CGSize)size score: (NSInteger)player_score {
    _score = player_score;
    if (self = [super initWithSize:size]) {
        [self addChild: [self newScoreList]];
        _readyToReturn = YES;
    }
    return self;
}
- (SKNode *)newScoreList

{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //test
    int highScore1 = [[prefs objectForKey:@"first_place"] intValue ];
    int highScore2 = [[prefs objectForKey:@"second_place"] intValue ];
    int highScore3 = [[prefs objectForKey:@"third_place"] intValue ];
    
    NSString *highScore1name = [prefs stringForKey:@"first_place_name"];
    NSString *highScore2name = [prefs stringForKey:@"second_place_name"];
    NSString *highScore3name = [prefs stringForKey:@"third_place_name"];
    
    SKNode *scoreList = [SKNode node];
    scoreList.name=@"scoreListLabel";
    SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    title.fontSize=40;
    title.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+42);
    title.text=[NSString stringWithFormat:@"HIGHSCORE:"];
    
    
    SKLabelNode *highscore1label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    SKLabelNode *highscore2label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    SKLabelNode *highscore3label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    highscore1label.text = [NSString stringWithFormat:@"%@  \t%i",highScore1name,highScore1];
    highscore2label.text = [NSString stringWithFormat:@"%@  \t%i",highScore2name,highScore2];
    highscore3label.text = [NSString stringWithFormat:@"%@  \t%i",highScore3name,highScore3];
    
    if(highScore1!=0)
    {
        [scoreList addChild:title];
        
        highscore1label.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        [scoreList addChild:highscore1label];
        if(highScore2!=0)
        {
            highscore2label.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-highscore2label.fontSize-2);
            [scoreList addChild:highscore2label];
            
            if(highScore3!=0)
            {
                highscore3label.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-highscore2label.fontSize*2-2);
                [scoreList addChild:highscore3label];
                
            }
        }
    }
    return scoreList;
    
}

-(void)didMoveToView:(SKView *)view {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    int highScore1 = [[prefs objectForKey:@"first_place"] intValue ];
    
    if (highScore1==0 || highScore1 < _score)
    {
        SKLabelNode *highScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        highScore.name=@"highscore";
        highScore.text=[NSString stringWithFormat:@"NEW HIGHSCORE:"];
        highScore.position=CGPointMake(self.size.width/2,self.size.height-150);
        [self addChild:highScore];
        
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(self.size.width/2, 100, 400, 40)];
        textField.center = CGPointMake(self.size.width/2,200.0);
        textField.borderStyle = UITextBorderStyleLine;
        textField.textColor = [UIColor whiteColor];
        textField.font = [UIFont fontWithName:@"Chalkduster" size:38];
        textField.placeholder = @"NAME";
        textField.backgroundColor = [UIColor blackColor];
        textField.autocorrectionType = UITextAutocorrectionTypeYes;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
        [self.view addSubview:textField];
        [textField becomeFirstResponder];
        _readyToReturn = NO;

    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    int highScore1 = [[[NSUserDefaults standardUserDefaults] objectForKey:@"first_place"] intValue ];
    int highScore2 = [[[NSUserDefaults standardUserDefaults] objectForKey:@"second_place"] intValue ];
    int highScore3 = [[[NSUserDefaults standardUserDefaults] objectForKey:@"third_place"] intValue ];
    
    NSString *highScore1name = [prefs objectForKey:@"first_place_name"];
    NSString *highScore2name = [prefs  stringForKey:@"second_place_name"];
    
    highScore3 = highScore2;
    highScore2 = highScore1;
    highScore1 = _score;
    
    
    [prefs setObject:[NSNumber numberWithInt:highScore1] forKey:@"first_place"];
    
    [prefs setObject:[NSNumber numberWithInt:highScore2] forKey:@"second_place"];
    [prefs setObject:[NSNumber numberWithInt:highScore3] forKey:@"third_place"];
    
    [prefs setObject: textField.text forKey:@"first_place_name"];
    [prefs setObject: highScore1name forKey:@"second_place_name"];
    [prefs setObject: highScore2name forKey:@"third_place_name"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    SKNode *scoreList = [self childNodeWithName:@"scoreListLabel"];
    SKLabelNode *highscore = [self childNodeWithName:@"highscore"];
    [highscore removeFromParent];
    [scoreList removeFromParent];
    [self addChild: [self newScoreList]];
    
    [textField resignFirstResponder];
    [textField removeFromSuperview];
    _readyToReturn=YES;
    return YES;
}


- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    if (_readyToReturn)
        
    {
        
        SKScene *spaceshipScene  = [[Hello alloc] initWithSize:self.size];
        
        SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
        
        [self.view presentScene:spaceshipScene transition:doors];
        
    }
    
}

@end

