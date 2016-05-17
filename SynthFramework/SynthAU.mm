//
//  SynthAU.m
//
//  Created by Eric on 4/22/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "SynthAU.h"

#import "BufferedAudioBus.hpp"
#import "SynthProc.hpp"
#import "Utility.hpp"

@interface SynthAU ()

@property (nonatomic, strong) AUAudioUnitBus *outputBus;
@property (nonatomic, strong) AUAudioUnitBusArray *outputBusArray;
@property (nonatomic, readwrite) AUParameterTree *parameterTree;

@end


@implementation SynthAU
{
    // C++ members need to be ivars; they would be copied on access if they were properties.
    SynthProc _kernel;
    BufferedOutputBus _outputBusBuffer;
}

@synthesize parameterTree = _parameterTree;

- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription
                                     options:(AudioComponentInstantiationOptions)options
                                       error:(NSError **)outError
{
    self = [super initWithComponentDescription:componentDescription options:options error:outError];
    
    if (self == nil)
    {
        return nil;
    }
    
    // Initialize a default format for the busses.
    AVAudioFormat *defaultFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:44100. channels:2];
    
    // Create a DSP kernel to handle the signal processing.
    _kernel.init(defaultFormat.channelCount, defaultFormat.sampleRate);
    
    // Create a parameter object for the volume.
    AudioUnitParameterOptions flags = kAudioUnitParameterFlag_IsWritable | kAudioUnitParameterFlag_IsReadable;
    
    // oscillator
    AUParameter *waveformParam = [AUParameterTree createParameterWithIdentifier:waveformParamKey name:@"Waveform"
                                                                        address:InstrumentParamWaveform
                                                                            min:0 max:4 unit:kAudioUnitParameterUnit_Indexed unitName:nil
                                                                          flags: flags valueStrings:nil dependentParameters:nil];
    
    // dca
    AUParameter *volumeParam = [AUParameterTree createParameterWithIdentifier:volumeParamKey name:@"Volume"
                                                                      address:InstrumentParamVolume
                                                                          min:0 max:100 unit:kAudioUnitParameterUnit_Percent unitName:nil
                                                                        flags: flags valueStrings:nil dependentParameters:nil];
    
    AUParameter *panParam = [AUParameterTree createParameterWithIdentifier:panParamKey name:@"Pan"
                                                                   address:InstrumentParamPan
                                                                       min:-1.0 max:1.0 unit:kAudioUnitParameterUnit_Pan unitName:nil
                                                                     flags: flags valueStrings:nil dependentParameters:nil];
    
    // envelope generator
    AUParameter *attackParam = [AUParameterTree createParameterWithIdentifier:attackParamKey name:@"Attack"
                                                                      address:InstrumentParamAttack
                                                                          min:0 max:10000 unit:kAudioUnitParameterUnit_Milliseconds unitName:nil
                                                                        flags: flags valueStrings:nil dependentParameters:nil];
    
    AUParameter *decayParam = [AUParameterTree createParameterWithIdentifier:decayParamKey name:@"Decay"
                                                                      address:InstrumentParamDecay
                                                                          min:0 max:10000 unit:kAudioUnitParameterUnit_Milliseconds unitName:nil
                                                                        flags: flags valueStrings:nil dependentParameters:nil];
    
    AUParameter *sustainParam = [AUParameterTree createParameterWithIdentifier:sustainParamKey name:@"Sustain"
                                                                      address:InstrumentParamSustain
                                                                          min:0 max:100 unit:kAudioUnitParameterUnit_Percent unitName:nil
                                                                        flags: flags valueStrings:nil dependentParameters:nil];
    
    AUParameter *releaseParam = [AUParameterTree createParameterWithIdentifier:releaseParamKey name:@"Release"
                                                                      address:InstrumentParamRelease
                                                                          min:0 max:10000 unit:kAudioUnitParameterUnit_Milliseconds unitName:nil
                                                                        flags: flags valueStrings:nil dependentParameters:nil];
    
    // filter
    AUParameter *cutoffParam = [AUParameterTree createParameterWithIdentifier:cutoffParamKey name:@"Cutoff"
                                                                      address:InstrumentParamCutoff
                                                                          min:0 max:0.99 unit:kAudioUnitParameterUnit_Generic unitName:nil
                                                                        flags: flags valueStrings:nil dependentParameters:nil];

    AUParameter *resonanceParam = [AUParameterTree createParameterWithIdentifier:resonanceParamKey name:@"Resonance"
                                                                   address:InstrumentParamResonance
                                                                       min:-1.0 max:1.0 unit:kAudioUnitParameterUnit_Generic unitName:nil
                                                                     flags: flags valueStrings:nil dependentParameters:nil];
    

    
    // oscillator
    waveformParam.value = 0;
    _kernel.setParameter(InstrumentParamWaveform, waveformParam.value);
    
    // dca
    volumeParam.value = 100.0;
    _kernel.setParameter(InstrumentParamVolume, volumeParam.value);
    
    panParam.value = 0;
    _kernel.setParameter(InstrumentParamPan, panParam.value);
    
    // envelope generator
    attackParam.value = 100;
    _kernel.setParameter(InstrumentParamAttack, attackParam.value);
    
    decayParam.value = 100;
    _kernel.setParameter(InstrumentParamDecay, decayParam.value);
    
    sustainParam.value = 70;
    _kernel.setParameter(InstrumentParamSustain, sustainParam.value);
    
    releaseParam.value = 1000;
    _kernel.setParameter(InstrumentParamRelease, releaseParam.value);
    
    // filter
    cutoffParam.value = 0.99;
    _kernel.setParameter(InstrumentParamCutoff, cutoffParam.value);
    
    resonanceParam.value = 0.0;
    _kernel.setParameter(InstrumentParamResonance, resonanceParam.value);
    
    // Create the parameter tree.
    _parameterTree = [AUParameterTree createTreeWithChildren:@[
                                                               // oscillator
                                                               waveformParam,
                                                               
                                                               // dca
                                                               volumeParam,
                                                               panParam,
                                                               
                                                               // envelope generator
                                                               attackParam,
                                                               decayParam,
                                                               sustainParam,
                                                               releaseParam,
                                                               
                                                               // filter
                                                               cutoffParam,
                                                               resonanceParam
                                                               ]];

    // Create the output bus.
    _outputBusBuffer.init(defaultFormat, 2);
    _outputBus = _outputBusBuffer.bus;
    
    // Create the input and output bus arrays.
    _outputBusArray = [[AUAudioUnitBusArray alloc] initWithAudioUnit:self busType:AUAudioUnitBusTypeOutput busses: @[_outputBus]];
    
    // Make a local pointer to the kernel to avoid capturing self.
    __block SynthProc *instrumentKernel = &_kernel;
    
    // implementorValueObserver is called when a parameter changes value.
    _parameterTree.implementorValueObserver = ^(AUParameter *param, AUValue value) {
        instrumentKernel->setParameter(param.address, value);
    };
    
    // implementorValueProvider is called when the value needs to be refreshed.
    _parameterTree.implementorValueProvider = ^(AUParameter *param) {
        return instrumentKernel->getParameter(param.address);
    };
    
    // A function to provide string representations of parameter values.
    _parameterTree.implementorStringFromValueCallback = ^(AUParameter *param, const AUValue *__nullable valuePtr) {
        AUValue value = valuePtr == nil ? param.value : *valuePtr;
        
        switch (param.address)
        {
            case InstrumentParamVolume:
            case InstrumentParamPan:
            case InstrumentParamCutoff:
            case InstrumentParamResonance:
            {
                return [NSString stringWithFormat:@"%.3f", value];
            }
            case InstrumentParamWaveform:
            case InstrumentParamAttack:
            case InstrumentParamDecay:
            case InstrumentParamSustain:
            case InstrumentParamRelease:
            {
                return [NSString stringWithFormat:@"%d", (uint8_t)value];
            }
                
            default:
                return @"?";
        }
    };

    self.maximumFramesToRender = 512;
    
    return self;
}

