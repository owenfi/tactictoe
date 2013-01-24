//
//  SNMainViewController.h
//  tactictoe
//
//  Created by Owen on 1/23/13.
//  Copyright (c) 2013 Swinging Sultan. All rights reserved.
//

#import "SNFlipsideViewController.h"

@interface SNMainViewController : UIViewController <SNFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, retain) IBOutlet UILabel *a, *b, *c, *d, *e, *f, *g, *h, *i;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

-(IBAction)spotPicked:(id)sender;

@end
