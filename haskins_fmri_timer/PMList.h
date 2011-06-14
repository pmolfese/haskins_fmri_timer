//
//  PMList.h
//  haskins_fmri_timer
//
//  Created by Peter Molfese on 6/13/11.
//  Copyright 2011 Haskins Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMEvent.h"


@interface PMList : NSObject 
{
    NSUInteger numberOfConditions;
    NSUInteger numberOfRuns;
    NSMutableArray *fullList;
}
@property(readwrite,copy)NSMutableArray *fullList;
@property(assign) NSUInteger numberOfConditions;
@property(assign) NSUInteger numberOfRuns;
-(id)init;
-(id)initWithArray:(NSArray *)anArray;
-(void)addEvent:(PMEvent *)anEvent;
-(void)addArrayOfEvents:(NSArray *)anArrayOfEvents;
-(void)calculateSelfStats;
-(NSArray *)eventsforCondition:(NSUInteger) conditionNumber;
-(NSArray *)eventsforRun:(NSUInteger) runNumber;
-(NSArray *)eventsforRun:(NSUInteger) runNumber condition:(NSUInteger) conditionNumber;


@end
