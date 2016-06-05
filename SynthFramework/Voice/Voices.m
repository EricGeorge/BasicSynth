//
//  Voices.m
//
//  Created by Eric on 5/18/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "Voices.h"

#import "Parameters.h"
#import "Voice.h"

@interface Voices()
{
}

@property (nonatomic, strong) NSArray *voices;
@property (nonatomic, readonly) uint8_t voiceCount;

@end

@implementation Voices

- (instancetype) init
{
    if (self = [super init])
    {
        self.sampleRate = 0;
        
        _voiceCount = 32;
        
        self.voices = [NSArray array];
        for (int i = 0; i < self.voiceCount; i++)
        {
            self.voices = [self.voices arrayByAddingObject:[[Voice alloc] init]];
        }
        
        Parameters *parameters = [Parameters sharedParameters];
        [parameters registerForDcaUpdates:^(void){
            [self updateDca];
        }];
        
        [parameters registerForOscillatorUpdates:^(void){
            [self updateOscillator];
        }];
        
        [parameters registerForAmpEnvUpdates:^(void){
            [self updateAmpEnv];
        }];

        [parameters registerForFilterUpdates:^(void){
            [self updateFilter];
        }];

        [parameters registerForFilterEnvUpdates:^(void){
            [self updateFilterEnv];
        }];

    }
    
    return self;
}

- (void) updateDca
{
    for (int i = 0; i < self.voiceCount; i++)
    {
        Voice *voice = self.voices[i];
        
        if ([voice isActive])
        {
            [voice updateDca];
        }
    }
}

- (void) updateOscillator
{
    for (int i = 0; i < self.voiceCount; i++)
    {
        Voice *voice = self.voices[i];
        
        if ([voice isActive])
        {
            [voice updateOscillator];
        }
    }
}

 - (void) updateAmpEnv
{
    for (int i = 0; i < self.voiceCount; i++)
    {
        Voice *voice = self.voices[i];
        
        if ([voice isActive])
        {
            [voice updateAmpEnv];
        }
    }
}
 
 - (void) updateFilter
{
    for (int i = 0; i < self.voiceCount; i++)
    {
        Voice *voice = self.voices[i];
        
        if ([voice isActive])
        {
            [voice updateFilter];
        }
    }
}
 
 - (void) updateFilterEnv
{
    for (int i = 0; i < self.voiceCount; i++)
    {
        Voice *voice = self.voices[i];
        
        if ([voice isActive])
        {
            [voice updateFilterEnv];
        }
    }
}
 
- (void) setSampleRate:(double)sampleRate
{
    _sampleRate = sampleRate;
    
    for (Voice *voice in self.voices)
    {
        voice.sampleRate = _sampleRate;
    }
}

- (Voice *) getFreeVoice
{
    Voice *freeVoice = nil;
    
    for (Voice *voice in self.voices)
    {
        if(![voice isActive])
        {
            freeVoice = voice;
            break;
        }
    }
    
    return freeVoice;
}

- (Voice *) stealVoice
{
    Voice *stolenVoice = nil;
    
    uint64_t age = 0;
    
    for (Voice *voice in self.voices)
    {
        if(voice.age > age)
        {
            stolenVoice = voice;
            age = voice.age;
        }
    }
    
    [stolenVoice steal];
    return stolenVoice;
}

- (void) start:(uint8_t)note withVelocity:(uint8_t)velocity
{
    Voice *voice = [self getFreeVoice];
    
    if (voice == nil)
    {
        voice = [self stealVoice];
    }
    
    // initialize
    [voice updateDca];
    [voice updateOscillator];
    [voice updateAmpEnv];
    [voice updateFilter];
    [voice updateFilterEnv];

    [voice start:note withVelocity:velocity];
}

- (void) stop:(uint8_t)note
{
    for (Voice *voice in self.voices)
    {
        if(voice.note == note)
        {
            [voice stop];
        }
    }
    
}

- (void) nextSample:(double *)outL andRight:(double *)outR
{
    for (Voice *voice in self.voices)
    {
        double leftOutput = 0.0;
        double rightOutput = 0.0;
    
        [voice nextSample:&leftOutput andRight:&rightOutput];
        
        ++voice.age;
        
        *outL += leftOutput;
        *outR += rightOutput;
    }
}

@end
