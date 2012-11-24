//
//  FlipsideViewController.h
//  utility
//
//  Created by stephen eshelman on 9/3/11.
//  Copyright 2011 blue sky computing. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SETTING_UPLOAD_PUBLIC @"SETTING_UPLOAD_PUBLIC"
#define SETTING_MAP_TYPE @"SETTING_MAP_TYPE"
#define PANDA_LING_LING @"PANDA_LING_LING"
#define PANDA_HSING_HSING @"PANDA_HSING_HSING"
#define PANDA_WANG_WANG @"PANDA_WANG_WANG"

#define SETTING_PHOTO_SMALL 50
#define SETTING_PHOTO_MEDIUM 75
#define SETTING_PHOTO_LARGE 100
#define SETTING_PHOTO_XLARGE 125
#define USER_DEFAULT_PHOTO_SIZE @"PHOTO_SIZE"

@class FlipsideViewController;

@interface PhotoWallSetting : NSObject <
UITableViewDataSource,
UITableViewDelegate>
{
}

@property (assign) int selected;

@end

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController <
UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView* tableView;

@end
