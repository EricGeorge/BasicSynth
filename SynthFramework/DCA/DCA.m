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
    double _midiVelocityGain;
}

@end;

@implementation DCA

- (instancetype)init
{
    if (self = [super init])
    {
        self.volumePct = 100.0;
        self.midiVelocity = 0;
        self.pan = 0;
    }
    
    return self;
}

- (void) setVolumePct:(double)volumePct
{
    _volumePct = volumePct;
    
    // put an exponential curve on the volume input (and normalize to 0-1)
    _volume = pow2(_volumePct/100.0);
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

- (void) compute:(double)leftInput
      rightInput:(double)rightInput
      leftOutput:(double *)leftOutput
     rightOutput:(double *)rightOutput
{
    NSLog(@"DCA:envGain is %f", _envGain);
    // form left and right outputs
    *leftOutput = leftInput * _envGain * _volume * _midiVelocityGain * _panL;
    *rightOutput = rightInput * _envGain * _volume * _midiVelocityGain * _panR;
}

@end
