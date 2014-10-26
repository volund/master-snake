//
//  LeftRightController.m
//  snake-2
//
//  Copyright (c) 2014 Amos Joshua. All rights reserved.
//

#import "LeftRightController.h"
#import "Snake.h"

@implementation LeftRightController

- (void)steerSnake:(Snake *)snake accelX:(double)accelX accelY:(double)accelY touching:(BOOL)touching lastTouchLocation:(CGPoint)lastTouchLocation {
    snake.angle = [self newAngleForAccelx:accelX accelY:accelY angle:snake.angle speed:snake.speed];
}

- (double)newAngleForAccelx:(double)accelX accelY:(double)accelY angle:(double)angle speed:(double)speed {
    double new_angle = angle;
    
/*
    if (fabsf(accelX) < 0.01)
        return new_angle;
    */
    
    if (fabsf(accelX) >= fabsf(lastAccelX))
        new_angle += accelX / 5.0;
    else
        new_angle += accelX / 20.0;

        
    if (new_angle > M_PI)
        new_angle -= 2*M_PI;
    if (new_angle < -M_PI)
        new_angle += 2*M_PI;
    
    lastAccelX = accelX;

    return new_angle;
}

@end
