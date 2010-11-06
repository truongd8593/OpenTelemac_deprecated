C                       *****************
                        SUBROUTINE VC08PP
C                       *****************
C
     *( XMUL,SF,SU,SV,SW,F,U,V,W,X,Y,Z,
     *  IKLE1,IKLE2,IKLE3,IKLE4,IKLE5,IKLE6,NELEM,NELMAX,
     *  W1,W2,W3,W4,W5,W6 )
C
C***********************************************************************
C BIEF VERSION 5.1           23/02/96    J-M HERVOUET (LNH) 30 87 80 18
C
C***********************************************************************
C
C FONCTION : CALCUL DU VECTEUR SUIVANT EN ELEMENTS FINIS :
C
C
C                    /                  DF      DF
C      V  =  XMUL   /       PSII  * ( U --  + V -- )   D(OMEGA)
C       I          /OMEGA               DX      DY
C
C
C    PSI(I) EST UNE BASE DE TYPE PRISME P1
C
C    ATTENTION : LE RESULTAT EST DANS W  SOUS FORME NON ASSEMBLEE.
C
C                MAILLAGE REEL
C
C
C-----------------------------------------------------------------------
C                             ARGUMENTS
C .________________.____.______________________________________________.
C |      NOM       |MODE|                   ROLE                       |
C |________________|____|______________________________________________|
C |      XMUL      | -->|  COEFFICIENT MULTIPLICATEUR.
C |      SF,SG,SH  | -->|  STRUCTURES DES FONCTIONS F,G ET H
C |      SU,SV,SW  | -->|  STRUCTURES DES FONCTIONS U,V ET W
C |      F,G,H     | -->|  FONCTIONS INTERVENANT DANS LA FORMULE.
C |      U,V,W     | -->|  COMPOSANTES D'UN VECTEUR
C |                |    |  INTERVENANT DANS LA FORMULE.
C |      X,Y,Z     | -->|  COORDONNEES DES POINTS
C |      SURFAC    | -->|  SURFACE DES ELEMENTS.
C |      IKLE1,... | -->|  PASSAGE DE LA NUMEROTATION LOCALE A GLOBALE.
C |      NELEM     | -->|  NOMBRE D'ELEMENTS DU MAILLAGE.
C |      NELMAX    | -->|  NOMBRE MAXIMUM D'ELEMENTS DU MAILLAGE.
C |                |    |  (CAS D'UN MAILLAGE ADAPTATIF)
C |      W1,2,3    | -->|  VECTEUR RESULTAT SOUS FORME NON ASSEMBLEE.
C |________________|____|_______________________________________________
C MODE : -->(DONNEE NON MODIFIEE), <--(RESULTAT), <-->(DONNEE MODIFIEE)
C-----------------------------------------------------------------------
C
C  PROGRAMMES APPELES : ASSVEC
C
C-----------------------------------------------------------------------
C     -------------
C     | ATTENTION | : LE JACOBIEN DOIT ETRE POSITIF .
C     -------------
C**********************************************************************
C
      USE BIEF, EX_VC08PP => VC08PP
C
      IMPLICIT NONE
      INTEGER LNG,LU
      COMMON/INFO/LNG,LU
C
C+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
C
      INTEGER, INTENT(IN) :: NELEM,NELMAX
      INTEGER, INTENT(IN) :: IKLE1(NELMAX),IKLE2(NELMAX),IKLE3(NELMAX)
      INTEGER, INTENT(IN) :: IKLE4(NELMAX),IKLE5(NELMAX),IKLE6(NELMAX)
C
      DOUBLE PRECISION, INTENT(IN) :: X(*),Y(*),Z(*)
      DOUBLE PRECISION, INTENT(IN) :: XMUL
      DOUBLE PRECISION, INTENT(INOUT)::W1(NELMAX),W2(NELMAX),W3(NELMAX)
      DOUBLE PRECISION, INTENT(INOUT)::W4(NELMAX),W5(NELMAX),W6(NELMAX)
C
C     STRUCTURES DE F,U,V ET DONNEES REELLES
C
      TYPE(BIEF_OBJ), INTENT(IN) :: SF,SU,SV,SW
      DOUBLE PRECISION, INTENT(IN) ::F(*),U(*),V(*),W(*)
C
C+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
C
      DOUBLE PRECISION X2,X3,Y2,Y3,DEN
      DOUBLE PRECISION PZ1,PX1,PX2,PX3,PY1,PY2,PY3
      DOUBLE PRECISION PXFI,PXFS,PYFI,PYFS
      DOUBLE PRECISION U1,U2,U3,U4,U5,U6,V1,V2,V3,V4,V5,V6
      DOUBLE PRECISION Q1,Q2,Q3,Q4,Q5,Q6,H1,H2,H3,HT
      DOUBLE PRECISION F1,F2,F3,F4,F5,F6
      DOUBLE PRECISION INT1,INT2,INT3,INT4,INT5,INT6
      DOUBLE PRECISION SUS,SUI,SHUI,SHUS
      DOUBLE PRECISION SHUI1,SHUS1,SHUI2,SHUS2,SHUI3,SHUS3
      DOUBLE PRECISION HU1S3I,HU1I3S,HU1SI,HU2S3I,HU2I3S,HU2SI
      DOUBLE PRECISION HU3S3I,HU3I3S,HU3SI
      DOUBLE PRECISION SVS,SVI,SHVI,SHVS
      DOUBLE PRECISION SHVI1,SHVS1,SHVI2,SHVS2,SHVI3,SHVS3
      DOUBLE PRECISION HV1S3I,HV1I3S,HV1SI,HV2S3I,HV2I3S,HV2SI
      DOUBLE PRECISION HV3S3I,HV3I3S,HV3SI
      DOUBLE PRECISION W14,W41,W25,W52,W63,W36
C
      INTEGER I1,I2,I3,I4,I5,I6,IELEM,IELMF,IELMU,IELMV,IELMW
C
C**********************************************************************
C
      DEN = XMUL/1440.D0
C
      IELMF=SF%ELM
      IELMU=SU%ELM
      IELMV=SV%ELM
      IELMW=SW%ELM
C
C-----------------------------------------------------------------------
C
C     FONCTION F ET VECTEUR U LINEAIRES
C
      IF(IELMU.EQ.41.AND.IELMV.EQ.41.AND.IELMW.EQ.41
     *              .AND.IELMF.EQ.41) THEN
C
C        BOUCLE SUR LES ELEMENTS
C
         DO 2 IELEM = 1,NELEM
C
            I1 = IKLE1(IELEM)
            I2 = IKLE2(IELEM)
            I3 = IKLE3(IELEM)
            I4 = IKLE4(IELEM)
            I5 = IKLE5(IELEM)
            I6 = IKLE6(IELEM)
C
            X2  =   X(I2) - X(I1)
            X3  =   X(I3) - X(I1)
            Y2  =   Y(I2) - Y(I1)
            Y3  =   Y(I3) - Y(I1)
C
            U1  =  U(I1)
            U2  =  U(I2)
            U3  =  U(I3)
            U4  =  U(I4)
            U5  =  U(I5)
            U6  =  U(I6)
            V1  =  V(I1)
            V2  =  V(I2)
            V3  =  V(I3)
            V4  =  V(I4)
            V5  =  V(I5)
            V6  =  V(I6)
            Q1  =  W(I1)
            Q2  =  W(I2)
            Q3  =  W(I3)
            Q4  =  W(I4)
            Q5  =  W(I5)
            Q6  =  W(I6)
            F1  =  F(I1)
            F2  =  F(I2)
            F3  =  F(I3)
            F4  =  F(I4)
            F5  =  F(I5)
            F6  =  F(I6)
C
            H1  =  Z(I4)-Z(I1)
            H2  =  Z(I5)-Z(I2)
            H3  =  Z(I6)-Z(I3)
C
C    CALCULS INTERMEDIAIRES
C
            PX2=Y3*DEN
            PX3=-Y2*DEN
            PX1=-PX2-PX3
            PY2=-X3*DEN
            PY3=X2*DEN
            PY1=-PY3-PY2
            PZ1=-DEN*(X2*Y3-Y2*X3)*2
C
            HT = H1+H2+H3
            SUS = U6+U5+U4
            SUI = U3+U2+U1
            SHUI = H3*U3+H2*U2+H1*U1
            SHUS = H3*U6+H2*U5+H1*U4
            SHUS1 = (HT+H1)*(SUS+U4)+SHUS+U4*H1
            SHUI1 = (HT+H1)*(SUI+U1)+SHUI+U1*H1
            SHUS2 = (HT+H2)*(SUS+U5)+SHUS+U5*H2
            SHUI2 = (HT+H2)*(SUI+U2)+SHUI+U2*H2
            SHUS3 = (HT+H3)*(SUS+U6)+SHUS+U6*H3
            SHUI3 = (HT+H3)*(SUI+U3)+SHUI+U3*H3
            HU1S3I = SHUS1+3*SHUI1
            HU1I3S = SHUI1+3*SHUS1
            HU1SI = SHUS1+SHUI1
            HU2S3I = SHUS2+3*SHUI2
            HU2I3S = SHUI2+3*SHUS2
            HU2SI = SHUS2+SHUI2
            HU3S3I = SHUS3+3*SHUI3
            HU3I3S = SHUI3+3*SHUS3
            HU3SI = SHUS3+SHUI3
C
            SVS = V6+V5+V4
            SVI = V3+V2+V1
            SHVI = H3*V3+H2*V2+H1*V1
            SHVS = H3*V6+H2*V5+H1*V4
            SHVS1 = (HT+H1)*(SVS+V4)+SHVS+V4*H1
            SHVI1 = (HT+H1)*(SVI+V1)+SHVI+V1*H1
            SHVS2 = (HT+H2)*(SVS+V5)+SHVS+V5*H2
            SHVI2 = (HT+H2)*(SVI+V2)+SHVI+V2*H2
            SHVS3 = (HT+H3)*(SVS+V6)+SHVS+V6*H3
            SHVI3 = (HT+H3)*(SVI+V3)+SHVI+V3*H3
            HV1S3I = SHVS1+3*SHVI1
            HV1I3S = SHVI1+3*SHVS1
            HV1SI = SHVS1+SHVI1
            HV2S3I = SHVS2+3*SHVI2
            HV2I3S = SHVI2+3*SHVS2
            HV2SI = SHVS2+SHVI2
            HV3S3I = SHVS3+3*SHVI3
            HV3I3S = SHVI3+3*SHVS3
            HV3SI = SHVS3+SHVI3
C
            W14 = Q1+2*Q4
            W41 = Q4+2*Q1
            W25 = Q2+2*Q5
            W52 = Q5+2*Q2
            W63 = Q6+2*Q3
            W36 = Q3+2*Q6
C
            INT1=2*(3*W41+W52+W63)
            INT2=2*(W41+W52)+W63
            INT3=2*(W41+W63)+W52
            INT4=2*(W41+3*W52+W63)
            INT5=2*(W52+W63)+W41
            INT6=2*(W41+W52+3*W63)
            W1(IELEM)=PZ1*((F1-F4)*INT1+(F2-F5)*INT2+(F3-F6)*INT3)
            W2(IELEM)=PZ1*((F1-F4)*INT2+(F2-F5)*INT4+(F3-F6)*INT5)
            W3(IELEM)=PZ1*((F1-F4)*INT3+(F2-F4)*INT5+(F3-F6)*INT6)
C
            INT1=2*(3*W14+W25+W36)
            INT2=2*(W14+W25)+W36
            INT3=2*(W14+W36)+W25
            INT4=2*(W14+3*W25+W36)
            INT5=2*(W25+W36)+W14
            INT6=2*(W14+W25+3*W36)
            W4(IELEM)=PZ1*((F1-F4)*INT1+(F2-F5)*INT2+(F3-F6)*INT3)
            W5(IELEM)=PZ1*((F1-F4)*INT2+(F2-F5)*INT4+(F3-F6)*INT5)
            W6(IELEM)=PZ1*((F1-F4)*INT3+(F2-F4)*INT5+(F3-F6)*INT6)
C
            PXFI=PX1*F1+PX2*F2+PX3*F3
            PXFS=PX1*F4+PX2*F5+PX3*F6
            PYFI=PY1*F1+PY2*F2+PY3*F3
            PYFS=PY1*F4+PY2*F5+PY3*F6
C
            W1(IELEM)=W1(IELEM)+PXFI*HU1S3I+PYFI*HV1S3I
     *                         +PXFS* HU1SI+PYFS* HV1SI
            W2(IELEM)=W2(IELEM)+PXFI*HU2S3I+PYFI*HV2S3I
     *                         +PXFS* HU2SI+PYFS* HV2SI
            W3(IELEM)=W3(IELEM)+PXFI*HU3S3I+PYFI*HV3S3I
     *                         +PXFS* HU3SI+PYFS* HV3SI
            W4(IELEM)=W4(IELEM)+PXFI* HU1SI+PYFI* HV1SI
     *                         +PXFS*HU1I3S+PYFS*HV1I3S
            W5(IELEM)=W5(IELEM)+PXFI* HU2SI+PYFI* HV2SI
     *                         +PXFS*HU2I3S+PYFS*HV2I3S
            W6(IELEM)=W6(IELEM)+PXFI* HU3SI+PYFI* HV3SI
     *                         +PXFS*HU3I3S+PYFS*HV3I3S
C
2        CONTINUE
C
C-----------------------------------------------------------------------
C
      ELSE
C
C-----------------------------------------------------------------------
C
         IF (LNG.EQ.1) WRITE(LU,100) IELMF,SF%NAME
         IF (LNG.EQ.1) WRITE(LU,200) IELMU,SU%NAME
         IF (LNG.EQ.1) WRITE(LU,300)
         IF (LNG.EQ.2) WRITE(LU,101) IELMF,SF%NAME
         IF (LNG.EQ.2) WRITE(LU,201) IELMU,SU%NAME
         IF (LNG.EQ.2) WRITE(LU,301)
100      FORMAT(1X,'VC08PP (BIEF) :',/,
     *          1X,'DISCRETISATION DE F : ',1I6,
     *          1X,'NOM REEL : ',A6)
200      FORMAT(1X,'DISCRETISATION DE U : ',1I6,
     *          1X,'NOM REEL : ',A6)
300      FORMAT(1X,'CAS NON PREVU')
101      FORMAT(1X,'VC08PP (BIEF) :',/,
     *          1X,'DISCRETIZATION OF F:',1I6,
     *          1X,'REAL NAME: ',A6)
201      FORMAT(1X,'DISCRETIZATION OF U:',1I6,
     *          1X,'REAL NAME: ',A6)
301      FORMAT(1X,'CASE NOT IMPLEMENTED')
         CALL PLANTE(1)
         STOP
C
      ENDIF
C
C-----------------------------------------------------------------------
C
      RETURN
      END  
 
 