- (AUAudioUnitBusArray *)outputBusses
{
    return _outputBusArray;
}

- (BOOL)allocateRenderResourcesAndReturnError:(NSError **)outError
{
    if (![super allocateRenderResourcesAndReturnError:outError])
    {
        return NO;
    }
    
    _outputBusBuffer.allocateRenderResources(self.maximumFramesToRender);
    
    _kernel.init(self.outputBus.format.channelCount, self.outputBus.format.sampleRate);
    _kernel.reset();
    
    return YES;
}

- (void)deallocateRenderResources
{
    [super deallocateRenderResources];
    
    _outputBusBuffer.deallocateRenderResources();
}

- (AUInternalRenderBlock)internalRenderBlock
{
    /*
     Capture in locals to avoid ObjC member lookups. If "self" is captured in
     render, we're doing it wrong.
     */
    __block SynthProc *state = &_kernel;
    
    return ^AUAudioUnitStatus(
                              AudioUnitRenderActionFlags *actionFlags,
                              const AudioTimeStamp       *timestamp,
                              AVAudioFrameCount           frameCount,
                              NSInteger                   outputBusNumber,
                              AudioBufferList            *outputData,
                              const AURenderEvent        *realtimeEventListHead,
                              AURenderPullInputBlock      pullInputBlock)
    {
        _outputBusBuffer.prepareOutputBufferList(outputData, frameCount, true);
        state->setBuffers(outputData);		
        state->processWithEvents(timestamp, frameCount, realtimeEventListHead);
        
        return noErr;
    };
}

@end

