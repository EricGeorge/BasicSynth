//
//  Parameters.m
//
//  Created by Eric on 5/21/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "Parameters.h"

#import "DCA.h"
#import "SynthConstants.h"

static Parameters *sharedParameters;

@interface Parameters()
{
}

@property (nonatomic, copy) updateDca dcaBlock;

@end

@implementation Parameters

+ (instancetype)sharedParameters
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedParameters = [(Parameters *)[super alloc] init];
    });
    
    return sharedParameters;
}

- (id) init
{
    if (self == sharedParameters)
    {
        return sharedParameters;
    }
    
    self = [super init];
    if (self)
    {

    }
    
    return self;
}

- (void) setParameter:(AUParameterAddress) address withValue:(AUValue) value
{
    switch (address)
    {
//            // oscillator
//        case InstrumentParamWaveform:
//            _osc.wave = (OscillatorWave)value;
//            break;
//            
            // dca
        case InstrumentParamVolume:
            self.volumeParam = value;
            break;
        case InstrumentParamPan:
            self.panParam = value;
            break;
            
//            // amp env
//        case InstrumentParamAmpEnvAttack:
//            _ampEnv.attackTime = value;
//            break;
//        case InstrumentParamAmpEnvDecay:
//            _ampEnv.decayTime = value;
//            break;
//        case InstrumentParamAmpEnvSustain:
//            _ampEnv.sustainLevel= value;
//            break;
//        case InstrumentParamAmpEnvRelease:
//            _ampEnv.releaseTime = value;
//            break;
//            
//            // filter
//        case InstrumentParamCutoff:
//            _filter.cutoff = value;
//            break;
//        case InstrumentParamResonance:
//            _filter.resonance = value;
//            break;
//            
//            // filter env
//        case InstrumentParamFilterEnvAttack:
//            _filterEnv.attackTime = value;
//            break;
//        case InstrumentParamFilterEnvDecay:
//            _filterEnv.decayTime = value;
//            break;
//        case InstrumentParamFilterEnvSustain:
//            _filterEnv.sustainLevel= value;
//            break;
//        case InstrumentParamFilterEnvRelease:
//            _filterEnv.releaseTime = value;
//            break;
            
    }
}

- (AUValue) getParameter:(AUParameterAddress) address
{
    AUValue value = 0.0f;
    
    switch (address)
    {
//            // oscillator
//        case InstrumentParamWaveform:
//            value = _osc.wave;
//            break;
//            
            // dca
        case InstrumentParamVolume:
            value = self.volumeParam;
            break;
        case InstrumentParamPan:
            value = self.panParam;
            break;
            
//            // amp env
//        case InstrumentParamAmpEnvAttack:
//            value = _ampEnv.attackTime;
//            break;
//        case InstrumentParamAmpEnvDecay:
//            value = _ampEnv.decayTime;
//            break;
//        case InstrumentParamAmpEnvSustain:
//            value = _ampEnv.sustainLevel;
//            break;
//        case InstrumentParamAmpEnvRelease:
//            value = _ampEnv.releaseTime;
//            break;
//            
//            // filter
//        case InstrumentParamCutoff:
//            value = _filter.cutoff;
//            break;
//        case InstrumentParamResonance:
//            value = _filter.resonance;
//            break;
//            
//            // amp env
//        case InstrumentParamFilterEnvAttack:
//            value = _filterEnv.attackTime;
//            break;
//        case InstrumentParamFilterEnvDecay:
//            value = _filterEnv.decayTime;
//            break;
//        case InstrumentParamFilterEnvSustain:
//            value = _filterEnv.sustainLevel;
//            break;
//        case InstrumentParamFilterEnvRelease:
//            value = _filterEnv.releaseTime;
//            break;
    }
    
    return value;
}

- (void) registerForDcaUpdates:(updateDca)dcaBlock
{
    self.dcaBlock = dcaBlock;
}

- (void) setVolumeParam:(double)volumeParam
{
    _volumeParam = volumeParam;
    self.dcaBlock();
}

- (void) setPanParam:(double)panParam
{
    _panParam = panParam;
    self.dcaBlock();
}
@end
