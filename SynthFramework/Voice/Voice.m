//
//  Voice.m
//
//  Created by Eric on 5/17/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "Voice.h"

#import "DCA.h"
#import "AmpEnvelopeGenerator.h"
#import "Filter.h"
#import "FilterEnvelopeGenerator.h"
#import "Oscillator.h"

#import "SynthConstants.h"
#import "Utility.hpp"

@interface Voice()
{
    Oscillator *_osc;
    DCA *_dca;
    AmpEnvelopeGenerator *_ampEnv;
    FilterEnvelopeGenerator *_filterEnv;
    Filter *_filter;
}


@end

@implementation Voice

- (instancetype) init
{
    if (self = [super init])
    {
        self.note = 0;
        self.sampleRate = 0;
        
        // osc
        _osc = [[Oscillator alloc] init];
        
        // dca
        _dca = [[DCA alloc] init];
        
        // amp env
        _ampEnv = [[AmpEnvelopeGenerator alloc] init];
        
        // filter
        _filter = [[Filter alloc] init];
        
        // filter env
        _filterEnv = [[FilterEnvelopeGenerator alloc] init];
    }
    
    return self;
}

- (void) updateDca
{
    [_dca update];
}

- (void) updateOscillator
{
    [_osc update];
}

- (void) updateAmpEnv
{
    [_ampEnv update];
}

- (void) updateFilter
{
    [_filter update];
}

- (void) updateFilterEnv
{
    [_filterEnv update];
}

- (void) setSampleRate:(double)sampleRate
{
    _sampleRate = sampleRate;
    
    _ampEnv.sampleRate = self.sampleRate;
    _filter.sampleRate = self.sampleRate;
    _filterEnv.sampleRate = self.sampleRate;
}


- (BOOL) isActive
{
    return ![_ampEnv isIdle];
}

- (void) start:(uint8_t)note withVelocity:(uint8_t)velocity
{
    _note = note;
    
    _osc.frequency = noteToHz(_note);
    _dca.midiVelocity = velocity;
    [_ampEnv start];
    [_filterEnv start];
}

- (void) stop
{
    [_ampEnv stop];
    [_filterEnv stop];
}

- (void) steal
{
    // do something better here than just cutting off
    [_ampEnv stop];
    
    self.note = 0;
    self.age = 0;
}

- (void) nextSample:(double *)outL andRight:(double *)outR
{
    if (self.isActive)
    {
        // amp env
        [_dca setEnvGain: [_ampEnv nextSample]];
        
        // filter env
        [_filter setEnvGain:[_filterEnv nextSample]];

        // oscillator + filter
        double oscSample = [_filter process:[_osc nextSample]];
        
        // dca
        [_dca process:oscSample rightInput:oscSample leftOutput:outL rightOutput:outR];
    }
}

@end
