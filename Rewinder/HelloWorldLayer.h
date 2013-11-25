//
//  HelloWorldLayer.h
//  Rewinder
//
//  Created by Pedro on 15/08/13.
//  Copyright Anonymous 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "CCPhysicsSprite.h"

#define PTM_RATIO 32

@interface HelloWorldLayer : CCLayer
{
	b2World *_world;
    b2Body *_body;
    CCPhysicsSprite *_ball;
    
    CGPoint initialPoint;
    
    NSTimer *mover;
    BOOL hasActionMove;
}

+ (CCScene *)scene;

@end
