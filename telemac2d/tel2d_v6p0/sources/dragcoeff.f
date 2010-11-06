C                       ********************
                        SUBROUTINE dragCoeff
C                       ********************
C
     & (v, d, vk, cW)
C
C***********************************************************************
C  TELEMAC-2D VERSION 5.5                 20/04/04      F. HUVELIN
C***********************************************************************
C
C      FONCTION:   DRAG COEFFICIENT BEHIND A CYLINDER
C      =========   
C
C-----------------------------------------------------------------------
C                             ARGUMENTS
C .________________.____.______________________________________________.
C |      NOM       |MODE|                   ROLE                       |
C |________________|____|______________________________________________|
C |   V            | -->| VELOCITY UPSTREAM
C |   D            | -->| DIAMETER
C |   VK           | -->| LAMINAR VISCOSITY
C |   CW           | <--| DRAG COEFFICIENT
C |________________|____|_______________________________________________
C MODE : -->(DONNEE NON MODIFIEE), <--(RESULTAT), <-->(DONNEE MODIFIEE)
C
C-----------------------------------------------------------------------
C
C APPELE PAR : FRICTION_LINDNER
C
C SOUS-PROGRAMMES APPELES : NEANT
C
C***********************************************************************
C
      IMPLICIT NONE
C
C+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
C
      DOUBLE PRECISION, INTENT(IN)  :: V, D, VK
      DOUBLE PRECISION, INTENT(OUT) :: cW
C
C+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
C
      DOUBLE PRECISION              :: Re
!
!=======================================================================!
!=======================================================================!
! 
      Re = v * d / vk
!  
      IF (Re.LE.800.0D0) THEN
         cW = 3.07D0 / Re**(0.168D0)
      ELSEIF(Re.LE.6000.D0) THEN
         cW = 1.D0    
      ELSEIF(Re.LE.11000.0D0) THEN
         cW = 1.0D0+0.2D0*(Re-6000.D0)/5000.D0
      ELSE
         cW = 1.2D0
      ENDIF
!
!=======================================================================!
!=======================================================================!
!
      RETURN
      END
