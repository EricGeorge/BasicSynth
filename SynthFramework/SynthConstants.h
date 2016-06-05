//
//  SynthConstants.h
//
//  Created by Eric on 4/30/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

typedef NS_ENUM(NSInteger, InstrumentParam)
{
    InstrumentParamVolume = 0,
    InstrumentParamWaveform,
    InstrumentParamPan,
    InstrumentParamAmpEnvAttack,
    InstrumentParamAmpEnvDecay,
    InstrumentParamAmpEnvSustain,
    InstrumentParamAmpEnvRelease,
    InstrumentParamCutoff,
    InstrumentParamResonance,
    InstrumentParamFilterEnvAttack,
    InstrumentParamFilterEnvDecay,
    InstrumentParamFilterEnvSustain,
    InstrumentParamFilterEnvRelease
};

static NSString *volumeParamKey = @"volume";
static NSString *waveformParamKey = @"waveform";
static NSString *panParamKey = @"pan";
static NSString *ampEnvAttackParamKey = @"ampEnvAttack";
static NSString *ampEnvDecayParamKey = @"ampEnvDecay";
static NSString *ampEnvSustainParamKey = @"ampEnvSustain";
static NSString *ampEnvReleaseParamKey = @"ampEnvRelease";
static NSString *cutoffParamKey = @"cutoff";
static NSString *resonanceParamKey = @"resonance";
static NSString *filterEnvAttackParamKey = @"filterEnvAttack";
static NSString *filterEnvDecayParamKey = @"filterEnvDecay";
static NSString *filterEnvSustainParamKey = @"filterEnvSustain";
static NSString *filterEnvReleaseParamKey = @"filterEnvRelease";

// waveform
static const uint8_t waveformParamMin = 0;
static const uint8_t waveformParamMax = 4;
static const uint8_t waveformParamDefault = 1;

// volume
static const uint8_t volumeParamMin = 0;
static const uint8_t volumeParamMax = 100;
static const uint8_t volumeParamDefault = 70;

// pan
static const uint8_t panParamMin = -1;
static const uint8_t panParamMax = 1;
static const uint8_t panParamDefault = 0;
