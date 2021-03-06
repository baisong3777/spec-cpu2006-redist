!WRF:PACKAGE:NODM
!
MODULE module_dm

  CONTAINS
   SUBROUTINE init_module_dm
   END SUBROUTINE init_module_dm

   REAL FUNCTION wrf_dm_max_real ( inval )
      IMPLICIT NONE
      REAL inval
      wrf_dm_max_real = inval
   END FUNCTION wrf_dm_max_real

   REAL FUNCTION wrf_dm_min_real ( inval )
      IMPLICIT NONE
      REAL inval
      wrf_dm_min_real = inval
   END FUNCTION wrf_dm_min_real

   REAL FUNCTION wrf_dm_sum_real ( inval )
      IMPLICIT NONE
      REAL inval
      wrf_dm_sum_real = inval
   END FUNCTION wrf_dm_sum_real

   SUBROUTINE wrf_dm_maxval ( val, idex, jdex )
      IMPLICIT NONE
      REAL val
      INTEGER idex, jdex
      RETURN
   END SUBROUTINE wrf_dm_maxval

END MODULE module_dm

!=========================================================================

! These are stub functions that do the right thing (usually nothing)
! in case DM_PARALLEL is not compiled for.
! This file, src/module_dm_stubs.F is copied to src/module_dm.F  when
! the code is built.
! If, on the other hand, a DM package is specified, the module_dm.F 
! provided with that package (e.g. RSL) is copied from /external/RSL/module_dm.F
! into src/module_dm.F.
! It is important to recognize this, because changes directly to src/module_dm.F
! will be lost!

LOGICAL FUNCTION wrf_dm_on_monitor()
  wrf_dm_on_monitor = .true.
END FUNCTION wrf_dm_on_monitor

SUBROUTINE wrf_get_myproc( myproc )
  IMPLICIT NONE
  INTEGER myproc
  myproc = 0
  RETURN
END SUBROUTINE wrf_get_myproc

SUBROUTINE wrf_get_nproc( nprocs )
  IMPLICIT NONE
  INTEGER nprocs
  nprocs = 1
  RETURN
END SUBROUTINE wrf_get_nproc

SUBROUTINE wrf_get_nprocx( nprocs )
  IMPLICIT NONE
  INTEGER nprocs
  nprocs = 1
  RETURN
END SUBROUTINE wrf_get_nprocx

SUBROUTINE wrf_get_nprocy( nprocs )
  IMPLICIT NONE
  INTEGER nprocs
  nprocs = 1
  RETURN
END SUBROUTINE wrf_get_nprocy

SUBROUTINE wrf_dm_bcast_string ( buf , size )
  IMPLICIT NONE
  INTEGER size
  INTEGER BUF(*)
  RETURN
END SUBROUTINE wrf_dm_bcast_string

SUBROUTINE wrf_dm_bcast_bytes ( buf , size )
  IMPLICIT NONE
  INTEGER size
  INTEGER BUF(*)
  RETURN
END SUBROUTINE wrf_dm_bcast_bytes

SUBROUTINE wrf_dm_bcast_integer( BUF, N1 )
   IMPLICIT NONE
   INTEGER n1
   INTEGER  buf(*)
   RETURN
END SUBROUTINE wrf_dm_bcast_integer

SUBROUTINE wrf_dm_bcast_real( BUF, N1 )
   IMPLICIT NONE
   INTEGER n1
   REAL  buf(*)
   RETURN
END SUBROUTINE wrf_dm_bcast_real

SUBROUTINE wrf_dm_bcast_logical( BUF, N1 )
   IMPLICIT NONE
   INTEGER n1
   LOGICAL  buf(*)
   RETURN
END SUBROUTINE wrf_dm_bcast_logical

SUBROUTINE wrf_dm_halo ( domdesc , comms , stencil_id )
   IMPLICIT NONE
   INTEGER domdesc , comms(*) , stencil_id
   RETURN
END SUBROUTINE wrf_dm_halo

SUBROUTINE wrf_dm_boundary ( domdesc , comms , period_id , &
                             periodic_x , periodic_y )
   IMPLICIT NONE
   INTEGER domdesc , comms(*) , period_id
   LOGICAL , INTENT(IN)      :: periodic_x, periodic_y
   RETURN
END SUBROUTINE wrf_dm_boundary

SUBROUTINE wrf_dm_xpose_z2x ( domdesc , comms , xpose_id  )
   IMPLICIT NONE
   INTEGER domdesc , comms(*), xpose_id
   RETURN
