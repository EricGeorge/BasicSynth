//
//  Utility.hpp
//
//  Created by Eric on 4/30/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#ifndef Utility_h
#define Utility_h

static inline double noteToHz(int noteNumber)
{
    return 440. * exp2((noteNumber - 69)/12.);
}

static inline double convertFromDecibels(double decibels)
{
    return pow((double)10.0, decibels/(double)20.0);
}

static inline void calculatePan(double pan, double *panL, double *panR)
{
    *panL = cos((M_PI/4.0)*(pan + 1.0));
    *panR = sin((M_PI/4.0)*(pan + 1.0));
    
    *panL = fmax(*panL, (double)0.0);
    *panL = fmin(*panL, (double)1.0);
    *panR = fmax(*panR, (double)0.0);
    *panR = fmin(*panR, (double)1.0);
    
}

#endif /* Utility_h */
