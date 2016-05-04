//
//  Utility.hpp
//
//  Created by Eric on 4/30/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#ifndef Utility_h
#define Utility_h

static inline double pow2(double x)
{
    return x*x;
}

static inline double noteToHz(int noteNumber)
{
    // midi note frequency  =  2^((m−69)/12) * 440 Hz
    // https://newt.phys.unsw.edu.au/jw/notes.html
    
    return 440. * exp2((noteNumber - 69)/12.);
}

static inline double convertFromDecibels(double decibels)
{
    return pow((double)10.0, decibels/(double)20.0);
}

static inline double convertToDecibels(double value)
{
    return 20 * log(value);
}

/** Equal power crossfade utilities:
    essentially use the first quadrant of sine and cosine waves (which overlap at 0.707) **/

static inline double getEqualPowerLeft(double bipolarValue)
{
    // p = pi/4 * (bipolar control + 1)
    // left = cos(p)
    
    return cos((M_PI/4.0)*(bipolarValue + 1.0));
}

static inline double getEqualPowerRight(double bipolarValue)
{
    // p = pi/4 * (bipolar control + 1)
    // right = sin(p)
    
    return sin((M_PI/4.0)*(bipolarValue + 1.0));
}

static inline double gainFromMidiVelocity(uint8_t velocity)
{
    // approximate an exponential convex curve: x^2/127^2
    
    return pow2(velocity/127.0);
}

#endif /* Utility_h */
