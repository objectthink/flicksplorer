//
//  EditViewController.h
//  iTripSimpleJournal
//
//  Created by stephen eshelman on 6/3/12.
//  Copyright (c) 2012 blue sky computing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditViewDelegate <NSObject>
-(void)editViewSaved;
-(void)editViewCanceled;
@end

@interface EditViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextView* name;
@property (nonatomic, retain) UISegmentedControl* segmentedControl;
@property (copy) NSString* theName;
@property (copy) NSString* theDetails;
@property (assign) id<EditViewDelegate> delegate;

@end
