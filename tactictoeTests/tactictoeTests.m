//
//  tactictoeTests.m
//  tactictoeTests
//
//  Created by Owen on 1/23/13.
//  Copyright (c) 2013 Swinging Sultan. All rights reserved.
//

#import "tactictoeTests.h"


@implementation tactictoeTests

- (void)setUp
{
    [super setUp];
    ai = [[SNComputerModel alloc] init];
    [ai retain];

    // Normally it would make sense to initialize to 0, but tic tac toe uses X and O
    // and they look too similar so that would probably lead to making a stupid mistake
    // thus I will initialize to 'e' for 'empty'.
    gameBoard = malloc(9*sizeof(char));
    for (int i = 0; i < 9; i++) {
        gameBoard[i] = 'e';
    }
}

- (void)tearDown
{
    [ai release];
    free(gameBoard);
    
    [super tearDown];
}

- (void)testFirstMove
{
    // A test to make sure the computer is capable of making an initial move.
    struct SNCoord position = [ai makeMove:gameBoard];
    
    STAssertTrue(position.x < 3, @"Should be within a 3x3 board, but x was %d", position.x);
    STAssertTrue(position.y < 3, @"Should be within a 3x3 board, but y was %d", position.y);
    
}

-(void)testSecondMove
{
    // This will test a move where the computer plays second.
    gameBoard[3*0 + 2] = 'x'; // Human "x" will move to upper right
    
    struct SNCoord position = [ai makeMove:gameBoard];

    
    STAssertTrue(position.x < 3, @"Should be within a 3x3 board, but x was %d", position.x);
    STAssertTrue(position.y < 3, @"Should be within a 3x3 board, but y was %d", position.y);
    STAssertTrue(!(position.x == 2 && position.y == 0), @"Not allowed to overlap human move");
    
    // Set this position to the computer's move
    gameBoard[3*position.y+position.x] = 'o';
    
    [ai printBoardDebug:gameBoard];
}

-(void)test2InARow
{
    gameBoard[3*0 + 0] = 'x'; // Human "x" will move to upper right
    gameBoard[3*0 + 2] = 'x'; // Human "x" will move to upper left
    gameBoard[3*1 + 1] = 'o'; // Computer moves to middle-middle
    
    struct SNCoord pos = [ai makeMove:gameBoard];
    
    STAssertTrue(pos.x == 1 && pos.y == 0, @"Computer should have moved to block human");
    
}

// Test that even if the computer knows it will lose it still plays
// Test the win move
// Test that something is returned if the board is full


@end
