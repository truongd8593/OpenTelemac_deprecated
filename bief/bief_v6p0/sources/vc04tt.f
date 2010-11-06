C                       *****************
                        SUBROUTINE VC04TT
C                       *****************
C
     *( XMUL,SU,SV,SW,U,V,W,X,Y,Z,
     *  IKLE1,IKLE2,IKLE3,IKLE4,NELEM,NELMAX,
     *  W1,W2,W3,W4,FORMUL)
C
C***********************************************************************
C BIEF VERSION 5.3           22/03/02    J-M HERVOUET (LNH) 30 87 80 18
C                                        
C***********************************************************************
C
C FONCTION : CALCUL DU VECTEUR SUIVANT EN ELEMENTS FINIS :
C
C
C
C                  /        D(PSII)       D(PSII)
C      V  = XMUL  /     U * ------- + V * -------   D(OMEGA)
C       I        /OMEGA       DX            DY
C
C                  /            D(PSII*)           D(PSII*)
C         = XMUL  /     H * U * -------- + H * V * --------   D(OMEGA*)
C                /OMEGA*           DX                 DY
C
C    LE TYPE DE DISCRETISATION DE PSII EST LE TETRAEDRE P1
C
C    ATTENTION : LE RESULTAT EST DANS W SOUS FORME NON ASSEMBLEE.
C
C                ICI MAILLAGE REEL, PEUT ETRE CONSIDERE COMME UN
C                CALCUL DANS LE MAILLAGE TRANSFORME, MAIS AVEC H
C                DANS L'INTEGRALE.
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
C |      XEL,YEL,..| -->|  COORDONNEES DES POINTS DANS L'ELEMENT
C |      SURFAC    | -->|  SURFACE DES ELEMENTS.
C |      IKLE1,... | -->|  PASSAGE DE LA NUMEROTATION LOCALE A GLOBALE.
C |      NELEM     | -->|  NOMBRE D'ELEMENTS DU MAILLAGE.
C |      NELMAX    | -->|  NOMBRE MAXIMUM D'ELEMENTS DU MAILLAGE.
C |                |    |  (CAS D'UN MAILLAGE ADAPTATIF)
C |      Q1,2,3    |<-- |  VECTEUR RESULTAT SOUS FORME NON ASSEMBLEE.
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
      USE BIEF, EX_VC04TT => VC04TT
C
      IMPLICIT NONE
      INTEGER LNG,LU
      COMMON/INFO/LNG,LU
C
C+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
C
      INTEGER, INTENT(IN) :: NELEM,NELMAX
      INTEGER, INTENT(IN) :: IKLE1(NELMAX),IKLE2(NELMAX)
      INTEGER, INTENT(IN) :: IKLE3(NELMAX),IKLE4(NELMAX)
C
      DOUBLE PRECISION, INTENT(IN) :: X(*),Y(*),Z(*)
      DOUBLE PRECISION, INTENT(INOUT) :: W1(NELMAX),W2(NELMAX)
      DOUBLE PRECISION, INTENT(INOUT) :: W3(NELMAX),W4(NELMAX)
      DOUBLE PRECISION, INTENT(IN) :: XMUL
C
      CHARACTER(LEN=16), INTENT(IN) :: FORMUL
C
C     STRUCTURES DE U,V ET DONNEES REELLES
C
      TYPE(BIEF_OBJ),   INTENT(IN) :: SU,SV,SW
      DOUBLE PRECISION, INTENT(IN) :: U(*),V(*),W(*)
C
C+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
C
      DOUBLE PRECISION XSUR24,X2,X3,X4,Y2,Y3,Y4,Z2,Z3,Z4
      DOUBLE PRECISION U1,U2,U3,U4,V1,V2,V3,V4,Q1,Q2,Q3,Q4
      INTEGER I1,I2,I3,I4,IELEM,IELMU,IELMV,IELMW
C
C**********************************************************************
C
      XSUR24 = XMUL / 24.D0
C
C-----------------------------------------------------------------------
C
      IELMU=SU%ELM
      IELMV=SV%ELM
      IELMW=SW%ELM
C
C-----------------------------------------------------------------------
C
C   TERMES HORIZONTAUX
C
      IF(FORMUL(14:16).EQ.'HOR') THEN
C
C   BOUCLE SUR LES ELEMENTS
C
      IF((IELMU.EQ.31.AND.IELMV.EQ.31).OR.
     *   (IELMU.EQ.51.AND.IELMV.EQ.51)     ) THEN
C
C-----------------------------------------------------------------------
C
C  U ET V DISCRETISEES EN PRISME P1 :
C
      DO 3 IELEM = 1 , NELEM
C
         I1 = IKLE1(IELEM)
         I2 = IKLE2(IELEM)
         I3 = IKLE3(IELEM)
         I4 = IKLE4(IELEM)
C
         X2 = X(I2) - X(I1)
         X3 = X(I3) - X(I1)
         X4 = X(I4) - X(I1)
C
         Y2 = Y(I2) - Y(I1)
         Y3 = Y(I3) - Y(I1)
         Y4 = Y(I4) - Y(I1)
C
         Z2 = Z(I2) - Z(I1)
         Z3 = Z(I3) - Z(I1)
         Z4 = Z(I4) - Z(I1)
C
         U1 = U(I1)
         U2 = U(I2)
         U3 = U(I3)
         U4 = U(I4)
         V1 = V(I1)
         V2 = V(I2)
         V3 = V(I3)
         V4 = V(I4)
C
         W1(IELEM) = XSUR24*(
     #U3*Z2*Y3+V4*X3*Z4-U4*Y3*Z4+U4*Z2*Y3+U4*Y4*Z3-U4*Z2*Y4-U4*
     #Y2*Z3+U1*Y4*Z3+V1*Z2*X4-V4*X2*Z4-U3*Z2*Y4-U2*Y2*Z3+V4*X2*Z3+V4*Z2*
     #X4-V4*X4*Z3+V2*Z2*X4-U2*Z2*Y4+U2*Y2*Z4+U2*Y4*Z3+U2*Z2*Y3-V1*Z2*X3+
     #V1*X2*Z3-V1*X4*Z3+V1*X3*Z4+U3*Y2*Z4+U3*Y4*Z3-V3*X2*Z4-V3*X4*Z3+V3*
     #X3*Z4-V3*Z2*X3+V3*X2*Z3+V3*Z2*X4+U1*Z2*Y3-U1*Y2*Z3+U1*Y2*Z4-V2*X2*
     #Z4-V2*X4*Z3-V2*Z2*X3+V2*X2*Z3-U3*Y2*Z3+V2*X3*Z4-V4*Z2*X3-U1*Y3*Z4+
     #U4*Y2*Z4-U3*Y3*Z4-V1*X2*Z4-U1*Z2*Y4-U2*Y3*Z4)
C
         W2(IELEM) = XSUR24*(
     #-U4*Y4*Z3+U4*Y3*Z4-V4*X3*Z4+V4*X4*Z3+U1*Y3*Z4-U1*Y4*Z3-V3
     #*X3*Z4+V3*X4*Z3+U3*Y3*Z4-U3*Y4*Z3-V1*X3*Z4+V1*X4*Z3+U2*Y3*Z4-U2*Y4
     #*Z3-V2*X3*Z4+V2*X4*Z3)
C
         W3(IELEM) = XSUR24*(
     #U4*Z2*Y4-U4*Y2*Z4-V4*Z2*X4+U3*Z2*Y4+V4*X2*Z4-V1*Z2*X4-U1*
     #Y2*Z4-V3*Z2*X4+V3*X2*Z4-U3*Y2*Z4+V1*X2*Z4-U2*Y2*Z4+U2*Z2*Y4-V2*Z2*
     #X4+V2*X2*Z4+U1*Z2*Y4)
C 
         W4(IELEM) = XSUR24*(
     #U4*Y2*Z3-U4*Z2*Y3+V4*Z2*X3-V4*X2*Z3+U1*Y2*Z3-U1*Z2*Y3+U3*
     #Y2*Z3-U3*Z2*Y3-V3*X2*Z3+V3*Z2*X3-V1*X2*Z3+V1*Z2*X3-U2*Z2*Y3+U2*Y2*
     #Z3-V2*X2*Z3+V2*Z2*X3)
C
3     CONTINUE
C
C-----------------------------------------------------------------------
C
C     ELSEIF(IELMU.EQ.  ) THEN
C
C-----------------------------------------------------------------------
C
      ELSE
C
C-----------------------------------------------------------------------
C
       IF (LNG.EQ.1) WRITE(LU,101) IELMU,SU%NAME
       IF (LNG.EQ.2) WRITE(LU,102) IELMU,SU%NAME
101    FORMAT(1X,'VC04TT (BIEF) :',/,
     *        1X,'DISCRETISATION DE U ET V : ',1I6,' CAS NON PREVU',/,
     *        1X,'NOM REEL DE U : ',A6)
102    FORMAT(1X,'VC04TT (BIEF) :',/,
     *        1X,'DISCRETISATION OF U ET V : ',1I6,' NOT IMPLEMENTED',/,
     *        1X,'REAL NAME OF U : ',A6)
       CALL PLANTE(1)
       STOP
C
      ENDIF
C
C-----------------------------------------------------------------------
C
      ELSEIF(FORMUL(14:16).EQ.'VER') THEN
C
      IF(IELMW.NE.31.AND.IELMW.NE.51) THEN
        IF (LNG.EQ.1) WRITE(LU,301) 
        IF (LNG.EQ.2) WRITE(LU,302) 
301     FORMAT(1X,'VC04TT (BIEF) :',/,
     *         1X,'CAS NON PREVU (IELMW.NE.31 ET .NE.51)')
302     FORMAT(1X,'VC04TT (BIEF) :',/,
     *         1X,'UNEXPECTED CASE (IELMW.NE.31 AND .NE.51)')
        CALL PLANTE(1)
        STOP
      ENDIF
C
      DO IELEM = 1 , NELEM
C
         I1 = IKLE1(IELEM)
         I2 = IKLE2(IELEM)
         I3 = IKLE3(IELEM)
         I4 = IKLE4(IELEM)
C
         X2 = X(I2) - X(I1)
         X3 = X(I3) - X(I1)
         X4 = X(I4) - X(I1)
C
         Y2 = Y(I2) - Y(I1)
         Y3 = Y(I3) - Y(I1)
         Y4 = Y(I4) - Y(I1)
C
         Q1 = W(I1)
         Q2 = W(I2)
         Q3 = W(I3)
         Q4 = W(I4)
C
         W1(IELEM) = (
     #         X4*Y3*Q4-Y2*X4*Q4+X2*Y4*Q4-X2*Y3*Q4-X3*Y4*Q4+Y2*X3*Q4-X2*
     #Y3*Q3-Y2*X4*Q3+X2*Y4*Q1-X3*Y4*Q3+X2*Y4*Q3+Y2*X3*Q3-X3*Y4*Q2+X4*Y3*
     #Q2+X2*Y4*Q2-Y2*X4*Q2-X2*Y3*Q2+Y2*X3*Q2+Y2*X3*Q1-Y2*X4*Q1-X2*Y3*Q1+
     #X4*Y3*Q3+X4*Y3*Q1-X3*Y4*Q1 )*XSUR24
C
         W2(IELEM) = (
     #         -X4*Y3*Q4+X3*Y4*Q4+X3*Y4*Q3+X3*Y4*Q2-X4*Y3*Q2-X4*Y3*Q3-X4
     #*Y3*Q1+X3*Y4*Q1 )*XSUR24
C
         W3(IELEM) = (
     #         Y2*X4*Q4-X2*Y4*Q4+Y2*X4*Q3-X2*Y4*Q1-X2*Y4*Q3-X2*Y4*Q2+Y2*
     #X4*Q2+Y2*X4*Q1 )*XSUR24
C
         W4(IELEM) = (
     #         X2*Y3*Q4-Y2*X3*Q4+X2*Y3*Q3-Y2*X3*Q3+X2*Y3*Q2-Y2*X3*Q2-Y2*
     #X3*Q1+X2*Y3*Q1 )*XSUR24       
C
      ENDDO
C
      ELSE
C
C-----------------------------------------------------------------------
C
       IF (LNG.EQ.1) WRITE(LU,201) FORMUL
       IF (LNG.EQ.2) WRITE(LU,202) FORMUL
201    FORMAT(1X,'VC04TT (BIEF) :',/,
     *        1X,'IL MANQUE HOR OU VER EN FIN DE FORMULE : ',A16)
202    FORMAT(1X,'VC04TT (BIEF):',/,
     *        1X,'HOR OR VER LACKING AT THE END OF THE FORMULA : ',A16)
       CALL PLANTE(1)
       STOP
C
C-----------------------------------------------------------------------
C
      ENDIF
C
C-----------------------------------------------------------------------
C
      RETURN
      END
