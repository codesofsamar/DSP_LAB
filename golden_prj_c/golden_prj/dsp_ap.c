/************************************************************
* dsp_ap.c
* 		You should edit this file to contain your DSP code
*		and calls to functions in other files.
*************************************************************/

#include "dsp_ap.h"

/* Global Declarations.  Add as needed. */
float mybuffer[BUFFER_SAMPLES];

/*-----------------------------------------------------------
* dsp_init
*	This function will be called when the board first starts.
*	In here you should allocate buffers or global things
*   you will need later during actual processing.
* Inputs:
*	None
* Outputs:
*	0	Success
*	1	Error
*----------------------------------------------------------*/
int dsp_init()
{

/* Add code here if needed. */


return(0);

}


/*-----------------------------------------------------------
* dsp_process
*	This function is what actually processes input samples
*	and generates output samples.  The samples are passed
*	in using the arrays inL and inR, corresponding to the
*	left and right channels, respectively.  You
*	can read these and then write to the arrays outL
*	and outR.  After processing the arrays, you should exit.
* Inputs:
*	inL		Array of left input samples.  Indices on this
*			and the other arrays go from 0 to BUFFER_SAMPLES.
*
* Outputs:
*	0	Success
*	1	Error
*----------------------------------------------------------*/
void dsp_process(
	const float inL[],
	const float inR[],
	float outL[],
	float outR[])
{
	int i;

	/* EXAMPLE: Copy input to output. */
	for (i=0; i<BUFFER_SAMPLES; i++)
	{
		outL[i] = inL[i];
		outR[i] = inR[i];
	}

}
