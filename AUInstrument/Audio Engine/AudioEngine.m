//
//  AudioEngine.m
//  AUInstrument
//
//  Created by Eric on 4/19/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "AudioEngine.h"
#import "WaveSynthAU.h"

@import AVFoundation;

@interface AudioEngine()
{
    // AVAudioEngine and AVAudioNodes
    AVAudioEngine *_engine;
}

@end

@implementation AudioEngine

- (instancetype)init
{
    if (self = [super init])
    {
        [self initAVAudioSession];
        [self createSynthAU];
        [self createEngineAndAttachNodes];
        [self makeEngineConnections];
        [self startEngine];
    }
    return self;
}

- (void) createSynthAU
{
    /*
     Register the AU in-process for development/debugging.
     First, build an AudioComponentDescription matching the one in our
     .appex's Info.plist.
     */
    AudioComponentDescription componentDescription;
    
    componentDescription.componentType = kAudioUnitType_MusicDevice;
    componentDescription.componentSubType = 0x77617665; /*'wave'*/
    componentDescription.componentManufacturer = 0x45454745; /*'EEGE'*/
    componentDescription.componentFlags = 0;
    componentDescription.componentFlagsMask = 0;
    
    /*
     Register our `AUAudioUnit` subclass, `AUv3FilterDemo`, to make it able
     to be instantiated via its component description.
     
     Note that this registration is local to this process.
     */
    [AUAudioUnit registerSubclass:WaveSynthAU.self asComponentDescription:componentDescription name:@"Local WaveSynth" version:1];
    
    [AVAudioUnit instantiateWithComponentDescription:componentDescription
                                             options:kAudioComponentInstantiation_LoadOutOfProcess
                                   completionHandler:^ (AVAudioUnit * __nullable audioUnit, NSError * __nullable error)
    {
        _synth = audioUnit;
    }];
}

- (void)createEngineAndAttachNodes
{
    _engine = [[AVAudioEngine alloc] init];
     [_engine attachNode:_synth];
}

- (void)makeEngineConnections
{
    AVAudioFormat *hardwareFormat = [_engine.outputNode outputFormatForBus:0];
    AVAudioFormat *stereoFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:hardwareFormat.sampleRate channels:2];
    
    AVAudioMixerNode *mainMixer = [_engine mainMixerNode];
    AVAudioOutputNode *output = [_engine outputNode];

    [_engine connect:_synth to:mainMixer format:stereoFormat];
    [_engine connect:mainMixer to:output format:hardwareFormat];
}

- (void)startEngine
{
    if (!_engine.isRunning)
    {
        NSError *error;
        BOOL success;
        success = [_engine startAndReturnError:&error];
        NSAssert(success, @"couldn't start engine, %@", [error localizedDescription]);
    }
}


- (void)initAVAudioSession
{
    // Configure the audio session
    AVAudioSession *sessionInstance = [AVAudioSession sharedInstance];
    NSError *error;
    
    // set the session category
    bool success = [sessionInstance setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (!success) NSLog(@"Error setting AVAudioSession category! %@\n", [error localizedDescription]);
    
    // activate the audio session
    success = [sessionInstance setActive:YES error:&error];
    if (!success) NSLog(@"Error setting session active! %@\n", [error localizedDescription]);
}

@end
