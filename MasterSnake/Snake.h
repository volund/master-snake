//
//  Snake.h
//  snake-2
//
//  Copyright (c) 2014 Amos Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Snake : SKSpriteNode

@property (nonatomic) double snakeSpeed;
@property (nonatomic) double angle;
@property (nonatomic) int pendingSnakePoints;
@property (nonatomic) int pendingSnakeNodes;
@property (nonatomic) int pointsPerNode;
@property (nonatomic) int startingNodeCount;
@property (nonatomic, strong) NSMutableArray *snakePoints;
@property (nonatomic, strong) NSMutableArray *snakeNodes;

- (void)advanceSnake:(int)steps;
- (void)advanceSnakeOneStep;
- (int)score;
- (BOOL)headIsInRect:(CGRect)frame;
- (BOOL)hasPendingNodes;
- (void)lengthenSnakeByNodes:(int)numNodes;
- (CGPoint)lastSnakePoint;

@end
