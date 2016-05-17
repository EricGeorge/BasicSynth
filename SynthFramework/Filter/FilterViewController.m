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

@property (strong, nonatomic) IBOutlet UISlider *cutoffSlider;
@property (strong, nonatomic) IBOutlet UILabel *cutoffValue;
@property (strong, nonatomic) IBOutlet UISlider *resonanceSlider;
@property (strong, nonatomic) IBOutlet UILabel *resonanceValue;

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
    _cutoffSlider.value = value;
    _cutoffValue.text = [NSString stringWithFormat:@"%.3f", _cutoffSlider.value];
}

- (IBAction)cutoffChanged:(UISlider *)sender
{
    _cutoffParameter.value =  sender.value;
    _cutoffValue.text = [NSString stringWithFormat:@"%.3f", _cutoffSlider.value];
}

- (void) updateResonance:(double)value
{
    _resonanceSlider.value = value;
    _resonanceValue.text = [NSString stringWithFormat:@"%.3f", _resonanceSlider.value];
}

- (IBAction)resonanceChanged:(UISlider *)sender
{
    _resonanceParameter.value =  sender.value;
    _resonanceValue.text = [NSString stringWithFormat:@"%.3f", _resonanceSlider.value];
}

- (void) registerParameters:(AUParameterTree *)parameterTree
{
    _cutoffParameter = [parameterTree valueForKey:cutoffParamKey];
    _resonanceParameter = [parameterTree valueForKey:resonanceParamKey];
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
