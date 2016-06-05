//
//  AmpEnvelopeGenerator.m
//  BasicSynth
//
//  Created by Eric on 6/5/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "AmpEnvelopeGenerator.h"

#import "Parameters.h"

@implementation AmpEnvelopeGenerator

- (instancetype)init
{
    if (self = [super init])
    {
    }
    
    return self;
}

- (void) update
{
    Parameters * parameters = [Parameters sharedParameters];
    
    self.normalizedAttackTime = parameters.ampEnvAttackParam/1000.0;
    self.normalizedDecayTime = parameters.ampEnvDecayParam/1000.0;
    self.normalizedSustainLevel = parameters.ampEnvSustainParam/100.0;
    self.normalizedReleaseTime = parameters.ampEnvReleaseParam/1000.0;
    
    [super calculate];
}

@end
