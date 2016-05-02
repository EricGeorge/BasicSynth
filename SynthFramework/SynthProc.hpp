//
//  SynthProc.hpp
//
//  Created by Eric on 4/23/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#ifndef SynthProc_hpp
#define SynthProc_hpp

#import "DSPKernel.hpp"
#import "Oscillator.h"

class SynthProc : public DSPKernel
{
public:
    enum {
        InstrumentParamVolume = 0,
        InstrumentParamWaveform = 1
    };
    
    SynthProc();
    
    void init(int channelCount, double inSampleRate);
    void reset();
    void setBuffers(AudioBufferList* outBufferList);
    
    void startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration)  override;
    void handleMIDIEvent(AUMIDIEvent const& midiEvent)  override;
    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override;

    void setParameter(AUParameterAddress address, AUValue value);
    AUValue getParameter(AUParameterAddress address);
    
private:
    float sampleRate;
    double frequencyScale;
    
    AudioBufferList* outBufferListPtr;
    
    Oscillator *osc;
    BOOL noteOn;
    uint8_t velocity;
    float volume;
};

#endif /* SynthProc_hpp */
