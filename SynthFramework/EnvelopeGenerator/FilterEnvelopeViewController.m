//
//  FilterEnvelopeViewController.m
//  BasicSynth
//
//  Created by Eric on 5/17/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "FilterEnvelopeViewController.h"

#import "SynthConstants.h"

@interface FilterEnvelopeViewController ()

@end

@implementation FilterEnvelopeViewController

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
    self.attackParameter = [parameterTree valueForKey:filterEnvAttackParamKey];
    self.decayParameter = [parameterTree valueForKey:filterEnvDecayParamKey];
    self.sustainParameter = [parameterTree valueForKey:filterEnvSustainParamKey];
    self.releaseParameter = [parameterTree valueForKey:filterEnvReleaseParamKey];
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
