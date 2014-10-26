//
//  Star.m
//  snake-2
//
//  Copyright (c) 2014 Amos Joshua. All rights reserved.
//

#import "Star.h"
#import "ObjectCategories.h"

@implementation Star

- (id)initWithPosition:(CGPoint)pos {
    self = [super initWithImageNamed:@"star"];
    if (self)
        [self configStarWithPosition:pos];
    return self;
}

- (void)configStarWithPosition:(CGPoint)pos {
    self.value = random() % 10;
    self.position = pos;
    double scalte_delta = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 0.0 : 0.3);
    self.xScale = 0.5 + self.value / 10.0 - scalte_delta;
    self.yScale = self.xScale;
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
    self.physicsBody.categoryBitMask = StarCategory;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.dynamic = YES;
}

@end
