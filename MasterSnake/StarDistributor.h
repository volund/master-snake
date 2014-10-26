//
//  StarDistributor.h
//  snake-2
//
//  Copyright (c) 2014 Amos Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@class Star;

@interface StarDistributor : NSObject

@property (nonatomic) CGSize allowedFrame;
@property (nonatomic, retain) Star *star;

- (void)removeStar;
- (void)distributeStar:(SKScene *)parentNode;

@end
