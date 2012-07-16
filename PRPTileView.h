/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
***/
//
//  PRPTileView.h
//  InfiniteImages
//
//  Created by Paul Warren
//  Copyright 2011 Primitive Dog Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PRPTiledLayer.h"
#import "Photo.h"

typedef enum
{
   SMALL = 50,
   MEDIUM = 75,
   LARGE = 100,
   EXLARGE = 125
}PHOTOSIZE;

@interface PRPTileView : UIView 
{
   int SIZE;
}

@property (assign) NSArray* photos;
@property (assign) int size;

- (UIImage *)tileAtPosition:(int)position;
- (Photo*)photoFromTouch:(CGPoint)touchPoint;
- (id)initWithFrame:(CGRect)frame size:(int)aSize;
@end
