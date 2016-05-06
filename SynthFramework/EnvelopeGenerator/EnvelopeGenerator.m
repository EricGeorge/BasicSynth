//
//  EnvelopeGenerator.m
//  BasicSynth
//
//  Created by Eric on 5/3/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "EnvelopeGenerator.h"

typedef NS_ENUM(NSUInteger, EnvelopeStage)
{
    ENVELOPE_STAGE_IDLE = 0,
    ENVELOPE_STAGE_ATTACK,
    ENVELOPE_STAGE_DECAY,
    ENVELOPE_STAGE_SUSTAIN,
    ENVELOPE_STAGE_RELEASE,
};

@interface EnvelopeGenerator()
{
    double _attackCoeff;
    double _attackOffset;
    double _attackTCO;
    
    double _decayCoeff;
    double _decayOffset;
    double _decayTCO;
    
    double _releaseCoeff;
    double _releaseOffset;
    double _releaseTCO;
    
    EnvelopeStage _currentStage;
    
    double _envelopeOutput;
}

@end

@implementation EnvelopeGenerator

- (instancetype)init
{
    if (self = [super init])
    {
        // analog time constants
        _attackTCO = exp(-0.5);  // fast attack
        _decayTCO = exp(-5.0);
        _releaseTCO = _decayTCO;
        
        // digital time constants
//        _attackTCO = pow(10.0, -96.0/20.0);
//        _decayTCO = _attackTCO;
//        _releaseTCO = _decayTCO;
    
        self.attackTime = 0.1;
        self.decayTime = 0.5;
        self.releaseTime = 1.0;
        self.sustainLevel = 0.7;
    }
    
    return self;
}

- (void) setSampleRate:(double)sampleRate
{
    _sampleRate = sampleRate;
    
    [self calculateAttackTime];
    [self calculateDecayTime];
    [self calculateReleaseTime];
}

- (void) setAttackTime:(double)attackTime
{
    _attackTime = attackTime;
    
    [self calculateAttackTime];
}

- (void) setDecayTime:(double)decayTime
{
    _decayTime = decayTime;
    
    [self calculateDecayTime];
}

- (void) setReleaseTime:(double)releaseTime
{
    _releaseTime = releaseTime;
    
    [self calculateReleaseTime];
}

- (void) setSustainLevel:(double)sustainLevel
{
    _sustainLevel = sustainLevel;
}

- (void) calculateAttackTime
{
    double stageSampleCount = _attackTime * _sampleRate;
    
    _attackCoeff = exp(-log((1.0 + _attackTCO)/_attackTCO)/stageSampleCount);
    _attackOffset = (1.0 + _attackTCO) * (1.0 - _attackCoeff);
}

- (void) calculateDecayTime
{
    double stageSampleCount = _decayTime * _sampleRate;
    
    _decayCoeff = exp(-log((1.0 + _decayTCO)/_decayTCO)/stageSampleCount);
    _decayOffset = (_sustainLevel - _decayTCO) * (1.0 - _decayCoeff);
}

- (void) calculateReleaseTime
{
    double stageSampleCount = _releaseTime * _sampleRate;
    
    _releaseCoeff = exp(-log((1.0 + _releaseTCO)/_releaseTCO)/stageSampleCount);
    _releaseOffset = -_releaseTCO * (1.0 - _releaseCoeff);
}

- (void) start
{
    _currentStage = ENVELOPE_STAGE_ATTACK;
}

- (void) stop
{
    _currentStage = ENVELOPE_STAGE_RELEASE;
}

- (double) nextSample
{
    switch(_currentStage)
    {
        case ENVELOPE_STAGE_IDLE:
            _envelopeOutput = 0.0;
            break;
            
        case ENVELOPE_STAGE_ATTACK:
            _envelopeOutput = _attackOffset + _envelopeOutput * _attackCoeff;
            
            if(_envelopeOutput >= 1.0 || _attackTime <= 0.0)
            {
                _envelopeOutput = 1.0;
                _currentStage = ENVELOPE_STAGE_DECAY;
            }
            
            break;
            
        case ENVELOPE_STAGE_DECAY:
            _envelopeOutput = _decayOffset + _envelopeOutput * _decayCoeff;
            
            if(_envelopeOutput <= _sustainLevel || _decayTime <= 0.0)
            {
                _envelopeOutput = _sustainLevel;
                _currentStage = ENVELOPE_STAGE_SUSTAIN;
            }
            
            break;

        case ENVELOPE_STAGE_SUSTAIN:
            _envelopeOutput = _sustainLevel;
            
            break;

        case ENVELOPE_STAGE_RELEASE:
            _envelopeOutput = _releaseOffset + _envelopeOutput * _releaseCoeff;
            
            if(_envelopeOutput <= 0.0 || _releaseTime <= 0.0)
            {
                _envelopeOutput = 0.0;
                _currentStage = ENVELOPE_STAGE_IDLE;
            }
            break;
        }
    
    return _envelopeOutput;
}

    @end
