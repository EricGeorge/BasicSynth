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
    double _panL;
    double _panR;
    double _rawVolume;
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

- (void) update
{
    Parameters * parameters = [Parameters sharedParameters];

    // put an exponential curve on the volume input (and normalize to 0-1)
    _rawVolume = pow2(parameters.volumeParam/100.0);
    
    // use equal power crossfades to get the left and right channels from the bipolar pan value
    _panL = getEqualPowerLeft(parameters.panParam);
    _panR = getEqualPowerRight(parameters.panParam);
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
    // form left and right outputs
    *leftOutput = leftInput * _envGain * _rawVolume * _midiVelocityGain * _panL;
    *rightOutput = rightInput * _envGain * _rawVolume * _midiVelocityGain * _panR;
}

@end
