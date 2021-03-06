 /*@@
  @file      StaggeredLeapfrog2.F
  @desc
     Optimised staggered leapfrog stepper for the ADM Evolution.
  @enddesc
@@*/

#include "cctk.h"
#include "cctk_Arguments.h"

/*@@
  @routine    Bench_StaggeredLeapfrog2
  @desc
     Optimised staggered leapfrog stepper for the ADM Evolution.
  @enddesc
  @calls
  @calledby
  @history

  @endhistory

@@*/
 
      subroutine Bench_StaggeredLeapfrog2(CCTK_ARGUMENTS)

      implicit none

      DECLARE_CCTK_ARGUMENTS

      integer :: i,j,k
      integer :: im,i0,ip,jm,j0,jp,km,k0,kp
      integer :: nx,ny,nz

      CCTK_REAL :: dx,dy,dz,dt,i2dx,i2dy,i2dz,idx2,idy2,idz2
      CCTK_REAL :: i4dxdy,i4dxdz,i4dydz

      CCTK_REAL :: 
     &     adm_rhsK_metric_xx,adm_rhsK_metric_xy,adm_rhsK_metric_xz,
     &     adm_rhsK_metric_yy,adm_rhsK_metric_yz,adm_rhsK_metric_zz,
     &     adm_rhsK_matter_xx,adm_rhsK_matter_xy,adm_rhsK_matter_xz,
     &     adm_rhsK_matter_yy,adm_rhsK_matter_yz,adm_rhsK_matter_zz

      CCTK_REAL   Ttt,Ttx,Tty,Ttz,Txx,Txy,Txz,Tyy,Tyz,Tzz
      CCTK_REAL   det,uxx,uxy,uxz,uyy,uyz,uzz
      CCTK_REAL   detg_psi4 
      CCTK_REAL   detg_tempxx ,detg_tempxy ,detg_tempxz 
      CCTK_REAL   detg_tempyy ,detg_tempyz ,detg_tempzz 
      CCTK_REAL   detg_detg , detg_detcg 
      CCTK_REAL   uppermet_fdet 
      CCTK_REAL   uppermet_uxx , uppermet_uxy , uppermet_uxz 
      CCTK_REAL   uppermet_uyy , uppermet_uyz , uppermet_uzz 
      CCTK_REAL   trt_ialp2,trt_trt 
      CCTK_REAL   delgb111,delgb112,delgb113,delgb122,delgb123,delgb133 
      CCTK_REAL   dxdg_psi4,dxdg_fac
      CCTK_REAL   dxdgxx,dxdgxy,dxdgxz
      CCTK_REAL   dxdgyy,dxdgyz,dxdgzz
      CCTK_REAL   dxxdgxx,dxxdgxy,dxxdgxz,dxxdgyy,dxxdgyz,dxxdgzz 
      CCTK_REAL   delgb211,delgb212,delgb213,delgb222,delgb223,delgb233 
      CCTK_REAL   dydg_psi4,dydg_fac
      CCTK_REAL   dydgxx,dydgxy,dydgxz,dydgyy,dydgyz,dydgzz
      CCTK_REAL   deldelg1211,deldelg1212,deldelg1213,deldelg1222 
      CCTK_REAL   deldelg1223,deldelg1233 
      CCTK_REAL   delgb311,delgb312,delgb313,delgb322,delgb323,delgb333 
      CCTK_REAL   dzdg_psi4,dzdg_fac
      CCTK_REAL   dzdgxx,dzdgxy,dzdgxz,dzdgyy,dzdgyz,dzdgzz
      CCTK_REAL   deldelg1311,deldelg1312,deldelg1313,deldelg1322 
      CCTK_REAL   deldelg1323,deldelg1333 
      CCTK_REAL   dxxdg_fac,dxydg_fac,dxzdg_fac 
      CCTK_REAL   dyydg_fac,dyzdg_fac,dzzdg_fac 
      CCTK_REAL   dyydgxx,dyydgxy,dyydgxz,dyydgyy,dyydgyz,dyydgzz 
      CCTK_REAL   deldelg2311,deldelg2312,deldelg2313,deldelg2322 
      CCTK_REAL   deldelg2323,deldelg2333 
      CCTK_REAL   dzzdgxx,dzzdgxy,dzzdgxz,dzzdgyy,dzzdgyz 
      CCTK_REAL   gammado111,gammado112,gammado113,gammado122,gammado123 
      CCTK_REAL   gammado133,gammado211,gammado212,gammado213,gammado222 
      CCTK_REAL   gammado223,gammado233,gammado311,gammado312,gammado313 
      CCTK_REAL   gammado322,gammado323,gammado333 
      CCTK_REAL   gamma111,gamma112,gamma113,gamma122,gamma123,gamma133 
      CCTK_REAL   gamma211,gamma212,gamma213,gamma222,gamma223,gamma233 
      CCTK_REAL   gamma311,gamma312,gamma313,gamma322,gamma323,gamma333 
      CCTK_REAL   ricci_R11,ricci_R12,ricci_R13,ricci_R22,ricci_R23,ricci_R33 
      CCTK_REAL   KK11,KK12,KK13,KK22,KK23,KK33 
      CCTK_REAL   trk_trK 
      CCTK_REAL   da_dxda,da_dyda,da_dzda 
      CCTK_REAL   dda_dxxda,dda_dxyda,dda_dxzda,dda_dyyda,dda_dyzda,dda_dzzda 
      CCTK_REAL   cdcda_cdxxda,cdcda_cdxyda,cdcda_cdxzda 
      CCTK_REAL   cdcda_cdyyda,cdcda_cdyzda,cdcda_cdzzda 
      CCTK_REAL   dxdb_dxbx,dxdb_dxby,dxdb_dxbz 
      CCTK_REAL   dydb_dydbx,dydb_dydby,dydb_dydbz 
      CCTK_REAL   dzdb_dzdbx,dzdb_dzdby,dzdb_dzdbz 
      CCTK_REAL   dxdk_dxdkxx,dxdk_dxdkxy,dxdk_dxdkxz,dxdk_dxdkyy,dxdk_dxdkyz 
      CCTK_REAL   dxdk_dxdkzz,dydk_dydkxx,dydk_dydkxy,dydk_dydkxz,dydk_dydkyy 
      CCTK_REAL   dydk_dydkyz,dydk_dydkzz,dzdk_dzdkxx,dzdk_dzdkxy,dzdk_dzdkxz 
      CCTK_REAL   dzdk_dzdkyy,dzdk_dzdkyz,dzdk_dzdkzz 
      CCTK_REAL   dkdt_dkxxdt,dkdt_dkxydt,dkdt_dkxzdt 
      CCTK_REAL   dkdt_dkyydt,dkdt_dkyzdt,dkdt_dkzzdt 

      CCTK_REAL zero,one,pi8,half,fac

      CCTK_REAL,DIMENSION(cctk_lsh(1),cctk_lsh(2),3):: 
     &     lgxx,lgxy,lgxz,lgyy,lgyz,lgzz
      CCTK_REAL,DIMENSION(cctk_lsh(1),cctk_lsh(2),3):: lalp
      CCTK_REAL pi8alp

      CCTK_REAL gxxc,gxyc,gxzc,gyyc,gyzc,gzzc
      CCTK_REAL kxxc,kxyc,kxzc,kyyc,kyzc,kzzc

