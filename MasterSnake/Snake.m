//
//  Snake.m
//  snake-2
//
//  Copyright (c) 2014 Amos Joshua. All rights reserved.
//

#import "Snake.h"
#import "ObjectCategories.h"

@implementation Snake {
    double nodeScale;
}

- (id)init {
    self = [super init];
    if (self) {
        self.pointsPerNode = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 26 : 16);
        nodeScale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 0.35 : 0.25);
        self.startingNodeCount = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 10 : 5);
        self.angle = 0;
        self.snakeSpeed = 1;
        self.pendingSnakePoints = -1;
        self.pendingSnakeNodes = 0;
        [self initializeSnakePoints];
        [self initializeSnakeNodes];
        [self adjustHeadAndTail];
    }
    return self;
}

-(void)initializeSnakePoints {
    self.snakePoints = [NSMutableArray array];
    double pt_delta = 1;
    CGPoint pt;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        pt = CGPointMake(100, 400);
    else
        pt = CGPointMake(30, 150);
    int starting_point_count = self.startingNodeCount * self.pointsPerNode;
    for (int i = 0; i < starting_point_count; i += 1) {
        CGPoint pt2 = CGPointMake(pt.x + i*pt_delta, pt.y);
        [self addSnakePoint:pt2];
    }
}

- (void)initializeSnakeNodes {
    self.snakeNodes = [NSMutableArray array];
    int num_nodes = self.startingNodeCount;
    for (int i = 0; i < num_nodes; i += 1) {
        BOOL is_head = (i==num_nodes - 1);
        BOOL is_neck = (i==num_nodes - 2);
        CGPoint pos = [self snakePointAtIndex:i*self.pointsPerNode];
        SKSpriteNode *node = [self freshSnakeNodeAtPosition:pos isHead:is_head isNeck:is_neck];
        [self.snakeNodes addObject:node];
        [self addChild:node];
    }
    
}

- (SKSpriteNode *)freshSnakeNodeAtPosition:(CGPoint)pos isHead:(BOOL)isHead isNeck:(BOOL)isNeck {
    SKSpriteNode *node;
    if (isHead)
        node = [SKSpriteNode spriteNodeWithImageNamed:@"head-segment"];
    else
        node = [SKSpriteNode spriteNodeWithImageNamed:@"body-segment"];
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:node.size.width/2];
    if (isHead) {
        node.physicsBody.contactTestBitMask = SnakeNodeCategory | StarCategory;
        node.physicsBody.categoryBitMask = SnakeHeadCategory;
    }
    else if (isNeck) {
        node.physicsBody.collisionBitMask = 0;
    }
    else {
        node.physicsBody.categoryBitMask = SnakeNodeCategory;
        node.physicsBody.collisionBitMask = 0;
    }
    node.physicsBody.affectedByGravity = NO;
    node.physicsBody.dynamic = YES;
    
    node.xScale = nodeScale;
    node.yScale = nodeScale;
    node.position = pos;
    return node;
}

/* Snake Points */

-(void)addSnakePoint:(CGPoint)pt {
    NSValue *val = [NSValue valueWithCGPoint:pt];
    [self.snakePoints addObject:val];
}

-(CGPoint)snakePointAtIndex:(NSUInteger)ind {
    NSValue *val = [self.snakePoints objectAtIndex:ind];
    return [val CGPointValue];
}

-(CGPoint)lastSnakePoint {
    NSValue *val = [self.snakePoints lastObject];
    return [val CGPointValue];
}

-(CGPoint)popSnakePointAtIndex:(NSUInteger)ind {
    CGPoint pt = [self snakePointAtIndex:ind];
    [self.snakePoints removeObjectAtIndex:ind];
    return pt;
}


-(void)advanceSnakePoint {
    
    CGPoint first_pt;
    if (self.pendingSnakePoints >= 0) {
        first_pt = [self snakePointAtIndex:0];
        self.pendingSnakePoints -= 1;
        if (self.pendingSnakePoints % self.pointsPerNode == 0) {
            self.pendingSnakeNodes += 1;
        }
    }
    else{
        first_pt = [self popSnakePointAtIndex:0];
    }
    CGPoint last_pt = [self lastSnakePoint];
    first_pt.x = last_pt.x + self.snakeSpeed * cos(self.angle);
    first_pt.y = last_pt.y - self.snakeSpeed * sin(self.angle);
    [self addSnakePoint:first_pt];
    
}

/* Snake Nodes */

- (void)advanceSnakeNode {
    int delta = [self.snakePoints count] - [self.snakeNodes count] * self.pointsPerNode;
    int i = 0;

    for (SKSpriteNode *node in self.snakeNodes) {
        node.position = [self snakePointAtIndex:delta + i*self.pointsPerNode];
        node.xScale = nodeScale;
        node.yScale = nodeScale;
        i += 1;
    }
    if (self.pendingSnakeNodes > 0) {
        CGPoint pos = [self snakePointAtIndex:0];
        SKSpriteNode *node = [self freshSnakeNodeAtPosition:pos isHead:NO isNeck:NO];
        [self.snakeNodes insertObject:node atIndex:0];
        [self addChild:node];
        self.pendingSnakeNodes -= 1;
    }
    
    [self adjustHeadAndTail];
}

- (void)adjustHeadAndTail {
    [[self.snakeNodes lastObject] setZRotation:-self.angle - M_PI_2];
    [[self.snakeNodes objectAtIndex:0] setXScale:nodeScale - 0.08];
    [[self.snakeNodes objectAtIndex:0] setYScale:nodeScale - 0.08];
    [[self.snakeNodes objectAtIndex:1] setXScale:nodeScale - 0.07];
    [[self.snakeNodes objectAtIndex:1] setYScale:nodeScale - 0.07];
    [[self.snakeNodes objectAtIndex:1] setXScale:nodeScale - 0.05];
    [[self.snakeNodes objectAtIndex:1] setYScale:nodeScale - 0.05];
}

- (BOOL)hasPendingNodes {
    return (self.pendingSnakePoints > 0);
}

- (void)lengthenSnakeByNodes:(int)num_nodes {
    self.pendingSnakePoints = (num_nodes + 1) * self.pointsPerNode - 1;
}

/* General Snake */

- (void)advanceSnake:(int)steps {
    for (int i = 0; i < steps; i += 1)
        [self advanceSnakeOneStep];
}

- (void)advanceSnakeOneStep {
    [self advanceSnakePoint];
    [self advanceSnakeNode];
}

- (int)score {
    return [self.snakeNodes count] - self.startingNodeCount;
}

- (BOOL)headIsInRect:(CGRect)frame {
    CGPoint head_pos = [self lastSnakePoint];
    return CGRectContainsPoint(frame, head_pos);
}

@end
