//
//  Parameters.h
//
//  Created by Eric on 6/4/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

typedef void (^updateDca)(void);
typedef void (^updateOscillator)(void);

@interface Parameters : NSObject

// oscillator
@property (nonatomic, assign) uint8_t waveformParam;

// dca
@property (nonatomic, assign) double volumeParam;
@property (nonatomic, assign) double panParam;


+ (instancetype)sharedParameters;

- (void) setParameter:(AUParameterAddress) address withValue:(AUValue) value;
- (AUValue) getParameter:(AUParameterAddress) address;

- (void) registerForDcaUpdates:(updateDca)dcaBlock;
- (void) registerForOscillatorUpdtaes:(updateOscillator)oscillatorBlock;

@end
