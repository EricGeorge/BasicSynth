//
//  EnvelopeGeneratorViewController.h
//
//  Created by Eric on 5/6/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SynthAUViewController;

@interface EnvelopeGeneratorViewController : UIViewController

- (void) updateAttack:(double)value;
- (void) updateDecay:(double)value;
- (void) updateSustain:(double)value;
- (void) updateRelease:(double)value;

@property(nonatomic, weak) SynthAUViewController *parentVC;

@end
