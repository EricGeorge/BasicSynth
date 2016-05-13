//
//  FilterViewController.m
//  BasicSynth
//
//  Created by Eric on 5/10/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "FilterViewController.h"

#import "SynthConstants.h"

@interface FilterViewController ()
{
    AUParameter *_cutoffParameter;
    AUParameter *_resonanceParameter;
}

@end

@implementation FilterViewController

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

- (void) updateCutoff:(double)value
{
    
}


- (void) updateResonance:(double)value
{
    
}


- (void) registerParameters:(AUParameterTree *)parameterTree
{
    _cutoffParameter = [parameterTree valueForKey:volumeParamKey];
    _resonanceParameter = [parameterTree valueForKey:panParamKey];
}

- (void) updateParameter:(AUParameterAddress)address andValue:(AUValue)value
{
    if (address == _cutoffParameter.address)
    {
        [self updateCutoff:value];
    }
    else if (address == _resonanceParameter.address)
    {
        [self updateResonance:value];
    }
}

- (void) updateAllParameters
{
    [self updateCutoff:_cutoffParameter.value];
    [self updateResonance:_resonanceParameter.value];
}


@end
