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

// global
static const uint16_t sampleRateDefault = 44100;

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

// ampEnvAttack
static const uint16_t ampEnvAttackParamMin = 0;
static const uint16_t ampEnvAttackParamMax = 10000;
static const uint16_t ampEnvAttackParamDefault = 100;

// ampEnvDecay
static const uint16_t ampEnvDecayParamMin = 0;
static const uint16_t ampEnvDecayParamMax = 10000;
static const uint16_t ampEnvDecayParamDefault = 100;

// ampEnvSustain
static const uint16_t ampEnvSustainParamMin = 0;
static const uint16_t ampEnvSustainParamMax = 100;
static const uint16_t ampEnvSustainParamDefault = 70;

// ampEnvRelease
static const uint16_t ampEnvReleaseParamMin = 0;
static const uint16_t ampEnvReleaseParamMax = 10000;
static const uint16_t ampEnvReleaseParamDefault = 1000;

// cutoff
static const double cutoffParamMin = 0;
static const double cutoffParamMax = 0.99;
static const double cutoffParamDefault = 0.99;

// resonance
static const double resonanceParamMin = -1;
static const double resonanceParamMax = 1;
static const double resonanceParamDefault = 0;

// filterEnvAttack
static const uint16_t filterEnvAttackParamMin = 0;
static const uint16_t filterEnvAttackParamMax = 10000;
static const uint16_t filterEnvAttackParamDefault = 100;

// filterEnvDecay
static const uint16_t filterEnvDecayParamMin = 0;
static const uint16_t filterEnvDecayParamMax = 10000;
static const uint16_t filterEnvDecayParamDefault = 100;

// filterEnvSustain
static const uint16_t filterEnvSustainParamMin = 0;
static const uint16_t filterEnvSustainParamMax = 100;
static const uint16_t filterEnvSustainParamDefault = 70;

// filterEnvRelease
static const uint16_t filterEnvReleaseParamMin = 0;
static const uint16_t filterEnvReleaseParamMax = 10000;
static const uint16_t filterEnvReleaseParamDefault = 1000;




