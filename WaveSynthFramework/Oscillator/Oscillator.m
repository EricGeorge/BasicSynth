//
//  Oscillator.m
//  AUInstrument
//
//  Created by Eric on 4/20/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "Oscillator.h"


static const double PI = 3.14159265358979;

@interface Oscillator ()
{
    double _phase;
    double _phaseIncrement;
}

- (void) updateIncrement;

@end


@implementation Oscillator

- (instancetype)init
{
    if (self = [super init])
    {
        self.mode = OSCILLATOR_MODE_SINE;
        self.frequency = 440.0;
        self.sampleRate = 44100;
        _phase = 0.0;
        
        [self updateIncrement];
    }
    
    return self;
}

- (void) setSampleRate:(double)sampleRate
{
    _sampleRate = sampleRate;
    [self updateIncrement];
}

- (void) setFrequency:(double)frequency
{
    _frequency = frequency;
    [self updateIncrement];
}

- (void) updateIncrement
{
    _phaseIncrement = _frequency * 2 * PI / _sampleRate;
}

- (void) generate:(double*)buffer withFrames:(int)frames
{
    const double twoPI = 2 * PI;
    
    switch (self.mode)
    {
        case OSCILLATOR_MODE_SINE:
            for (int i = 0; i < frames; i++)
            {
                buffer[i] = sin(_phase);
                _phase += _phaseIncrement;
                while (_phase >= twoPI)
                {
                    _phase -= twoPI;
                }
            }
            break;
        case OSCILLATOR_MODE_SAW:
            for (int i = 0; i < frames; i++)
            {
                buffer[i] = 1.0 - (2.0 * _phase / twoPI);
                _phase += _phaseIncrement;
                while (_phase >= twoPI)
                {
                    _phase -= twoPI;
                }
            }
            break;
        case OSCILLATOR_MODE_SQUARE:
            for (int i = 0; i < frames; i++)
            {
                if (_phase <= PI)
                {
                    buffer[i] = 1.0;
                }
                else
                {
                    buffer[i] = -1.0;
                }
                _phase += _phaseIncrement;
                while (_phase >= twoPI)
                {
                    _phase -= twoPI;
                }
            }
            break;
        case OSCILLATOR_MODE_TRIANGLE:
            for (int i = 0; i < frames; i++)
            {
                double value = -1.0 + (2.0 * _phase / twoPI);
                buffer[i] = 2.0 * (fabs(value) - 0.5);
                _phase += _phaseIncrement;
                while (_phase >= twoPI)
                {
                    _phase -= twoPI;
                }
            }
            break;
        default:
            NSLog(@"Unknown Oscillator Mode passed to Oscillator::generate");
            break;
    }
}
@end
