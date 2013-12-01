/*
* Ozone - iOS Edition
* Copyright (C) 2009-2013 Ignacio Sanchez

* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* any later version.

* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.

* You should have received a copy of the GNU General Public License
* along with this program. If not, see http://www.gnu.org/licenses/
*
*/


#include "Ozone/inputmanager.h"

//
//  EAGLView.m
//  Ozone
//
//  Created by nacho on 12/02/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//



#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "EAGLView.h"

#include "uimanager.h"

#define USE_DEPTH_BUFFER 1

// A class extension to declare private methods
@interface EAGLView()

@property(nonatomic, retain) EAGLContext *context;
@property(nonatomic, assign) NSTimer *animationTimer;

-(BOOL) createFramebuffer;
-(void) destroyFramebuffer;

@end


@implementation EAGLView

@synthesize context;
@synthesize animationTimer;
@synthesize animationInterval;
@synthesize delegate;


// You must implement this method

+(Class) layerClass
{
    return [CAEAGLLayer class];
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:

-(id) initWithCoder : (NSCoder*) coder
{

    m_bStarted = false;
    m_bFinished = false;
	displayLink = nil;
	
    if ((self = [super initWithCoder : coder]))
    {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *) self.layer;

        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys :
                [NSNumber numberWithBool : NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];

        context = [[EAGLContext alloc] initWithAPI : kEAGLRenderingAPIOpenGLES1];

        if (!context || ![EAGLContext setCurrentContext : context])
        {
            [self release];
            return nil;
        }

        animationInterval = ANIMATION_INTERVAL;
    }
    return self;
}

-(void) drawView
{

    ///////////////////////

    if (m_bStarted)
    {
        GameManager::Instance().Update();
    }

    ///////////////////////

}

-(void) layoutSubviews
{
    [EAGLContext setCurrentContext : context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    //[self drawView];
}

-(BOOL) createFramebuffer
{

    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);

    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage : GL_RENDERBUFFER_OES fromDrawable : (CAEAGLLayer*) self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);

    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);

    if (USE_DEPTH_BUFFER)
    {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }

    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
    {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }

    [self setMultipleTouchEnabled : YES];

    bool homeRight = false;

    UIDevice *aDevice = [UIDevice currentDevice];

    NSLog(@"Running on %@", [aDevice localizedModel]);

#ifdef GEARDOME_PLATFORM_IPAD
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    homeRight = (orientation == UIDeviceOrientationLandscapeLeft);  ///--- home a la dcha

    if (homeRight)
    {
        [[UIApplication sharedApplication] setStatusBarOrientation : UIInterfaceOrientationLandscapeRight animated : NO];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarOrientation : UIInterfaceOrientationLandscapeLeft animated : NO];
    }
#else

    if ([[aDevice localizedModel] isEqualToString : @"iPod touch"])
    {
        homeRight = true;
    }

#endif

    Renderer::Instance().Init(context, viewRenderbuffer, viewFramebuffer, depthRenderbuffer);

    GameManager::Instance().Init(homeRight, delegate, self.window);

    m_bStarted = true;
    
    //[NSThread detachNewThreadSelector : @selector(_mainLoop :) toTarget : self withObject : nil];
	
	displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView)];
	[displayLink setFrameInterval:1];
	[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	
    return YES;
}

-(void) destroyFramebuffer
{

    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;

    if (depthRenderbuffer)
    {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}

- (void)setDelegate:(OzoneAppDelegate*)del {
    delegate = del;
}

-(void) startAnimation {
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(_handleUI) userInfo:nil repeats:YES];
}

-(void) _handleUI
{
    UIManager::Instance().Update();
}

-(void) _mainLoop : (id) context
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    [NSThread setThreadPriority : 1.0];

    while (m_bStarted)
    {
        [self drawView];
    }

    //Renderer::Instance().Cleanup();
    //GameManager::Instance().Cleanup();

    [pool release];

    m_bFinished = true;
}

-(void) stopAnimation {
    self.animationTimer = nil;
}

-(void) setAnimationTimer : (NSTimer *) newTimer {
    //[animationTimer invalidate];
    //animationTimer = newTimer;
}

-(void) setAnimationInterval : (NSTimeInterval) interval {
    /*
    animationInterval = interval;
    if (animationTimer) {
        [self stopAnimation];
        [self startAnimation];
    }*/ }

-(void) cleanup
{
	[displayLink invalidate];
	displayLink = nil;
	
	Renderer::Instance().Cleanup();
    GameManager::Instance().Cleanup();
	
	/*
    m_bStarted = false;

    while (!m_bFinished)
    {
        [ NSThread sleepForTimeInterval : 0.1];
    }*/
}

-(void) dealloc
{
    [self stopAnimation];

    if ([EAGLContext currentContext] == context)
    {
        [EAGLContext setCurrentContext : nil];
    }

    [context release];
    [super dealloc];
}

-(void) _handleTouch : (UITouch *) touch
{
    InputManager::Instance().HandleTouch(touch, self);
}

// Handles the start of a touch

-(void) touchesBegan : (NSSet *) touches withEvent : (UIEvent *) event
{
    for (UITouch *touch in touches)
    {
        [self _handleTouch : touch];
    }
}

// Handles the continuation of a touch.

-(void) touchesMoved : (NSSet *) touches withEvent : (UIEvent *) event
{
    for (UITouch *touch in touches)
    {
        [self _handleTouch : touch];
    }
}

// Handles the end of a touch event when the touch is a tap.

-(void) touchesEnded : (NSSet *) touches withEvent : (UIEvent *) event
{
    for (UITouch *touch in touches)
    {
        [self _handleTouch : touch];
    }
}

// Handles the end of a touch event.

-(void) touchesCancelled : (NSSet *) touches withEvent : (UIEvent *) event
{
    for (UITouch *touch in touches)
    {
        [self _handleTouch : touch];
    }
}


@end
