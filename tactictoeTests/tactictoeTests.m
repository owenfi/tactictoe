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
    
    [super tearDown];
}

- (void)testFirstMove
{
    // A test to make sure the computer is capable of making an initial move.
    struct SNCoord position = [ai makeMove:gameBoard];
    
    STAssertTrue(position.x < 3, @"Should be within a 3x3 board, but x was %d", position.x);
    STAssertTrue(position.y < 3, @"Should be within a 3x3 board, but y was %d", position.y);
    
}

@end
