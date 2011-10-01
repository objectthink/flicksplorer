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

#define SIZE 75

@interface PRPTileView()

@property (nonatomic, copy)  NSArray *albumCollections;

@end

@implementation PRPTileView

@synthesize albumCollections;
@synthesize photos;

+ (Class)layerClass 
{
   return [CATiledLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) 
    {
       CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
        
       CGFloat sf = self.contentScaleFactor;
       tiledLayer.tileSize = CGSizeMake(SIZE*sf, SIZE*sf);

//       MPMediaQuery *everything = [MPMediaQuery albumsQuery];
//       self.albumCollections = [everything collections];		
    }
    return self;
}

- (void)dealloc 
{
   [albumCollections release]; albumCollections=nil;
   [super dealloc];
}

- (void)drawRect:(CGRect)rect 
{
   if([self.photos count]==0) return;
   
   int col = rect.origin.x / SIZE;
   int row = rect.origin.y / SIZE;
   
   int columns = self.bounds.size.width/SIZE;
   
   UIImage *tile = [self tileAtPosition:row*columns+col];
    
   if(tile == nil)
   {
      tile = [UIImage imageNamed:@"icon.png"];

      [tile drawInRect:rect];
      [self setNeedsDisplayInRect:rect];
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
      //return [UIImage imageNamed:@"missing.png"];
	}
	
   int index = position%count;
	
   Photo* photo = [self.photos objectAtIndex:index];
   
   if(photo.thumb == nil)
   {
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
                        NSData *imageData = [NSData dataWithContentsOfURL:photo.photoThumbURL];
                        thumb = [UIImage imageWithData:imageData];
                        
                        if(imageData == nil)
                           thumb = [UIImage imageNamed:@"icon.png"];
                     }
                     
                     if(photo.buddyURL == nil)
                     {
                        buddy = [UIImage imageNamed:@"19-gear.png"];
                     }
                     else
                     {
                        if(photo.buddy == nil)
                        {
                           NSData *imageData = [NSData dataWithContentsOfURL:photo.buddyURL];
                           photo.buddy = [UIImage imageWithData:imageData];
                        
                           if(imageData == nil)
                              photo.buddy = [UIImage imageNamed:@"19-gear.png"];
                        }
                        
                     }

                     photo.thumb = thumb;
                     //photo.buddy = buddy;
                     
                     dispatch_sync(dispatch_get_main_queue(), 
                                   ^{
//                                      wait_state++;
//                                      
//                                      if( (wait_state%100)==0 )
                                         [self setNeedsDisplay];
                                   });
                   });        
   }
   
   return photo.thumb;
}

- (Photo*)photoFromTouch:(CGPoint)touchPoint 
{
   NSLog(@"%s %f %f", __PRETTY_FUNCTION__,touchPoint.x,touchPoint.y);  

   if(photos.count == 0) return nil;
   
   int col = touchPoint.x / SIZE;
   int row = touchPoint.y / SIZE;
   int cols = (self.bounds.size.width/SIZE);
   
   int position = row*cols+col;
   
   int index = position%self.photos.count;
   
   NSLog(@"row:%d col:%d position:%d index:%d count:%d",
         row,
         col,
         position,
         index,
         self.photos.count);  

   return [photos objectAtIndex:index];
}

- (UIImage *)tileAtPositionX:(int)position
{
   int albums = [self.albumCollections count];
   if (albums == 0) {
      return [UIImage imageNamed:@"missing.png"];
	}
	
   int index = position%albums;
	
   MPMediaItemCollection *mCollection = [self.albumCollections 
                                         objectAtIndex:index];
   MPMediaItem *mItem = [mCollection representativeItem];
   MPMediaItemArtwork *artwork =
   [mItem valueForProperty: MPMediaItemPropertyArtwork];
	
   UIImage *image = [artwork imageWithSize: CGSizeMake(SIZE, SIZE)];
   if (!image) image = [UIImage imageNamed:@"missing.png"];
   
   return image;
}

@end
