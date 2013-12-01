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

//
//  OzoneAppDelegate.m
//  Ozone
//
//  Created by nacho on 12/02/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "OzoneAppDelegate.h"
#import "EAGLView.h"
#include "audiomanager.h"
#include "uimanager.h"
#include "Ozone/SaveManager.h"
#include "PlayHaven.h"

@implementation OzoneAppDelegate

@synthesize window;
@synthesize glView;

-(void) applicationDidFinishLaunching : (UIApplication *) application
{

#ifdef GEARDOME_PLATFORM_IPAD

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    [[NSNotificationCenter defaultCenter] addObserver : self selector : @selector(didRotateDevice :) name : @"UIDeviceOrientationDidChangeNotification" object : nil];

#else

    if ([[[UIDevice currentDevice] localizedModel] isEqualToString : @"iPod touch"])
    {
        [[UIApplication sharedApplication] setStatusBarOrientation : UIInterfaceOrientationLandscapeRight animated : NO];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarOrientation : UIInterfaceOrientationLandscapeLeft animated : NO];
    }	

	[PlayHaven preloadWithPublisherToken : @"A0l_hlD-B8YiP-Md8TplsQ" testing : NO];

#endif

    AudioManager::Instance().Init(44100);

    glView.delegate = self;

    glView.animationInterval = ANIMATION_INTERVAL;
    [glView startAnimation];
}

#ifdef GEARDOME_PLATFORM_IPAD

-(void) didRotateDevice : (NSNotification *) notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];

    if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight))
    {
        bool homeRight = (orientation == UIDeviceOrientationLandscapeLeft); ///--- home a la dcha

        if (homeRight)
        {
            [[UIApplication sharedApplication] setStatusBarOrientation : UIInterfaceOrientationLandscapeRight animated : NO];
        }
        else
        {
            [[UIApplication sharedApplication] setStatusBarOrientation : UIInterfaceOrientationLandscapeLeft animated : NO];
        }

        GameManager::Instance().SetHomeRight(homeRight);
    }
}
#endif

-(void) applicationWillResignActive : (UIApplication *) application
{
    glView.animationInterval = ANIMATION_INTERVAL;
}

-(void) applicationDidBecomeActive : (UIApplication *) application
{
    glView.animationInterval = ANIMATION_INTERVAL;
}

-(void) applicationWillTerminate : (UIApplication*) application
{
    [glView cleanup];
}

-(void) dealloc
{
    [window release];
    [glView release];
    [super dealloc];
}

-(void) alertView : (UIAlertView *) alertView clickedButtonAtIndex : (NSInteger) buttonIndex
{

    UIManager::Instance().AlertViewResponse(alertView, buttonIndex);
}

-(void) scores_back : (id) sender
{

    UIManager::Instance().AlertViewResponse(NULL, 0);
}

-(void) animationDidStop : (NSString *) animationID finished : (NSNumber *) finished context : (void *) context
{
    NSArray* scoresViews = [window subviews];
    UIView* view = [ scoresViews objectAtIndex : 1];
    [view removeFromSuperview];
}

-(void) threadCargarPuntos
{
    Log("+++ OzoneAppDelegate::threadCargarPuntos ...\n");

    [ NSThread detachNewThreadSelector : @selector(cargarPuntos) toTarget : self withObject : nil ];

}

-(void) cargarPuntos
{
    Log("+++ OzoneAppDelegate::cargarPuntos ...\n");


    NSAutoreleasePool *pool = [ [ NSAutoreleasePool alloc ] init ];

    char path[256];

    int rn = MAT_RandomInt(100, 10000);

    sprintf(path, "http://www.geardome.com/iphone/ozone/high.php?random=%d", rn);

    NSString *FeedURL = [NSString stringWithCString : path encoding : [NSString defaultCStringEncoding]];

    NSURLRequest *theRequest = [NSURLRequest requestWithURL : [NSURL URLWithString : FeedURL]
            cachePolicy : NSURLRequestReloadIgnoringCacheData
            timeoutInterval : 30];

    NSURLResponse *resp = nil;

    NSError *err = nil;

    NSData *response = [NSURLConnection sendSynchronousRequest : theRequest returningResponse : &resp error : &err];

    NSString * theString = [[NSString alloc] initWithData : response encoding : NSUTF8StringEncoding];

    const char *str = [theString UTF8String];

    if (strcmp(str, "") == 0)
    {
        Log("@@@ OzoneAppDelegate::cargarPuntos There was an error trying to connect.\n");
    }
    else
    {
        //char text[256];
        //strncpy(text, str, 254);
        //Log("+++ OzoneAppDelegate::cargarPuntos %s\n", text);
    }

    UIManager::Instance().WebResponse(str);

    [ pool release ];

    Log("+++ OzoneAppDelegate::cargarPuntos correcto\n");
}

