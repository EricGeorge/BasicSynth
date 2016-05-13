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
    InstrumentParamAttack,
    InstrumentParamDecay,
    InstrumentParamSustain,
    InstrumentParamRelease,
    InstrumentParamCutoff,
    InstrumentParamResonance
};

static NSString *volumeParamKey = @"volume";
static NSString *waveformParamKey = @"waveform";
static NSString *panParamKey = @"pan";
static NSString *attackParamKey = @"attack";
static NSString *decayParamKey = @"decay";
static NSString *sustainParamKey = @"sustain";
static NSString *releaseParamKey = @"release";
static NSString *cutoffParamKey = @"cutoff";
static NSString *resonanceParamKey = @"resonance";