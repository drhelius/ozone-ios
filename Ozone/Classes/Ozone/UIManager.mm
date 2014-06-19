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

/* 
 * File:   UIManager.mm
 * Author: nacho
 * 
 * Created on 13 de marzo de 2010, 14:23
 */

#include "UIManager.h"
#include "gamemanager.h"
#include "ScoresView.h"
#include "HelpButton.h"
#include "SubMenuHighScoresState.h"
#include "SaveManager.h"
#include "audio.h"

//////////////////////////
//////////////////////////

UIManager::UIManager(void)
{
    Log("+++ UIManager::UIManager ...\n");

    m_bWaitingEvent = false;
    m_pCallback = NULL;

    m_pViewController = [[highscores alloc]

            initWithNibName : @"highscores" bundle : [NSBundle mainBundle]];

    Log("+++ UIManager::UIManager correcto\n");
}

//////////////////////////
//////////////////////////

UIManager::~UIManager()
{
    Log("+++ UIManager::~UIManager ...\n");

    [m_pViewController release];

    Log("+++ UIManager::~UIManager destruido\n");
}

//////////////////////////
//////////////////////////

void UIManager::Update(void)
{
    if (m_bWaitingEvent)
    {
        m_bWaitingEvent = false;

        switch (m_WaitingEvent)
        {
			case UI_EVENT_PLAYHAVEN:
			{
				break;
			}

            case UI_EVENT_ENTERNAME:
            {
                UIAlertView *prompt = [[UIAlertView alloc] initWithTitle : @"Enter your name"
                        message : @"\n\n" // IMPORTANT
                        delegate : GameManager::Instance().GetAppDelegate()
                        cancelButtonTitle : @"Cancel"
                        otherButtonTitles : @"OK", nil];

                UITextField* textField = [[UITextField alloc] initWithFrame : CGRectMake(12.0, 50.0, 260.0, 25.0)];
                [textField setBackgroundColor : [UIColor whiteColor]];
                [textField setPlaceholder : @"Will be used in the scoreboard"];
                textField.tag = 69;
                [prompt addSubview : textField];

                // set place
                [prompt setTransform : CGAffineTransformMakeTranslation(0.0, 0.0)];
                [prompt show];
                [prompt release];

                // set cursor and show keyboard
                [textField becomeFirstResponder];

                break;
            }
            case UI_EVENT_ASKLEVELDOWNLOAD:
            {
                UIAlertView *prompt = [[UIAlertView alloc] initWithTitle : @"Enter Download Code"
                        message : @"\n\n" // IMPORTANT
                        delegate : GameManager::Instance().GetAppDelegate()
                        cancelButtonTitle : @"Cancel"
                        otherButtonTitles : @"OK", nil];

                UITextField* textField = [[UITextField alloc] initWithFrame : CGRectMake(12.0, 50.0, 260.0, 25.0)];
                [textField setBackgroundColor : [UIColor whiteColor]];
                [textField setPlaceholder : @"Download code"];
                textField.tag = 69;
                [prompt addSubview : textField];

                // set place
                [prompt setTransform : CGAffineTransformMakeTranslation(0.0, 0.0)];
                [prompt show];
                [prompt release];

                // set cursor and show keyboard
                [textField becomeFirstResponder];

                break;
            }
            case UI_EVENT_LEVELDELETE:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle : @"Delete Level"
                        message : @"Are you sure?"
                        delegate : GameManager::Instance().GetAppDelegate()
                        cancelButtonTitle : @"NO" otherButtonTitles : @"YES", nil];

                [alert show];
                [alert release];
                break;
            }
            case UI_EVENT_ASKSENDSCORE:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle : @"High Score!"
                        message : @"Do you want to submit your score to the worldwide scoreboard?"
                        delegate : GameManager::Instance().GetAppDelegate()
                        cancelButtonTitle : @"NO" otherButtonTitles : @"YES", nil];

                [alert show];
                [alert release];
                break;
            }            
            case UI_EVENT_LEVELALERT:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle : @"Custom Levels!"
                        message : @"You can build and play your own custom levels!\nVisit ozone-editor.geardome.com for instructions."
                        delegate : GameManager::Instance().GetAppDelegate()
                        cancelButtonTitle : @"LATER" otherButtonTitles : @"VISIT NOW", nil];

                [alert show];
                [alert release];
                break;
            }
            case UI_EVENT_ASKGOTOITUNES:
            {
#ifdef GEARDOME_PLATFORM_IPAD
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle : @"Get Ozone HD!"
                        message : @"Get more levels and continue playing Ozone HD."
                        delegate : GameManager::Instance().GetAppDelegate()
                        cancelButtonTitle : @"NO" otherButtonTitles : @"YES", nil];
#else
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle : @"Get Ozone!"
                        message : @"Get more levels and continue playing Ozone."
                        delegate : GameManager::Instance().GetAppDelegate()
                        cancelButtonTitle : @"NO" otherButtonTitles : @"YES", nil];
