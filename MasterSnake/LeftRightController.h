//
//  LeftRightController.h
//  snake-2
//
//  Copyright (c) 2014 Amos Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SnakeControl.h"

@interface LeftRightController : NSObject <SnakeControl> {
    double lastAccelX;
}

@end
