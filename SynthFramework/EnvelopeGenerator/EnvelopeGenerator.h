//
//  EnvelopeGenerator.h
//  BasicSynth
//
//  Created by Eric on 5/3/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, EnvelopeStage)
{
        ENVELOPE_STAGE_OFF = 0,
        ENVELOPE_STAGE_ATTACK,
        ENVELOPE_STAGE_DECAY,
        ENVELOPE_STAGE_SUSTAIN,
        ENVELOPE_STAGE_RELEASE,
        kNumEnvelopeStages
};

@interface EnvelopeGenerator : NSObject

@property (nonatomic, assign) double sampleRate;

- (double) process;
- (void) enterStage:(EnvelopeStage) newStage;

@end