c     ==================================================================

      half = 0.5D0
      pi8 = 8d0*acos(-1.0d0)

      dt = cctk_delta_time
      dx = cctk_delta_space(1)
      dy = cctk_delta_space(2)
      dz = cctk_delta_space(3)

      i2dx = 1d0/(2d0*dx)
      i2dy = 1d0/(2d0*dy)
      i2dz = 1d0/(2d0*dz)

      idx2 = 1d0/(dx*dx)
      idy2 = 1d0/(dy*dy)
      idz2 = 1d0/(dz*dz)

      i4dxdy = 1d0/(4d0*dx*dy)
      i4dxdz = 1d0/(4d0*dx*dz)
      i4dydz = 1d0/(4d0*dy*dz)

      nx = cctk_lsh(1)
      ny = cctk_lsh(2)
      nz = cctk_lsh(3)

      detg_psi4  = 1.0d0
      dxdg_psi4  = 1.0d0
      dxdg_fac   = 0.0d0
      dydg_psi4  = 1.0d0
      dydg_fac   = 0.0d0
      dzdg_psi4  = 1.0d0
      dzdg_fac   = 0.0d0
      dxxdg_fac  = 0.0d0
      dxydg_fac  = 0.0d0
      dxzdg_fac  = 0.0d0
      dyydg_fac  = 0.0d0
      dyzdg_fac  = 0.0d0
      dzzdg_fac  = 0.0d0

c     Load up planes
      km = 1
      do j=1,ny
         do i=1,nx

            lalp(i,j,km) = alp(i,j,1)

            fac = -2.0d0*dt*lalp(i,j,1)

            ADM_gxx(i,j,1) = ADM_gxx_p(i,j,1)+fac*ADM_kxx_stag_p(i,j,1)
            lgxx(i,j,km) = ADM_gxx(i,j,1)
            ADM_gxy(i,j,1) = ADM_gxy_p(i,j,1)+fac*ADM_kxy_stag_p(i,j,1)
            lgxy(i,j,km) = ADM_gxy(i,j,1)
            ADM_gxz(i,j,1) = ADM_gxz_p(i,j,1)+fac*ADM_kxz_stag_p(i,j,1)
            lgxz(i,j,km) = ADM_gxz(i,j,1)
            ADM_gyy(i,j,1) = ADM_gyy_p(i,j,1)+fac*ADM_kyy_stag_p(i,j,1)
            lgyy(i,j,km) = ADM_gyy(i,j,1)
            ADM_gyz(i,j,1) = ADM_gyz_p(i,j,1)+fac*ADM_kyz_stag_p(i,j,1)
            lgyz(i,j,km) = ADM_gyz(i,j,1)
            ADM_gzz(i,j,1) = ADM_gzz_p(i,j,1)+fac*ADM_kzz_stag_p(i,j,1)
            lgzz(i,j,km) = ADM_gzz(i,j,1)
            
         end do
      end do
      
      k0 = 2
      do j=1,ny
         do i=1,nx

            lalp(i,j,2) = alp(i,j,2)

            fac = -2.0d0*dt*lalp(i,j,2)

            ADM_gxx(i,j,2) = ADM_gxx_p(i,j,2)+fac*ADM_kxx_stag_p(i,j,2)
            lgxx(i,j,k0) = ADM_gxx(i,j,2)
            ADM_gxy(i,j,2) = ADM_gxy_p(i,j,2)+fac*ADM_kxy_stag_p(i,j,2)
            lgxy(i,j,k0) = ADM_gxy(i,j,2)
            ADM_gxz(i,j,2) = ADM_gxz_p(i,j,2)+fac*ADM_kxz_stag_p(i,j,2)
            lgxz(i,j,k0) = ADM_gxz(i,j,2)
            ADM_gyy(i,j,2) = ADM_gyy_p(i,j,2)+fac*ADM_kyy_stag_p(i,j,2)
            lgyy(i,j,k0) = ADM_gyy(i,j,2)
            ADM_gyz(i,j,2) = ADM_gyz_p(i,j,2)+fac*ADM_kyz_stag_p(i,j,2)
            lgyz(i,j,k0) = ADM_gyz(i,j,2)
            ADM_gzz(i,j,2) = ADM_gzz_p(i,j,2)+fac*ADM_kzz_stag_p(i,j,2)
            lgzz(i,j,k0) = ADM_gzz(i,j,2)
            
         end do
      end do

      do k = 2,nz-1

         km = 1+mod(k-2,3)
         k0 = 1+mod(k-1,3)
         kp = 1+mod(k,3)

         do j=1,ny
            do i=1,nx

               lalp(i,j,kp) = alp(i,j,k+1)

               fac = -2.0d0*dt*lalp(i,j,kp)

               ADM_gxx(i,j,k+1) = ADM_gxx_p(i,j,k+1)+
     &              fac*ADM_kxx_stag_p(i,j,k+1)
               lgxx(i,j,kp) = ADM_gxx(i,j,k+1)
               ADM_gxy(i,j,k+1) = ADM_gxy_p(i,j,k+1)+
     &              fac*ADM_kxy_stag_p(i,j,k+1)
               lgxy(i,j,kp) = ADM_gxy(i,j,k+1)
               ADM_gxz(i,j,k+1) = ADM_gxz_p(i,j,k+1)+
     &              fac*ADM_kxz_stag_p(i,j,k+1)
               lgxz(i,j,kp) = ADM_gxz(i,j,k+1)
               ADM_gyy(i,j,k+1) = ADM_gyy_p(i,j,k+1)+
     &              fac*ADM_kyy_stag_p(i,j,k+1)
               lgyy(i,j,kp) = ADM_gyy(i,j,k+1)
               ADM_gyz(i,j,k+1) = ADM_gyz_p(i,j,k+1)+
     &              fac*ADM_kyz_stag_p(i,j,k+1)
               lgyz(i,j,kp) = ADM_gyz(i,j,k+1)
               ADM_gzz(i,j,k+1) = ADM_gzz_p(i,j,k+1)+
     &              fac*ADM_kzz_stag_p(i,j,k+1)
               lgzz(i,j,kp) = ADM_gzz(i,j,k+1)

            end do
         end do

         do j=2,ny-1

            do i=2,nx-1

