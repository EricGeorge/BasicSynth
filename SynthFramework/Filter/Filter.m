//
//  Filter.m
//
//  Created by Eric on 5/10/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "Filter.h"

#import "Parameters.h"

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
    }
    
    return self;
}

- (void) setEnvGain:(double)envGain
{
    _envGain = envGain;
    
    [self update];
}

- (void) update
{
    Parameters * parameters = [Parameters sharedParameters];

    _modulatedCutoff = fmax(fmin(parameters.cutoffParam * _envGain, 0.99), 0.01);
    _feedback = parameters.resonanceParam + parameters.resonanceParam/(1.0 - _modulatedCutoff);
}

- (double) process:(double) input;
{
    _buf0 += _modulatedCutoff * (input - _buf0 + _feedback * (_buf0 - _buf1));
    _buf1 += _modulatedCutoff * (_buf0 - _buf1);
        
    // hard code LP for now
    return _buf1;
}

@end