#endif

                [alert show];
                [alert release];
                break;
            }
            case UI_EVENT_SHOWSCORESLIST:
            {
                ShowScoresWindow();
                break;
            }
            case UI_EVENT_LEVELDOWNLOADOK:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle : @"Level Downloaded"
                        message : @"Your level has been downloaded successfully!"
                        delegate : GameManager::Instance().GetAppDelegate()
                        cancelButtonTitle : @"OK" otherButtonTitles : nil];

                [alert show];
                [alert release];
                break;
            }
            case UI_EVENT_LEVELDOWNLOADNOTOK:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle : @"ERROR"
                        message : @"There was an error downloading your level.\nPlease, check the Download Code or try again later."
                        delegate : GameManager::Instance().GetAppDelegate()
                        cancelButtonTitle : @"OK" otherButtonTitles : nil];

                [alert show];
                [alert release];
                break;
            }
            case UI_EVENT_SENDERROR:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle : @"ERROR"
                        message : @"Please, check your Internet connection.\nYou can send your score later using the button in the main menu."
                        delegate : GameManager::Instance().GetAppDelegate()
                        cancelButtonTitle : @"OK" otherButtonTitles : nil];

                [alert show];
                [alert release];
                break;
            }
            case UI_EVENT_EXISTENTSCORE:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle : @"High Score!"
                        message : @"Your score was already in the scoreboard."
                        delegate : GameManager::Instance().GetAppDelegate()
                        cancelButtonTitle : @"OK" otherButtonTitles : nil];

                [alert show];
                [alert release];
                break;
            }
            case UI_EVENT_SENDSCOREOK:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle : @"High Score!"
                        message : [NSString stringWithCString : m_szScoreText encoding : [NSString defaultCStringEncoding]]
                        delegate : GameManager::Instance().GetAppDelegate()
                        cancelButtonTitle : @"OK" otherButtonTitles : nil];

                [alert show];
                [alert release];
                break;
            }
            case UI_EVENT_DELETESAVESLOT:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle : @"Are you sure?"
                        message : @"All your progress in this slot will be lost."
                        delegate : GameManager::Instance().GetAppDelegate()
                        cancelButtonTitle : @"NO" otherButtonTitles : @"YES", nil];

                [alert show];
                [alert release];
                break;
            }
            case UI_EVENT_GETSCORES:
            {
                [GameManager::Instance().GetAppDelegate() threadCargarPuntos];
                break;
            }
            case UI_EVENT_DOSENDSCORE:
            {
                [GameManager::Instance().GetAppDelegate() threadEnviarPuntos];
                break;
            }
            case UI_EVENT_DOSENDWAITINGSCORE:
            {
                [GameManager::Instance().GetAppDelegate() threadEnviarPuntosAtrapados];
                break;
            }
            case UI_EVENT_LEVELDOWNLOAD:
            {
                [GameManager::Instance().GetAppDelegate() threadDescargarNivel];
                break;
            }
        }
    }
}

//////////////////////////
//////////////////////////

void UIManager::AlertViewResponse(UIAlertView* alertView, NSInteger buttonIndex)
{
    Log("+++ UIManager::AlertViewResponse ...\n");

    if (m_pCallback != NULL)
    {
        char text[12] = {0};

        if (m_WaitingEvent == UI_EVENT_ENTERNAME)
        {
            strncpy(text, [((UITextField*) [alertView viewWithTag : 69]).text UTF8String], 10);
        }
        else if (m_WaitingEvent == UI_EVENT_ASKLEVELDOWNLOAD)
        {
            strncpy(text, [((UITextField*) [alertView viewWithTag : 69]).text UTF8String], 8);
        }

        m_pCallback->Execute(buttonIndex, text);
    }

    if (m_WaitingEvent == UI_EVENT_SHOWSCORESLIST)
    {
        NSArray* views = [GameManager::Instance().GetAppWindow() subviews];
        ScoresView* pScoresView = [ views objectAtIndex : 1];
        [UIView beginAnimations : nil context : NULL];
        [UIView setAnimationDelegate : GameManager::Instance().GetAppDelegate()];
        [UIView setAnimationDidStopSelector : @selector(animationDidStop : finished : context :) ];
        [UIView setAnimationDuration : 0.5];
        pScoresView.alpha = 0.0;
        [UIView commitAnimations];
    }

    Log("+++ UIManager::AlertViewResponse correcto\n");
}

//////////////////////////
//////////////////////////

