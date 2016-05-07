//
//  SynthProc.cpp
//
//  Created by Eric on 4/23/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "SynthProc.hpp"

#import "DCA.h"
#import "EnvelopeGenerator.h"
#import "MIDIEvent.h"
#import "Oscillator.h"
#import "Utility.hpp"

SynthProc::SynthProc()
{
    sampleRate = 44100.0;
    frequencyScale = 2. * M_PI / sampleRate;
    
    outBufferListPtr = nullptr;
    
    // osc
    osc = [[Oscillator alloc] init];
    
    // dca
    dca = [[DCA alloc] init];
    
    // env
    env = [[EnvelopeGenerator alloc] init];
    env.sampleRate = sampleRate;
}

void SynthProc::init(int channelCount, double inSampleRate)
{
    sampleRate = float(inSampleRate);
    frequencyScale = 2.0 * M_PI / sampleRate;
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
        case SynthProc::InstrumentParamWaveform:
            osc.wave = (OscillatorWave)value;
            break;
            
        // dca
        case SynthProc::InstrumentParamVolume:
            dca.volumePct = value;
            break;
        case SynthProc::InstrumentParamPan:
            dca.pan = value;
            break;
            
        // envelope generator
        case SynthProc::InstrumentParamAttack:
            env.attackTime = value/1000.0;
            break;
        case SynthProc::InstrumentParamDecay:
            env.decayTime = value/1000.0;
            break;
        case SynthProc::InstrumentParamSustain:
            env.sustainLevel= value/100.0;
            break;
        case SynthProc::InstrumentParamRelease:
            env.releaseTime = value/1000.0;
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
            value = dca.volumePct;
            break;
        case InstrumentParamPan:
            value = dca.pan;
            break;
            
        // envelope generator
        case InstrumentParamAttack:
            value = env.attackTime * 1000;
            break;
        case InstrumentParamDecay:
            value = env.decayTime * 1000;
            break;
        case InstrumentParamSustain:
            value = env.sustainLevel * 100;
            break;
        case InstrumentParamRelease:
            value = env.releaseTime * 1000;
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
            [env stop];
            break;
        case MIDIMessageType_NoteOn:
            osc.frequency = noteToHz(event.data1);
            dca.midiVelocity = event.data2;
            [env start];
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
        
        // oscillator
        inL = inR = [osc nextSample];
        
        // env
        [dca setEnvGain: [env nextSample]];
        
        // dca
        [dca compute:inL rightInput:inR leftOutput:&outL rightOutput:&outR];

        // update the buffer
        left[i] = outL;
        right[i] = outR;
    }
}
