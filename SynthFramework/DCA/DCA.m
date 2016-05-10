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
    double _normalizedVolume;
    double _panL;
    double _panR;
    double _midiVelocityGain;
}

@end;

@implementation DCA

- (instancetype)init
{
    if (self = [super init])
    {
        self.volume = 100.0;
        self.midiVelocity = 0;
        self.pan = 0;
    }
    
    return self;
}

- (void) setVolume:(double)volume
{
    _volume = volume;
    
    // put an exponential curve on the volume input (and normalize to 0-1)
    _normalizedVolume = pow2(_volume/100.0);
}

- (void) setMidiVelocity:(uint8_t)midiVelocity
{
    _midiVelocity = midiVelocity;
    _midiVelocity = _midiVelocityGain = gainFromMidiVelocity(midiVelocity);
}

- (void) setPan:(double)pan
{
    _pan = pan;
    
    // use equal power crossfades to get the left and right channels from the bipolar pan value
    _panL = getEqualPowerLeft(_pan);
    _panR = getEqualPowerRight(_pan);
}

- (void) process:(double)leftInput
      rightInput:(double)rightInput
      leftOutput:(double *)leftOutput
     rightOutput:(double *)rightOutput
{
    // form left and right outputs
    *leftOutput = leftInput * _envGain * _normalizedVolume * _midiVelocityGain * _panL;
    *rightOutput = rightInput * _envGain * _normalizedVolume * _midiVelocityGain * _panR;
}

@end
