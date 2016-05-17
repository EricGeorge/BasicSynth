//
//  EnvelopeGeneratorViewController.h
//
//  Created by Eric on 5/6/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SynthAUViewController.h"

@interface EnvelopeGeneratorViewController : UIViewController

@property (nonatomic, strong) AUParameter *attackParameter;
@property (nonatomic, strong) AUParameter *decayParameter;
@property (nonatomic, strong) AUParameter *sustainParameter;
@property (nonatomic, strong) AUParameter *releaseParameter;

- (void) updateParameter:(AUParameterAddress)address andValue:(AUValue)value;
- (void) updateAllParameters;

@end
