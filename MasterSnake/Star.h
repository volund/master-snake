//
//  Star.h
//  snake-2
//
//  Copyright (c) 2014 Amos Joshua. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Star : SKSpriteNode
@property (nonatomic) int value;

- (id)initWithPosition:(CGPoint)pos;

@end
