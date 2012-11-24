//
//  EditViewController.h
//  iTripSimpleJournal
//
//  Created by stephen eshelman on 6/3/12.
//  Copyright (c) 2012 blue sky computing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewData : NSObject

+(id)withTitle:(NSString*)title description:(NSString*)description image:(UIImage*)image;

@property (copy) NSString* title;
@property (copy) NSString* description;
@property (retain) UIImage* image;
@end

@protocol EditViewDelegate <NSObject>
-(void)editViewSaved:(EditViewData*)data;
-(void)editViewCanceled;
@end

@interface EditViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextView* name;
@property (nonatomic, retain) UISegmentedControl* segmentedControl;
@property (copy) NSString* theName;
@property (copy) NSString* theDetails;
@property (retain) UIImage* image;
@property (assign) id<EditViewDelegate> delegate;

@end
