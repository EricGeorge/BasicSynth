//
//  SynthAUViewController.h
//
//  Created by Eric on 4/23/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <CoreAudioKit/AUViewController.h>

@class SynthAU;

@interface SynthAUViewController : AUViewController

@property (nonatomic)SynthAU *audioUnit;

- (void) attackChanged:(double)value;
- (void) decayChanged:(double)value;
- (void) sustainChanged:(double)value;
- (void) releaseChanged:(double)value;

@end
