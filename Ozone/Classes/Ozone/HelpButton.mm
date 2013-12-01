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
//  HelpButton.mm
//  PuzzleStar
//
//  Created by nacho on 11/01/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HelpButton.h"


@implementation HelpButton


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


- (void)setResult:(CResult*)res {
    
    self->result = res;	
}

- (CResult*)result {
    
    return self->result;	
}

@end
