//
//  SNComputerModel.h
//  tactictoe
//
//  Created by Owen on 1/23/13.
//  Copyright (c) 2013 Swinging Sultan. All rights reserved.
//

#import <Foundation/Foundation.h>

// The coordinate system will be just like the arrays/UIView layout
// (origin is in upper left)
struct SNCoord {
    int x, y;
};

@interface SNComputerModel : NSObject

-(struct SNCoord)makeMove:(char*)board;

@end