c Preserve staggered arrays
               ip=i+1
               i0=i
               im=i-1 
               jp=j+1
               j0=j
               jm=j-1

               gxxc = lgxx(i0,j0,k0)
               gxyc = lgxy(i0,j0,k0)
               gxzc = lgxz(i0,j0,k0)
               gyyc = lgyy(i0,j0,k0)
               gyzc = lgyz(i0,j0,k0)
               gzzc = lgzz(i0,j0,k0)

c              Only need extrapolated curv at the center
               kxxc = 1.5D0*ADM_kxx_stag_p(i,j,k)
     &              -0.5D0*ADM_kxx_stag_p_p(i,j,k)
               kxyc = 1.5D0*ADM_kxy_stag_p(i,j,k)
     &              -0.5D0*ADM_kxy_stag_p_p(i,j,k)
               kxzc = 1.5D0*ADM_kxz_stag_p(i,j,k)
     &              -0.5D0*ADM_kxz_stag_p_p(i,j,k)
               kyyc = 1.5D0*ADM_kyy_stag_p(i,j,k)
     &              -0.5D0*ADM_kyy_stag_p_p(i,j,k)
               kyzc = 1.5D0*ADM_kyz_stag_p(i,j,k)
     &              -0.5D0*ADM_kyz_stag_p_p(i,j,k)
               kzzc = 1.5D0*ADM_kzz_stag_p(i,j,k)
     &              -0.5D0*ADM_kzz_stag_p_p(i,j,k)

               detg_tempxx = gyyc*gzzc-gyzc*gyzc
               detg_tempxy = gxzc*gyzc-gxyc*gzzc
               detg_tempxz = -gxzc*gyyc+gxyc*gyzc 
               detg_tempyy = gxxc*gzzc-gxzc*gxzc
               detg_tempyz = gxyc*gxzc-gxxc*gyzc
               detg_tempzz = gxxc*gyyc-gxyc*gxyc

               detg_detcg  = (detg_tempxx*gxxc+
     &              detg_tempxy*gxyc+detg_tempxz*gxzc)
               detg_detg  = detg_psi4**3*detg_detcg 
               det = detg_detcg 
               uppermet_fdet  = 1d0/(detg_psi4*detg_detcg)
               uppermet_uxx  = detg_tempxx*uppermet_fdet 
               uppermet_uxy  = detg_tempxy*uppermet_fdet 
               uppermet_uxz  = detg_tempxz*uppermet_fdet 
               uppermet_uyy  = detg_tempyy*uppermet_fdet 
               uppermet_uyz  = detg_tempyz*uppermet_fdet 
               uppermet_uzz  = detg_tempzz*uppermet_fdet 

               uxx = uppermet_uxx 
               uxy = uppermet_uxy 
               uxz = uppermet_uxz 
               uyy = uppermet_uyy
               uyz = uppermet_uyz 
               uzz = uppermet_uzz 

c ***********Compute a big bunch of interdependent stuff**************
               fac = idx2*dxdg_psi4

               delgb111 = i2dx*(lgxx(ip,j0,k0)-lgxx(im,j0,k0))
               dxdgxx = delgb111*dxdg_psi4+dxdg_fac*gxxc