-(void) threadEnviarPuntos
{
    Log("+++ OzoneAppDelegate::threadEnviarPuntos ...\n");

    [ NSThread detachNewThreadSelector : @selector(enviarPuntos) toTarget : self withObject : nil ];

}

-(void) enviarPuntos
{
    Log("+++ OzoneAppDelegate::enviarPuntos ...\n");


    NSAutoreleasePool *pool = [ [ NSAutoreleasePool alloc ] init ];


    char path[256];

    int puntos = SaveManager::Instance().GetScore();

    //long puntos = 170;
    unsigned long ra = ((puntos / 7) ^ 0xf317) + ((puntos % 9) * 9);

    char* name_final = SaveManager::Instance().GetName();

    //while (strstr(name_final, " "))
    {
        name_final = str_replace(" ", "%20", name_final);
    }

    int level = SaveManager::Instance().GetLevelCompleted();

    sprintf(path, "http://www.geardome.com/iphone/ozone/score.php?nombre=%s&sc=%d&le=%d&ra=%lu", name_final, puntos, level, ra);

    NSString *FeedURL = [NSString stringWithCString : path encoding : [NSString defaultCStringEncoding]];

    NSURLRequest *theRequest = [NSURLRequest requestWithURL : [NSURL URLWithString : FeedURL]];

    NSURLResponse *resp = nil;

    NSError *err = nil;

    NSData *response = [NSURLConnection sendSynchronousRequest : theRequest returningResponse : &resp error : &err];

    NSString * theString = [[NSString alloc] initWithData : response encoding : NSUTF8StringEncoding];

    const char *str = [theString UTF8String];

    UIManager::Instance().WebResponse(str);

    [ pool release ];

    Log("+++ OzoneAppDelegate::enviarPuntos correcto\n");
}

-(void) threadEnviarPuntosAtrapados
{
    Log("+++ OzoneAppDelegate::threadEnviarPuntosAtrapados ...\n");

    [ NSThread detachNewThreadSelector : @selector(enviarPuntosAtrapados) toTarget : self withObject : nil ];

}

-(void) enviarPuntosAtrapados
{
    Log("+++ OzoneAppDelegate::enviarPuntosAtrapados ...\n");


    NSAutoreleasePool *pool = [ [ NSAutoreleasePool alloc ] init ];


    char path[256];

    int puntos = SaveManager::Instance().GetWaitingScore().score;

    //long puntos = 170;
    unsigned long ra = ((puntos / 7) ^ 0xf317) + ((puntos % 9) * 9);

    char* name_final = SaveManager::Instance().GetWaitingScore().name;

    //while (strstr(name_final, " "))
    {
        name_final = str_replace(" ", "%20", name_final);
    }

    int level = SaveManager::Instance().GetWaitingScore().level_complete;

    sprintf(path, "http://www.geardome.com/iphone/ozone/score.php?nombre=%s&sc=%d&le=%d&ra=%lu", name_final, puntos, level, ra);

    NSString *FeedURL = [NSString stringWithCString : path encoding : [NSString defaultCStringEncoding]];

    NSURLRequest *theRequest = [NSURLRequest requestWithURL : [NSURL URLWithString : FeedURL]];

    NSURLResponse *resp = nil;

    NSError *err = nil;

    NSData *response = [NSURLConnection sendSynchronousRequest : theRequest returningResponse : &resp error : &err];

    NSString * theString = [[NSString alloc] initWithData : response encoding : NSUTF8StringEncoding];

    const char *str = [theString UTF8String];

    UIManager::Instance().WebResponse(str);

    [ pool release ];

    Log("+++ OzoneAppDelegate::enviarPuntosAtrapados correcto\n");
}



