//
//  DCA.h
//  BasicSynth
//
//  Created by Eric on 5/2/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCA : NSObject

@property(nonatomic, assign) double volume_dB;
@property(nonatomic, assign) uint8_t midiVelocity;
@property(nonatomic, assign) double pan;

- (void) compute:(double)leftInput
      rightInput:(double)rightInput
      leftOutput:(double *)leftOutput
     rightOutput:(double *)rightOutput;

@end
