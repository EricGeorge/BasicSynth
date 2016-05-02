//
//  SynthAUViewController_AUAudioUnitFactory.m
//
//  Created by Eric on 4/23/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "SynthAUViewController+AUAudioUnitFactory.h"

@implementation SynthAUViewController (AUAudioUnitFactory)

- (SynthAU *) createAudioUnitWithComponentDescription:(AudioComponentDescription) desc error:(NSError **)error
{
    self.audioUnit = [[SynthAU alloc] initWithComponentDescription:desc error:error];
    return self.audioUnit;
}

@end
