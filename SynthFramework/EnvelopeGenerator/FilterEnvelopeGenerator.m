//
//  FilterEnvelopeGenerator.m
//
//  Created by Eric on 6/5/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "FilterEnvelopeGenerator.h"

#import "Parameters.h"

@implementation FilterEnvelopeGenerator

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
    
    self.normalizedAttackTime = parameters.filterEnvAttackParam/1000.0;
    self.normalizedDecayTime = parameters.filterEnvDecayParam/1000.0;
    self.normalizedSustainLevel = parameters.filterEnvSustainParam/100.0;
    self.normalizedReleaseTime = parameters.filterEnvReleaseParam/1000.0;
    
    [super calculate];
}

@end
