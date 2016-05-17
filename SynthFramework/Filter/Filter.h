//
//  Filter.h
//
//  Created by Eric on 5/10/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filter : NSObject

@property (nonatomic, assign) double sampleRate;

@property (nonatomic, assign) double cutoff;
@property (nonatomic, assign) double resonance;

- (double) process:(double)input;

@end
