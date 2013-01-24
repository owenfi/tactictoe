//
//  SNMainViewController.h
//  tactictoe
//
//  Created by Owen on 1/23/13.
//  Copyright (c) 2013 Swinging Sultan. All rights reserved.
//

#import "SNFlipsideViewController.h"
#import "SNComputerModel.h"

@interface SNMainViewController : UIViewController <SNFlipsideViewControllerDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate> {
    char *gameBoard;
}

@property (nonatomic, retain) IBOutlet UILabel *a, *b, *c, *d, *e, *f, *g, *h, *i;
@property (nonatomic, retain) IBOutlet UIButton *ab, *bb, *cb, *db, *eb, *fb, *gb, *hb, *ib;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

-(IBAction)spotPicked:(id)sender;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