c dxxdgxx is produced, but not used by anything
c               dxxdgxx  = 2*delgb111*dxdg_fac+dxxdg_fac*gxxc+fac
c     &             *(lgxx(im,j0,k0)-2*gxxc+lgxx(ip,j0,k0))
               delgb211 = i2dy*(-lgxx(i0,jm,k0)+lgxx(i0,jp,k0))
               dydgxx = delgb211*dydg_psi4+dydg_fac*gxxc 
               delgb311 = i2dz*(-lgxx(i0,j0,km)+lgxx(i0,j0,kp))
               dzdgxx = delgb311*dzdg_psi4+dzdg_fac*gxxc 
               deldelg1211 = delgb211*dxdg_fac+delgb111*dydg_fac+
     &              dxydg_fac*
     &              gxxc+dxdg_psi4*i4dxdy*(lgxx(ip,jp,k0)-
     &              lgxx(ip,jm,k0)-lgxx(im,jp,k0)+lgxx(im,jm,k0))
               deldelg1311 = delgb311*dxdg_fac+delgb111*dzdg_fac+
     &              dxzdg_fac*
     &              gxxc+dxdg_psi4*i4dxdz*(lgxx(ip,j0,kp)-
     &              lgxx(i+1,j,km)-lgxx(im,j0,kp)+lgxx(im,j0,km))
               dyydgxx = 2*delgb211*dydg_fac+dyydg_fac*gxxc+
     &              dydg_psi4*idy2*(lgxx(i0,jp,k0)-2*gxxc+
     &              lgxx(i0,jm,k0))
               deldelg2311 = delgb311*dydg_fac+delgb211*dzdg_fac+
     &              dyzdg_fac*
     &              gxxc+dydg_psi4*i4dydz*(lgxx(i0,jp,kp)-
     &              lgxx(i0,jp,km)-lgxx(i0,jm,kp)+lgxx(i0,jm,km))
               dzzdgxx = 2*delgb311*dzdg_fac+dzzdg_fac*gxxc+
     &              dzdg_psi4*idz2*(lgxx(i0,j0,kp)-2*gxxc+
     &              lgxx(i0,j0,km))

               delgb112 = i2dx*(lgxy(ip,j0,k0)-lgxy(im,j0,k0))
               dxdgxy = delgb112*dxdg_psi4+dxdg_fac*gxyc 
               delgb212 = i2dy*(-lgxy(i0,jm,k0)+lgxy(i0,jp,k0))
               dydgxy = delgb212*dydg_psi4+dydg_fac*gxyc 
               delgb312 = i2dz*(-lgxy(i0,j0,km)+lgxy(i0,j0,kp))
               dzdgxy = delgb312*dzdg_psi4+dzdg_fac*gxyc 
               deldelg1212 = delgb212*dxdg_fac+delgb112*dydg_fac+
     &              dxydg_fac*
     &              gxyc+dxdg_psi4*i4dxdy*(lgxy(ip,jp,k0)-
     &              lgxy(ip,jm,k0)-lgxy(im,jp,k0)+lgxy(im,jm,k0))
               deldelg1312 = delgb312*dxdg_fac+delgb112*dzdg_fac+
     &              dxzdg_fac*
     &              gxyc+dxdg_psi4*i4dxdz*(lgxy(ip,j0,kp)-
     &              lgxy(i+1,j,km)-lgxy(im,j0,kp)+lgxy(im,j0,km))
               deldelg2312 = delgb312*dydg_fac+delgb212*dzdg_fac+
     &              dyzdg_fac*
     &              gxyc+dydg_psi4*i4dydz*(lgxy(i0,jp,kp)-
     &              lgxy(i0,jp,km)-lgxy(i0,jm,kp)+lgxy(i0,jm,km))
               dzzdgxy = 2*delgb312*dzdg_fac+dzzdg_fac*gxyc+
     &              dzdg_psi4*idz2*(lgxy(i0,j0,kp)-2*gxyc+
     &              lgxy(i0,j0,km))

               delgb113 = i2dx*(lgxz(ip,j0,k0)-lgxz(im,j0,k0))
               dxdgxz = delgb113*dxdg_psi4+dxdg_fac*gxzc 
               delgb213 = i2dy*(-lgxz(i0,jm,k0)+lgxz(i0,jp,k0))
               dydgxz = delgb213*dydg_psi4+dydg_fac*gxzc 
               delgb313 = i2dz*(-lgxz(i0,j0,km)+lgxz(i0,j0,kp))
               dzdgxz = delgb313*dzdg_psi4+dzdg_fac*gxzc 
               deldelg1213 = delgb213*dxdg_fac+delgb113*dydg_fac+
     &              dxydg_fac*
     &              gxzc+dxdg_psi4*i4dxdy*(lgxz(ip,jp,k0)-
     &              lgxz(ip,jm,k0)-lgxz(im,jp,k0)+lgxz(im,jm,k0))
               deldelg1313 = delgb313*dxdg_fac+delgb113*dzdg_fac+
     &              dxzdg_fac*
     &              gxzc+dxdg_psi4*i4dxdz*(lgxz(ip,j0,kp)-
     &              lgxz(i+1,j,km)-lgxz(im,j0,kp)+lgxz(im,j0,km))
               dyydgxz = 2*delgb213*dydg_fac+dyydg_fac*gxzc+
     &              dydg_psi4*idy2*(lgxz(i0,jp,k0)-2*gxzc+
     &              lgxz(i0,jm,k0))
               deldelg2313 = delgb313*dydg_fac+delgb213*dzdg_fac+
     &              dyzdg_fac*
     &              gxzc+dydg_psi4*i4dydz*(lgxz(i0,jp,kp)-
     &              lgxz(i0,jp,km)-lgxz(i0,jm,kp)+lgxz(i0,jm,km))

               delgb122 = i2dx*(lgyy(ip,j0,k0)-lgyy(im,j0,k0))
               dxdgyy = delgb122*dxdg_psi4+dxdg_fac*gyyc 
               dxxdgyy  = 2*delgb122*dxdg_fac+dxxdg_fac*gyyc+fac
     &             *(lgyy(im,j0,k0)-2*gyyc+lgyy(ip,j0,k0))
               delgb222 = i2dy*(-lgyy(i0,jm,k0)+lgyy(i0,jp,k0))
               dydgyy = delgb222*dydg_psi4+dydg_fac*gyyc 
               delgb322 = i2dz*(-lgyy(i0,j0,km)+lgyy(i0,j0,kp))
               dzdgyy = delgb322*dzdg_psi4+dzdg_fac*gyyc 
               deldelg1222 = delgb222*dxdg_fac+delgb122*dydg_fac+
     &              dxydg_fac*
     &              gyyc+dxdg_psi4*i4dxdy*(lgyy(ip,jp,k0)-
     &              lgyy(ip,jm,k0)-lgyy(im,jp,k0)+lgyy(im,jm,k0))
               deldelg1322 = delgb322*dxdg_fac+delgb122*dzdg_fac+
     &              dxzdg_fac*
     &              gyyc+dxdg_psi4*i4dxdz*(lgyy(ip,j0,kp)-
     &              lgyy(i+1,j,km)-lgyy(im,j0,kp)+lgyy(im,j0,km))
               deldelg2322 = delgb322*dydg_fac+delgb222*dzdg_fac+
     &              dyzdg_fac*
     &              gyyc+dydg_psi4*i4dydz*(lgyy(i0,jp,kp)-
     &              lgyy(i0,jp,km)-lgyy(i0,jm,kp)+lgyy(i0,jm,km))
               dzzdgyy = 2*delgb322*dzdg_fac+dzzdg_fac*gyyc+
     &              dzdg_psi4*idz2*(lgyy(i0,j0,kp)-2*gyyc+
     &              lgyy(i0,j0,km))

               delgb123 = i2dx*(lgyz(ip,j0,k0)-lgyz(im,j0,k0))
               dxdgyz = delgb123*dxdg_psi4+dxdg_fac*gyzc 
               dxxdgyz  = 2*delgb123*dxdg_fac+dxxdg_fac*gyzc+fac
     &             *(lgyz(im,j0,k0)-2*gyzc+lgyz(ip,j0,k0))
               delgb223 = i2dy*(-lgyz(i0,jm,k0)+lgyz(i0,jp,k0))
               dydgyz = delgb223*dydg_psi4+dydg_fac*gyzc 
               delgb323 = i2dz*(-lgyz(i0,j0,km)+lgyz(i0,j0,kp))
               dzdgyz = delgb323*dzdg_psi4+dzdg_fac*gyzc 
               deldelg1223 = delgb223*dxdg_fac+delgb123*dydg_fac+
     &              dxydg_fac*
     &              gyzc+dxdg_psi4*i4dxdy*(lgyz(ip,jp,k0)-
     &              lgyz(ip,jm,k0)-lgyz(im,jp,k0)+lgyz(im,jm,k0))
               deldelg1323 = delgb323*dxdg_fac+delgb123*dzdg_fac+
     &              dxzdg_fac*
     &              gyzc+dxdg_psi4*i4dxdz*(lgyz(ip,j0,kp)-
     &              lgyz(i+1,j,km)-lgyz(im,j0,kp)+lgyz(im,j0,km))
               deldelg2323 = delgb323*dydg_fac+delgb223*dzdg_fac+
     &              dyzdg_fac*
     &              gyzc+dydg_psi4*i4dydz*(lgyz(i0,jp,kp)-
     &              lgyz(i0,jp,km)-lgyz(i0,jm,kp)+lgyz(i0,jm,km))

               delgb133 = i2dx*(lgzz(ip,j0,k0)-lgzz(im,j0,k0))
               dxdgzz = delgb133*dxdg_psi4+dxdg_fac*gzzc 
               dxxdgzz  = 2*delgb133*dxdg_fac+dxxdg_fac*gzzc+fac
     &             *(lgzz(im,j0,k0)-2*gzzc+lgzz(ip,j0,k0))
               delgb233 = i2dy*(-lgzz(i0,jm,k0)+lgzz(i0,jp,k0))
               dydgzz = delgb233*dydg_psi4+dydg_fac*gzzc 
               delgb333 = i2dz*(-lgzz(i0,j0,km)+lgzz(i0,j0,kp))
               dzdgzz = delgb333*dzdg_psi4+dzdg_fac*gzzc 
               deldelg1233 = delgb233*dxdg_fac+delgb133*dydg_fac+
     &              dxydg_fac*
     &              gzzc+dxdg_psi4*i4dxdy*(lgzz(ip,jp,k0)-
     &              lgzz(ip,jm,k0)-lgzz(im,jp,k0)+lgzz(im,jm,k0))
               deldelg1333 = delgb333*dxdg_fac+delgb133*dzdg_fac+
     &              dxzdg_fac*
     &              gzzc+dxdg_psi4*i4dxdz*(lgzz(ip,j0,kp)-
     &              lgzz(i+1,j,km)-lgzz(im,j0,kp)+lgzz(im,j0,km))
               dyydgzz = 2*delgb233*dydg_fac+dyydg_fac*gzzc+
     &              dydg_psi4*idy2*(lgzz(i0,jp,k0)-2*gzzc+
     &              lgzz(i0,jm,k0))
               deldelg2333 = delgb333*dydg_fac+delgb233*dzdg_fac+
     &              dyzdg_fac*
     &              gzzc+dydg_psi4*i4dydz*(lgzz(i0,jp,kp)-
     &              lgzz(i0,jp,km)-lgzz(i0,jm,kp)+lgzz(i0,jm,km))

