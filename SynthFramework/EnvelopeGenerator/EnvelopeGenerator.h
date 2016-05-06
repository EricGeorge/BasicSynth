//
//  EnvelopeGenerator.h
//  BasicSynth
//
//  Created by Eric on 5/3/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnvelopeGenerator : NSObject

@property (nonatomic, assign) double sampleRate;

@property (nonatomic, assign) double attackTime;    // seconds
@property (nonatomic, assign) double decayTime;     // seconds
@property (nonatomic, assign) double releaseTime;   // seconds
@property (nonatomic, assign) double sustainLevel;  // 0-1

- (void) start;
- (void) stop;

- (double) nextSample;

@end
