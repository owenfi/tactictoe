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
    self.a.text = @"";
    self.b.text = @"";
    self.c.text = @"";
    self.d.text = @"";
    self.e.text = @"";
    self.f.text = @"";
    self.g.text = @"";
    self.h.text = @"";
    self.i.text = @"";
    
    gameBoard = malloc(9*sizeof(char));
    for (int i = 0; i < 9; i++) {
        gameBoard[i] = 'e';
    }
}


// This will probably move the the actual game logic eventually
// legal = 0; illegal = 1;
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

-(IBAction)spotPicked:(id)sender {
    NSLog(@"Player attempted to pick spot: %d", ((UIView*)sender).tag);
    
    char player = 'x';
    
    int pos = ((UIView*)sender).tag;
    if(gameBoard[pos] == 'e') {
        gameBoard[pos] = player;
        NSLog(@"Setting the first to this player");

        
        NSString *playerLetter = [[NSString alloc] initWithFormat:@"%c",player];
        
        switch (pos) {
            case 0:
                NSLog(@"Setting the first to this player");
                self.a.text = playerLetter;
                break;
            case 1:
                self.b.text = playerLetter;
                break;
            case 2:
                self.c.text = playerLetter;
                break;
            case 3:
                self.d.text = playerLetter;
                break;
            case 4:
                self.e.text = playerLetter;
                break;
            case 5:
                self.f.text = playerLetter;
                break;
            case 6:
                self.g.text = playerLetter;
                break;
            case 7:
                self.h.text = playerLetter;
                break;
            case 8:
                self.i.text = playerLetter;
                break;
                
            default:
                break;
        }
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
