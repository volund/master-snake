//
//  GameScene.h
//  MasterSnake
//

//  Copyright (c) 2014 Amos Joshua. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
#import "SnakeControl.h"

@class Snake;
@class StarDistributor;

@interface GameScene : SKScene <SKPhysicsContactDelegate> {
    double accelX;
    double accelY;
    CGPoint lastTouchLocation;
    BOOL isTouching;
    int snakeStepsStart;
    int snakeSteps;
}

@property (nonatomic, strong) Snake *snake;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) id <SnakeControl> snakeController;
@property (nonatomic, strong) StarDistributor* starDistributor;
@property (nonatomic) BOOL snakeIsActive;
@property (nonatomic) BOOL snakeIsDead;
@property (nonatomic, weak) UIViewController *presentingViewController;
@property (nonatomic, strong) SKLabelNode *score;

@end
