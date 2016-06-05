//
//  SynthAU.m
//
//  Created by Eric on 4/22/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "SynthAU.h"

#import "BufferedAudioBus.hpp"
#import "Parameters.h"
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
    
    // Create the output bus.
    _outputBusBuffer.init(defaultFormat, 2);
    _outputBus = _outputBusBuffer.bus;
    
    // Create the input and output bus arrays.
    _outputBusArray = [[AUAudioUnitBusArray alloc] initWithAudioUnit:self busType:AUAudioUnitBusTypeOutput busses: @[_outputBus]];
    
    // Make a local pointer to the kernel to avoid capturing self.
    __block SynthProc *instrumentKernel = &_kernel;
    
    [self createParameterTree];
    
    Parameters *parameters = [Parameters sharedParameters];
    
    // implementorValueObserver is called when a parameter changes value.
    _parameterTree.implementorValueObserver = ^(AUParameter *param, AUValue value) {
        if (param.address == InstrumentParamVolume || param.address == InstrumentParamPan || param.address == InstrumentParamWaveform)
            [parameters setParameter:param.address withValue:value];
        else
            instrumentKernel->setParameter(param.address, value);
    };
    
    // implementorValueProvider is called when the value needs to be refreshed.
    _parameterTree.implementorValueProvider = ^(AUParameter *param) {
        if (param.address == InstrumentParamVolume || param.address == InstrumentParamPan || param.address == InstrumentParamWaveform)
            return [parameters getParameter:param.address];
        else
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
            case InstrumentParamAmpEnvAttack:
            case InstrumentParamAmpEnvDecay:
            case InstrumentParamAmpEnvSustain:
            case InstrumentParamAmpEnvRelease:
            case InstrumentParamFilterEnvAttack:
            case InstrumentParamFilterEnvDecay:
            case InstrumentParamFilterEnvSustain:
            case InstrumentParamFilterEnvRelease:
            {
                return [NSString stringWithFormat:@"%d", (uint8_t)value];
            }
                
            default:
                return @"?";
        }
    };

    [self initializeParameters];
    
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