void UIManager::WebResponse(const char* text)
{
    Log("+++ UIManager::WebResponse ...\n");

    if (m_WaitingEvent == UI_EVENT_DOSENDSCORE || m_WaitingEvent == UI_EVENT_DOSENDWAITINGSCORE)
    {
        if (strcmp(text, "YA") == 0)
        {
            SaveManager::Instance().ClearForUpload();
            RaiseEvent(UI_EVENT_EXISTENTSCORE);
        }
        else if ((strcmp(text, "E1") == 0) || (strcmp(text, "E2") == 0) || (strcmp(text, "E3") == 0))
        {
            RaiseEvent(UI_EVENT_SENDERROR);
        }
        else if (strcmp(text, "") == 0)
        {
            RaiseEvent(UI_EVENT_SENDERROR);
        }
        else
        {
            // correcto
            SaveManager::Instance().ClearForUpload();

            if (strcmp(text, "1") == 0)
            {
                SaveManager::Instance().SetAward(1);
                sprintf(m_szScoreText, "You are the %sst in the scoreboard!\n\nYou are the one!", text);
            }
            else if (strcmp(text, "2") == 0)
            {
                SaveManager::Instance().SetAward(2);
                sprintf(m_szScoreText, "You are the %snd in the scoreboard!\n\nSuperb!", text);
            }
            else if (strcmp(text, "3") == 0)
            {
                SaveManager::Instance().SetAward(3);
                sprintf(m_szScoreText, "You are the %srd in the scoreboard!\n\nCongrats!", text);
            }
            else
            {
                sprintf(m_szScoreText, "You are the %sth in the scoreboard!\n\nWell done!", text);
            }

            RaiseEvent(UI_EVENT_SENDSCOREOK);
        }

    }
    else
    {
        if (m_pCallback != NULL)
        {
            m_pCallback->Execute(0, text);
        }

        if (m_WaitingEvent == UI_EVENT_LEVELDOWNLOAD)
        {
            if (strcmp(text, "OK") == 0)
            {
                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_MENU_EPISODE_UNLOCK));
                RaiseEvent(UI_EVENT_LEVELDOWNLOADOK);
            }
            else
            {
                RaiseEvent(UI_EVENT_LEVELDOWNLOADNOTOK);
            }
        }
    }

    Log("+++ UIManager::WebResponse correcto\n");
}

//////////////////////////
//////////////////////////

void UIManager::ShowScoresWindow(void)
{
    ScoresView* pScoresView = [m_pViewController view];

    NSArray* scoresViews = [pScoresView subviews];

    UINavigationBar* navBar = [scoresViews objectAtIndex : 2];

    NSArray* navItems = [navBar items];
    UINavigationItem* navItem = [navItems objectAtIndex : 0];

    HelpButton *anotherButton = [[HelpButton alloc] initWithTitle : @"Back" style : UIBarButtonItemStylePlain
            target : GameManager::Instance().GetAppDelegate() action : @selector(scores_back :)];

    navItem.leftBarButtonItem = anotherButton;

    pScoresView.alpha = 0.0;

    NSString * result = @"";


    char* text = SubMenuHighScoresState::Instance().GetScoresString();

    char * tok = strchr(text, '\n');

    float offsetY = 0.0f;
    int row = 0;

    while (tok != NULL)
    {

        result = [result stringByAppendingString : [NSString stringWithFormat : @"%d - ", row + 1]];

        char line_buffer[50];

        strncpy(line_buffer, text, tok - text);
        line_buffer[tok - text] = 0;

        char* line = line_buffer;

        char * pch = strchr(line_buffer, '%');

        int token = 0;
        while (pch != NULL)
        {
            char word[50];
            strncpy(word, line, pch - line);
            word[pch - line] = 0;

            if (token == 1)
            {
                result = [result stringByAppendingString : @": "];
            }
            else if (token == 0)
            {

            }
            else
            {
                result = [result stringByAppendingString : @", "];

                if (strcmp(word, "6") == 0)
                {
                    strcpy(word, "Tutorial");
                }
                else if (strcmp(word, "24") == 0)
                {
                    strcpy(word, "Earth");
                }
                else if (strcmp(word, "36") == 0)
                {
                    strcpy(word, "Vulcan");
                }
                else if (strcmp(word, "48") == 0)
                {
                    strcpy(word, "Ocean");
                }
                else if (strcmp(word, "60") == 0)
                {
                    strcpy(word, "Space");
                }
                else
                {
                    strcpy(word, "Tutorial");
                }
            }

            result = [result stringByAppendingString : [NSString stringWithCString : word encoding : [NSString defaultCStringEncoding]]];


            line = pch + 1;
            pch = strchr(pch + 1, '%');
            token++;
        }

        text = tok + 1;
        tok = strchr(tok + 1, '\n');

        offsetY += 15.0f;
        row++;

        result = [result stringByAppendingString : @"\n"];
    }



    UITextView* scoresTextView = [scoresViews objectAtIndex : 1];

    scoresTextView.text = result;


    [GameManager::Instance().GetAppWindow() addSubview : pScoresView];

    [UIView beginAnimations : nil context : NULL];
    [UIView setAnimationDuration : 1.0];
    pScoresView.alpha = 1.0;
    [UIView commitAnimations];
}