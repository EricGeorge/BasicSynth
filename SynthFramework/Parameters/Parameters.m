//
//  Parameters.m
//
//  Created by Eric on 5/21/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "Parameters.h"

#import "DCA.h"
#import "EnvelopeGenerator.h"
#import "Filter.h"
#import "Oscillator.h"
#import "SynthConstants.h"

static Parameters *sharedParameters;

@interface Parameters()
{
}

@property (nonatomic, copy) updateGlobalParams globalParamsBlock;
@property (nonatomic, copy) updateDca dcaBlock;
@property (nonatomic, copy) updateOscillator oscillatorBlock;
@property (nonatomic, copy) updateAmpEnv ampEnvBlock;
@property (nonatomic, copy) updateFilter filterBlock;
@property (nonatomic, copy) updateFilterEnv filterEnvBlock;

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
        // set defaults for global parameteres
        _sampleRate = sampleRateDefault;
    }
    
    return self;
}

- (void) setParameter:(AUParameterAddress) address withValue:(AUValue) value
{
    switch (address)
    {
            // oscillator
        case InstrumentParamWaveform:
            self.waveformParam = (OscillatorWave)value;
            break;
            
            // dca
        case InstrumentParamVolume:
            self.volumeParam = value;
            break;
        case InstrumentParamPan:
            self.panParam = value;
            break;
            
            // amp env
        case InstrumentParamAmpEnvAttack:
            self.ampEnvAttackParam = value;
            break;
        case InstrumentParamAmpEnvDecay:
            self.ampEnvDecayParam = value;
            break;
        case InstrumentParamAmpEnvSustain:
            self.ampEnvSustainParam = value;
            break;
        case InstrumentParamAmpEnvRelease:
            self.ampEnvReleaseParam = value;
            break;
            
            // filter
        case InstrumentParamCutoff:
            self.cutoffParam = value;
            break;
        case InstrumentParamResonance:
            self.resonanceParam = value;
            break;
            
            // filter env
        case InstrumentParamFilterEnvAttack:
            self.filterEnvAttackParam = value;
            break;
        case InstrumentParamFilterEnvDecay:
            self.filterEnvDecayParam = value;
            break;
        case InstrumentParamFilterEnvSustain:
            self.filterEnvSustainParam = value;
            break;
        case InstrumentParamFilterEnvRelease:
            self.filterEnvReleaseParam = value;
            break;
            
    }
}

- (AUValue) getParameter:(AUParameterAddress) address
{
    AUValue value = 0.0f;
    
    switch (address)
    {
            // oscillator
        case InstrumentParamWaveform:
            value = self.waveformParam;
            break;
            
            // dca
        case InstrumentParamVolume:
            value = self.volumeParam;
            break;
        case InstrumentParamPan:
            value = self.panParam;
            break;
            
            // amp env
        case InstrumentParamAmpEnvAttack:
            value = self.ampEnvAttackParam;
            break;
        case InstrumentParamAmpEnvDecay:
            value = self.ampEnvDecayParam;
            break;
        case InstrumentParamAmpEnvSustain:
            value = self.ampEnvSustainParam;
            break;
        case InstrumentParamAmpEnvRelease:
            value = self.ampEnvReleaseParam;
            break;
            
            // filter
        case InstrumentParamCutoff:
            value = self.cutoffParam;
            break;
        case InstrumentParamResonance:
            value = self.resonanceParam;
            break;
            
            // amp env
        case InstrumentParamFilterEnvAttack:
            value = self.filterEnvAttackParam;
            break;
        case InstrumentParamFilterEnvDecay:
            value = self.filterEnvDecayParam;
            break;
        case InstrumentParamFilterEnvSustain:
            value = self.filterEnvSustainParam;
            break;
        case InstrumentParamFilterEnvRelease:
            value = self.filterEnvReleaseParam;
            break;
    }
    
    return value;
}

- (void) registerForGlobalParamUpdates:(updateGlobalParams)globalParamsBlock
{
    self.globalParamsBlock = globalParamsBlock;
}

- (void) registerForDcaUpdates:(updateDca)dcaBlock
{
    self.dcaBlock = dcaBlock;
}

- (void) registerForOscillatorUpdates:(updateOscillator)oscillatorBlock
{
    self.oscillatorBlock = oscillatorBlock;
}

- (void) registerForAmpEnvUpdates:(updateAmpEnv)ampEnvBlock
{
    self.ampEnvBlock = ampEnvBlock;
}

- (void) registerForFilterUpdates:(updateFilter)filterBlock
{
    self.filterBlock = filterBlock;
}

- (void) registerForFilterEnvUpdates:(updateFilterEnv)filterEnvBlock
{
    self.filterEnvBlock = filterEnvBlock;
}

// globalParams
- (void) setSampleRate:(uint16_t)sampleRate
{
    _sampleRate = sampleRate;
    
    // early initialization means that there could be no blocks set up yet.
    if (self.globalParamsBlock)
    {
        self.globalParamsBlock();
    }
}

// oscillator
- (void) setWaveformParam:(uint8_t)waveformParam
{
    _waveformParam = waveformParam;
    self.oscillatorBlock();
}

// dca
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

// ampEnv
- (void) setAmpEnvAttackParam:(double)ampEnvAttackParam
{
    _ampEnvAttackParam = ampEnvAttackParam;
    self.ampEnvBlock();
}

- (void) setAmpEnvDecayParam:(double)ampEnvDecayParam
{
    _ampEnvDecayParam = ampEnvDecayParam;
    self.ampEnvBlock();
}

- (void) setAmpEnvSustainParam:(double)ampEnvSustainParam
{
    _ampEnvSustainParam = ampEnvSustainParam;
    self.ampEnvBlock();
}

- (void) setAmpEnvReleaseParam:(double)ampEnvReleaseParam
{
    _ampEnvReleaseParam = ampEnvReleaseParam;
    self.ampEnvBlock();
}

// filter
- (void) setCutoffParam:(double)cutoffParam
{
    _cutoffParam = cutoffParam;
    self.filterBlock();
}

- (void) setResonanceParam:(double)resonanceParam
{
    _resonanceParam = resonanceParam;
    self.filterBlock();
}

// filterEnv
- (void) setFilterEnvAttackParam:(double)filterEnvAttackParam
{
    _filterEnvAttackParam = filterEnvAttackParam;
    self.filterEnvBlock();
}

- (void) setFilterEnvDecayParam:(double)filterEnvDecayParam
{
    _filterEnvDecayParam = filterEnvDecayParam;
    self.filterEnvBlock();
}

- (void) setFilterEnvSustainParam:(double)filterEnvSustainParam
{
    _filterEnvSustainParam = filterEnvSustainParam;
    self.filterEnvBlock();
}

- (void) setFilterEnvReleaseParam:(double)filterEnvReleaseParam
{
    _filterEnvReleaseParam = filterEnvReleaseParam;
    self.filterEnvBlock();
}


@end