c **************** Mongo bigtime interdependent terms ********
               gammado111  = dxdgxx*HALF
               gammado112  = dydgxx*HALF
               gammado113  = dzdgxx*HALF
               gammado122  =-dxdgyy*HALF+dydgxy 
               gammado123  = (-dxdgyz+dydgxz+dzdgxy)*HALF
               gammado133  =-dxdgzz*HALF+dzdgxz 
               gammado211  = dxdgxy-dydgxx*HALF
               gammado212  = dxdgyy*HALF
               gammado213  = (dxdgyz-dydgxz+dzdgxy)*HALF
               gammado222  = dydgyy*HALF
               gammado223  = dzdgyy*HALF
               gammado233  =-dydgzz*HALF+dzdgyz 
               gammado311  =  dxdgxz-dzdgxx*HALF
               gammado312  = (dxdgyz+dydgxz-dzdgxy)*HALF
               gammado313  = dxdgzz*HALF
               gammado322  = dydgyz-dzdgyy*HALF
               gammado323  = dydgzz*HALF
               gammado333  = dzdgzz*HALF
c ***************** Cross Dependent Terms ********************
               gamma111  = gammado111*uppermet_uxx+gammado211*
     &              uppermet_uxy+gammado311*uppermet_uxz 
               gamma112  = gammado112*uppermet_uxx+gammado212*
     &              uppermet_uxy+gammado312*uppermet_uxz 
               gamma113  = gammado113*uppermet_uxx+gammado213*
     &              uppermet_uxy+gammado313*uppermet_uxz 
               gamma122  = gammado122*uppermet_uxx+gammado222*
     &              uppermet_uxy+gammado322*uppermet_uxz 
               gamma123  = gammado123*uppermet_uxx+gammado223*
     &              uppermet_uxy+gammado323*uppermet_uxz 
               gamma133  = gammado133*uppermet_uxx+gammado233*
     &              uppermet_uxy+gammado333*uppermet_uxz 
               gamma211  = gammado111*uppermet_uxy+gammado211*
     &              uppermet_uyy+gammado311*uppermet_uyz 
               gamma212  = gammado112*uppermet_uxy+gammado212*
     &              uppermet_uyy+gammado312*uppermet_uyz 
               gamma213  = gammado113*uppermet_uxy+gammado213*
     &              uppermet_uyy+gammado313*uppermet_uyz 
               gamma222  = gammado122*uppermet_uxy+gammado222*
     &              uppermet_uyy+gammado322*uppermet_uyz 
               gamma223  = gammado123*uppermet_uxy+gammado223*
     &              uppermet_uyy+gammado323*uppermet_uyz 
               gamma233  = gammado133*uppermet_uxy+gammado233*
     &              uppermet_uyy+gammado333*uppermet_uyz 
               gamma311  = gammado111*uppermet_uxz+gammado211*
     &              uppermet_uyz+gammado311*uppermet_uzz 
               gamma312  = gammado112*uppermet_uxz+gammado212*
     &              uppermet_uyz+gammado312*uppermet_uzz 
               gamma313  = gammado113*uppermet_uxz+gammado213*
     &              uppermet_uyz+gammado313*uppermet_uzz 
               gamma322  = gammado122*uppermet_uxz+gammado222*
     &              uppermet_uyz+gammado322*uppermet_uzz 
               gamma323  = gammado123*uppermet_uxz+gammado223*
     &              uppermet_uyz+gammado323*uppermet_uzz 
               gamma333  = gammado133*uppermet_uxz+gammado233*
     &              uppermet_uyz+gammado333*uppermet_uzz 
