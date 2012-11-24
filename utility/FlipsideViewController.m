//
//  FlipsideViewController.m
//  utility
//
//  Created by stephen eshelman on 9/3/11.
//  Copyright 2011 blue sky computing. All rights reserved.
//

#import "FlipsideViewController.h"
#import "utilityAppDelegate.h"

#define SECTIONS_COUNT 6

#define SECTION_PHOTO_WALL 0
#define SECTION_AUTHORIZATION 1
#define SECTION_UPLOAD 2
#define SECTION_MAP 3
#define SECTION_PANDAS 4
#define SECTION_CREDITS 5

#define SECTION_PHOTO_WALL_COUNT 1
#define SECTION_AUTHORIZATION_COUNT 1
#define SECTION_UPLOAD_COUNT 1
#define SECTION_MAP_COUNT 1
#define SECTION_PANDAS_COUNT 3
#define SECTION_CREDITS_COUNT 1

#define PUBLIC_SETTING 1
#define MAP_TYPE_SETTING 7
#define PANDA_LING_LING_SETTING 77
#define PANDA_HSING_HSING_SETTING 777
#define PANDA_WANG_WANG_SETTING 7777

@implementation PhotoWallSetting
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return 4;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//   return @"Choose the size of the photos on the photo wall";
//}

//-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//   return @"The photo size will be updated in the photo wall the next time the photo wall is updated";
//}

- (UITableViewCell *)
tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString* CellIdentifier = @"Cell";

   UITableViewCell *cell;   // = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

   cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
   if(cell==nil)
      cell =
      [[[UITableViewCell alloc]
        initWithStyle:UITableViewCellStyleDefault
        reuseIdentifier:CellIdentifier] autorelease];

   switch (indexPath.row) {
      case 0:
         cell.textLabel.text = @"Small";
         break;
      case 1:
         cell.textLabel.text = @"Medium";
         break;
      case 2:
         cell.textLabel.text = @"Large";
         break;
      case 3:
         cell.textLabel.text = @"Extra Large";
         break;
      default:
         break;
   }
   
   if(indexPath.row == self.selected)
      [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
   else
      [cell setAccessoryType:UITableViewCellAccessoryNone];
   
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
   self.selected = indexPath.row;
   
   [tableView reloadData];
   
   int size = 50;
   switch (indexPath.row) {
      case 0:
         size = SETTING_PHOTO_SMALL;
         break;
      case 1:
         size = SETTING_PHOTO_MEDIUM;
         break;
      case 2:
         size = SETTING_PHOTO_LARGE;
         break;
      case 3:
         size = SETTING_PHOTO_XLARGE;
         break;
      default:
         break;
   }

   [[NSUserDefaults standardUserDefaults] setInteger:size forKey:USER_DEFAULT_PHOTO_SIZE];

   [[NSUserDefaults standardUserDefaults] synchronize];
   [NSUserDefaults resetStandardUserDefaults];
   
   //Post change notification
   [[NSNotificationCenter defaultCenter]
    postNotificationName:@"photoWallSizeChanged" object:self];
}

@end

@implementation FlipsideViewController

@synthesize delegate = _delegate;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return SECTIONS_COUNT;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   switch(section)
   {
      case SECTION_PHOTO_WALL:
         return @"Photo Wall";
         break;
      case SECTION_AUTHORIZATION:
         return @"flickr Authorization";
         break;
      case SECTION_UPLOAD:
         return @"Upload";
         break;
      case SECTION_MAP:
         return @"Map";
         break;
      case SECTION_PANDAS:
         return @"Pandas";
         break;
      case SECTION_CREDITS:
         return @"";
         break;
   }
   
   return nil;
}

