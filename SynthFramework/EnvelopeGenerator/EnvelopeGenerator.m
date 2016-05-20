//
//  EnvelopeGenerator.m
//
//  Created by Eric on 5/3/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "EnvelopeGenerator.h"

typedef NS_ENUM(NSUInteger, EnvelopeStage)
{
    EnvelopeStageIdle = 0,
    EnvelopeStageAttack,
    EnvelopeStageDecay,
    EnvelopeStageSustain,
    EnvelopeStageRelease,
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
    
    double _normalizedAttackTime;
    double _normalizedDecayTime;
    double _normalizedSustainLevel;
    double _normalizedReleaseTime;
    
    EnvelopeStage _currentStage;
    
    double _envelopeOutput;
}

@end

@implementation EnvelopeGenerator

- (instancetype)init
{
    if (self = [super init])
    {
        _currentStage = EnvelopeStageIdle;
        
        // analog time constants
        _attackTCO = exp(-0.5);  // fast attack
        _decayTCO = exp(-5.0);
        _releaseTCO = _decayTCO;
        
        // digital time constants
//        _attackTCO = pow(10.0, -96.0/20.0);
//        _decayTCO = _attackTCO;
//        _releaseTCO = _decayTCO;
    
        self.attackTime = 100;  // msec
        self.decayTime = 500;   // msec
        self.releaseTime = 1000;// msec
        self.sustainLevel = 70; // percent
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
    _normalizedAttackTime = _attackTime/1000.0;
    
    [self calculateAttackTime];
}

- (void) setDecayTime:(double)decayTime
{
    _decayTime = decayTime;
    _normalizedDecayTime = _decayTime/1000.0;
    
    [self calculateDecayTime];
}

- (void) setReleaseTime:(double)releaseTime
{
    _releaseTime = releaseTime;
    _normalizedReleaseTime = _releaseTime/1000.0;
    
    [self calculateReleaseTime];
}

- (void) setSustainLevel:(double)sustainLevel
{
    _sustainLevel = sustainLevel;
    _normalizedSustainLevel = _sustainLevel/100.0;
    
    [self calculateDecayTime];
}

- (void) calculateAttackTime
{
    double stageSampleCount = _normalizedAttackTime * _sampleRate;
    
    _attackCoeff = exp(-log((1.0 + _attackTCO)/_attackTCO)/stageSampleCount);
    _attackOffset = (1.0 + _attackTCO) * (1.0 - _attackCoeff);
}

- (void) calculateDecayTime
{
    double stageSampleCount = _normalizedDecayTime * _sampleRate;
    
    _decayCoeff = exp(-log((1.0 + _decayTCO)/_decayTCO)/stageSampleCount);
    _decayOffset = (_normalizedSustainLevel - _decayTCO) * (1.0 - _decayCoeff);
}

- (void) calculateReleaseTime
{
    double stageSampleCount = _normalizedReleaseTime * _sampleRate;
    
    _releaseCoeff = exp(-log((1.0 + _releaseTCO)/_releaseTCO)/stageSampleCount);
    _releaseOffset = -_releaseTCO * (1.0 - _releaseCoeff);
}

- (BOOL) isIdle
{
    return _currentStage == EnvelopeStageIdle;
}

- (void) start
{
    _currentStage = EnvelopeStageAttack;
}

- (void) stop
{
    _currentStage = EnvelopeStageRelease;
}

- (double) nextSample
{
    switch(_currentStage)
    {
        case EnvelopeStageIdle:
            _envelopeOutput = 0.0;
            break;
            
        case EnvelopeStageAttack:
            _envelopeOutput = _attackOffset + _envelopeOutput * _attackCoeff;
            
            if(_envelopeOutput >= 1.0 || _normalizedAttackTime <= 0.0)
            {
                _envelopeOutput = 1.0;
                _currentStage = EnvelopeStageDecay;
            }
            
            break;
            
        case EnvelopeStageDecay:
            _envelopeOutput = _decayOffset + _envelopeOutput * _decayCoeff;
            
            if(_envelopeOutput <= _normalizedSustainLevel || _normalizedDecayTime <= 0.0)
            {
                _envelopeOutput = _normalizedSustainLevel;
                _currentStage = EnvelopeStageSustain;
            }
            
            break;

        case EnvelopeStageSustain:
            _envelopeOutput = _normalizedSustainLevel;
            
            break;

        case EnvelopeStageRelease:
            _envelopeOutput = _releaseOffset + _envelopeOutput * _releaseCoeff;
            
            if(_envelopeOutput <= 0.0 || _normalizedReleaseTime <= 0.0)
            {
                _envelopeOutput = 0.0;
                _currentStage = EnvelopeStageIdle;
            }
            break;
        }
    
    return _envelopeOutput;
}

@end
