//
//  PMList.m
//  haskins_fmri_timer
//
//  Created by Peter Molfese on 6/13/11.
//  Copyright 2011 Haskins Labs. All rights reserved.
//

#import "PMList.h"


@implementation PMList

@synthesize fullList;
@synthesize numberOfRuns;
@synthesize numberOfConditions;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        fullList = [[NSMutableArray alloc] initWithCapacity:30];
        numberOfConditions = 0;
        numberOfRuns = 0;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(id)initWithArray:(NSArray *)anArray
{
    self = [self init];
    [self setFullList:[NSMutableArray arrayWithArray: anArray]];
    [self calculateSelfStats];
    return self;
}

-(void)addEvent:(PMEvent *)anEvent
{
    [fullList addObject:anEvent];
    [self calculateSelfStats];
}

-(void)addArrayOfEvents:(NSArray *)anArrayOfEvents
{
    for( PMEvent *anEvent in anArrayOfEvents )
    {
        [fullList addObject:anEvent];
    }
    [self calculateSelfStats];
}

-(void)calculateSelfStats
{
    NSUInteger maxCond = 0;
    NSUInteger maxRun = 0;
    for( PMEvent *anEvent in fullList )
    {
        if( [[anEvent condition] intValue] > maxCond )
            maxCond = [[anEvent condition] intValue];
        if( [[anEvent run] intValue] > maxRun )
            maxRun = [[anEvent run] intValue];
    }
    [self setNumberOfRuns:maxRun];
    [self setNumberOfConditions:maxCond];
}

-(NSArray *)eventsforCondition:(NSUInteger) conditionNumber
{
    NSMutableArray *eventsOfInterest = [NSMutableArray arrayWithCapacity:10];
    for( PMEvent *anEvent in fullList )
    {
        if( [[anEvent condition] intValue] == conditionNumber )
        {
            [eventsOfInterest addObject:anEvent];
        }
    }
    return eventsOfInterest;
}

-(NSArray *)eventsforRun:(NSUInteger) runNumber
{
    NSMutableArray *eventsOfInterest = [NSMutableArray arrayWithCapacity:10];
    for( PMEvent *anEvent in fullList )
    {
        if( [[anEvent run] intValue] == runNumber )
        {
            [eventsOfInterest addObject:anEvent];
        }
    }
    return eventsOfInterest;
}

-(NSArray *)eventsforRun:(NSUInteger) runNumber condition:(NSUInteger) conditionNumber
{
    NSMutableArray *eventsOfInterest = [NSMutableArray arrayWithCapacity:10];
    for( PMEvent *anEvent in fullList )
    {
        if( ([[anEvent run] intValue] == runNumber) && ([[anEvent condition] intValue] == conditionNumber) )
        {
            [eventsOfInterest addObject:anEvent];
        }
    }
    return eventsOfInterest;
}


@end
