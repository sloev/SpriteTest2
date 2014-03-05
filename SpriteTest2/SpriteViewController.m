//
//  SpriteViewController.m
//  SpriteTest2
//
//  Created by johannes on 2/25/14.
//  Copyright (c) 2014 Sprite. All rights reserved.
//

#import "SpriteViewController.h"
#import "Hello.h"

@interface SpriteViewController ()

@end

@implementation SpriteViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    SKView *spriteView = (SKView *) self.view;
    
    spriteView.showsDrawCount = YES;
    
    spriteView.showsNodeCount = YES;
    
    spriteView.showsFPS = YES;
    
}
- (void)viewWillAppear:(BOOL)animated

{
    
    Hello* hello = [[Hello alloc] initWithSize:CGSizeMake(768,1024)];
    
    SKView *spriteView = (SKView *) self.view;
    
    [spriteView presentScene: hello];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
