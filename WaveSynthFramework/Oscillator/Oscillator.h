//
//  Oscillator.h
//  AUInstrument
//
//  Created by Eric on 4/20/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OscillatorWave)
{
    OSCILLATOR_WAVE_SINE,
    OSCILLATOR_WAVE_SAW,
    OSCILLATOR_WAVE_SQUARE,
    OSCILLATOR_WAVE_TRIANGLE
};

@interface Oscillator : NSObject

@property (nonatomic, assign) OscillatorWave wave;
@property (nonatomic, assign) double frequency;
@property (nonatomic, assign) double sampleRate;

- (double) nextSample;

@end

