/*============================================================================
 * pll.c
 *      Code to implement a simple frequency locked loop on the DSP.
 *==========================================================================*/

#include <std.h>
#include <sys.h>
#include <dev.h>
#include <sio.h>
#include <math.h>

#include "dsp_ap.h"
#include "pll.h"

#include "sin_tables.h"

/* Mathematical constants */
#define M_PI    3.14159265358979

/*----------------------------------------------------------------------------
 * pll_init
 *      Initializes state of the PLL.
 * Inputs:
 *      f0      Nominal center frequency of PLL (discrete)
 *      T       Time constant of loop filter
 *      k       Gain factor
 *      damp    Damping factor (1.0=critically damped)
 *      mult    Frequency multiplier on output
 * Notes:
 *      The multiplier operation is not implemented.  You will have to
 *      consider how to do this!
 *--------------------------------------------------------------------------*/
pll_state_def *pll_init(float f0, float T, float K, float damp, float mult)
{
    pll_state_def *s;
    float wn, tau1, tau2;

    /* Allocate a new pll_state_def structure.  Holds state and parameters. */
    if ((s = (pll_state_def *)MEM_calloc(PLL_SEG_ID, sizeof(pll_state_def), PLL_BUFFER_ALIGN)) == NULL)
    {
        SYS_error("Unable to create state structure for PLL.", SYS_EUSER, 0);
        return(0);
    }

    /* Copy input parameters */
    s->f0 = f0;
    s->damp_fact = damp;
    s->K = K;
    s->mult = mult;

    /* Compute the filter coefficients */
    /* Add your code here !!! */
    wn = 2.0*M_PI/100.0;
    tau1 = K/(wn*wn);
    tau2 = 2.0*damp/wn - 1.0/K;
    s->a1 = -(T - 2.0*tau1)/(T + 2.0*tau1);
    s->b0 = (T + 2.0*tau2)/(T + 2.0*tau1);
    s->b1 =  (T - 2.0*tau2)/(T + 2.0*tau1);

    /* Set state variables (initially all 0) */
    s->z_nm1 = 0;
    s->v_nm1 = 0;
    s->x_nm1 = 0;
    s->y_nm1 = 0;
    s->accum = 0;
    s->accum2 = 0;

    /* Set initial block amplitude (cannot be 0!) */
    s->Ap = 1.0;

    return(s);
}

/*---------------------------------------------------------------------------
 * pll
 *      PLL process function.
 *--------------------------------------------------------------------------*/
void pll(pll_state_def *s, const float x_in[], float y_out[])
{
    int n;
    float A;

    float x_n;
    float z_n;
    float v_n;
    float y_n;
    float y_n2;
    float k = 2.0;
    /* Add other temporary variables as needed. */
    /* Do not put any arrays as local variables! */

    /*
     * If signal level is below some threshold, make Ap large, which has the
     * effect of just doing holdover mode.
     */
    if (s->Ap < 1.0E-3)
    {
        s->Ap = 100.;
    }

    A = 0.0;  /* Variable for computing amplitude */
    for (n=0; n<BUFFER_SAMPLES; n++)
    {
        /* Input sample (input reference) */
        /* Take the sign of the input signal. */
        s->x_n = x_in[n];

        /* Estimate amplitude from summed |x| */
        A = A + fabs(s->x_n);

        /* Add your code here to do PLL operation !!! */
        /* Code should generate y_n from x_n. */
        z_n = s->x_nm1/s->Ap*s->y_nm1;
        v_n = s->a1*s->v_nm1 + s->b0*z_n + s->b1*s->z_nm1;
        s->accum = s->accum + s->f0 - k/(2.0*M_PI)*v_n;
		s->accum = s->accum - floor(s->accum);
		y_n = sin_table[(int)(((float)SIN_TABLE_SIZE * s->accum))];
        /* ... */

        /* Put output sample */
        y_out[n] = y_n;

        /* Shift current variables to previous values. */
        s->z_nm1 = z_n;
        s->v_nm1 = v_n;
        s->x_nm1 = x_n;
        s->y_nm1 = y_n;
    }

    /* Get amplitude estimate for next block (compute from A) */
    s->Ap = A/(BUFFER_SAMPLES)/(2/M_PI);

}
