//
//  DCA.m
//  BasicSynth
//
//  Created by Eric on 5/2/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "DCA.h"

#import "Parameters.h"
#import "Utility.hpp"

@interface DCA()
{
    double _midiVelocityGain;
}

@end;

@implementation DCA

- (instancetype)init
{
    if (self = [super init])
    {
        self.midiVelocity = 0;
    }
    
    return self;
}

- (void) setMidiVelocity:(uint8_t)midiVelocity
{
    _midiVelocity = midiVelocity;
    _midiVelocity = _midiVelocityGain = gainFromMidiVelocity(midiVelocity);
}

+ (double) calculateRawVolume:(double)volume
{
    // put an exponential curve on the volume input (and normalize to 0-1)
    return pow2(volume/100.0);
}

+ (void) calculateRawPans:(double)inPan withOutL:(double *)outPanL andOutR:(double *)outPanR
{
    // use equal power crossfades to get the left and right channels from the bipolar pan value
    *outPanL = getEqualPowerLeft(inPan);
    *outPanR = getEqualPowerRight(inPan);
}

- (void) process:(double)leftInput
      rightInput:(double)rightInput
      leftOutput:(double *)leftOutput
     rightOutput:(double *)rightOutput
{
    Parameters * parameters = [Parameters sharedParameters];

    // form left and right outputs
    *leftOutput = leftInput * _envGain * parameters.volume * _midiVelocityGain * parameters.panL;
    *rightOutput = rightInput * _envGain * parameters.volume * _midiVelocityGain * parameters.panR;
}

@end
