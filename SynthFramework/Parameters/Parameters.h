//
//  Parameters.h
//
//  Created by Eric on 6/4/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

typedef void (^updateDca)(void);
typedef void (^updateOscillator)(void);
typedef void (^updateAmpEnv)(void);
typedef void (^updateFilter)(void);
typedef void (^updateFilterEnv)(void);

@interface Parameters : NSObject

// oscillator
@property (nonatomic, assign) uint8_t waveformParam;

// dca
@property (nonatomic, assign) double volumeParam;
@property (nonatomic, assign) double panParam;

// ampEnv
@property (nonatomic, assign) double ampEnvAttackParam;
@property (nonatomic, assign) double ampEnvDecayParam;
@property (nonatomic, assign) double ampEnvSustainParam;
@property (nonatomic, assign) double ampEnvReleaseParam;

// filter
@property (nonatomic, assign) double cutoffParam;
@property (nonatomic, assign) double resonanceParam;

// filterEnv
@property (nonatomic, assign) double filterEnvAttackParam;
@property (nonatomic, assign) double filterEnvDecayParam;
@property (nonatomic, assign) double filterEnvSustainParam;
@property (nonatomic, assign) double filterEnvReleaseParam;


+ (instancetype)sharedParameters;

- (void) setParameter:(AUParameterAddress) address withValue:(AUValue) value;
- (AUValue) getParameter:(AUParameterAddress) address;

- (void) registerForDcaUpdates:(updateDca)dcaBlock;
- (void) registerForOscillatorUpdates:(updateOscillator)oscillatorBlock;
- (void) registerForAmpEnvUpdates:(updateAmpEnv)ampEnvBlock;
- (void) registerForFilterUpdates:(updateFilter)filterBlock;
- (void) registerForFilterEnvUpdates:(updateFilterEnv)filterEnvBlock;

@end
