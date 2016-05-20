//
//  Voices.m
//
//  Created by Eric on 5/18/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "Voices.h"

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
        
        _voiceCount = 16;
        
        self.voices = [NSArray array];
        for (int i = 0; i < self.voiceCount; i++)
        {
            self.voices = [self.voices arrayByAddingObject:[[Voice alloc] init]];
        }
    }
    
    return self;
}

- (void) setParameter:(AUParameterAddress)address withValue:(AUValue)value
{
    for (Voice *voice in self.voices)
    {
        [voice setParameter:address withValue:value];
    }
}

- (AUValue) getParameter:(AUParameterAddress)address
{
    AUValue result = 0.0;
    
    // for now just get the first voice's parameter.  But
    // TODO - refactor params out into their own class with KVO
    
    if(self.voices.count > 0)
    {
        result = [self.voices[0] getParameter:address];
    }
    
    return result;
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

- (void) start:(uint8_t)note withVelocity:(uint8_t)velocity
{
    Voice *voice = [self getFreeVoice];
    
    if (voice != nil)
    {
        [voice start:note withVelocity:velocity];
    }
    else
    {
        // steal voice logic here
    }
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
        
        *outL += leftOutput;
        *outR += rightOutput;
    }
}

@end