c *************** Interrelated Terms ***********************
c *********** but closely related to stuff below *****
c * relates to computation of admrhs below
               Ttt = 0.0D0; Ttx = 0.0D0; Tty = 0.0D0; Ttz = 0.0D0
               Txx = 0.0D0; Txy = 0.0D0; Txz = 0.0D0
               Tyy = 0.0D0; Tyz = 0.0D0
               Tzz = 0.0D0
               trt_ialp2  = 1D0/(lalp(i0,j0,k0)*lalp(i0,j0,k0))
c Well wait... whats the point of the trt_trt computation
c if the T?? stuff is all set to 0???
               trt_trt  =-Ttt*trt_ialp2+Txx*uppermet_uxx+
     &              Tyy*uppermet_uyy+Tzz*uppermet_uzz+2D0*(
     &              Txy*uppermet_uxy+Txz*uppermet_uxz+Tyz*
     &              uppermet_uyz)
               fac = trt_trt*half
c * indep *
               pi8alp = -lalp(i0,j0,k0)*pi8
               trk_trK = uppermet_uxx*kxxc+uppermet_uyy*
     &              kyyc+uppermet_uzz*kzzc+2D0*(
     &              uppermet_uxy*kxyc+uppermet_uxz*
     &              kxzc+uppermet_uyz*kyzc)
c * indep *
               da_dxda  = i2dx*(lalp(ip,j0,k0)-lalp(im,j0,k0))
               da_dyda  = i2dy*(lalp(i0,jp,k0)-lalp(i0,jm,k0))
               da_dzda  = i2dz*(lalp(i0,j0,kp)-lalp(i0,j0,km))

     
c *******************  XX **********************************
               
               adm_rhsK_matter_xx = pi8alp*(Txx-fac*gxxc)
               ricci_R11  = (deldelg1212+(-dxxdgyy-dyydgxx)*half-
     &              gammado122*gamma111+gammado112*gamma112-gammado222*
     &              gamma211+gammado212*gamma212-gammado322*gamma311+
     &              gammado312*gamma312)*uppermet_uyy+(-dxxdgyz+
     &              deldelg1213+
     &              deldelg1312-deldelg2311-2*(gammado223*gamma211+
     &              gammado323*gamma311)+2*(-(gammado123*gamma111)+
     &              gammado113*
     &              gamma112+gammado213*gamma212+gammado313*gamma312))*
     &              uppermet_uyz+(deldelg1313+(-dxxdgzz-dzzdgxx)*half-
     &              gammado133*gamma111+gammado113*gamma113-gammado233*
     &              gamma211+gammado213*gamma213-gammado333*gamma311+
     &              gammado313*gamma313)*uppermet_uzz 
               KK11 = 2*(uppermet_uyz*kxyc*kxzc+
     &              kxxc*(uppermet_uxy*kxyc+
     &              uppermet_uxz*kxzc))+uppermet_uxx*kxxc*
     &              kxxc+uppermet_uyy*kxyc*kxyc+
     &              uppermet_uzz*kxzc*kxzc 
               dda_dxxda  = idx2*(lalp(ip,j0,k0)-2D0*lalp(i0,j0,k0)+
     &              lalp(im,j0,k0))
               cdcda_cdxxda  = (dda_dxxda-gamma111*da_dxda-gamma211*
     &              da_dyda-gamma311*da_dzda)
               dkdt_dkxxdt = lalp(i0,j0,k0)*(ricci_R11-2*KK11+kxxc
     &              *trk_trK)-cdcda_cdxxda 

               ADM_kxx_stag(i,j,k) = ADM_kxx_stag_p(i,j,k)+
     &              dkdt_dkxxdt*dt

