//
//  IntroLevelLayer.m
//  Rewinder
//
//  Created by Pedro on 16/08/13.
//  Copyright (c) 2013 Anonymous. All rights reserved.
//

#import "IntroLevelLayer.h"

@implementation IntroLevelLayer

-(id) init
{
	if( (self=[super init])) {
		
        for (int i=0; i<100; i++) {
            CCSprite *tileBase = [CCSprite spriteWithFile:@"tile-1.png" rect:CGRectMake(0, 0, 64, 64)];
            tileBase.anchorPoint=ccp(0,0);
            tileBase.position = ccp(i * 64, 0);
            
            [self addChild:tileBase];
            
        }
        
	}
	
	return self;
}

@end
