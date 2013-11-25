//
//  HelloWorldLayer.mm
//  Rewinder
//
//  Created by Pedro on 15/08/13.
//  Copyright Anonymous 2013. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"
#import "CCPhysicsSprite.h"
#import "AppDelegate.h"
#import "IntroLevelLayer.h"

@interface HelloWorldLayer()

@end

@implementation HelloWorldLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
        [self setTouchEnabled:YES];
        
        IntroLevelLayer *moveLayer = [[[IntroLevelLayer alloc] init] autorelease];
        moveLayer.position = ccp(0, 0);
        
        [self addChild:moveLayer z:-1];
        
        //Create Sprite
        _ball = [CCPhysicsSprite spriteWithFile:@"hero.png" rect:CGRectMake(0, 0, 40, 60)];
        [self addChild:_ball];
        
        //Create world
        b2Vec2 gravity = b2Vec2(0.0f, -12.0f);
        _world = new b2World(gravity);
        
        _world->SetAllowSleeping(true);
        
        _world->SetContinuousPhysics(true);

        GLESDebugDraw *m_debugDraw;
        m_debugDraw = new GLESDebugDraw( PTM_RATIO );
        _world->SetDebugDraw(m_debugDraw);
        
        uint32 flags = 0;
        flags += b2Draw::e_shapeBit;
        m_debugDraw->SetFlags(flags);
        
        // Create ball body and shape
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.position.Set(6300.0/PTM_RATIO, 65.0/PTM_RATIO);
        ballBodyDef.userData = _ball;
        _body = _world->CreateBody(&ballBodyDef);
        
        b2PolygonShape circle;
        circle.SetAsBox(_ball.contentSize.width/PTM_RATIO/2.0, _ball.contentSize.height/PTM_RATIO/2.0);
        
        [_ball setPTMRatio:PTM_RATIO];
        [_ball setB2Body:_body];
        
        b2FixtureDef ballShapeDef;
        ballShapeDef.shape = &circle;
        ballShapeDef.density = 1.0f;
        ballShapeDef.friction = 0.2f;
        _body->CreateFixture(&ballShapeDef);
        
        [self createEdges];
        
        _body->SetLinearVelocity(b2Vec2(-10.0, 0.0));
        
        [self movePlataform];
        
        [self schedule:@selector(updateBox2d:)];
        
	}
	return self;
}

- (void)createEdges {
    
    //CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // Create edges around the entire screen
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0);
    
    
    b2BodyDef bodyDef;
	bodyDef.position.Set(5000.0 / PTM_RATIO, 100.0/PTM_RATIO);
	b2Body *body = _world->CreateBody(&bodyDef);
	
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(40.0/PTM_RATIO/2.0, 40.0/PTM_RATIO/2.0);
	
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	body->CreateFixture(&fixtureDef);
    
    CCSprite *boxBlock = [CCSprite spriteWithFile:@"hero.png" rect:CGRectMake(0, 0, 40, 40)];
    boxBlock.position = ccp(5000, 100);
    [self addChild:boxBlock];
//
//    b2BodyDef groundBodyDefTop;
//	groundBodyDefTop.position.Set(0, winSize.height/PTM_RATIO);
//
//    b2BodyDef groundBodyDefLeft;
//	groundBodyDefLeft.position.Set(0, 0);
//
//    b2BodyDef groundBodyDefRight;
//	groundBodyDefRight.position.Set(6400/PTM_RATIO, 0);

	b2Body *groundBody = _world->CreateBody(&groundBodyDef);
//	b2Body *groundBodyTop = _world->CreateBody(&groundBodyDefTop);
//	b2Body *groundBodyLeft = _world->CreateBody(&groundBodyDefLeft);
//	b2Body *groundBodyRight = _world->CreateBody(&groundBodyDefRight);
	
    b2EdgeShape ground;
	b2FixtureDef boxShape;
	
    boxShape.shape = &ground;
	//wall definitions
	ground.Set(b2Vec2(0.0, 64.0/PTM_RATIO), b2Vec2(6400.0/PTM_RATIO, 64.0/PTM_RATIO)); //down
	groundBody->CreateFixture(&boxShape);
    
    ground.Set(b2Vec2(0.0, 300.0/PTM_RATIO), b2Vec2(2000.0/PTM_RATIO, 0.0/PTM_RATIO)); //down
	groundBody->CreateFixture(&boxShape);
    
