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
    Oscillator *_osc;
    DCA *_dca;
    EnvelopeGenerator *_ampEnv;
    EnvelopeGenerator *_filterEnv;
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
        _ampEnv = [[EnvelopeGenerator alloc] init];
        
        // filter
        _filter = [[Filter alloc] init];
        
        // filter env
        _filterEnv = [[EnvelopeGenerator alloc] init];
    }
    
    return self;
}

- (void) setSampleRate:(double)sampleRate
{
    _sampleRate = sampleRate;
    
    _ampEnv.sampleRate = self.sampleRate;
    _filter.sampleRate = self.sampleRate;
    _filterEnv.sampleRate = self.sampleRate;
}

- (void) setParameter:(AUParameterAddress)address withValue:(AUValue)value
{
    switch (address)
    {
            // oscillator
        case InstrumentParamWaveform:
            _osc.wave = (OscillatorWave)value;
            break;
            
            // dca
        case InstrumentParamVolume:
            _dca.volume = value;
            break;
        case InstrumentParamPan:
            _dca.pan = value;
            break;
            
            // amp env
        case InstrumentParamAmpEnvAttack:
            _ampEnv.attackTime = value;
            break;
        case InstrumentParamAmpEnvDecay:
            _ampEnv.decayTime = value;
            break;
        case InstrumentParamAmpEnvSustain:
            _ampEnv.sustainLevel= value;
            break;
        case InstrumentParamAmpEnvRelease:
            _ampEnv.releaseTime = value;
            break;
            
            // filter
        case InstrumentParamCutoff:
            _filter.cutoff = value;
            break;
        case InstrumentParamResonance:
            _filter.resonance = value;
            break;
            
            // filter env
        case InstrumentParamFilterEnvAttack:
            _filterEnv.attackTime = value;
            break;
        case InstrumentParamFilterEnvDecay:
            _filterEnv.decayTime = value;
            break;
        case InstrumentParamFilterEnvSustain:
            _filterEnv.sustainLevel= value;
            break;
        case InstrumentParamFilterEnvRelease:
            _filterEnv.releaseTime = value;
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
            value = _osc.wave;
            break;
            
            // dca
        case InstrumentParamVolume:
            value = _dca.volume;
            break;
        case InstrumentParamPan:
            value = _dca.pan;
            break;
            
            // amp env
        case InstrumentParamAmpEnvAttack:
            value = _ampEnv.attackTime;
            break;
        case InstrumentParamAmpEnvDecay:
            value = _ampEnv.decayTime;
            break;
        case InstrumentParamAmpEnvSustain:
            value = _ampEnv.sustainLevel;
            break;
        case InstrumentParamAmpEnvRelease:
            value = _ampEnv.releaseTime;
            break;
            
            // filter
        case InstrumentParamCutoff:
            value = _filter.cutoff;
            break;
        case InstrumentParamResonance:
            value = _filter.resonance;
            break;
            
            // amp env
        case InstrumentParamFilterEnvAttack:
            value = _filterEnv.attackTime;
            break;
        case InstrumentParamFilterEnvDecay:
            value = _filterEnv.decayTime;
            break;
        case InstrumentParamFilterEnvSustain:
            value = _filterEnv.sustainLevel;
            break;
        case InstrumentParamFilterEnvRelease:
            value = _filterEnv.releaseTime;
            break;
    }
    
    return value;
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
    // amp env
    [_dca setEnvGain: [_ampEnv nextSample]];
    
    // filter env
    [_filter setEnvGain: [_filterEnv nextSample]];

    // oscillator + filter
    double oscSample = [_filter process:[_osc nextSample]];
    
    // dca
    [_dca process:oscSample rightInput:oscSample leftOutput:outL rightOutput:outR];
}

@end