//-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//   switch(section)
//   {
//      case SECTION_AUTHORIZATION:
//         return @"flickr account used for uploads";
//         break;
//      case SECTION_PANDAS:
//         return @"flickr pandas you wish to see!";
//         break;
//      default:
//         return @"";
//         break;
//   }   
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   switch(section)
   {
      case SECTION_AUTHORIZATION:
         return SECTION_AUTHORIZATION_COUNT;
         break;
      case SECTION_UPLOAD:
         return SECTION_UPLOAD_COUNT;
         break;
      case SECTION_PHOTO_WALL:         //photo wall settings
         return SECTION_PHOTO_WALL_COUNT;
         break;
      case SECTION_MAP:                //map settings, photo settings
         return SECTION_MAP_COUNT;
         break;
      case SECTION_PANDAS:
         return SECTION_PANDAS_COUNT;
         break;
      case SECTION_CREDITS:            //legal
         return SECTION_CREDITS_COUNT;
         break;
      default:
         return 0;
         break;
   }
}

/**
	return a view used for the tableview header
   so that we can affect the color of the text
	@param tableView the tableview
	@param section the section
	@returns a uiview
 */
-(UIView *)
tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
   NSString *sectionTitle =
   [self tableView:tableView titleForHeaderInSection:section];
   
   if (sectionTitle == nil) {
      return nil;
   }
   
   UILabel *label = [[UILabel alloc] init];
   label.frame = CGRectMake(20, 8, 320, 20);
   label.backgroundColor = [UIColor clearColor];
   label.textColor = [UIColor whiteColor];
   label.shadowColor = [UIColor grayColor];
   label.shadowOffset = CGSizeMake(-1.0, 1.0);
   label.font = [UIFont boldSystemFontOfSize:16];
   label.text = sectionTitle;
   
   UIView *view = [[UIView alloc] init];
   [view addSubview:label];
   
   return view;
}

