//
//  EnvelopeGenerator.m
//  BasicSynth
//
//  Created by Eric on 5/3/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "EnvelopeGenerator.h"

@interface EnvelopeGenerator()
{
    double _currentLevel;
    double _multiplier;
    uint64_t _currentSampleIndex;
    uint64_t _nextStageSampleIndex;
}

@property (nonatomic, assign) EnvelopeStage currentStage;
@property (nonatomic, strong) NSMutableDictionary *stageValue;
@property (nonatomic, readonly) double minimumLevel;

@end

@implementation EnvelopeGenerator

- (instancetype)init
{
    if (self = [super init])
    {
        self.currentStage = ENVELOPE_STAGE_OFF;
        
        self.stageValue = [[NSMutableDictionary alloc] init];
        self.stageValue[@(ENVELOPE_STAGE_OFF)] = [NSNumber numberWithFloat:0.0];
        self.stageValue[@(ENVELOPE_STAGE_ATTACK)] = [NSNumber numberWithFloat:0.01];
        self.stageValue[@(ENVELOPE_STAGE_DECAY)] = [NSNumber numberWithFloat:0.5];
        self.stageValue[@(ENVELOPE_STAGE_SUSTAIN)] = [NSNumber numberWithFloat:0.1];
        self.stageValue[@(ENVELOPE_STAGE_RELEASE)] = [NSNumber numberWithFloat:1.0];
        
        _minimumLevel = 0.0001;
        _currentLevel = self.minimumLevel,
        _sampleRate = 44100.0;
        _multiplier = 1.0;
        _currentSampleIndex = 0;
        _nextStageSampleIndex = 0;
    }
    
    return self;
}

- (double) process
{
    if (self.currentStage != ENVELOPE_STAGE_OFF &&
        self.currentStage != ENVELOPE_STAGE_SUSTAIN)
    {
        if (_currentSampleIndex == _nextStageSampleIndex)
        {
            EnvelopeStage newStage = (EnvelopeStage)(++self.currentStage % kNumEnvelopeStages);
            [self enterStage:newStage];
        }
        _currentLevel *= _multiplier;
        _currentSampleIndex++;
    }
    
    NSLog(@"EG level is %f", _currentLevel);
    return _currentLevel;
}

- (void) calculateMultiplier:(double) startLevel
                withEndLevel:(double) endLevel
                  andLength:(uint64_t) lengthInSamples
{
    _multiplier = 1.0 + (log(endLevel) - log(startLevel)) / (lengthInSamples);
}

- (void) enterStage:(EnvelopeStage) newStage
{
    self.currentStage = newStage;
    _currentSampleIndex = 0;
    if (self.currentStage == ENVELOPE_STAGE_OFF ||
        self.currentStage == ENVELOPE_STAGE_SUSTAIN)
    {
        _nextStageSampleIndex = 0;
    }
    else
    {
        _nextStageSampleIndex = [[self.stageValue objectForKey:@(self.currentStage)] floatValue] * self.sampleRate;
    }
    switch (newStage)
    {
        case ENVELOPE_STAGE_OFF:
            _currentLevel = 0.0;
            _multiplier = 1.0;
            break;
        case ENVELOPE_STAGE_ATTACK:
            _currentLevel = _minimumLevel;
            [self calculateMultiplier:_currentLevel
                         withEndLevel:1.0
                           andLength:_nextStageSampleIndex];
            break;
        case ENVELOPE_STAGE_DECAY:
            _currentLevel = 1.0;
            [self calculateMultiplier:_currentLevel
                         withEndLevel:fmax([[self.stageValue objectForKey:@(ENVELOPE_STAGE_SUSTAIN)] floatValue], self.minimumLevel)
                            andLength:_nextStageSampleIndex];
            break;
        case ENVELOPE_STAGE_SUSTAIN:
            _currentLevel = [[self.stageValue objectForKey:@(ENVELOPE_STAGE_SUSTAIN)] floatValue];
            _multiplier = 1.0;
            break;
        case ENVELOPE_STAGE_RELEASE:
            [self calculateMultiplier:_currentLevel
                         withEndLevel:_minimumLevel
                            andLength:_nextStageSampleIndex];
            break;
        default:
            break;
    }
}

@end
