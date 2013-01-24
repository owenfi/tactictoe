//
//  SNComputerModel.m
//  tactictoe
//
//  Created by Owen on 1/23/13.
//  Copyright (c) 2013 Swinging Sultan. All rights reserved.
//

#import "SNComputerModel.h"

@implementation SNComputerModel

/* Computer will be required to take turns.

 That will require:
 1. Knowing/receiving the game board state
 2. Returning a new position choice
 
 (2 could use a stateful strategy, but that seems overkill for basic tic tac toe)
 (1 might as well be a 2d array, since that most closely matches the game board metaphor)
 
*/

//-(void)makeMove:(char gameBoard[][]) {
//    
//}

-(struct SNCoord)makeMove:(char*) board {
    [self printBoardDebug:board];
    
    struct SNCoord move;
    move.x = 0;
    move.y = 0;
    return move;
}

-(void)printBoardDebug:(char *) board {
    NSLog(@"Board:");
    for(int i = 0; i < 3; i++) {
        for(int j = 0; j < 3; j++) {
            printf(" %c ",board[i*3+j]);
        }
        printf("\n");
    }
}

@end
