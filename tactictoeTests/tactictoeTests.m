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
}

- (void)tearDown
{
    [ai release];
    
    [super tearDown];
}

- (void)testFirstMove
{
    // A test to make sure the computer is capable of making an initial move.
    char gameBoard[3][3] = {{'e', 'e', 'e'},{'e', 'e', 'e'},{'e', 'e', 'e'}};
    [ai makeMove:&gameBoard[0][0]];
    
}

@end
