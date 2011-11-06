//
//  FlipsideViewController.m
//  utility
//
//  Created by stephen eshelman on 9/3/11.
//  Copyright 2011 blue sky computing. All rights reserved.
//

#import "FlipsideViewController.h"
#import "utilityAppDelegate.h"

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
   return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   switch(section)
   {
      case 0:
         return [NSString stringWithString:@"Map"];
         break;
      case 1:
         return [NSString stringWithString:@"Pandas"];
         break;
      case 2:
         return [NSString stringWithFormat:@""];
         break;
   }
   
   return nil;
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
   switch(section)
   {
      case 1:
         return [NSString stringWithString:@"Choose which flickr pandas you wish to hear from!"];
         break;
      default:
         return @"";
         break;
   }   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   switch(section)
   {
      case 0:        //map settings, photo settings
         return 1;
         break;
      case 1:
         return 3;
         break;
      case 2:        //legal
         return 1;
         break;
      default:
         return 0;
         break;
   }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *CellIdentifier = @"Cell";
   
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   if (cell == nil) 
   {
      cell = 
      [[[UITableViewCell alloc] 
        initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
   }
   
   switch(indexPath.section)
   {
      case 0: //SETTINGS
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
                     
                     mySwitch.tag = 7;
                     break;
               }
            }
         }
         break;
      case 1: //pandas
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
                  
                  mySwitch.tag = 77;
                  break;
               case 1:
                  cell.textLabel.text = @"hsing hsing";
                  
                  mySwitch.on = 
                  [[NSUserDefaults standardUserDefaults] boolForKey:PANDA_HSING_HSING];
                  
                  mySwitch.tag = 777;
                  break;
               case 2:
                  cell.textLabel.text = @"wang wang";
                  
                  mySwitch.on = 
                  [[NSUserDefaults standardUserDefaults] boolForKey:PANDA_WANG_WANG];
                  
                  mySwitch.tag = 7777;
                  break;
            }
         }
      }
      break;
      case 2: //LEGAL
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
      case 7:
         if ([aSwitch isOn])
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SETTING_MAP_TYPE];
         else 
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SETTING_MAP_TYPE];
         break;
         break;
      case 77:
         if ([aSwitch isOn])
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PANDA_LING_LING];
         else 
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PANDA_LING_LING];
         break;
         break;
      case 777:
         if ([aSwitch isOn])
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PANDA_HSING_HSING];
         else 
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PANDA_HSING_HSING];
         break;
         break;
      case 7777:
         if ([aSwitch isOn])
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PANDA_WANG_WANG];
         else 
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PANDA_WANG_WANG];
         break;
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

-(void)dismissLegal
{
   [self dismissModalViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
   if(indexPath.section == 2) //LEGAL
   {
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
      
      UIViewController* controller = [[UIViewController alloc] init];
      
      controller.title = @"Credits";
      
      UITextView* statement = [[UITextView alloc] init];
      
      UIButton* back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      
      [back addTarget:self action:@selector(dismissLegal) forControlEvents:UIControlEventTouchUpInside];
      
      [back setBackgroundColor:[UIColor whiteColor]];
      
      back.frame = CGRectMake(0, 0, 320, 30);
      
      [back setTitle:@"Back" forState:UIControlStateNormal];
      
      [statement addSubview:back];
       
      statement.text = 
      @"\n\nThis product uses the Flickr API but is not endorsed or certified by Flickr\n\n"
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
      
      [self presentModalViewController:controller animated:YES];
      
      [controller release];
   }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];  
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

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
