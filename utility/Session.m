//
//  OFSession.m
//  utility
//
//  Created by stephen eshelman on 9/10/11.
//  Copyright 2011 blue sky computing. All rights reserved.
//

#import "Session.h"

@implementation Session

@synthesize requestType;
@synthesize location;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(Session*)sessionWithRequestType:(REQUESTTYPE)requestType
{
   Session* session = [[Session alloc] init];
   
   session.requestType = requestType;

   return [session autorelease];
}

-(void)dealloc
{
   //NSLog(@"%s", __PRETTY_FUNCTION__);
   
   [super dealloc];
}


@end
