//
//  SynthProc.hpp
//
//  Created by Eric on 4/23/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#ifndef SynthProc_hpp
#define SynthProc_hpp

#import "DSPKernel.hpp"

@class Oscillator;
@class DCA;
@class EnvelopeGenerator;

class SynthProc : public DSPKernel
{
public:
    enum {
        InstrumentParamVolume = 0,
        InstrumentParamWaveform = 1,
        InstrumentParamPan = 2
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
    DCA *dca;
    EnvelopeGenerator *env;
};

#endif /* SynthProc_hpp */
