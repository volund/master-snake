//
//  StarDistributor.m
//  snake-2
//
//  Copyright (c) 2014 Amos Joshua. All rights reserved.
//

#import "StarDistributor.h"
#import "Star.h"

@implementation StarDistributor

- (id)init {
    self = [super init];
    if (self)
        self.star = nil;
    return self;
}

- (void)removeStar {
    if (self.star != nil) {
        [self.star removeFromParent];
        self.star = nil;
    }
}

- (void)distributeStar:(SKScene *)parentNode {
    CGPoint pos = CGPointMake(30 + random() % (int)(self.allowedFrame.width - 60), 30 + random() % (int)(self.allowedFrame.height - 60));
    self.star = [[Star alloc] initWithPosition:pos];
    [parentNode addChild:self.star];
}



@end