//-(UIView *)tableView:(UITableView *)tableView
//viewForFooterInSection:(NSInteger)section
//{
//   NSString *sectionTitle =
//   [self tableView:tableView titleForFooterInSection:section];
//   
//   if (sectionTitle == nil) {
//      return nil;
//   }
//   
//   UILabel *label = [[UILabel alloc] init];
//   label.frame = CGRectMake(20, 8, 320, 20);
//   label.backgroundColor = [UIColor clearColor];
//   label.textColor = [UIColor whiteColor];
//   label.shadowColor = [UIColor grayColor];
//   label.shadowOffset = CGSizeMake(-1.0, 1.0);
//   label.font = [UIFont boldSystemFontOfSize:16];
//   label.text = sectionTitle;
//   
//   UIView *view = [[UIView alloc] init];
//   [view addSubview:label];
//   
//   return view;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString* CellIdentifier = @"Cell";
   static NSString* ValueCellIdentifier = @"ValueCell";
   
   utilityAppDelegate* app =
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
   
   UITableViewCell *cell;   // = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

   if(
      (indexPath.section == SECTION_PHOTO_WALL)||(indexPath.section == SECTION_AUTHORIZATION)
      )
   {
      cell = [tableView dequeueReusableCellWithIdentifier:ValueCellIdentifier];
      
      if (cell==nil)
         cell =
         [[[UITableViewCell alloc]
           initWithStyle:UITableViewCellStyleValue1
           reuseIdentifier:ValueCellIdentifier] autorelease];
   }
   else
   {
      cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

      if(cell==nil)
         cell =
         [[[UITableViewCell alloc]
           initWithStyle:UITableViewCellStyleDefault
           reuseIdentifier:CellIdentifier] autorelease];
   }
   
   switch(indexPath.section)
   {
      case SECTION_AUTHORIZATION:
         cell.textLabel.text = @"flickr Authorization";
         cell.textLabel.textAlignment = UITextAlignmentLeft;
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         
         //cell.detailTextLabel.text = @"Unauthorized";
         cell.detailTextLabel.text = app.user.username;
         break;
      case SECTION_UPLOAD:
      {
         UISwitch *mySwitch = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
         [mySwitch addTarget:self action:@selector(doit:) forControlEvents:UIControlEventValueChanged];
         cell.accessoryView = mySwitch;
         
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.textLabel.text = @"Public";
            
         mySwitch.on =
         [[NSUserDefaults standardUserDefaults] boolForKey:SETTING_UPLOAD_PUBLIC];
            
         mySwitch.tag = PUBLIC_SETTING;
      }
         break;
      case SECTION_PHOTO_WALL:
         cell.textLabel.text = @"Photo size";
         cell.textLabel.textAlignment = UITextAlignmentLeft;
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         
         //SET FROM USER DEFAULTS
         switch ([[NSUserDefaults standardUserDefaults] integerForKey:USER_DEFAULT_PHOTO_SIZE])
         {
            case 50:
               cell.detailTextLabel.text = @"Small";
               break;
            case 75:
               cell.detailTextLabel.text = @"Medium";
               break;
            case 100:
               cell.detailTextLabel.text = @"Large";
               break;
            case 125:
               cell.detailTextLabel.text = @"XLarge";
            break;
            
            default:
            break;
      }
         
         break;
      case SECTION_MAP:
         switch(indexPath.row)
         {
            default:
            {
               UISwitch *mySwitch = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
               [mySwitch addTarget:self action:@selector(doit:) forControlEvents:UIControlEventValueChanged];
               cell.accessoryView = mySwitch;
               
               cell.selectionStyle = UITableViewCellSelectionStyleNone;
               switch(indexPath.row)
               {
                  default:
                     cell.textLabel.text = @"Show Satellite";
 
                     mySwitch.on = 
                     [[NSUserDefaults standardUserDefaults] boolForKey:SETTING_MAP_TYPE];
                     
                     mySwitch.tag = MAP_TYPE_SETTING;
                     break;
               }
            }
         }
         break;
      case SECTION_PANDAS: //pandas
      switch(indexPath.row)
      {
         default:
         {
            UISwitch *mySwitch = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
            [mySwitch addTarget:self action:@selector(doit:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = mySwitch;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            switch(indexPath.row)
            {
               case 0:
                  cell.textLabel.text = @"ling ling";
                  
                  mySwitch.on = 
                  [[NSUserDefaults standardUserDefaults] boolForKey:PANDA_LING_LING];
                  
                  mySwitch.tag = PANDA_LING_LING_SETTING;
                  break;
               case 1:
                  cell.textLabel.text = @"hsing hsing";
                  
                  mySwitch.on = 
                  [[NSUserDefaults standardUserDefaults] boolForKey:PANDA_HSING_HSING];
                  
                  mySwitch.tag = PANDA_HSING_HSING_SETTING;
                  break;
               case 2:
                  cell.textLabel.text = @"wang wang";
                  
                  mySwitch.on = 
                  [[NSUserDefaults standardUserDefaults] boolForKey:PANDA_WANG_WANG];
                  
                  mySwitch.tag = PANDA_WANG_WANG_SETTING;
                  break;
            }
         }
      }
      break;
      case SECTION_CREDITS: //LEGAL
         cell.textLabel.text = @"Credits";
         cell.textLabel.textAlignment = UITextAlignmentCenter;
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         break;
   }  
   
   return cell;
}

-(void)doit:(id)sender
{
   UISwitch* aSwitch = (UISwitch*)sender;
   switch(aSwitch.tag)
   {
      case PUBLIC_SETTING:
         if ([aSwitch isOn])
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SETTING_UPLOAD_PUBLIC];
         else
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SETTING_UPLOAD_PUBLIC];
         break;
         break;
      case MAP_TYPE_SETTING:
         if ([aSwitch isOn])
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SETTING_MAP_TYPE];
         else 
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SETTING_MAP_TYPE];
         break;
      case PANDA_LING_LING_SETTING:
         if ([aSwitch isOn])
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PANDA_LING_LING];
         else 
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PANDA_LING_LING];
         break;
      case PANDA_HSING_HSING_SETTING:
         if ([aSwitch isOn])
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PANDA_HSING_HSING];
         else 
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PANDA_HSING_HSING];
         break;
      case PANDA_WANG_WANG_SETTING:
         if ([aSwitch isOn])
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PANDA_WANG_WANG];
         else 
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PANDA_WANG_WANG];
         break;
      case 77777:
         break;
      case 777777:
         break;
   }
   
   //////////////////////////////////////////////////////////
   //UPDATE THE USER DEFAULTS
   [[NSUserDefaults standardUserDefaults] synchronize];
   [NSUserDefaults resetStandardUserDefaults];
   
   //tell the app to refresh the based on the user's choice
   utilityAppDelegate* app =
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
   [app refreshPandaList];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    utilityAppDelegate* app =
    (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
   
   switch (indexPath.section)
   {
      case SECTION_PHOTO_WALL:
      {
         UITableViewController* controller =
         [[[UITableViewController alloc]
           initWithStyle:UITableViewStyleGrouped]
          autorelease];
                  
         controller.title = @"Photo Size";
         controller.tableView.backgroundColor = [UIColor blackColor];
         
         UIView *backView = [[UIView alloc] init];
         [backView setBackgroundColor:[UIColor clearColor]];
         
         [controller.tableView setBackgroundView:backView];
         
         PhotoWallSetting* settings =
         [[PhotoWallSetting alloc]init];
         
         switch ([[NSUserDefaults standardUserDefaults] integerForKey:USER_DEFAULT_PHOTO_SIZE])
         {
            case 50:
               settings.selected = 0;
               break;
            case 75:
               settings.selected = 1;
               break;
            case 100:
               settings.selected = 2;
               break;
            case 125:
               settings.selected = 3;
               break;
               
            default:
               break;
         }
         
         controller.tableView.delegate = settings;
         controller.tableView.dataSource = settings;
                  
         [self.navigationController pushViewController:controller animated:YES];
      }
         break;
      case SECTION_AUTHORIZATION:
           [app authorization];
        break;
      case SECTION_CREDITS:
         [tableView deselectRowAtIndexPath:indexPath animated:YES];
         
         UIViewController* controller = [[UIViewController alloc] init];
         
         controller.title = @"Credits";
         
         UITextView* statement = [[UITextView alloc] init];
         
         statement.text =
         @"\nThis product uses the Flickr API but is not endorsed or certified by Flickr\n\n"
         "ObjectiveFlickr Copyright (c) 2006-2009 Lukhnos D. Liu.\n"
         "LFWebAPIKit Copyright (c) 2007-2009 Lukhnos D. Liu and Lithoglyph Inc."
         "\n\n"
         "One test in LFWebAPIKit (Tests/StreamedBodySendingTest) makes use of Google Toolbox for Mac, Copyright (c) 2008"
         "Google Inc. Refer to COPYING.txt in the directory for the full text of the Apache License, Version 2.0, under"
         "which the said software is licensed."
         "Both ObjectiveFlickr and LFWebAPIKit are released under the MIT license, the full text of which is printed here as "
         "follows. You can also find the text at: http://www.opensource.org/licenses/mit-license.php "
         "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated "
         "documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation "
         "the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to "
         "permit persons to whom the Software is furnished to do so, subject to the following conditions in this license.  "
         "\n\n"
         "Special thanks to:"
         "\n\n"
         "SVWebViewController\n"
         "Created by Sam Vermette on 08.11.10.\n"
         "Copyright 2010 Sam Vermette. All rights reserved.\n"
         "\n\n"
         "MBProgressHUD\n"
         "Version 0.4\n"
         "Created by Matej Bukovinski on 2.4.09.\n"
         "\n\n"
         "iOS Recipes\n"
         "The Pragmatic Programmer"
         "\n\n"
         ;
         
         statement.editable = NO;
         
         controller.view = statement;
         
         [statement release];
         
         [self.navigationController pushViewController:controller animated:YES];
         
         [controller release];
         break;
      default:
         break;
   }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
   [super viewDidLoad];
   self.view.backgroundColor = [UIColor blackColor]; //[UIColor viewFlipsideBackgroundColor];
   
   //listen for authorization change notification
   [[NSNotificationCenter defaultCenter]
    addObserver:self
    selector:@selector(authorizationChanged)
    name:@"authorizationChanged"
    object:nil];
   
   //listen for photo wall size changed
   [[NSNotificationCenter defaultCenter]
    addObserver:self
    selector:@selector(photowallSizeChanged)
    name:@"photoWallSizeChanged"
    object:nil];
}

-(void) authorizationChanged
{
   [self.tableView reloadData];
}

-(void) photowallSizeChanged
{
   //update the list
   [self.tableView reloadData];
   
   //pop back to the settings list
   [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

@end
