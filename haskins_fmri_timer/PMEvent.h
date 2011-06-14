//
//  PMEvent.h
//  haskins_fmri_timer
//
//  Created by Peter Molfese on 6/13/11.
//  Copyright 2011 Haskins Labs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PMEvent : NSObject {
    NSString *run;
    NSString *trial;
    NSString *time;
    NSString *condition;
    NSString *iti;
}
@property(readwrite,copy)NSString *run;
@property(readwrite,copy)NSString *trial;
@property(readwrite,copy)NSString *time;
@property(readwrite,copy)NSString *condition;
@property(readwrite,copy)NSString *iti;

- (id)init;

@end
