//
//  DCA.m
//  BasicSynth
//
//  Created by Eric on 5/2/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "DCA.h"

#import "Utility.hpp"

@interface DCA()
{
    double _volume;
    double _panL;
    double _panR;
}

@end;

@implementation DCA

- (instancetype)init
{
    if (self = [super init])
    {
        _volume = 0;
        self.volume_dB = 0.0;
        self.midiVelocity = 0;
    }
    
    return self;
}

- (void) setVolume_dB:(double)volume_dB
{
    _volume_dB = volume_dB;
    _volume = convertFromDecibels(_volume_dB);
}

- (void) setPan:(double)pan
{
    _pan = pan;
    calculatePan(_pan, &_panL, &_panR);
}

- (void) compute:(double)leftInput
      rightInput:(double)rightInput
      leftOutput:(double *)leftOutput
     rightOutput:(double *)rightOutput
{
    // form left and right outputs
    *leftOutput = leftInput * _volume * self.midiVelocity / 127.0 * _panL;
    *rightOutput = rightInput * _volume * self.midiVelocity / 127.0 * _panR;
}

@end
