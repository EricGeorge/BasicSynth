//
//  AmpEnvelopeViewController.m
//
//  Created by Eric on 5/17/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "AmpEnvelopeViewController.h"

#import "SynthConstants.h"

@interface AmpEnvelopeViewController ()

@end

@implementation AmpEnvelopeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) registerParameters:(AUParameterTree *)parameterTree
{
    self.attackParameter = [parameterTree valueForKey:ampEnvAttackParamKey];
    self.decayParameter = [parameterTree valueForKey:ampEnvDecayParamKey];
    self.sustainParameter = [parameterTree valueForKey:ampEnvSustainParamKey];
    self.releaseParameter = [parameterTree valueForKey:ampEnvReleaseParamKey];
}

- (void) updateParameter:(AUParameterAddress)address andValue:(AUValue)value
{
    [super updateParameter:address andValue:value];
}

- (void) updateAllParameters
{
    [super updateAllParameters];
}

@end
