//
//  Oscillator.h
//
//  Created by Eric on 4/20/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthConstants.h"

typedef NS_ENUM(NSInteger, OscillatorWave)
{
    OscillatorWaveSine,
    OscillatorWaveFirst = OscillatorWaveSine,
    OscillatorWaveSaw,
    OscillatorWaveSquare,
    OscillatorWaveTriangle,
    OscillatorWaveLast = OscillatorWaveTriangle
};

@interface Oscillator : NSObject

@property (nonatomic, assign) double frequency;

- (double) nextSample;
- (void) update;

@end

