C                       *****************
                        SUBROUTINE GTSH13
C                       *****************
C
     *(U,V,X,Y,SHP,ELT,IKLE,INDIC,NLOC,NPOIN,
     * NELEM,NELMAX,LV,MSK,MASKEL)
C
C
C  A SUPPRIMER : U,V,X,Y,INDIC,NLOC,LV
C
C***********************************************************************
C BIEF VERSION 5.9           08/08/08    ALGIANE FROEHLY (MATMECA)
C
C***********************************************************************
C
C      FONCTION:
C
C   - FIXE, POUR LES TRIANGLES P1 DE TELEMAC-2D ET,
C     AVANT LA REMONTEE DES COURBES CARACTERISTIQUES,
C     LES COORDONNEES BARYCENTRIQUES DE TOUS LES NOEUDS DU
C     MAILLAGE DANS L'ELEMENT VERS OU POINTE CETTE COURBE.
C
C-----------------------------------------------------------------------
C                             ARGUMENTS
C .________________.____.______________________________________________.
C |      NOM       |MODE|                   ROLE                       |
C |________________|____|______________________________________________|
C |    U,V         | -->| COMPOSANTES DE LA VITESSE                    |
C |    X,Y         | -->| COORDONNEES DES POINTS DU MAILLAGE.          |
C |    SHP         |<-- | COORDONNEES BARYCENTRIQUES DES NOEUDS DANS   |
C |                |    | LEURS ELEMENTS "ELT" ASSOCIES.               |
C |    ELT         |<-- | NUMEROS DES ELEMENTS CHOISIS POUR CHAQUE     |
C |                |    | NOEUD.                                       |
C |    IKLE        | -->| TRANSITION ENTRE LES NUMEROTATIONS LOCALE    |
C |                |    | ET GLOBALE.                                  |
C |    NPOIN       | -->| NOMBRE DE POINTS.                            |
C |    NELEM       | -->| NOMBRE D'ELEMENTS.                           |
C |    NELMAX      | -->| NOMBRE MAXIMAL D'ELEMENTS DANS LE MAILLAGE 2D|
C |    MSK         | -->| SI OUI, PRESENCE D'ELEMENTS MASQUES.         |
C |    MASKEL      | -->| TABLEAU DE MASQUAGE DES ELEMENTS             |
C |                |    |  =1. : NORMAL   =0. : ELEMENT MASQUE.        |
C |________________|____|______________________________________________|
C MODE : -->(DONNEE NON MODIFIEE), <--(RESULTAT), <-->(DONNEE MODIFIEE)
C
C-----------------------------------------------------------------------
C
C APPELE PAR : CARACT
C
C SOUS-PROGRAMME APPELE : NEANT
C
C***********************************************************************
C
      USE BIEF, EX_GTSH13 => GTSH13
C
      IMPLICIT NONE
      INTEGER LNG,LU
      COMMON/INFO/LNG,LU
C 
C+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
C
      INTEGER, INTENT(IN)    :: NPOIN,NELEM,NELMAX,LV
      INTEGER, INTENT(IN)    :: IKLE(NELMAX,6)
      INTEGER, INTENT(INOUT) :: ELT(NPOIN),INDIC(NPOIN),NLOC(NPOIN)
C
      DOUBLE PRECISION, INTENT(IN)    :: U(NPOIN),V(NPOIN)
      DOUBLE PRECISION, INTENT(IN)    :: X(*),Y(*)
      DOUBLE PRECISION, INTENT(INOUT) :: SHP(3,NPOIN)
      DOUBLE PRECISION, INTENT(IN)    :: MASKEL(NELMAX)
C
      LOGICAL, INTENT(IN) :: MSK
C
C+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
C
      INTEGER I,IELEM,IPOIN,N1,N2,N3,N4,N5,N6
C
C***********************************************************************
C
C     FIRST LOOP, TO GET AN ELEMENT FOR ALL POINTS
C
      DO IELEM = 1,NELEM
          N1=IKLE(IELEM,1)
          N2=IKLE(IELEM,2)
          N3=IKLE(IELEM,3)
          N4=IKLE(IELEM,4)
          N5=IKLE(IELEM,5)
          N6=IKLE(IELEM,6)
          SHP(1,N1)=1.D0
          SHP(2,N1)=0.D0
          SHP(3,N1)=0.D0
          SHP(1,N2)=0.D0
          SHP(2,N2)=1.D0
          SHP(3,N2)=0.D0
          SHP(1,N3)=0.D0
          SHP(2,N3)=0.D0
          SHP(3,N3)=1.D0
          SHP(1,N4)=0.5D0
          SHP(2,N4)=0.5D0
          SHP(3,N4)=0.D0
          SHP(1,N5)=0.D0
          SHP(2,N5)=0.5D0
          SHP(3,N5)=0.5D0
          SHP(1,N6)=0.5D0
          SHP(2,N6)=0.D0
          SHP(3,N6)=0.5D0
          ELT(N1)=IELEM
          ELT(N2)=IELEM
          ELT(N3)=IELEM
          ELT(N4)=IELEM
          ELT(N5)=IELEM
          ELT(N6)=IELEM
      ENDDO
C
C     SECOND LOOP IF MASKING, TO GET AN ELEMENT WHICH IS NOT MASKED,
C                             IF THERE IS ONE
C
      IF(MSK) THEN
        DO IELEM = 1,NELEM
          IF(MASKEL(IELEM).GT.0.5D0) THEN
            N1=IKLE(IELEM,1)
            N2=IKLE(IELEM,2)
            N3=IKLE(IELEM,3)
            N4=IKLE(IELEM,4)
            N5=IKLE(IELEM,5)
            N6=IKLE(IELEM,6)
            SHP(1,N1)=1.D0
            SHP(2,N1)=0.D0
            SHP(3,N1)=0.D0
            SHP(1,N2)=0.D0
            SHP(2,N2)=1.D0
            SHP(3,N2)=0.D0
            SHP(1,N3)=0.D0
            SHP(2,N3)=0.D0
            SHP(3,N3)=1.D0
            SHP(1,N4)=0.5D0
            SHP(2,N4)=0.5D0
            SHP(3,N4)=0.D0
            SHP(1,N5)=0.D0
            SHP(2,N5)=0.5D0
            SHP(3,N5)=0.5D0
            SHP(1,N6)=0.5D0
            SHP(2,N6)=0.D0
            SHP(3,N6)=0.5D0
            ELT(N1)=IELEM
            ELT(N2)=IELEM
            ELT(N3)=IELEM
            ELT(N4)=IELEM
            ELT(N5)=IELEM
            ELT(N6)=IELEM
          ENDIF
        ENDDO
      ENDIF
C
C-----------------------------------------------------------------------
C
      RETURN
      END
