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
    struct SNCoord pos = [ai makeMove:gameBoard];
    
    STAssertTrue(pos.x < 3, @"Should be within a 3x3 board, but x was %d", pos.x);
    STAssertTrue(pos.y < 3, @"Should be within a 3x3 board, but y was %d", pos.y);
    
    int moveErr = [self isLegalMove:pos onBoard:gameBoard];
    STAssertTrue(moveErr == 0, @"Illegal Move %d",moveErr);

}

-(void)testSecondMove
{
    // This will test a move where the computer plays second.
    gameBoard[3*0 + 2] = 'x'; // Human "x" will move to upper right
    
    struct SNCoord pos = [ai makeMove:gameBoard];

    
    STAssertTrue(pos.x < 3, @"Should be within a 3x3 board, but x was %d", pos.x);
    STAssertTrue(pos.y < 3, @"Should be within a 3x3 board, but y was %d", pos.y);
    STAssertTrue(!(pos.x == 2 && pos.y == 0), @"Not allowed to overlap human move");
    
    int moveErr = [self isLegalMove:pos onBoard:gameBoard];
    STAssertTrue(moveErr == 0, @"Illegal Move %d",moveErr);

    // Set this position to the computer's move
    gameBoard[3*pos.y+pos.x] = 'o';
    
    [ai printBoardDebug:gameBoard];
}

-(void)test2InARow
{
    gameBoard[3*0 + 0] = 'x'; // Human "x" will move to upper right
    gameBoard[3*0 + 2] = 'x'; // Human "x" will move to upper left
    gameBoard[3*1 + 1] = 'o'; // Computer moves to middle-middle
    
    struct SNCoord pos = [ai makeMove:gameBoard];
    
    STAssertTrue(pos.x == 1 && pos.y == 0, @"Computer should have moved to block human");
    
    int moveErr = [self isLegalMove:pos onBoard:gameBoard];
    STAssertTrue(moveErr == 0, @"Illegal Move %d",moveErr);

}

-(void)test2AlreadyBlocked
{
    gameBoard[3*0 + 0] = 'x'; // Human "x" moved to upper right
    gameBoard[3*0 + 2] = 'x'; // Human "x" moved to upper left
    gameBoard[3*0 + 1] = 'o'; // Computer moved to middle-middle
    
    struct SNCoord pos = [ai makeMove:gameBoard];
    
    int moveErr = [self isLegalMove:pos onBoard:gameBoard];
    STAssertTrue(moveErr == 0, @"Illegal Move %d",moveErr);
}

-(void)testCompWin
{
    gameBoard[3*2 + 0] = 'o'; // e e e
    gameBoard[3*2 + 1] = 'o'; // x x e
    gameBoard[3*1 + 0] = 'x'; // o o e
    gameBoard[3*1 + 1] = 'x';

    struct SNCoord pos = [ai makeMove:gameBoard];
    
    int moveErr = [self isLegalMove:pos onBoard:gameBoard];
    STAssertTrue(moveErr == 0, @"Illegal Move %d",moveErr);
    
    STAssertTrue(pos.x == 2 && pos.y == 2, @"Computer should win by going in 2,2; but went in %d,%d",pos.x,pos.y);
    
}
// Test that even if the computer knows it will lose it still plays
// Test the win move
// Test that something is returned if the board is full


@end
