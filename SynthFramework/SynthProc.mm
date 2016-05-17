//
//  SynthProc.cpp
//
//  Created by Eric on 4/23/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "SynthProc.hpp"

#import "DCA.h"
#import "EnvelopeGenerator.h"
#import "Filter.h"
#import "MIDIEvent.h"
#import "Oscillator.h"
#import "SynthConstants.h"
#import "Utility.hpp"

SynthProc::SynthProc()
{
    sampleRate = 44100.0;
    outBufferListPtr = nullptr;
}

void SynthProc::init(int channelCount, double inSampleRate)
{
    sampleRate = float(inSampleRate);
    
    // osc
    osc = [[Oscillator alloc] init];
    
    // dca
    dca = [[DCA alloc] init];
    
    // amp env
    ampEnv = [[EnvelopeGenerator alloc] init];
    ampEnv.sampleRate = sampleRate;
    
    // filter
    filter = [[Filter alloc] init];
    filter.sampleRate = sampleRate;
    
    // filter env
    filterEnv = [[EnvelopeGenerator alloc] init];
    filterEnv.sampleRate = sampleRate;
}

void SynthProc::reset()
{
    // this currently does nothing
}

void SynthProc::setParameter(AUParameterAddress address, AUValue value)
{
    switch (address)
    {
        // oscillator
        case InstrumentParamWaveform:
            osc.wave = (OscillatorWave)value;
            break;
            
        // dca
        case InstrumentParamVolume:
            dca.volume = value;
            break;
        case InstrumentParamPan:
            dca.pan = value;
            break;
            
        // envelope generator
        case InstrumentParamAttack:
            ampEnv.attackTime = value;
            break;
        case InstrumentParamDecay:
            ampEnv.decayTime = value;
            break;
        case InstrumentParamSustain:
            ampEnv.sustainLevel= value;
            break;
        case InstrumentParamRelease:
            ampEnv.releaseTime = value;
            break;
            
        // filter
        case InstrumentParamCutoff:
            filter.cutoff = value;
            break;
        case InstrumentParamResonance:
            filter.resonance = value;
            break;
    }
}

AUValue SynthProc::getParameter(AUParameterAddress address)
{
    AUValue value = 0.0f;
    
    switch (address)
    {
        // oscillator
        case InstrumentParamWaveform:
            value = osc.wave;
            break;
            
        // dca
        case InstrumentParamVolume:
            value = dca.volume;
            break;
        case InstrumentParamPan:
            value = dca.pan;
            break;
            
        // envelope generator
        case InstrumentParamAttack:
            value = ampEnv.attackTime;
            break;
        case InstrumentParamDecay:
            value = ampEnv.decayTime;
            break;
        case InstrumentParamSustain:
            value = ampEnv.sustainLevel;
            break;
        case InstrumentParamRelease:
            value = ampEnv.releaseTime;
            break;
            
        // filter
        case InstrumentParamCutoff:
            value = filter.cutoff;
            break;
        case InstrumentParamResonance:
            value = filter.resonance;
            break;
    }
    
    return value;
}

void SynthProc::startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration)
{
    setParameter(address, value);
}

void SynthProc::setBuffers(AudioBufferList* outBufferList)
{
    outBufferListPtr = outBufferList;
}

void SynthProc::handleMIDIEvent(AUMIDIEvent const& midiEvent)
{
    MIDIEvent *event = [[MIDIEvent alloc] initWithAUMidiEvent:&midiEvent];
    
    switch (event.message)
    {
        default:
//            NSLog(@"Instrument received unhandled MIDI event");
            break;
        case MIDIMessageType_NoteOff:
            [ampEnv stop];
            [filterEnv stop];
            break;
        case MIDIMessageType_NoteOn:
            osc.frequency = noteToHz(event.data1);
            dca.midiVelocity = event.data2;
            [ampEnv start];
            [filterEnv start];
            break;
    }
}

void SynthProc::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset)
{
    float* left = (float*)outBufferListPtr->mBuffers[0].mData + bufferOffset;
    float* right = (float*)outBufferListPtr->mBuffers[1].mData + bufferOffset;

    double inL = 0.0;
    double inR = 0.0;
    double outL = 0.0;
    double outR = 0.0;

    for (AUAudioFrameCount i = 0; i < frameCount; ++i)
    {
        inL = 0.0;
        inR = 0.0;
        outL = 0.0;
        outR = 0.0;
        
        // oscillator + filter
        inL = inR = [filter process:[osc nextSample]];
        
        // amp env
        [dca setEnvGain: [ampEnv nextSample]];
        
        // filter env
        [filter setEnvGain: [filterEnv nextSample]];
        
        // dca
        [dca process:inL rightInput:inR leftOutput:&outL rightOutput:&outR];

        // update the buffer
        left[i] = outL;
        right[i] = outR;
    }
}
