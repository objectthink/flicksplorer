/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
***/
//
//  PRPTileView.m
//  InfiniteImages
//
//  Created by Paul Warren
//  Copyright 2011 Primitive Dog Software. All rights reserved.
//

#import "PRPTileView.h"
#import <QuartzCore/CATiledLayer.h>
#import "Photo.h"

//#define SIZE 75

@interface PRPTileView()

@end

@implementation PRPTileView

@synthesize photos;
@synthesize size=SIZE;

+ (Class)layerClass
{
   //return [CATiledLayer class];
   return [PRPTiledLayerX class];   
}

- (id)initWithFrame:(CGRect)frame size:(int)aSize
{
   self.size = aSize;
   
   if ((self = [super initWithFrame:frame]))
   {
      CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
      
      CGFloat sf = self.contentScaleFactor;
      
      tiledLayer.tileSize = CGSizeMake(SIZE*sf, SIZE*sf);
   }
   
   return self;
}

- (id)initWithFrame:(CGRect)frame
{
   SIZE = MEDIUM;
   
   if ((self = [super initWithFrame:frame]))
   {
      CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
        
      CGFloat sf = self.contentScaleFactor;

      tiledLayer.tileSize = CGSizeMake(SIZE*sf, SIZE*sf);
   }
   
   return self;
}

- (void)dealloc 
{
   [super dealloc];
}

- (void)drawRect:(CGRect)rect 
{
   if([self.photos count]==0) return;
      
   int col = rect.origin.x / SIZE;
   int row = rect.origin.y / SIZE;
   
   //NSLog(@"row:%d col:%d",row, col);

   int columns = self.bounds.size.width/SIZE;
   
   UIImage *tile = [self tileAtPosition:row*columns+col];
    
   if(tile == nil)
   {
      tile = [UIImage imageNamed:@"icon.png"];

      [tile drawInRect:rect];
      
      //this was causing the photo wall update latency
      //as each set needs display was requesting every
      //photo be redrawn
      
      //[self setNeedsDisplayInRect:rect];
   }
   else
      [tile drawInRect:rect];
}

int wait_state = 0;
- (UIImage *)tileAtPosition:(int)position
{   
   int count = [self.photos count];
   if (count == 0) 
   {
      return nil;
	}
	
   int index = position%count;
	
   Photo* photo = [self.photos objectAtIndex:index];
   
   if(((photo.thumb == nil)||(photo.buddy == nil))&&(!photo.isFetching))
   {
      photo.isFetching = YES;
      
      dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
      dispatch_async(queue, 
                  ^{
                     UIImage* thumb;
                     UIImage* buddy;
                     
                     if(photo.photoThumbURL == nil)
                     {
                        thumb = [UIImage imageNamed:@"icon.png"];
                     }
                     else
                     {
                        //NSLog(@"FETCHING THUMB");
                        NSData *imageData = [NSData dataWithContentsOfURL:photo.photoThumbURL];
                                                
                        if(imageData == nil)
                           thumb = [UIImage imageNamed:@"icon.png"];
                        else
                           thumb = [UIImage imageWithData:imageData];
                     }
                     
                     if(photo.buddyURL == nil)
                     {
                        buddy = [UIImage imageNamed:@"19-gear.png"];
                     }
                     else
                     {
                        //NSLog(@"FETCHING BUDDY");
                        NSData *imageData = [NSData dataWithContentsOfURL:photo.buddyURL];
                                                   
                        if(imageData == nil)
                           buddy = [UIImage imageNamed:@"19-gear.png"];
                        else
                           buddy = [UIImage imageWithData:imageData];
                     }

                     photo.thumb = thumb;
                     photo.buddy = buddy;
                     
                     dispatch_sync(dispatch_get_main_queue(), 
                                   ^{
                                      //NSLog(@"SET NEEDS DISPLAY");
                                      [self setNeedsDisplay];
                                   });
                     photo.isFetching = NO;
 
                  });        
   }
   
   return photo.thumb;
}

- (Photo*)photoFromTouch:(CGPoint)touchPoint 
{
   //NSLog(@"%s %f %f", __PRETTY_FUNCTION__,touchPoint.x,touchPoint.y);  

   if(photos.count == 0) return nil;
   
   int col = touchPoint.x / SIZE;
   int row = touchPoint.y / SIZE;
   int cols = (self.bounds.size.width/SIZE);
   
   int position = row*cols+col;
   
   int index = position%self.photos.count;
   
   //NSLog(@"row:%d col:%d position:%d index:%d count:%d",
//         row,
//         col,
//         position,
//         index,
//         self.photos.count);  

   return [photos objectAtIndex:index];
}

@end
