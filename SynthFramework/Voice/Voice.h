//
//  Voice.h
//
//  Created by Eric on 5/17/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AudioToolbox/AudioToolbox.h>

@interface Voice : NSObject

@property (nonatomic, assign) double sampleRate;
@property (nonatomic, readonly) BOOL isActive;
@property (nonatomic, assign) uint8_t note;
@property (nonatomic, assign) uint64_t age;

- (void) steal;
- (void) start:(uint8_t)note withVelocity:(uint8_t)velocity;
- (void) stop;

- (void) nextSample:(double *)outL andRight:(double *)outR;

- (void) updateDca;
- (void) updateOscillator;
- (void) updateAmpEnv;
- (void) updateFilter;
- (void) updateFilterEnv;

@end