c *******************  XY **********************************

               adm_rhsK_matter_xy = pi8alp*(Txy-fac*gxyc)
               ricci_R12  = (-deldelg1212+(dxxdgyy+dyydgxx)*half+
     &              gammado122*gamma111-gammado112*gamma112+gammado222*
     &              gamma211-gammado212*gamma212+gammado322*gamma311-
     &              gammado312*gamma312)*uppermet_uxy+((dxxdgyz-
     &              deldelg1213-
     &              deldelg1312+deldelg2311)*half+gammado123*gamma111-
     &              gammado113*gamma112+gammado223*gamma211-gammado213*
     &              gamma212+gammado323*gamma311-gammado313*gamma312)*
     &              uppermet_uxz+((-deldelg1223+deldelg1322+dyydgxz-
     &              deldelg2312)*half-gammado123*gamma112+gammado122*
     &              gamma113-gammado223*gamma212+gammado222*gamma213-
     &              gammado323*gamma312+gammado322*gamma313)*
     &              uppermet_uyz+
     &              ((-deldelg1233+deldelg1323+deldelg2313-dzzdgxy)*
     &              half-
     &              gammado133*gamma112+gammado123*gamma113-gammado233*
     &              gamma212+gammado223*gamma213-gammado333*gamma312+
     &              gammado323*gamma313)*uppermet_uzz
               KK12 = kxyc*(uppermet_uxx*kxxc+
     &              uppermet_uyy*kyyc)+uppermet_uzz*kxzc*
     &              kyzc+uppermet_uxz*(kxyc*
     &              kxzc+kxxc*kyzc)+
     &              uppermet_uyz*(kxzc*kyyc+
     &              kxyc*kyzc)+uppermet_uxy*(
     &              kxxc*kyyc+kxyc*
     &              kxyc) 
               dda_dxyda  = i4dxdy*(lalp(ip,jp,k0)-lalp(ip,jm,k0)-
     &              lalp(im,jp,k0)+lalp(im,jm,k0))
               cdcda_cdxyda  = (dda_dxyda-gamma112*da_dxda-gamma212*
     &              da_dy
     &              da-gamma312*da_dzda)
               dkdt_dkxydt = lalp(i0,j0,k0)*(ricci_R12-2*KK12+kxyc
     &              *trk_trK)-cdcda_cdxyda 
               ADM_kxy_stag(i,j,k) = ADM_kxy_stag_p(i,j,k)+
     &              dkdt_dkxydt*dt

c *******************  XZ **********************************

               adm_rhsK_matter_xz = pi8alp*(Txz-fac*gxzc)
               ricci_R13 = ((dxxdgyz-deldelg1213-deldelg1312+
     &              deldelg2311)*
     &              half+gammado123*gamma111-gammado113*gamma112+
     &              gammado223*
     &              gamma211-gammado213*gamma212+gammado323*gamma311-
     &              gammado313*gamma312)*uppermet_uxy+(-deldelg1313+
     &              (dxxdgzz+
     &              dzzdgxx)*half+gammado133*gamma111-gammado113*
     &              gamma113+
     &              gammado233*gamma211-gammado213*gamma213+gammado333*
     &              gamma311-gammado313*gamma313)*uppermet_uxz+
     &              ((deldelg1223-
     &              deldelg1322-dyydgxz+deldelg2312)*half+gammado123*
     &              gamma112-
     &              gammado122*gamma113+gammado223*gamma212-gammado222*
     &              gamma213+gammado323*gamma312-gammado322*gamma313)*
     &              uppermet_uyy+((deldelg1233-deldelg1323-deldelg2313+
     &              dzzdgxy)*half+gammado133*gamma112-gammado123*
     &              gamma113+
     &              gammado233*gamma212-gammado223*gamma213+gammado333*
     &              gamma312-gammado323*gamma313)*uppermet_uyz
               KK13 = uppermet_uyy*kxyc*kyzc+uppermet_uxy*(kxyc*kxzc+
     &              kxxc*kyzc)+kxzc*(
     &              uppermet_uxx*kxxc+uppermet_uzz*kzzc)+
     &              uppermet_uyz*(kxzc*kyzc+
     &              kxyc*kzzc)+uppermet_uxz*(kxxc*kzzc+kxzc*kxzc)
               dda_dxzda  = i4dxdz*(lalp(ip,j0,kp)-lalp(i+1,j,km)-
     &              lalp(im,j0,kp)+lalp(im,j0,km))
               cdcda_cdxzda  = (dda_dxzda-gamma113*da_dxda-gamma213*
     &              da_dyda-gamma313*da_dzda)
               dkdt_dkxzdt = lalp(i0,j0,k0)*(ricci_R13-2*KK13+kxzc
     &              *trk_trK)-cdcda_cdxzda 
               ADM_kxz_stag(i,j,k) = ADM_kxz_stag_p(i,j,k)+
     &              dkdt_dkxzdt*dt


