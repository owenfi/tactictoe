//
//  tactictoeTests.h
//  tactictoeTests
//
//  Created by Owen on 1/23/13.
//  Copyright (c) 2013 Swinging Sultan. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "SNComputerModel.h"
#import "SNMainViewController.h"

@interface tactictoeTests : SenTestCase {
    SNComputerModel *ai;
    char *gameBoard;
}

@end