-(void) threadDescargarNivel
{
    Log("+++ OzoneAppDelegate::threadDescargarNivel ...\n");

    [ NSThread detachNewThreadSelector : @selector(descargarNivel) toTarget : self withObject : nil ];

}

-(void) descargarNivel
{
    Log("+++ OzoneAppDelegate::descargarNivel ...\n");


    NSAutoreleasePool *pool = [ [ NSAutoreleasePool alloc ] init ];
    
    char path[256];
    
    sprintf(path, "http://www.geardome.com/iphone/ozone/getlevel.php?c=%s", GameManager::Instance().GetDownloadCode());
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: [NSString stringWithCString : path encoding : [NSString defaultCStringEncoding]]]];

    NSUInteger len = [data length];
    
    if (len > 20)
    {
        u8 *byteData = (u8*)malloc(len);
        memcpy(byteData, [data bytes], len);
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSLog(@"paths=%@", paths);
        NSString *documentsDirectory = [paths objectAtIndex : 0];
        
        char file[256];
    
        sprintf(file, "levels/%s.oil", GameManager::Instance().GetDownloadCode());
        
        NSString *path = [documentsDirectory stringByAppendingPathComponent : [NSString stringWithCString : file encoding : [NSString defaultCStringEncoding]]];

        FILE* pFile = fopen([path cStringUsingEncoding : 1], "wb");

        if (pFile == NULL)
        {
            Log("@@@ OzoneAppDelegate::descargarNivel Imposible abrir el fichero para escritura: %s\n", [path cStringUsingEncoding : 1]);
            UIManager::Instance().WebResponse("BAD");
        }
        else
        {
            fwrite(byteData, 1, len, pFile);
            
            fclose(pFile);

            Log("+++ OzoneAppDelegate::descargarNivel descarga correcta\n");

            UIManager::Instance().WebResponse("OK");
        }
		
		free(byteData);		
    }
    else
    {
        Log("@@@ OzoneAppDelegate::descargarNivel descarga erronea\n");

        UIManager::Instance().WebResponse("BAD");
    }

    

    [ pool release ];

    Log("+++ OzoneAppDelegate::descargarNivel correcto\n");
}

-(void)playhaven:(UIView *)view didLoadWithContext:(id)contextValue {
	
	Log("+++ OzoneAppDelegate::didLoadWithContext playhaven obtengo ventana\n");

	view.alpha = 1.0;
	
	[GameManager::Instance().GetAppWindow() addSubview : view];
	
    //[UIView beginAnimations : nil context : NULL];
    //[UIView setAnimationDuration : 1.0];
    //view.alpha = 1.0;
    //[UIView commitAnimations];	
	//[myFullScreenContainerView addSubview:view];
}

-(void)playhaven:(UIView *)view didFailWithError:(NSString *)message context:(id)contextValue {
	
	Log("+++ OzoneAppDelegate::didFailWithError playhaven falla ventana\n");

	//NSLog(@"playhaven didFailWithError: %@", message);
	//[view removeFromSuperview];
}

-(void)playhaven:(UIView *)view wasDismissedWithContext:(id)contextValue {
	
	Log("+++ OzoneAppDelegate::wasDismissedWithContext se cierra ventana\n");
	
	NSArray* views = [GameManager::Instance().GetAppWindow() subviews];
	UIView* pScoresView = [ views objectAtIndex : 1];
	[UIView beginAnimations : nil context : NULL];
	[UIView setAnimationDelegate : GameManager::Instance().GetAppDelegate()];
	[UIView setAnimationDidStopSelector : @selector(animationDidStop : finished : context :) ];
	[UIView setAnimationDuration : 0.5];
	pScoresView.alpha = 0.0;
	[UIView commitAnimations];
}


@end
