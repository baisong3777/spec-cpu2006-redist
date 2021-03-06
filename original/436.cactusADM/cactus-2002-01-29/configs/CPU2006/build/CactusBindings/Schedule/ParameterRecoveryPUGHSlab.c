#define THORN_IS_PUGHSlab

#include <stdarg.h>

#include "cctk.h"
#include "cctk_Parameters.h"
#include "cctki_ScheduleBindings.h"

/* Prototypes for functions to be registered. */


/*@@
  @routine    CCTKi_BindingsParameterRecovery_PUGHSlab
  @date       
  @author     
  @desc 
  Creates the parameter recovery bindings for thorn PUGHSlab
  @enddesc 
  @calls     
  @calledby   
  @history 

  @endhistory

@@*/
int CCTKi_BindingsParameterRecovery_PUGHSlab(void);
int CCTKi_BindingsParameterRecovery_PUGHSlab(void)
{
  DECLARE_CCTK_PARAMETERS
  int result = 0;


  USE_CCTK_PARAMETERS;   return (result);
}
