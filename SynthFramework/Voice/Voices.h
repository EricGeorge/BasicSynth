//
//  Voices.h
//
//  Created by Eric on 5/18/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AudioToolbox/AudioToolbox.h>

@interface Voices : NSObject

@property (nonatomic, assign) double sampleRate;

- (void) setParameter:(AUParameterAddress)address withValue:(AUValue)value;
- (AUValue) getParameter:(AUParameterAddress)address;

- (void) start:(uint8_t)note withVelocity:(uint8_t)velocity;
- (void) stop:(uint8_t)note;

- (void) nextSample:(double *)outL andRight:(double *)outR;

@end
