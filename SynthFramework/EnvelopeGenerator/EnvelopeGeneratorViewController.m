//
//  EnvelopeGeneratorViewController.m
//
//  Created by Eric on 5/6/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "EnvelopeGeneratorViewController.h"

#import "SynthAUViewController.h"

@interface EnvelopeGeneratorViewController ()
@property (strong, nonatomic) IBOutlet UISlider *attackSlider;
@property (strong, nonatomic) IBOutlet UILabel *attackValue;
@property (strong, nonatomic) IBOutlet UISlider *decaySlider;
@property (strong, nonatomic) IBOutlet UILabel *decayValue;
@property (strong, nonatomic) IBOutlet UISlider *sustainSlider;
@property (strong, nonatomic) IBOutlet UILabel *sustainValue;
@property (strong, nonatomic) IBOutlet UISlider *releaseSlider;
@property (strong, nonatomic) IBOutlet UILabel *releaseValue;

@end

@implementation EnvelopeGeneratorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _attackValue.text = [NSString stringWithFormat:@"%d", (uint16_t)_attackSlider.value];
    _decayValue.text = [NSString stringWithFormat:@"%d", (uint16_t)_decaySlider.value];
    _sustainValue.text = [NSString stringWithFormat:@"%d%%", (uint16_t)_sustainSlider.value];
    _releaseValue.text = [NSString stringWithFormat:@"%d", (uint16_t)_releaseSlider.value];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)attackSliderChanged:(UISlider *)sender
{
    uint16_t valueInRange = (long)(powf(10, _attackSlider.value) + 0.5);
    _attackValue.text = [NSString stringWithFormat:@"%d", valueInRange];
    [self.parentVC attackChanged:valueInRange];
}

- (void) updateAttack:(double)value
{
    _attackSlider.value = log10(value);
    _attackValue.text = [NSString stringWithFormat:@"%d", (uint16_t)value];
}

- (IBAction)decaySliderChanged:(UISlider *)sender
{
    uint16_t valueInRange = (long)(powf(10, _decaySlider.value) + 0.5);
    _decayValue.text = [NSString stringWithFormat:@"%d", valueInRange];
    [self.parentVC decayChanged:valueInRange];
}

- (void) updateDecay:(double)value
{
    _decaySlider.value = log10(value);
    _decayValue.text = [NSString stringWithFormat:@"%d", (uint16_t)value];
}

- (IBAction)sustainSliderChanged:(UISlider *)sender
{
    _sustainValue.text = [NSString stringWithFormat:@"%d%%", (uint16_t)_sustainSlider.value];
    [self.parentVC sustainChanged:_sustainSlider.value];
}

- (void) updateSustain:(double)value
{
    _sustainSlider.value = value;
    _sustainValue.text = [NSString stringWithFormat:@"%d%%", (uint16_t)_sustainSlider.value];
}

- (IBAction)releaseSliderChanged:(UISlider *)sender
{
    uint16_t valueInRange = (long)(powf(10, _releaseSlider.value) + 0.5);
    _releaseValue.text = [NSString stringWithFormat:@"%d", valueInRange];
    [self.parentVC releaseChanged:valueInRange];
}

- (void) updateRelease:(double)value
{
    _releaseSlider.value = log10(value);
    _releaseValue.text = [NSString stringWithFormat:@"%d", (uint16_t)value];
}

@end
