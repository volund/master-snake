//
//  SnakeControl.h
//  snake-2
//
//  Copyright (c) 2014 Amos Joshua. All rights reserved.
//

#import <UIKit/UIKit.h>;

#ifndef snake_2_SnakeControl_h
#define snake_2_SnakeControl_h

@class Snake;

@protocol SnakeControl <NSObject>

- (void)steerSnake:(Snake *)snake accelX:(double)accelX accelY:(double)accelY touching:(BOOL)touching lastTouchLocation:(CGPoint)lastTouchLocation;

@end

#endif
