//
//  DCAViewController.m
//
//  Created by Eric on 5/9/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "DCAViewController.h"

#import "SynthConstants.h"

@interface DCAViewController ()
{
    AUParameter *_volumeParameter;
    AUParameter *_panParameter;
}

@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;
@property (strong, nonatomic) IBOutlet UILabel *volumeValue;
@property (strong, nonatomic) IBOutlet UISlider *panSlider;
@property (strong, nonatomic) IBOutlet UILabel *panValue;

@end

@implementation DCAViewController

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

- (void) updateVolume:(double)value
{
    _volumeSlider.value = _volumeParameter.value;
    _volumeValue.text = [NSString stringWithFormat:@"%d%%", (uint8_t)_volumeSlider.value];    
}

- (IBAction)volumeChanged:(UISlider *)sender
{
    _volumeParameter.value =  sender.value;
    _volumeValue.text = [NSString stringWithFormat:@"%d%%", (uint8_t)_volumeSlider.value];
}

- (void) updatePan:(double)value
{
    _panSlider.value = _panParameter.value;
    _panValue.text = [NSString stringWithFormat:@"%.2f", _panSlider.value];    
}

- (IBAction)panChanged:(UISlider *)sender
{
    _panParameter.value = sender.value;
    _panValue.text = [NSString stringWithFormat:@"%.2f", _panSlider.value];    
}

- (void) registerParameters:(AUParameterTree *)parameterTree
{
    _volumeParameter = [parameterTree valueForKey:volumeParamKey];
    _panParameter = [parameterTree valueForKey:panParamKey];
}

- (void) updateParameter:(AUParameterAddress)address andValue:(AUValue)value
{
    if (address == _volumeParameter.address)
    {
        [self updateVolume:value];
    }
    else if (address == _panParameter.address)
    {
        [self updatePan:value];
    }
}

- (void) updateAllParameters
{
    [self updateVolume:_volumeParameter.value];
    [self updatePan:_panParameter.value];
}

@end
