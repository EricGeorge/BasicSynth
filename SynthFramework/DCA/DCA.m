//
//  DCA.m
//  BasicSynth
//
//  Created by Eric on 5/2/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "DCA.h"

@implementation DCA

- (instancetype)init
{
    if (self = [super init])
    {
        self.volume = 0.0;
        self.midiVelocity = 0;
    }
    
    return self;
}

- (void) compute:(double)leftInput
      rightInput:(double)rightInput
      leftOutput:(double *)leftOutput
     rightOutput:(double *)rightOutput
{
    // form left and right outputs
    *leftOutput = leftInput * self.volume * self.midiVelocity / 127.0;
    *rightOutput = rightInput * self.volume * self.midiVelocity / 127.0;
}

@end
