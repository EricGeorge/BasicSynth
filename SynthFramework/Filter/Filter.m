//
//  Filter.m
//
//  Created by Eric on 5/10/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "Filter.h"

@interface Filter()
{
    double _buf0;
    double _buf1;
    double _feedback;
    double _modulatedCutoff;
}

@end

@implementation Filter

- (instancetype) init
{
    if (self = [super init])
    {
        _buf0 = 0.0;
        _buf1 = 0.0;
        _feedback = 0.0;
        _modulatedCutoff = 0.0;
        
        self.cutoff = 0.99;
        self.resonance = 0.0;
    }
    
    return self;
}

- (void) setSampleRate:(double)sampleRate
{
    _sampleRate = sampleRate;
}

- (void) setCutoff:(double)cutoff
{
    _cutoff = cutoff;
    
    [self calculate];
}

- (void) setResonance:(double)resonance
{
    _resonance = resonance;
    
    [self calculate];
}

- (void) setEnvGain:(double)envGain
{
    _envGain = envGain;
    
    [self calculate];
}

- (void) calculate
{
    _feedback = _resonance + _resonance/(1.0 - _cutoff);
    _modulatedCutoff = fmax(fmin(_cutoff + _envGain, 0.99), 0.01);
}

- (double) process:(double) input;
{
    _buf0 += _modulatedCutoff * (input - _buf0 + _feedback * (_buf0 - _buf1));
    _buf1 += _modulatedCutoff * (_buf0 - _buf1);
        
    // hard code LP for now
    return _buf1;
}

@end
