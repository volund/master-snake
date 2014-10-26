//
//  AllTiltController.m
//  snake-2
//
//  Copyright (c) 2014 Amos Joshua. All rights reserved.
//

#import "AllTiltController.h"
#import "Snake.h"

@implementation AllTiltController

- (void)steerSnake:(Snake *)snake accelX:(double)accelX accelY:(double)accelY touching:(BOOL)touching lastTouchLocation:(CGPoint)lastTouchLocation {
    snake.angle = [self newAngleForAccelx:accelX accelY:accelY angle:snake.angle speed:snake.snakeSpeed];
}

- (double)newAngleForAccelx:(double)accelX accelY:(double)accelY angle:(double)angle speed:(double)speed {
    double theta = atan2f(accelY, accelX);
    double new_angle = angle;
    
    
    //NSLog(@"x: %.3f    y: %.3f", accelX, accelY);
    if ((fabsf(accelX) < 0.02) && (fabsf(accelY) < 0.02))
        return new_angle;
    
    
    if ((theta > M_PI/2) && (new_angle < -M_PI/2)) {
        theta -= 2*M_PI;
    }
    else if ((theta < -M_PI/2) && (new_angle > M_PI/2)) {
        theta += 2*M_PI;
    }
    
    if (theta > new_angle) {
        new_angle += 0.09;
    }
    else {
        new_angle -= 0.09;
    }
    
    if (new_angle > M_PI)
        new_angle -= 2*M_PI;
    if (new_angle < -M_PI)
        new_angle += 2*M_PI;
    
    return new_angle;
}
@end
