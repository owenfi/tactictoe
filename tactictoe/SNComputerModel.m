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


// There are a lot of ways to go about this strategy, but it seems like if we start
// "defensively" blocking instant wins and then the 'obvious' play and then move
// to the offensive moves (playing the obvious pattern) I think that should work.

// 1st new thought = might be good to go for win before checkign on defense (duh)
// 2nd thought: no need to block a spot if we already do (current algorithm broke)

-(struct SNCoord)makeMove:(char*) board {
    [self printBoardDebug:board];
    struct SNCoord move;
    move.x = 0;
    move.y = 0;
    
    

    
    /* There are 8 possible wins, iterate across the lines and see
     if opponent is within strike distance (increment where they own space)
     if any row is ==2 then they can win
     0: vert left
     1: vert middle
     2: vert right
     3: horz top
     4: horz middle
     5: horz bottom
     6: diag top-left
     7: diag top-right
     */
    
    int lineCount[8] = {0};
    
    // 1. Oof, this could probably get rewritten
    // Luckily that's why I'm writing unit tests (do it later)
    // 2. Ha, writing the numbers out makes the pattern fairly obvious
    // Still waiting to refactor, because diagonals are a bit odd (modulo something?)
    
    // Upper left, 0,3,6
    if (board[3*0 + 0] == getPlayerChar()) {
        lineCount[0]++;
        lineCount[3]++;
        lineCount[6]++;
    }
    
    // Upper mid, 1, 3
    if (board[3*0 + 1] == getPlayerChar()) {
        lineCount[1]++;
        lineCount[3]++;
    }
    
    // Upper right, 2,3,7
    if (board[3*0 + 2] == getPlayerChar()) {
        lineCount[2]++;
        lineCount[3]++;
        lineCount[7]++;
    }
    
    // Mid left, 0,4
    if (board[3*1 + 0] == getPlayerChar()) {
        lineCount[0]++;
        lineCount[4]++;
    }
    
    // Mid mid, 1,4,6,7
    if (board[3*1 + 1] == getPlayerChar()) {
        lineCount[1]++;
        lineCount[4]++;
        lineCount[6]++;
        lineCount[7]++;
    }
    
    // Mid right 2,4
    if (board[3*1 + 2] == getPlayerChar()) {
        lineCount[2]++;
        lineCount[4]++;
    }
    
    // Bot left 0,5,7
    if (board[3*2 + 0] == getPlayerChar()) {
        lineCount[0]++;
        lineCount[5]++;
        lineCount[7]++;
    }
    
    // Bot mid 1,5
    if (board[3*2 + 1] == getPlayerChar()) {
        lineCount[1]++;
        lineCount[5]++;
    }
    
    // Bot right 2,5,6
    if (board[3*2 + 2] == getPlayerChar()) {
        lineCount[2]++;
        lineCount[5]++;
        lineCount[6]++;
    }
    
    
    /*
     Now what happens: try aggressive strategy,
     Count up across threatened lines, checking each one
     Set move to block if a space is threatened and empty
     */
    // go aggressively, take the corners first
    if (board[3*0 + 0] == 'e') { move.y = 0; move.x = 0; }
    else if (board[3*0 + 2] == 'e') { move.y = 0; move.x = 2; }
    else if (board[3*2 + 0] == 'e') { move.y = 2; move.x = 0; }
    else if (board[3*2 + 2] == 'e') { move.y = 2; move.x = 2; }
    
    
    // BEWARE: X & Y Coordinates inside array are reversed from what makes sense
    for(int i = 0; i < 8; i++) {
        if(lineCount[i] > 1) {
            NSLog(@"Threatened row = %d",i);
            switch (i) {
                case 7: // diagonal from lower left
                    if (board[3*0 + 2] == 'e') { move.y = 0; move.x = 2; }
                    else if (board[3*1 + 1] == 'e') { move.y = 1; move.x = 1; }
                    else if (board[3*2 + 0] == 'e') { move.y = 2; move.x = 0; }
                    break;
                case 6: // diagonal from upper left
                    if (board[3*0 + 0] == 'e') { move.y = 0; move.x = 0; }
                    else if (board[3*1 + 1] == 'e') { move.y = 1; move.x = 1; }
                    else if (board[3*2 + 2] == 'e') { move.y = 2; move.x = 2; }
                    break;
                case 5: // horiz bottom
                    if (board[3*2 + 0] == 'e') { move.y = 2; move.x = 0; }
                    else if (board[3*2 + 1] == 'e') { move.y = 2; move.x = 1; }
                    else if (board[3*2 + 2] == 'e') { move.y = 2; move.x = 2; }
                    break;
                case 4: // horiz mid
                    if (board[3*1 + 0] == 'e') { move.y = 1; move.x = 0; }
                    else if (board[3*1 + 1] == 'e') { move.y = 1; move.x = 1; }
                    else if (board[3*1 + 2] == 'e') { move.y = 1; move.x = 2; }
                    break;
                case 3: // horiz top
                    if (board[3*0 + 0] == 'e') { move.y = 0; move.x = 0; NSLog(@"A");}
                    else if (board[3*0 + 1] == 'e') { move.y = 0; move.x = 1; NSLog(@"B");}
                    else if (board[3*0 + 2] == 'e') { move.y = 0; move.x = 2; NSLog(@"c");}
                    break;
                case 2: // vert right
                    if (board[3*0 + 2] == 'e') { move.y = 0; move.x = 2; }
                    else if (board[3*1 + 2] == 'e') { move.y = 1; move.x = 2; }
                    else if (board[3*2 + 2] == 'e') { move.y = 2; move.x = 2; }
                    break;
                case 1: // vert mid
                    if (board[3*0 + 1] == 'e') { move.y = 0; move.x = 1; }
                    else if (board[3*1 + 1] == 'e') { move.y = 1; move.x = 1; }
                    else if (board[3*2 + 1] == 'e') { move.y = 2; move.x = 1; }
                    break;
                case 0: //vert left
                    if (board[3*0 + 0] == 'e') { move.y = 0; move.x = 0; }
                    else if (board[3*1 + 0] == 'e') { move.y = 1; move.x = 0; }
                    else if (board[3*2 + 0] == 'e') { move.y = 2; move.x = 0; }
                    break;
                default:
                    break;
            }
            
        }
    }
    
    NSLog(@"Move suggested: (%d,%d)",move.x,move.y);

    return move;
}

char getPlayerChar() {
    return 'x';
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