//    ground.Set(b2Vec2(0, 0), b2Vec2(6400/PTM_RATIO, 0)); //left
//	groundBody->CreateFixture(&boxShape);
//    
//    ground.Set(b2Vec2(0,0), b2Vec2(0, winSize.height/PTM_RATIO)); //down
//	groundBody->CreateFixture(&boxShape);
//
//    ground.Set(b2Vec2(0,0), b2Vec2(0, winSize.height/PTM_RATIO)); //top
//	groundBody->CreateFixture(&boxShape);
    
}

- (void)updateBox2d:(ccTime) dt {
    
    int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	_world->Step(dt, velocityIterations, positionIterations);
    
    _ball.position = ccp(ceilf(_body->GetPosition().x * PTM_RATIO), ceilf(_body->GetPosition().y * PTM_RATIO));
    
    _body->SetLinearVelocity(b2Vec2(-10, _body->GetLinearVelocity().y));
    
//    _world->Step(dt, 1, 1);
//    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
//        if (b->GetUserData() == _ball) {
//            
//            CCSprite *ballData = (CCSprite *)b->GetUserData();
//            NSLog(@"yPosition: %f - %f", b->GetPosition().y * PTM_RATIO, b->GetPosition().x * PTM_RATIO);
//            
//            //b->SetAngularVelocity(0);
//            //_body->SetLinearVelocity(b2Vec2(-5, 0));
//    
//            ballData.position = ccp(ceilf(b->GetPosition().x * PTM_RATIO), b->GetPosition().y * PTM_RATIO);
//            ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
//        }
//    }
    
    [self movePlataform];
}

- (void)movePlataform {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGRect worldRect = CGRectMake(0, 0, 6400, 400);
    CGPoint position = _ball.position;
    
    int x = MAX(position.x, worldRect.origin.x + winSize.width / 2);
    int y = MAX(position.y, worldRect.origin.y + winSize.height / 2);
    x = MIN(x, (worldRect.origin.x + worldRect.size.width) - winSize.width / 2);
    y = MIN(y, (worldRect.origin.y + worldRect.size.height) - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    
    self.position = viewPoint;
    
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch* touch = [touches anyObject];
    CGPoint new_location = [touch locationInView: [touch view]];
    new_location = [[CCDirector sharedDirector] convertToGL:new_location];
    //NSLog(@"position: %@",NSStringFromCGPoint(new_location));
    
    hasActionMove = NO;
    initialPoint = new_location;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    if(new_location.x >= winSize.width / 2.0) {
        _body->ApplyLinearImpulse(b2Vec2(0.0, 20),_body->GetPosition());
    }else{
//        _body->SetLinearVelocity(b2Vec2(-10, 0));
    }
    
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    hasActionMove = YES;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch* touch = [touches anyObject];
//    CGPoint new_location = [touch locationInView: [touch view]];
//    new_location = [[CCDirector sharedDirector] convertToGL:new_location];
//    
//    CGPoint add = CGPointMake(new_location.x - initialPoint.x, new_location.y - initialPoint.y);
//    
    //_body->SetLinearVelocity(b2Vec2(0, 0));
    //_body->SetAngularVelocity(0);
    //_body->ApplyLinearImpulse(b2Vec2(add.x * 0.1, add.y * 0.1),_body->GetPosition());
    
//    if(hasActionMove) {
//        _body->SetLinearVelocity(b2Vec2(0, 0));
//        _body->SetAngularVelocity(0);
//        _body->ApplyLinearImpulse(b2Vec2(add.x * 0.1, add.y * 0.1),_body->GetPosition());
//    }else{
//        b2Vec2 force = b2Vec2(0, 0);
//        _body->SetLinearVelocity(force);
//        _body->SetAngularVelocity(0);
//    }
}

-(void) dealloc
{
	delete _world;
	_world = NULL;
	_body = NULL;
    
	[super dealloc];
}	

@end