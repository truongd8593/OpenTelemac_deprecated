C                       *****************
                        SUBROUTINE UM1X09
C                       *****************
C
     *(X1,X2,X3,D12,D13,D23)
C
C***********************************************************************
C BIEF VERSION 5.1           23/12/94  J.M. HERVOUET (LNH)  30 87 80 18
C***********************************************************************
C
C    FONCTION : VOIR UM1X
C
C-----------------------------------------------------------------------
C                             ARGUMENTS
C .________________.____.______________________________________________.
C |      NOM       |MODE|                   ROLE                       |
C |________________|____|______________________________________________|
C |   X1,2,3       |<-->|  X ET X' (TRAITEMENT SUR PLACE).
C |   D12,D13,D23  | -->|  DIAGONALES SUPERIEURES.
C |________________|____|______________________________________________
C MODE : -->(DONNEE NON MODIFIEE), <--(RESULTAT), <-->(DONNEE MODIFIEE)
C-----------------------------------------------------------------------
C
C PROGRAMMES APPELES : OS
C
C**********************************************************************
C
      USE BIEF, EX_UM1X09 => UM1X09
C
      IMPLICIT NONE
      INTEGER LNG,LU
      COMMON/INFO/LNG,LU
C
C+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+      
C
      TYPE(BIEF_OBJ), INTENT(INOUT) :: X1,X2
      TYPE(BIEF_OBJ), INTENT(IN)    :: X3,D12,D13,D23
C
C+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+      
C
      CALL OS( 'X=X-YZ  ' , X=X2 , Y=X3 , Z=D23 )
      CALL OS( 'X=X-YZ  ' , X=X1 , Y=X2 , Z=D12 )
      CALL OS( 'X=X-YZ  ' , X=X1 , Y=X3 , Z=D13 )
C
C-----------------------------------------------------------------------
C
      RETURN
      END 
 
 
