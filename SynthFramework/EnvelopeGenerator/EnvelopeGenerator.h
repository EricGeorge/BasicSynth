//
//  EnvelopeGenerator.h
//
//  Created by Eric on 5/3/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnvelopeGenerator : NSObject

@property (nonatomic, assign) double sampleRate;

@property (nonatomic, assign) double attackTime;    // msec
@property (nonatomic, assign) double decayTime;     // msec
@property (nonatomic, assign) double releaseTime;   // msec
@property (nonatomic, assign) double sustainLevel;  // percent

- (void) start;
- (void) stop;

- (double) nextSample;

@end
