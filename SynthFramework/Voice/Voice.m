//
//  Voice.m
//
//  Created by Eric on 5/17/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "Voice.h"

#import "DCA.h"
#import "EnvelopeGenerator.h"
#import "Filter.h"
#import "Oscillator.h"

#import "SynthConstants.h"
#import "Utility.hpp"

@interface Voice()
{
    Oscillator *osc;
    DCA *dca;
    EnvelopeGenerator *ampEnv;
    EnvelopeGenerator *filterEnv;
    Filter *filter;    
}


@end

@implementation Voice

- (instancetype) init
{
    if (self = [super init])
    {
        // osc
        osc = [[Oscillator alloc] init];
        
        // dca
        dca = [[DCA alloc] init];
        
        // amp env
        ampEnv = [[EnvelopeGenerator alloc] init];
        
        // filter
        filter = [[Filter alloc] init];
        
        // filter env
        filterEnv = [[EnvelopeGenerator alloc] init];
    }
    
    return self;
}

- (void) setSampleRate:(double)sampleRate
{
    _sampleRate = sampleRate;
    
    ampEnv.sampleRate = self.sampleRate;
    filter.sampleRate = self.sampleRate;
    filterEnv.sampleRate = self.sampleRate;
}

- (void) setParameter:(AUParameterAddress)address withValue:(AUValue)value
{
    switch (address)
    {
            // oscillator
        case InstrumentParamWaveform:
            osc.wave = (OscillatorWave)value;
            break;
            
            // dca
        case InstrumentParamVolume:
            dca.volume = value;
            break;
        case InstrumentParamPan:
            dca.pan = value;
            break;
            
            // amp env
        case InstrumentParamAmpEnvAttack:
            ampEnv.attackTime = value;
            break;
        case InstrumentParamAmpEnvDecay:
            ampEnv.decayTime = value;
            break;
        case InstrumentParamAmpEnvSustain:
            ampEnv.sustainLevel= value;
            break;
        case InstrumentParamAmpEnvRelease:
            ampEnv.releaseTime = value;
            break;
            
            // filter
        case InstrumentParamCutoff:
            filter.cutoff = value;
            break;
        case InstrumentParamResonance:
            filter.resonance = value;
            break;
            
            // filter env
        case InstrumentParamFilterEnvAttack:
            filterEnv.attackTime = value;
            break;
        case InstrumentParamFilterEnvDecay:
            filterEnv.decayTime = value;
            break;
        case InstrumentParamFilterEnvSustain:
            filterEnv.sustainLevel= value;
            break;
        case InstrumentParamFilterEnvRelease:
            filterEnv.releaseTime = value;
            break;
            
    }
}

- (AUValue) getParameter:(AUParameterAddress)address
{
    AUValue value = 0.0f;
    
    switch (address)
    {
            // oscillator
        case InstrumentParamWaveform:
            value = osc.wave;
            break;
            
            // dca
        case InstrumentParamVolume:
            value = dca.volume;
            break;
        case InstrumentParamPan:
            value = dca.pan;
            break;
            
            // amp env
        case InstrumentParamAmpEnvAttack:
            value = ampEnv.attackTime;
            break;
        case InstrumentParamAmpEnvDecay:
            value = ampEnv.decayTime;
            break;
        case InstrumentParamAmpEnvSustain:
            value = ampEnv.sustainLevel;
            break;
        case InstrumentParamAmpEnvRelease:
            value = ampEnv.releaseTime;
            break;
            
            // filter
        case InstrumentParamCutoff:
            value = filter.cutoff;
            break;
        case InstrumentParamResonance:
            value = filter.resonance;
            break;
            
            // amp env
        case InstrumentParamFilterEnvAttack:
            value = filterEnv.attackTime;
            break;
        case InstrumentParamFilterEnvDecay:
            value = filterEnv.decayTime;
            break;
        case InstrumentParamFilterEnvSustain:
            value = filterEnv.sustainLevel;
            break;
        case InstrumentParamFilterEnvRelease:
            value = filterEnv.releaseTime;
            break;
    }
    
    return value;
}

- (void) start:(uint8_t)note withVelocity:(uint8_t)velocity
{
    osc.frequency = noteToHz(note);
    dca.midiVelocity = velocity;
    [ampEnv start];
    [filterEnv start];
}

- (void) stop
{
    [ampEnv stop];
    [filterEnv stop];
}

- (void) nextSample:(double *)outL andRight:(double *)outR
{
    // amp env
    [dca setEnvGain: [ampEnv nextSample]];
    
    // filter env
    [filter setEnvGain: [filterEnv nextSample]];

    // oscillator + filter
    double oscSample = [filter process:[osc nextSample]];
    
    // dca
    [dca process:oscSample rightInput:oscSample leftOutput:outL rightOutput:outR];
}

@end
