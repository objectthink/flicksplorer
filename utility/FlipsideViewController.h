//
//  FlipsideViewController.h
//  utility
//
//  Created by stephen eshelman on 9/3/11.
//  Copyright 2011 blue sky computing. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SETTING_MAP_TYPE @"SETTING_MAP_TYPE"
#define PANDA_LING_LING @"PANDA_LING_LING"
#define PANDA_HSING_HSING @"PANDA_HSING_HSING"
#define PANDA_WANG_WANG @"PANDA_WANG_WANG"

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController <
UITableViewDataSource,
UITableViewDelegate>
@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

@end
