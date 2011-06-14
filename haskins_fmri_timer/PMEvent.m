//
//  PMEvent.m
//  haskins_fmri_timer
//
//  Created by Peter Molfese on 6/13/11.
//  Copyright 2011 Haskins Labs. All rights reserved.
//

#import "PMEvent.h"


@implementation PMEvent

@synthesize run;
@synthesize trial;
@synthesize time;
@synthesize condition;
@synthesize iti;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [run release];
    [trial release];
    [time release];
    [condition release];
    [iti release];
    self.run = nil;
    self.trial = nil;
    self.time = nil;
    self.condition = nil;
    self.iti = nil;
    
    [super dealloc];
}

@end
