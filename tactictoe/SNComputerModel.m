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

// Duplicated from unit test!
-(int)isLegalMove:(struct SNCoord) pos onBoard:(char*) board {
    if (pos.x > 2) {
        return 1; // x out of bounds
    }
    if (pos.y > 2) {
        return 2; // y out of bounds
    }
    
    if (board[3*pos.y + pos.x] != 'e') {
        return 3; // overlapping existing play
    }
    
    return 0;
}

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
    
    int opponentLine[8] = {0};
    int myLine[8] = {0};
    
    [self testWinPossible:opponentLine forPlayer:'x' onBoard:board];
    [self testWinPossible:myLine forPlayer:'o' onBoard:board];
    
    /*
     Now what happens: try aggressive strategy,
     Count up across threatened lines, checking each one
     Set move to block if a space is threatened and empty
     */
    
    // go aggressively, take the corners first
    if (   board[3*0 + 0] == 'e'
        && board[3*0 + 2] == 'e'
        && board[3*2 + 0] == 'e'
        && board[3*2 + 2] == 'e'
        && board[3*0 + 1] == 'e'
        && board[3*1 + 0] == 'e'
        && board[3*1 + 2] == 'e'
        && board[3*2 + 1] == 'e' ) {
        //In this case the player didn't take any corner and the computer will
        move.y = 0; move.x = 0;
        
        // Might this get tripped up if the player knows comp goes in this corner?
    } else if(board[3*1 + 1] == 'o'){
        move.y = 0; move.x =1;
    } else {
        move.y = 1; move.x = 1;
    }
    
    for(int i = 0; i < 8; i++) {
        if(opponentLine[i] > 1) {
            move = findSpotToPlay(board, i, move);
        }
    }
    
    for(int i = 0; i < 8; i++) {
        if(myLine[i] > 1) {
            move = findSpotToPlay(board, i, move);
        }
    }
    
    if([self isLegalMove:move onBoard:board] > 0) {
        move.x = 0;
        move.y = 0;
        int index = 0;
        while ([self isLegalMove:move onBoard:board] > 0) {
            move.x = index % 3;
            move.y = index/3 % 3;
            index++;
        }
    }
    
    //NSLog(@"Move suggested: (%d,%d)",move.x,move.y);

    return move;
}

char getPlayerChar() {
    return 'x';
}

struct SNCoord findSpotToPlay(char *board, int i, struct SNCoord currentMove) {
    struct SNCoord move;
    move.x = currentMove.x;
    move.y = currentMove.y;
    
    // BEWARE: X & Y Coordinates inside array are reversed from what makes sense
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
            if (board[3*0 + 0] == 'e') { move.y = 0; move.x = 0;}
            else if (board[3*0 + 1] == 'e') { move.y = 0; move.x = 1;}
            else if (board[3*0 + 2] == 'e') { move.y = 0; move.x = 2;}
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
    
    return move;
}

-(void)testWinPossible:(int *)line forPlayer:(char)player onBoard:(char*) board {    // 1. Oof, this could probably get rewritten
    // Luckily that's why I'm writing unit tests (do it later)
    // 2. Ha, writing the numbers out makes the pattern fairly obvious
    // Still waiting to refactor, because diagonals are a bit odd (modulo something?)
    
    // Upper left, 0,3,6
    if (board[3*0 + 0] == player) {
        line[0]++;
        line[3]++;
        line[6]++;
    }
    
    // Upper mid, 1, 3
    if (board[3*0 + 1] == player) {
        line[1]++;
        line[3]++;
    }
    
    // Upper right, 2,3,7
    if (board[3*0 + 2] == player) {
        line[2]++;
        line[3]++;
        line[7]++;
    }
    
    // Mid left, 0,4
    if (board[3*1 + 0] == player) {
        line[0]++;
        line[4]++;
    }
    
    // Mid mid, 1,4,6,7
    if (board[3*1 + 1] == player) {
        line[1]++;
        line[4]++;
        line[6]++;
        line[7]++;
    }
    
    // Mid right 2,4
    if (board[3*1 + 2] == player) {
        line[2]++;
        line[4]++;
    }
    
    // Bot left 0,5,7
    if (board[3*2 + 0] == player) {
        line[0]++;
        line[5]++;
        line[7]++;
    }
    
    // Bot mid 1,5
    if (board[3*2 + 1] == player) {
        line[1]++;
        line[5]++;
    }
    
    // Bot right 2,5,6
    if (board[3*2 + 2] == player) {
        line[2]++;
        line[5]++;
        line[6]++;
    }
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
