//
//  GameScene.m
//  MasterSnake
//
//  Copyright (c) 2014 Amos Joshua. All rights reserved.
//

#import "GameScene.h"
#import "AllTiltController.h"
#import "LeftRightController.h"
#import "TouchAngleController.h"
#import "Star.h"
#import "Snake.h"
#import "StarDistributor.h"
#import "ObjectCategories.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    srandom(time(NULL));
    isTouching = false;
    
    snakeStepsStart = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 4 : 3);
    snakeSteps = snakeStepsStart;
    self.snakeIsActive = NO;
    self.snakeIsDead = NO;
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                 [self storeAccelertionData:accelerometerData.acceleration];
                                                 if(error)
                                                 {
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
    
    self.starDistributor = [[StarDistributor alloc] init];
    self.starDistributor.allowedFrame = self.view.frame.size;
    //self.snakeController = [[AllTiltController alloc] init];
    //self.snakeController = [[LeftRightController alloc] init];
    self.snakeController = [[TouchAngleController alloc] init];
    self.snake = [[Snake alloc] init];
    [self addChild:self.snake];
    
    [self.starDistributor distributeStar:self];
    
    [self doReadyGoAnimationAndActivateSnake];
    
    self.score = [SKLabelNode node];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.score.position = CGPointMake(100, 720);
    else
        self.score.position = CGPointMake(90, 695);
    self.score.fontColor = [UIColor blackColor];
    [self addChild:self.score];
    [self updateScore];
}

- (void)doReadyGoAnimationAndActivateSnake {
    SKSpriteNode *ready = [SKSpriteNode spriteNodeWithImageNamed:@"ready.png"];
    SKSpriteNode *go = [SKSpriteNode spriteNodeWithImageNamed:@"go.png"];
    
    ready.position = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 1.7);
    go.position = ready.position;
    
    [self addChild:ready];
    [ready runAction:[SKAction scaleBy:1.5 duration:1.5] completion:^{
        [ready removeFromParent];
        [self addChild:go];
        [go runAction:[SKAction fadeAlphaTo:0.0 duration:1] completion:^{
            [go removeFromParent];
        }];
        self.snakeIsActive = YES;
    }];
}

- (void)doGameOverAnimation {
    SKSpriteNode *gameover = [SKSpriteNode spriteNodeWithImageNamed:@"ohno.png"];
    
    gameover.position = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 1.7);
    gameover.alpha = 0.0;
    
    [self addChild:gameover];
    [gameover runAction:[SKAction fadeAlphaTo:1.0 duration:2]];
}

-(void)storeAccelertionData:(CMAcceleration)acceleration
{
    accelX = 0;
    accelY = 0;
    
    if(fabs(acceleration.y) > fabs(accelX))
    {
        accelX = acceleration.y;
    }
    if(fabs(acceleration.x) > fabs(accelY))
    {
        accelY = acceleration.x;
    }
}


-(void)update:(CFTimeInterval)currentTime {
    
    if (self.snakeIsActive) {
        [self.snakeController steerSnake:self.snake accelX:accelX accelY:accelY touching:isTouching lastTouchLocation:lastTouchLocation];
        [self.snake advanceSnake:snakeSteps];
        [self updateScore];
        if (![self.snake headIsInRect:self.frame])
            [self endGame];
    }
}

- (void)updateScore {
    self.score.text = [NSString stringWithFormat:@"Score: %d", [self.snake score]];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *bodyA = contact.bodyA;
    SKPhysicsBody *bodyB = contact.bodyB;
    
    if (bodyB.categoryBitMask < bodyA.categoryBitMask) {
        bodyA = contact.bodyB;
        bodyB = contact.bodyA;
    }
    
    if ((bodyA.categoryBitMask == SnakeHeadCategory) && (bodyB.categoryBitMask == StarCategory)){
        int star_value = self.starDistributor.star.value;
        [self.starDistributor removeStar];
        [self.starDistributor distributeStar:self];
        if (![self.snake hasPendingNodes]) {
            [self.snake lengthenSnakeByNodes:star_value];
            snakeSteps = snakeStepsStart + (self.snake.score / 50);
        }
        
    }
    else if ((bodyA.categoryBitMask == SnakeHeadCategory) && (bodyB.categoryBitMask == SnakeNodeCategory)) {
        [self endGame];
    }
}

- (void)endGame {
    self.snakeIsActive = NO;
    self.snakeIsDead = YES;
    [self doGameOverAnimation];
    
    int current_high_score = [[NSUserDefaults standardUserDefaults] integerForKey:@"com.snake.highscore"];
    if (current_high_score < self.snake.score) {
        [[NSUserDefaults standardUserDefaults] setInteger:self.snake.score forKey:@"com.snake.highscore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)updateLastTouch:(UIEvent *)event {
    NSSet *set = [event touchesForView:self.view];
    UITouch *touch = [set anyObject];
    lastTouchLocation = [touch locationInView:self.view];
    lastTouchLocation.y = self.view.frame.size.height - lastTouchLocation.y;
}

//handle touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.snakeIsDead) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    isTouching = YES;
    [self updateLastTouch:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"touches moved: %@", event);
    //NSLog(@"touches for: %@", [event touchesForView:self.view]);
    [self updateLastTouch:event];
//    NSLog(@"touchLoc: %@", NSStringFromCGPoint(lastTouchLocation));
    //NSLog(@"snake pos: %@", NSStringFromCGPoint(self.snake.lastSnakePoint));
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    isTouching = NO;
}

@end
