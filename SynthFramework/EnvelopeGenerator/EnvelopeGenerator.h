//
//  EnvelopeGenerator.h
//
//  Created by Eric on 5/3/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnvelopeGenerator : NSObject

@property (nonatomic, assign) double sampleRate;

@property (nonatomic, assign) double normalizedAttackTime;
@property (nonatomic, assign) double normalizedDecayTime;
@property (nonatomic, assign) double normalizedSustainLevel;
@property (nonatomic, assign) double normalizedReleaseTime;

@property (nonatomic, readonly) BOOL isIdle;

- (void) start;
- (void) stop;

- (double) nextSample;
- (void) calculate;
- (void) update;

@end