c *******************  YY **********************************
 
               adm_rhsK_matter_yy = pi8alp*(Tyy-fac*gyyc)
               ricci_R22 = (deldelg1212+(-dxxdgyy-dyydgxx)*half-
     &              gammado122*
     &              gamma111+gammado112*gamma112-gammado222*gamma211+
     &              gammado212*gamma212-gammado322*gamma311+gammado312*
     &              gamma312)*uppermet_uxx+(deldelg1223-deldelg1322-
     &              dyydgxz+deldelg2312+2*(gammado123*gamma112-
     &              gammado122*
     &              gamma113+gammado223*gamma212+gammado323*gamma312)-
     &              2*(gammado222*gamma213+gammado322*gamma313))*
     &              uppermet_uxz+(deldelg2323+(-dyydgzz-dzzdgyy)*half-
     &              gammado133*gamma122+gammado123*gamma123-gammado233*
     &              gamma222+gammado223*gamma223-gammado333*gamma322+
     &              gammado323*gamma323)*uppermet_uzz
               KK22 = 2*(uppermet_uyz*kyyc*kyzc+
     &              kxyc*(uppermet_uxy*kyyc+
     &              uppermet_uxz*kyzc))+uppermet_uxx*
     &              kxyc*kxyc+uppermet_uyy*
     &              kyyc*kyyc+uppermet_uzz*kyzc*kyzc
               dda_dyyda  = idy2*(lalp(i0,jp,k0)-2D0*lalp(i0,j0,k0)+
     &              lalp(i0,jm,k0))
               cdcda_cdyyda  = (dda_dyyda-gamma122*da_dxda-gamma222*
     &              da_dyda-gamma322*da_dzda)
               dkdt_dkyydt = lalp(i0,j0,k0)*(ricci_R22-2*KK22+kyyc
     &              *trk_trK)-cdcda_cdyyda 
               ADM_kyy_stag(i,j,k) = ADM_kyy_stag_p(i,j,k)+
     &              dkdt_dkyydt*dt

c *******************  YZ **********************************

               adm_rhsK_matter_yz = pi8alp*(Tyz-fac*gyzc)
               ricci_R23 = ((-dxxdgyz+deldelg1213+deldelg1312-
     &              deldelg2311)*half-gammado123*gamma111+gammado113*
     &              gamma112-gammado223*
     &              gamma211+gammado213*gamma212-gammado323*gamma311+
     &              gammado313*gamma312)*uppermet_uxx+((-deldelg1223+
     &              deldelg1322+dyydgxz-deldelg2312)*half-gammado123*
     &              gamma112+
     &              gammado122*gamma113-gammado223*gamma212+gammado222*
     &              gamma213-gammado323*gamma312+gammado322*gamma313)*
     &              uppermet_uxy+((deldelg1233-deldelg1323-deldelg2313+
     &              dzzdgxy)*half+gammado133*gamma112-gammado123*
     &              gamma113+
     &              gammado233*gamma212-gammado223*gamma213+gammado333*
     &              gamma312-gammado323*gamma313)*uppermet_uxz+
     &              (-deldelg2323 
     &              +(dyydgzz+dzzdgyy)*half+gammado133*gamma122-
     &              gammado123*
     &              gamma123+gammado233*gamma222-gammado223*gamma223+
     &              gammado333*gamma322-gammado323*gamma323)*
     &              uppermet_uyz
               KK23 = uppermet_uxx*kxyc*kxzc+
     &              uppermet_uxy*(kxzc*kyyc+kxyc*kyzc)+kyzc*(
     &              uppermet_uyy*kyyc+uppermet_uzz*kzzc)+
     &              uppermet_uxz*(kxzc*kyzc+kxyc*kzzc)+uppermet_uyz*(
     &              kyyc*kzzc+kyzc*kyzc) 
               dda_dyzda  = i4dydz*(lalp(i0,jp,kp)-lalp(i0,jp,km)-
     &              lalp(i0,jm,kp)+lalp(i0,jm,km))
               cdcda_cdyzda  = (dda_dyzda-gamma123*da_dxda-gamma223*
     &              da_dyda-gamma323*da_dzda)
               dkdt_dkyzdt = lalp(i0,j0,k0)*(ricci_R23-2*KK23+kyzc
     &              *trk_trK)-cdcda_cdyzda
               ADM_kyz_stag(i,j,k) = ADM_kyz_stag_p(i,j,k)+
     &              dkdt_dkyzdt*dt

c *******************  ZZ **********************************
               
               adm_rhsK_matter_zz = pi8alp*(Tzz-fac*gzzc)
c               ADM_kzz_stag_p(i,j,k) = ADM_kzz_stag(i,j,k)
c * indep (used by dkdt_dkzzdt
               ricci_R33 = (deldelg1313+(-dxxdgzz-dzzdgxx)*half-
     &              gammado133*
     &              gamma111+gammado113*gamma113-gammado233*gamma211+
     &              gammado213*gamma213-gammado333*gamma311+gammado313*
     &              gamma313)*uppermet_uxx+(-deldelg1233+deldelg1323+
     &              deldelg2313-dzzdgxy-2*(gammado233*gamma212+
     &              gammado333*gamma312)+2*(-(gammado133*gamma112)+
     &              gammado123*gamma113+gammado223*gamma213+
     &              gammado323*gamma313))*uppermet_uxy+
     &              (deldelg2323+(-dyydgzz-dzzdgyy)*half-gammado133*
     &              gamma122+
     &              gammado123*gamma123-gammado233*gamma222+gammado223*
     &              gamma223-gammado333*gamma322+gammado323*gamma323)*
     &              uppermet_uyy
c * indep (used by dkdt_dkzzdt         
               KK33 = 2*(uppermet_uyz*kyzc*kzzc+
     &              kxzc*(uppermet_uxy*kyzc+
     &              uppermet_uxz*kzzc))+uppermet_uxx*
     &              kxzc*kxzc+uppermet_uyy*
     &              kyzc*kyzc+uppermet_uzz*
     &              kzzc*kzzc 
c * indep  
               dda_dzzda  = idz2*(lalp(i0,j0,kp)-2D0*lalp(i0,j0,k0)+
     &              lalp(i0,j0,km))
               cdcda_cdzzda  = (dda_dzzda-gamma133*da_dxda-gamma233*
     &              da_dyda-gamma333*da_dzda)
               dkdt_dkzzdt = lalp(i0,j0,k0)*(ricci_R33-2*KK33+kzzc
     &              *trk_trK)-cdcda_cdzzda 
               ADM_kzz_stag(i,j,k) = ADM_kzz_stag_p(i,j,k)+
     &              dkdt_dkzzdt*dt 

            end do
         end do

      end do

      end subroutine Bench_StaggeredLeapfrog2
