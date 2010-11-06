C                       *****************
                        SUBROUTINE MT08BA
C                       *****************
C
     *(  A11 , A12 , A13 ,
     *   A21 , A22 , A23 ,
     *   A31 , A32 , A33 ,
     *   A41 , A42 , A43 ,
     *   XMUL,SF,F,XEL,YEL,IKLE1,IKLE2,IKLE3,IKLE4,
     *   NELEM,NELMAX,ICOORD)
C
C***********************************************************************
C BIEF VERSION 5.1           09/12/94    J-M HERVOUET (LNH) 30 87 80 18
C                                          C MOULIN   (LNH) 30 87 83 81
C***********************************************************************
C
C  FONCTION : CALCUL DES COEFFICIENTS DE LA MATRICE SUIVANTE
C
C  EXEMPLE AVEC ICOORD = 1
C
C                  /                     D
C A(I,J)= -XMUL   /  PSI2(J) *    F    * --( PSI1(I) ) D(OMEGA)
C                /OMEGA                  DX
C
C  ATTENTION AU SIGNE MOINS ||
C
C  AVEC ICOORD=2 ON AURAIT UNE DERIVEE SUIVANT Y
C
C  PSI1 : BASES DE TYPE TRIANGLE QUASI-BULLE
C  PSI2 : BASES DE TYPE TRIANGLE P1
C
C-----------------------------------------------------------------------
C                             ARGUMENTS
C .________________.____.______________________________________________.
C |      NOM       |MODE|                   ROLE                       |
C |________________|____|______________________________________________|
C |     A11,A12... |<-- |  ELEMENTS DE LA MATRICE
C |     XMUL       | -->|  FACTEUR MULTIPLICATIF
C |     SF,SG,SH   | -->|  STRUCTURES DE F,G ET H.
C |     SU,SV,SW   | -->|  STRUCTURES DE U,V ET W.
C |     F,G,H      | -->|  FONCTIONS INTERVENANT DANS LE CALCUL DE LA
C |                |    |  MATRICE.
C |     U,V,W      | -->|  COMPOSANTES D'UN VECTEUR INTERVENANT DANS LE
C |                |    |  CALCUL DE LA MATRICE.
C |     XEL,YEL,ZEL| -->|  COORDONNEES DES POINTS DANS L'ELEMENT
C |     SURFAC     | -->|  SURFACE DES TRIANGLES.
C |     IKLE1..3   | -->|  PASSAGE DE LA NUMEROTATION LOCALE A GLOBALE
C |     NELEM      | -->|  NOMBRE D'ELEMENTS DU MAILLAGE
C |     NELMAX     | -->|  NOMBRE MAXIMUM D'ELEMENTS DU MAILLAGE
C |                |    |  (CAS D'UN MAILLAGE ADAPTATIF)
C |     ICOORD     | -->|  1: DERIVEE SUIVANT X, 2:SUIVANT Y
C |________________|____|______________________________________________
C MODE : -->(DONNEE NON MODIFIEE), <--(RESULTAT), <-->(DONNEE MODIFIEE)
C-----------------------------------------------------------------------
C
C PROGRAMMES APPELES : ASSVEC , OV
C
C-----------------------------------------------------------------------
C     -------------
C     | ATTENTION | : LE JACOBIEN DOIT ETRE POSITIF .
C     -------------
C**********************************************************************
C
      USE BIEF, EX_MT08BA => MT08BA
C
      IMPLICIT NONE
      INTEGER LNG,LU
      COMMON/INFO/LNG,LU
C
C+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
C
      INTEGER, INTENT(IN) :: NELEM,NELMAX,ICOORD
      INTEGER, INTENT(IN) :: IKLE1(NELMAX),IKLE2(NELMAX)
      INTEGER, INTENT(IN) :: IKLE3(NELMAX),IKLE4(NELMAX)
C
      DOUBLE PRECISION, INTENT(INOUT) :: A11(*),A12(*),A13(*)
      DOUBLE PRECISION, INTENT(INOUT) :: A21(*),A22(*),A23(*)
      DOUBLE PRECISION, INTENT(INOUT) :: A31(*),A32(*),A33(*)
      DOUBLE PRECISION, INTENT(INOUT) :: A41(*),A42(*),A43(*)
C
      DOUBLE PRECISION, INTENT(IN) :: XMUL
      DOUBLE PRECISION, INTENT(IN) :: F(*)
C
C     STRUCTURE DE F
      TYPE(BIEF_OBJ), INTENT(IN) :: SF
C
      DOUBLE PRECISION, INTENT(IN) :: XEL(NELMAX,3),YEL(NELMAX,3)     
C
C+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
C
      INTEGER IELEM,IELMF
      DOUBLE PRECISION X2,X3,Y2,Y3,F1,F2,F3,F4,XSUR18,XSUR72,XSU216
C
C-----------------------------------------------------------------------
C
      IELMF=SF%ELM
C
      XSUR18 = XMUL / 18.D0
      XSUR72 = XMUL / 72.D0
      XSU216 = XMUL / 216.D0
C
C-----------------------------------------------------------------------
C  CAS OU F EST DE DISCRETISATION P1
C-----------------------------------------------------------------------
C
      IF(IELMF.EQ.11) THEN
C
C================================
C  CAS DE LA DERIVEE SUIVANT X  =
C================================
C
        IF(ICOORD.EQ.1) THEN
C
C   BOUCLE SUR LES ELEMENTS
C
        DO 1 IELEM = 1 , NELEM
C
C   INITIALISATION DES VARIABLES GEOMETRIQUES
C
        Y2 = YEL(IELEM,2)
        Y3 = YEL(IELEM,3)
C
        F1  =  F(IKLE1(IELEM))
        F2  =  F(IKLE2(IELEM))
        F3  =  F(IKLE3(IELEM))
C
C   TERMES EXTRADIAGONAUX
C
        A12(IELEM)=(5*Y3*F3+10*Y3*F2+9*Y3*F1-5*Y2*F3-18*Y2*
     *   F2-13*Y2*F1)*XSU216
        A13(IELEM)=(18*Y3*F3+5*Y3*F2+13*Y3*F1-10*Y2*F3-5*Y2*
     *   F2-9*Y2*F1)*XSU216
        A21(IELEM)=-(5*Y3*F3+9*Y3*F2+10*Y3*F1+4*Y2*F2+8*Y2*F1)*XSU216
        A23(IELEM)=-(18*Y3*F3+13*Y3*F2+5*Y3*F1-8*Y2*F3-4*Y2*F2)*XSU216
        A31(IELEM)=(4*Y3*F3+8*Y3*F1+9*Y2*F3+5*Y2*F2+10*Y2*F1)*XSU216
        A32(IELEM)=-(4*Y3*F3+8*Y3*F2-13*Y2*F3-18*Y2*F2-5*Y2*F1)*XSU216
        A41(IELEM)=-(Y3*F3+2*Y3*F1-Y2*F2-2*Y2*F1)*XSUR18
        A42(IELEM)=(Y3*F3+2*Y3*F2-Y2*F3+Y2*F1)*XSUR18
        A43(IELEM)=(Y3*F2-Y3*F1-2*Y2*F3-Y2*F2)*XSUR18
C
C   TERMES DIAGONAUX
C   LA SOMME DE CHAQUE COLONNE EST NULLE
C
        A11(IELEM) = - A21(IELEM) - A31(IELEM) - A41(IELEM)
        A22(IELEM) = - A12(IELEM) - A32(IELEM) - A42(IELEM)
        A33(IELEM) = - A13(IELEM) - A23(IELEM) - A43(IELEM)
C
1     CONTINUE
C
        ELSEIF(ICOORD.EQ.2) THEN
C
C================================
C  CAS DE LA DERIVEE SUIVANT Y  =
C================================
C
        DO 2 IELEM = 1 , NELEM
C
C   INITIALISATION DES VARIABLES GEOMETRIQUES
C
        X2  =  XEL(IELEM,2)
        X3  =  XEL(IELEM,3)
C
        F1  =  F(IKLE1(IELEM))
        F2  =  F(IKLE2(IELEM))
        F3  =  F(IKLE3(IELEM))
C
C   TERMES EXTRADIAGONAUX
C
        A12(IELEM)=(5*X2*F3+18*X2*F2+13*X2*F1-5*X3*F3-10*X3*
     *   F2-9*X3*F1)*XSU216
        A13(IELEM)=(10*X2*F3+5*X2*F2+9*X2*F1-18*X3*F3-5*X3*
     *   F2-13*X3*F1)*XSU216
        A21(IELEM)=(4*X2*F2+8*X2*F1+5*X3*F3+9*X3*F2+10*X3*F1 )*XSU216
        A23(IELEM)=-(8*X2*F3+4*X2*F2-18*X3*F3-13*X3*F2-5*X3*F1)*XSU216
        A31(IELEM)=-(9*X2*F3+5*X2*F2+10*X2*F1+4*X3*F3+8*X3*F1)*XSU216
        A32(IELEM)=-(13*X2*F3+18*X2*F2+5*X2*F1-4*X3*F3-8*X3*F2)*XSU216
        A41(IELEM)=-(X2*F2+2*X2*F1-X3*F3-2*X3*F1)*XSUR18
        A42(IELEM)=(X2*F3-X2*F1-X3*F3-2*X3*F2)*XSUR18
        A43(IELEM)=(2*X2*F3+X2*F2-X3*F2+X3*F1)*XSUR18
C
C   TERMES DIAGONAUX
C   LA SOMME DE CHAQUE COLONNE EST NULLE
C
        A11(IELEM) = - A21(IELEM) - A31(IELEM) - A41(IELEM)
        A22(IELEM) = - A12(IELEM) - A32(IELEM) - A42(IELEM)
        A33(IELEM) = - A13(IELEM) - A23(IELEM) - A43(IELEM)
C
2       CONTINUE
C
        ELSE
C
          IF (LNG.EQ.1) WRITE(LU,200) ICOORD
          IF (LNG.EQ.2) WRITE(LU,201) ICOORD
          CALL PLANTE(0)
          STOP
        ENDIF
C
C
C-----------------------------------------------------------------------
C  CAS OU F EST DE DISCRETISATION QUASI-BULLE
C-----------------------------------------------------------------------
C
      ELSEIF(IELMF.EQ.12) THEN
C
C================================
C  CAS DE LA DERIVEE SUIVANT X  =
C================================
C
        IF(ICOORD.EQ.1) THEN
C
C   BOUCLE SUR LES ELEMENTS
C
        DO 3 IELEM = 1 , NELEM
C
C   INITIALISATION DES VARIABLES GEOMETRIQUES
C
        Y2 = YEL(IELEM,2)
        Y3 = YEL(IELEM,3)
C
        F1  =  F(IKLE1(IELEM))
        F2  =  F(IKLE2(IELEM))
        F3  =  F(IKLE3(IELEM))
        F4  =  F(IKLE4(IELEM))
C
C   TERMES EXTRADIAGONAUX
C
        A12(IELEM)=((2*Y3-Y2)*(F3+2*F4+F1)+(Y3-2*Y2)*(5*F4+7
     *   *F2+4*F1))*XSU216
        A13(IELEM)=((2*Y3-Y2)*(7*F3+5*F4+4*F1)+(Y3-2*Y2)*(2
     *   *F4+F2+F1))*XSU216
        A21(IELEM)=-((2*Y3-Y2)*(F3+2*F4+F2)+(Y3+Y2)*(5*F4+4*
     *   F2+7*F1))*XSU216
        A23(IELEM)=-((2*Y3-Y2)*(7*F3+5*F4+4*F2)+(Y3+Y2)*(2*
     *   F4+F2+F1))*XSU216
        A31(IELEM)=((Y3+Y2)*(4*F3+5*F4+7*F1)-(Y3-2*Y2)*(F3+2
     *   *F4+F2))*XSU216
        A32(IELEM)=((Y3+Y2)*(F3+2*F4+F1)-(Y3-2*Y2)*(4*F3+5*F4
     *   +7*F2))*XSU216
        A41(IELEM)=-(3*Y3*F3+3*Y3*F4-Y3*F2+7*Y3*F1+Y2*F3-3*Y2
     *   *F4-3*Y2*F2-7*Y2*F1)*XSUR72
        A42(IELEM)=(3*Y3*F3+3*Y3*F4+7*Y3*F2-Y3*F1-4*Y2*F3+4*
     *   Y2*F1)*XSUR72
        A43(IELEM)=(4*Y3*F2-4*Y3*F1-7*Y2*F3-3*Y2*F4-3*Y2*F2+
     *   Y2*F1)*XSUR72
C
C   TERMES DIAGONAUX
C   LA SOMME DE CHAQUE COLONNE EST NULLE
C
        A11(IELEM) = - A21(IELEM) - A31(IELEM) - A41(IELEM)
        A22(IELEM) = - A12(IELEM) - A32(IELEM) - A42(IELEM)
        A33(IELEM) = - A13(IELEM) - A23(IELEM) - A43(IELEM)
C
3       CONTINUE
C
        ELSEIF(ICOORD.EQ.2) THEN
C
C================================
C  CAS DE LA DERIVEE SUIVANT Y  =
C================================
C
        DO 4 IELEM = 1 , NELEM
C
C   INITIALISATION DES VARIABLES GEOMETRIQUES
C
        X2  =  XEL(IELEM,2)
        X3  =  XEL(IELEM,3)
C
        F1  =  F(IKLE1(IELEM))
        F2  =  F(IKLE2(IELEM))
        F3  =  F(IKLE3(IELEM))
        F4  =  F(IKLE4(IELEM))
C
C   TERMES EXTRADIAGONAUX
C
        A12(IELEM)=((F3+2*F4+F1)*X2-2*(F3+2*F4+F1)*X3+2*(5*
     *   F4+7*F2+4*F1)*X2-(5*F4+7*F2+4*F1)*X3)*XSU216
        A13(IELEM)=((7*F3+5*F4+4*F1)*X2-2*(7*F3+5*F4+4*F1)
     *   *X3+2*(2*F4+F2+F1)*X2-(2*F4+F2+F1)*X3)*XSU216
        A21(IELEM)=-((F3+2*F4+F2)*X2-2*(F3+2*F4+F2)*X3-(5*F4+
     *   4*F2+7*F1)*X2-(5*F4+4*F2+7*F1)*X3)*XSU216
        A23(IELEM)=-((7*F3+5*F4+4*F2)*X2-2*(7*F3+5*F4+4*F2
     *   )*X3-(2*F4+F2+F1)*X2-(2*F4+F2+F1)*X3)*XSU216
        A31(IELEM)=-((4*F3+5*F4+7*F1)*X2+(4*F3+5*F4+7*F1)*
     *   X3+2*(F3+2*F4+F2)*X2-(F3+2*F4+F2)*X3)*XSU216
        A32(IELEM)=-(2*(4*F3+5*F4+7*F2)*X2-(4*F3+5*F4+7*F2
     *   )*X3+(F3+2*F4+F1)*X2+(F3+2*F4+F1)*X3)*XSU216
        A41(IELEM)=(X2*F3-3*X2*F4-3*X2*F2-7*X2*F1+3*X3*F3+3*
     *   X3*F4-X3*F2+7*X3*F1)*XSUR72
        A42(IELEM)=(4*X2*F3-4*X2*F1-3*X3*F3-3*X3*F4-7*X3*F2+
     *   X3*F1)*XSUR72
        A43(IELEM)=(7*X2*F3+3*X2*F4+3*X2*F2-X2*F1-4*X3*F2+4*
     *   X3*F1)*XSUR72
C
C   TERMES DIAGONAUX
C   LA SOMME DE CHAQUE COLONNE EST NULLE
C
        A11(IELEM) = - A21(IELEM) - A31(IELEM) - A41(IELEM)
        A22(IELEM) = - A12(IELEM) - A32(IELEM) - A42(IELEM)
        A33(IELEM) = - A13(IELEM) - A23(IELEM) - A43(IELEM)
C
4       CONTINUE
C
        ELSE
C
          IF (LNG.EQ.1) WRITE(LU,200) ICOORD
          IF (LNG.EQ.2) WRITE(LU,201) ICOORD
          CALL PLANTE(0)
          STOP
        ENDIF
C
C-----------------------------------------------------------------------
C
      ELSE
       IF (LNG.EQ.1) WRITE(LU,100) IELMF
       IF (LNG.EQ.2) WRITE(LU,101) IELMF
100    FORMAT(1X,'MT08BA (BIEF) :',/,
     *        1X,'DISCRETISATION DE F : ',1I6,' NON PREVUE')
101    FORMAT(1X,'MT08BA (BIEF) :',/,
     *        1X,'DISCRETIZATION OF F : ',1I6,' NOT AVAILABLE')
       CALL PLANTE(0)
       STOP
      ENDIF
C
200       FORMAT(1X,'MT08BA (BIEF) : COMPOSANTE IMPOSSIBLE ',
     *              1I6,' VERIFIER ICOORD')
201       FORMAT(1X,'MT08BA (BIEF) : IMPOSSIBLE COMPONENT ',
     *              1I6,' CHECK ICOORD')
C
C-----------------------------------------------------------------------
C
      RETURN
      END  
 
 