END SUBROUTINE wrf_dm_xpose_z2x
SUBROUTINE wrf_dm_xpose_x2y ( domdesc , comms , xpose_id  )
   IMPLICIT NONE
   INTEGER domdesc , comms(*), xpose_id
   RETURN
END SUBROUTINE wrf_dm_xpose_x2y
SUBROUTINE wrf_dm_xpose_y2z ( domdesc , comms , xpose_id  )
   IMPLICIT NONE
   INTEGER domdesc , comms(*), xpose_id
   RETURN
END SUBROUTINE wrf_dm_xpose_y2z

SUBROUTINE wrf_dm_define_comms ( grid )
   USE module_domain
   IMPLICIT NONE
   TYPE(domain) , INTENT (INOUT) :: grid
   RETURN
END SUBROUTINE wrf_dm_define_comms

SUBROUTINE wrf_get_dm_communicator ( communicator )
   IMPLICIT NONE
   INTEGER , INTENT(OUT) :: communicator
   communicator = 0
   RETURN
END SUBROUTINE wrf_get_dm_communicator

SUBROUTINE wrf_get_dm_iocommunicator ( iocommunicator )
   IMPLICIT NONE
   INTEGER , INTENT(OUT) :: iocommunicator
   iocommunicator = 0
   RETURN
END SUBROUTINE wrf_get_dm_iocommunicator

SUBROUTINE wrf_dm_shutdown
      RETURN
END SUBROUTINE wrf_dm_shutdown
SUBROUTINE wrf_abort
      STOP 'wrf_abort'
END SUBROUTINE wrf_abort

SUBROUTINE wrf_patch_to_global_real (buf,globbuf,domdesc,ndim,&
                                       ids,ide,jds,jde,kds,kde,&
                                       ims,ime,jms,jme,kms,kme,&
                                       ips,ipe,jps,jpe,kps,kpe )
   IMPLICIT NONE
   INTEGER                             ids,ide,jds,jde,kds,kde,&
                                       ims,ime,jms,jme,kms,kme,&
                                       ips,ipe,jps,jpe,kps,kpe
   INTEGER fid,domdesc,ndim,glen(3),llen(3)
   REAL globbuf(*)
   REAL buf(*)
   RETURN
END SUBROUTINE wrf_patch_to_global_real

SUBROUTINE wrf_global_to_patch_real (globbuf,buf,domdesc,ndim,&
                                       ids,ide,jds,jde,kds,kde,&
                                       ims,ime,jms,jme,kms,kme,&
                                       ips,ipe,jps,jpe,kps,kpe )
   IMPLICIT NONE
   INTEGER                             ids,ide,jds,jde,kds,kde,&
                                       ims,ime,jms,jme,kms,kme,&
                                       ips,ipe,jps,jpe,kps,kpe
   INTEGER fid,domdesc,ndim,glen(3),llen(3)
   REAL globbuf(*)
   REAL buf(*)
   RETURN
END SUBROUTINE wrf_global_to_patch_real

SUBROUTINE wrf_patch_to_global_integer (buf,globbuf,domdesc,ndim,&
                                       ids,ide,jds,jde,kds,kde,&
                                       ims,ime,jms,jme,kms,kme,&
                                       ips,ipe,jps,jpe,kps,kpe )
   IMPLICIT NONE
   INTEGER                             ids,ide,jds,jde,kds,kde,&
                                       ims,ime,jms,jme,kms,kme,&
                                       ips,ipe,jps,jpe,kps,kpe
   INTEGER fid,domdesc,ndim,glen(3),llen(3)
   INTEGER globbuf(*)
   INTEGER buf(*)
   RETURN
END SUBROUTINE wrf_patch_to_global_integer

SUBROUTINE wrf_global_to_patch_integer (globbuf,buf,domdesc,ndim,&
                                       ids,ide,jds,jde,kds,kde,&
                                       ims,ime,jms,jme,kms,kme,&
                                       ips,ipe,jps,jpe,kps,kpe )
   IMPLICIT NONE
   INTEGER                             ids,ide,jds,jde,kds,kde,&
                                       ims,ime,jms,jme,kms,kme,&
                                       ips,ipe,jps,jpe,kps,kpe
   INTEGER fid,domdesc,ndim,glen(3),llen(3)
   INTEGER globbuf(*)
   INTEGER buf(*)
   RETURN
END SUBROUTINE wrf_global_to_patch_integer



