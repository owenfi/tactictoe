//
//  SNMainViewController.m
//  tactictoe
//
//  Created by Owen on 1/23/13.
//  Copyright (c) 2013 Swinging Sultan. All rights reserved.
//

#import "SNMainViewController.h"

@interface SNMainViewController ()

@end

@implementation SNMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    gameBoard = malloc(9*sizeof(char));
    [self resetGame];
}

-(void) resetGame {
    self.a.text = @"";
    self.b.text = @"";
    self.c.text = @"";
    self.d.text = @"";
    self.e.text = @"";
    self.f.text = @"";
    self.g.text = @"";
    self.h.text = @"";
    self.i.text = @"";
    self.ab.hidden = NO;
    self.bb.hidden = NO;
    self.cb.hidden = NO;
    self.db.hidden = NO;
    self.eb.hidden = NO;
    self.fb.hidden = NO;
    self.gb.hidden = NO;
    self.hb.hidden = NO;
    self.ib.hidden = NO;
    
    for (int i = 0; i < 9; i++) {
        gameBoard[i] = 'e';
    }
}

-(IBAction)spotPicked:(id)sender {
    NSLog(@"Player attempted to pick spot: %d", ((UIView*)sender).tag);
    
    char player = 'x';
    
    int pos = ((UIView*)sender).tag;
    if(gameBoard[pos] == 'e') {
        
        // If the person found a legal move they get that spot
        [self applyMoveAtPosition:pos forPlayer:player];
        
        if(![self isGameOver:gameBoard]) {

            // Now the computer goes (instantly, not very game like)
            SNComputerModel *comp = [[SNComputerModel alloc] init];
            struct SNCoord computersPlay = [comp makeMove:gameBoard];
            [self applyMoveAtPosition:(3*computersPlay.y + computersPlay.x) forPlayer:'o'];
            
            [self isGameOver:gameBoard];

        }
    }
}

-(BOOL)isGameOver:(char*)board {
    BOOL emptySpaces = NO;
    BOOL gameOver = NO;
    
    int opponentLine[8] = {0};
    int myLine[8] = {0};
    
    SNComputerModel *testModel = [[SNComputerModel alloc] init];
    
    [testModel testWinPossible:opponentLine forPlayer:'x' onBoard:board];
    [testModel testWinPossible:myLine forPlayer:'o' onBoard:board];

    for(int i = 0; i < 9; i++) {
        if(opponentLine[i] == 3) {
            // Show Alert for human win and reset game
            UIAlertView *win = [[UIAlertView alloc] initWithTitle:@"Winner!" message:@"Humans win this round... Somehow." delegate:self cancelButtonTitle:@"Great!" otherButtonTitles:nil, nil];
            [win show];
            gameOver = YES;
        } else if (myLine[i] == 3) {
            UIAlertView *lose = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"Score one for the robots." delegate:self cancelButtonTitle:@":(" otherButtonTitles:nil, nil];
            [lose show];
            // Robots win this time and reset game
            gameOver = YES;
        }
        
        if (board[i] == 'e') {
                emptySpaces = YES;
        }
    }
    
    if(!emptySpaces) {
        NSLog(@"");
        UIAlertView *lose = [[UIAlertView alloc] initWithTitle:@"Cat's Game!" message:@"Looks like a draw." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [lose show];
    }
    
    return gameOver || !emptySpaces ;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Closed the alert");
    [self resetGame];
}

-(void)applyMoveAtPosition:(int)position forPlayer:(char)player {
    gameBoard[position] = player;
    
    NSString *playerLetter = [[NSString alloc] initWithFormat:@"%c",player];
    
    switch (position) {
        case 0:
            self.a.text = playerLetter;
            self.ab.hidden = YES;
            break;
        case 1:
            self.b.text = playerLetter;
            self.bb.hidden = YES;
            break;
        case 2:
            self.c.text = playerLetter;
            self.cb.hidden = YES;
            break;
        case 3:
            self.d.text = playerLetter;
            self.db.hidden = YES;
            break;
        case 4:
            self.e.text = playerLetter;
            self.eb.hidden = YES;
            break;
        case 5:
            self.f.text = playerLetter;
            self.fb.hidden = YES;
            break;
        case 6:
            self.g.text = playerLetter;
            self.gb.hidden = YES;
            break;
        case 7:
            self.h.text = playerLetter;
            self.hb.hidden = YES;
            break;
        case 8:
            self.i.text = playerLetter;
            self.ib.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(SNFlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (void)dealloc
{
    free(gameBoard);
    [_flipsidePopoverController release];
    [super dealloc]; // Why do the iOS 6 docs say not to do the super call...?
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

@end
