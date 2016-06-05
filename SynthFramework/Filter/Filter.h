//
//  Filter.h
//
//  Created by Eric on 5/10/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filter : NSObject

@property (nonatomic, assign) double envGain;

- (double) process:(double)input;
- (void) update;

@end
