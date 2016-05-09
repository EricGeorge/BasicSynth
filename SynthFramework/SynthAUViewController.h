//
//  SynthAUViewController.h
//
//  Created by Eric on 4/23/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <CoreAudioKit/AUViewController.h>

@class SynthAU;

@protocol SynthComponentDelegate

- (void) registerParameters:(AUParameterTree *)parameterTree;
- (void) updateParameter:(AUParameterAddress)address andValue:(AUValue)value;
- (void) updateAllParameters;

@end

@interface SynthAUViewController : AUViewController

@property (nonatomic)SynthAU *audioUnit;

@end
