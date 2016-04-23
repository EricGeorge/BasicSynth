//
//  Oscillator.h
//  AUInstrument
//
//  Created by Eric on 4/20/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OscillatorMode)
{
    OSCILLATOR_MODE_SINE,
    OSCILLATOR_MODE_SAW,
    OSCILLATOR_MODE_SQUARE,
    OSCILLATOR_MODE_TRIANGLE
};

@interface Oscillator : NSObject

@property (nonatomic, assign) OscillatorMode mode;
@property (nonatomic, assign) double frequency;
@property (nonatomic, assign) double sampleRate;

- (void) generate:(double*)buffer withFrames:(int)frames;

@end

