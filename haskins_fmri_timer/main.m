//
//  main.m
//  haskins_fmri_timer
//
//  Created by Peter Molfese on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMList.h"

PMList* readFile(NSString *pathToFile);
void createAFNIFile(PMList *aListOfEvents, NSString *path);
void createFSLFile(PMList *aListOfEvents, NSString *path);
void createFSLMLMFiles(PMList *aListOfEvents, NSString *path);

int main (int argc, const char * argv[])
{

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    // insert code here...
    if( argc < 4 )
    {
        printf("Usage: ./haskins_fmri_timer <afni/fsl/hlmfsl> <input> <output_prefix>\n");
    }
    
    //uppercaseString
    
    printf("Input File: %s\n", argv[2]);
    
    PMList *aList = readFile([NSString stringWithCString:argv[2] encoding:1]);
    [aList retain];
    
    //get path
    NSString *basePath = [NSString stringWithCString:argv[3] encoding:1];
    //get type
    NSString *fileType = [NSString stringWithCString:argv[1] encoding:1];
    
    if( [fileType caseInsensitiveCompare:@"FSL"] == 0 )
    {
        printf("Output: FSL\n");
        printf("ATTN: These files can't be fed directly into FSL, break down by Run!\n");
        createFSLFile(aList, basePath);
    }
    else if( [fileType caseInsensitiveCompare:@"HLMFSL"] == 0 )
    {
        printf("Output: FSL for Multilevel Models\n");
        createFSLMLMFiles(aList, basePath);
    }
    else if( [fileType caseInsensitiveCompare:@"AFNI"] == 0 )
    {
        printf("Output: AFNI\n");
        createAFNIFile(aList, basePath);
    }
    else
    {
        printf("Type not found...\n Exiting.\n");
    }

    [pool drain];
    [aList release];
    return 0;
}

PMList* readFile(NSString *pathToFile)
{
    //NSLog(@"reading file");
    NSString *fileContents = [NSString stringWithContentsOfFile:pathToFile encoding:1 error:NULL];
    NSArray *allLines = [fileContents componentsSeparatedByString:@"\n"];
    NSMutableArray *myEvents = [NSMutableArray arrayWithCapacity:100];
    
    int i = 0;
    for( i=0; i< [allLines count]; ++i )
    {
        NSArray *oneLine = [[allLines objectAtIndex:i] componentsSeparatedByString:@"\t"];
        if( [oneLine count] < 4 )
            break;
        PMEvent *anEvent = [[PMEvent alloc] init];
        [anEvent setRun:[oneLine objectAtIndex:0]];
        [anEvent setTrial:[oneLine objectAtIndex:1]];
        [anEvent setTime:[oneLine objectAtIndex:2]];
        [anEvent setCondition:[oneLine objectAtIndex:3]];
        [anEvent setIti:[oneLine objectAtIndex:4]];
        [myEvents addObject:anEvent];
        [anEvent release];
    }
    
    PMList *listFromFile = [[PMList alloc] initWithArray:myEvents];
    return listFromFile;
}

void createAFNIFile(PMList *aListOfEvents, NSString *path)
{
    
}

void createFSLFile(PMList *aListOfEvents, NSString *path)
{
    int i = 0;
    int j = 0;
    NSUInteger totalConditions = [aListOfEvents numberOfConditions];
    
    for( i=1; i <= totalConditions; ++i )
    {
        NSArray *eventsOfInterest = [aListOfEvents eventsforCondition:i];
        NSMutableString *fileToMake = [NSMutableString stringWithCapacity:100];
        
        for( j=0; j<[eventsOfInterest count]; ++j )
        {
            [fileToMake appendString:[[eventsOfInterest objectAtIndex:j] time]];
            [fileToMake appendString:@" "];
            [fileToMake appendString:@"1"];
            [fileToMake appendString:@" "];
            [fileToMake appendString:@"1"];
            [fileToMake appendString:@"\n"];
        }
        
        //all the write out code:
        NSString *pathToWrite = [path stringByAppendingString:@"-fsl_cond"];
        pathToWrite = [pathToWrite stringByAppendingString:[[NSNumber numberWithInt:i] stringValue]];
        pathToWrite = [pathToWrite stringByAppendingString:@".txt"];
        printf("Wrote: %s\n", [pathToWrite cStringUsingEncoding:1]);
        [fileToMake writeToFile:pathToWrite atomically:YES encoding:1 error:NULL];
    }
}

void createFSLMLMFiles(PMList *aListOfEvents, NSString *path)
{
    int i, j, k;
    NSUInteger totalConditions = [aListOfEvents numberOfConditions];
    NSUInteger totalRuns = [aListOfEvents numberOfRuns];
    
    for( i=1; i<= totalRuns; i++ )               //runs
    {
        NSMutableString *fileToMake = [NSMutableString stringWithCapacity:30];
        for( j=1; j<=totalConditions; j++ )      //conditions
        {
            NSArray *eventsOfInterest = [aListOfEvents eventsforRun:i condition:j];
            for( k=0; k<[eventsOfInterest count]; k++ )
            {
                [fileToMake appendString:[[eventsOfInterest objectAtIndex:k] time]];
                [fileToMake appendString:@" "];
                [fileToMake appendString:@"1"];
                [fileToMake appendString:@" "];
                [fileToMake appendString:@"1"];
                [fileToMake appendString:@"\n"];
            }
            //write one file per run, per condition
            NSString *pathToWrite = [path stringByAppendingString:@"-fsl_cond"];
            pathToWrite = [pathToWrite stringByAppendingString:[[NSNumber numberWithInt:j] stringValue]];
            pathToWrite = [pathToWrite stringByAppendingString:@"_run"];
            pathToWrite = [pathToWrite stringByAppendingString:[[NSNumber numberWithInt:i] stringValue]];
            pathToWrite = [pathToWrite stringByAppendingString:@".txt"];
            printf("Wrote: %s\n", [pathToWrite cStringUsingEncoding:1]);
            [fileToMake writeToFile:pathToWrite atomically:YES encoding:1 error:NULL];
        }   //conditions, j
    }   //runs, i
    
    
}