- (void) createParameterTree
{
    AudioUnitParameterOptions flags = kAudioUnitParameterFlag_IsWritable | kAudioUnitParameterFlag_IsReadable;
    
    // amp env
    AUParameter *ampEnvAttackParam = [AUParameterTree createParameterWithIdentifier:ampEnvAttackParamKey name:@"AmpEnvAttack"
                                                                            address:InstrumentParamAmpEnvAttack
                                                                                min:0 max:10000 unit:kAudioUnitParameterUnit_Milliseconds unitName:nil
                                                                              flags: flags valueStrings:nil dependentParameters:nil];
    
    AUParameter *ampEnvDecayParam = [AUParameterTree createParameterWithIdentifier:ampEnvDecayParamKey name:@"AmpEnvDecay"
                                                                           address:InstrumentParamAmpEnvDecay
                                                                               min:0 max:10000 unit:kAudioUnitParameterUnit_Milliseconds unitName:nil
                                                                             flags: flags valueStrings:nil dependentParameters:nil];
    
    AUParameter *ampEnvSustainParam = [AUParameterTree createParameterWithIdentifier:ampEnvSustainParamKey name:@"AmpEnvSustain"
                                                                             address:InstrumentParamAmpEnvSustain
                                                                                 min:0 max:100 unit:kAudioUnitParameterUnit_Percent unitName:nil
                                                                               flags: flags valueStrings:nil dependentParameters:nil];
    
    AUParameter *ampEnvReleaseParam = [AUParameterTree createParameterWithIdentifier:ampEnvReleaseParamKey name:@"AmpEnvRelease"
                                                                             address:InstrumentParamAmpEnvRelease
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
    
    // filter env
    AUParameter *filterEnvAttackParam = [AUParameterTree createParameterWithIdentifier:filterEnvAttackParamKey name:@"FilterEnvAttack"
                                                                               address:InstrumentParamFilterEnvAttack
                                                                                   min:0 max:10000 unit:kAudioUnitParameterUnit_Milliseconds unitName:nil
                                                                                 flags: flags valueStrings:nil dependentParameters:nil];
    
    AUParameter *filterEnvDecayParam = [AUParameterTree createParameterWithIdentifier:filterEnvDecayParamKey name:@"FilterAmpEnvDecay"
                                                                              address:InstrumentParamFilterEnvDecay
                                                                                  min:0 max:10000 unit:kAudioUnitParameterUnit_Milliseconds unitName:nil
                                                                                flags: flags valueStrings:nil dependentParameters:nil];
    
    AUParameter *filterEnvSustainParam = [AUParameterTree createParameterWithIdentifier:filterEnvSustainParamKey name:@"FilterEnvSustain"
                                                                                address:InstrumentParamFilterEnvSustain
                                                                                    min:0 max:100 unit:kAudioUnitParameterUnit_Percent unitName:nil
                                                                                  flags: flags valueStrings:nil dependentParameters:nil];
    
    AUParameter *filterEnvReleaseParam = [AUParameterTree createParameterWithIdentifier:filterEnvReleaseParamKey name:@"FilterEnvRelease"
                                                                                address:InstrumentParamFilterEnvRelease
                                                                                    min:0 max:10000 unit:kAudioUnitParameterUnit_Milliseconds unitName:nil
                                                                                  flags: flags valueStrings:nil dependentParameters:nil];
    

    // Create the parameter tree.
_parameterTree = [AUParameterTree createTreeWithChildren:@[
                                                           
                           // oscillator
                           [AUParameterTree createParameterWithIdentifier:waveformParamKey
                                                                     name:@"Waveform"
                                                                  address:InstrumentParamWaveform
                                                                      min:waveformParamMin
                                                                      max:waveformParamMax
                                                                     unit:kAudioUnitParameterUnit_Indexed
                                                                 unitName:nil
                                                                    flags:flags
                                                             valueStrings:nil
                                                       dependentParameters:nil],
                           

                           
                           // dca
                           [AUParameterTree createParameterWithIdentifier:volumeParamKey
                                                                     name:@"Volume"
                                                                  address:InstrumentParamVolume
                                                                      min:volumeParamMin
                                                                      max:volumeParamMax
                                                                     unit:kAudioUnitParameterUnit_Percent
                                                                 unitName:nil
                                                                    flags:flags
                                                             valueStrings:nil
                                                      dependentParameters:nil],
                           
                           [AUParameterTree createParameterWithIdentifier:panParamKey
                                                                     name:@"Pan"
                                                                  address:InstrumentParamPan
                                                                      min:panParamMin
                                                                      max:panParamMax
                                                                     unit:kAudioUnitParameterUnit_Pan
                                                                 unitName:nil
                                                                    flags:flags
                                                             valueStrings:nil
                                                      dependentParameters:nil],
                           
                           // amp env
                           ampEnvAttackParam,
                           ampEnvDecayParam,
                           ampEnvSustainParam,
                           ampEnvReleaseParam,
                           
                           // filter
                           cutoffParam,
                           resonanceParam,
                           
                           // filter env
                           filterEnvAttackParam,
                           filterEnvDecayParam,
                           filterEnvSustainParam,
                           filterEnvReleaseParam
                           ]];

}

- (void) initializeParameters
{
    // oscillator
    [_parameterTree parameterWithAddress:InstrumentParamWaveform].value = waveformParamDefault;
    
    // dca
    [_parameterTree parameterWithAddress:InstrumentParamVolume].value = volumeParamDefault;
    [_parameterTree parameterWithAddress:InstrumentParamPan].value = panParamDefault;
    
    // amp env
    _kernel.setParameter(InstrumentParamAmpEnvAttack, 100);
    _kernel.setParameter(InstrumentParamAmpEnvDecay, 100);
    _kernel.setParameter(InstrumentParamAmpEnvSustain, 70);
    _kernel.setParameter(InstrumentParamAmpEnvRelease, 1000);
    
    // filter
    _kernel.setParameter(InstrumentParamCutoff, 0.99);
    _kernel.setParameter(InstrumentParamResonance, 0);
    
    // filter env
    _kernel.setParameter(InstrumentParamFilterEnvAttack, 100);
    _kernel.setParameter(InstrumentParamFilterEnvDecay, 100);
    _kernel.setParameter(InstrumentParamFilterEnvSustain, 70);
    _kernel.setParameter(InstrumentParamFilterEnvRelease, 1000);
    
}
@end

