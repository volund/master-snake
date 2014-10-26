//
//  TouchAngleController
//  MasterSnake
//
//  Copyright (c) 2014 Amos Joshua. All rights reserved.
//

#import "TouchAngleController.h"
#import "Snake.h"

@implementation TouchAngleController

- (void)steerSnake:(Snake *)snake accelX:(double)accelX accelY:(double)accelY touching:(BOOL)touching lastTouchLocation:(CGPoint)lastTouchLocation {
    snake.angle = [self newAngleForTouch:lastTouchLocation touching:touching snakeLocation:snake.lastSnakePoint angle:snake.angle speed:snake.snakeSpeed];
}

- (double)newAngleForTouch:(CGPoint)touchLocation touching:(BOOL)touching snakeLocation:(CGPoint)snakePos angle:(double)angle speed:(double)speed {
    
    if (!touching)
        return angle;
    
    double theta = atan2f(touchLocation.y - snakePos.y,  touchLocation.x - snakePos.x);
    theta = -theta;
    double new_angle = angle;
    
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
