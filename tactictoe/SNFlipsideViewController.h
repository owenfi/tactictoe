//
//  SNFlipsideViewController.h
//  tactictoe
//
//  Created by Owen on 1/23/13.
//  Copyright (c) 2013 Swinging Sultan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SNFlipsideViewController;

@protocol SNFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(SNFlipsideViewController *)controller;
@end

@interface SNFlipsideViewController : UIViewController

@property (assign, nonatomic) id <SNFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
