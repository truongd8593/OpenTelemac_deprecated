!                    *******************
                     SUBROUTINE VOISIN31
!                    *******************
!
     &(IFABOR,NELEM,NELMAX,IELM,IKLE,SIZIKL,
     & NPOIN,NACHB,NBOR,NPTFR,LIHBOR,KLOG,IKLESTR,NELEMTOTAL,NELEB2)
!
!***********************************************************************
! BIEF   V6P1                                   21/08/2010
!***********************************************************************
!
!brief    BUILDS THE ARRAY IFABOR, WHERE IFABOR(IELEM, IFACE) IS
!+                THE GLOBAL NUMBER OF THE NEIGHBOUR OF SIDE IFACE OF
!+                ELEMENT IELEM (IF THIS NEIGHBOUR EXISTS) AND 0 IF THE
!+                SIDE IS ON THE DOMAIN BOUNDARY.
!
!history  REGINA NEBAUER (LNHE)
!+        22/01/08
!+        V5P8
!+
!
!history  N.DURAND (HRW), S.E.BOURBAN (HRW)
!+        13/07/2010
!+        V6P0
!+   Translation of French comments within the FORTRAN sources into
!+   English comments
!
!history  N.DURAND (HRW), S.E.BOURBAN (HRW)
!+        21/08/2010
!+        V6P0
!+   Creation of DOXYGEN tags for automated documentation and
!+   cross-referencing of the FORTRAN sources
!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!| IELM           |-->| 31: TETRAHEDRA
!| IFABOR         |-->| ELEMENTS BEHIND THE EDGES OF A TRIANGLE
!|                |   | IF NEGATIVE OR ZERO, THE EDGE IS A LIQUID
!|                |   | BOUNDARY
!| IKLE           |-->| CONNECTIVITY TABLE.
!| IKLESTR        |-->| CONNECTIVITY TABLE OF BOUNDARY TRIANGLES ?
!| KLOG           |-->| CONVENTION FOR SOLID BOUNDARY
!| LIHBOR         |-->| TYPE OF BOUNDARY CONDITIONS ON DEPTH
!| NACHB          |-->| IN PARALLELISM ,INFORMATION ON NEIGHBOURS
!| NBOR           |-->| GLOBAL NUMBER OF BOUNDARY POINTS
!| NELEM          |-->| NUMBER OF ELEMENTS
!| NELEMTOTAL     |-->| NUMBER OF BOUNDARY TRIANGLES ?
!| NELMAX         |-->| MAXIMUM NUMBER OF ELEMENTS
!| NPOIN          |-->| NUMBER OF POINTS
!| NPTFR          |-->| NUMBER OF BOUNDARY POINTS
!| SIZIKL         |-->| FIRST DIMENSION OF IKLE
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!
      USE BIEF !, EX_VOISIN31 => VOISIN31
!
      IMPLICIT NONE
      INTEGER LNG,LU
      COMMON/INFO/LNG,LU
!
!+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
!
      INTEGER, INTENT(IN   ) :: IELM
      INTEGER, INTENT(IN   ) :: NPTFR
      INTEGER, INTENT(IN   ) :: NELEM
      INTEGER, INTENT(IN   ) :: NELMAX
      INTEGER, INTENT(IN   ) :: NPOIN
      INTEGER, INTENT(IN   ) :: SIZIKL
      INTEGER, INTENT(IN   ) :: NBOR(NPTFR)
      INTEGER, INTENT(IN   ) :: NACHB(NBMAXNSHARE,NPTIR)
!     NOTE: THE SECOND DIMENSION OF IFABOR AND IKLE ARE
!     EXPLICITLY GIVEN, BECAUSE WE'RE DEALING WITH TETRAHEDRONS
      INTEGER, INTENT(INOUT) :: IFABOR(NELMAX,4)
      INTEGER, INTENT(IN   ) :: IKLE(SIZIKL,4)
      INTEGER, INTENT(IN   ) :: LIHBOR(NPTFR)
      INTEGER, INTENT(IN   ) :: KLOG
      INTEGER, INTENT(IN   ) :: NELEMTOTAL
      INTEGER, INTENT(IN   ) :: IKLESTR(NELEMTOTAL,3)
      INTEGER, INTENT(IN   ) :: NELEB2
!
!+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
!
! LOCAL VARIABLES
!
      ! ARRAY WHICH IS THE REVERSE OF NBOR
      ! (GIVES FOR EACH NODE IN THE DOMAIN THE BOUNDARY NODE NUMBER E,
      ! OR 0 IF IT IS AN INTERIOR NODE)
      INTEGER, DIMENSION(:  ), ALLOCATABLE :: NBOR_INV
      ! ARRAY DEFINING THE NUMBER OF ELEMENT (TETRAHEDRONS) NEIGHBOURING
      ! A NODE
      INTEGER, DIMENSION(:  ), ALLOCATABLE :: NVOIS
      ! ARRAY DEFINING THE IDENTIFIERS OF THE ELEMENTS NEIGHBOURING
      ! EACH NODE
      INTEGER, DIMENSION(:  ), ALLOCATABLE :: NEIGH
      INTEGER, DIMENSION(:,:), ALLOCATABLE :: IKLE_TRI
      INTEGER, DIMENSION(:,:), ALLOCATABLE :: VOIS_TRI
      ! ARRAY DEFINING THE ADDRESSES OF THE VARIOUS ENTRIES IN
      ! ARRAY NEIGH
      INTEGER, DIMENSION(NPOIN)            :: IADR
      ! THE VALUE OF AN ENTRY IN THIS ARRAY
      INTEGER                              :: ADR
!
      ! THE MAXIMUM NUMBER OF ELEMENTS NEIGHBOURING A NODE
      INTEGER :: NMXVOISIN
      INTEGER :: IMAX       ! SIZE OF ARRAY IADR
!
      INTEGER :: NFACE      ! NUMBER OF SIDES TO ELEMENT (TETRA: 4)
      INTEGER :: NBTRI      ! NUMBER OF DEFINED TRIANGLES
!
      INTEGER :: IELEM      ! ELEMENTS COUNTER
      INTEGER :: IELEM2     ! ELEMENTS COUNTER
      INTEGER :: IPOIN      ! DOMAIN NODES COUNTER
      INTEGER :: INOEUD     ! TETRAHEDRONS/TRIANGLES NODES COUNTER
      INTEGER :: IFACE      ! SIDE COUNTER
      INTEGER :: IFACE2     ! SIDE COUNTER
      INTEGER :: ITRI       ! TRIANGLES COUNTER
      INTEGER :: IVOIS      ! NEIGHBOURS COUNTER
      INTEGER :: NV         ! NUMBER OF NEIGHBOURS
!
      INTEGER :: ERR        ! ERROR CODE FOR MEMORY ALLOCATION
!
      LOGICAL :: FOUND      ! FOUND OR NOT ...
!
      INTEGER :: I1, I2, I3 ! THE THREE NODES OF A TRIANGLE
      INTEGER :: M1, M2, M3 ! SAME THING, ORDERED
!
      INTEGER :: I,J,K      ! USEFUL ...
!
      INTEGER :: IR1,IR2,IR3,IR4,IR5,IR6,COMPT
      LOGICAL :: BORD
!
!   ~~~~~~~~~~~~~~~~~~~~~~~
!     DEFINES THE FOUR TRIANGLES OF THE TETRAHEDRON: THE FIRST
!     DIMENSION IS THE NUMBER OF THE TRIANGLE, THE SECOND GIVES
!     THE NODE NUMBERS OF THE NODES OF TETRAHEDRONS WHICH DEFINE IT.
      INTEGER SOMFAC(3,4)
      DATA SOMFAC /  1,2,3 , 4,1,2 , 2,3,4 , 3,4,1   /
!-----------------------------------------------------------------------
! START
!-----------------------------------------------------------------------
!
!
!
! CHECKS FIRST THAT WE ARE INDEED DEALING WITH TETRAHEDRONS. IF NOT,
! GOODBYE.
!
      IF(IELM.EQ.31) THEN
       NFACE = 4
      ELSE
       IF(LNG.EQ.1) WRITE(LU,98) IELM
       IF(LNG.EQ.2) WRITE(LU,99) IELM
98     FORMAT(1X,'VOISIN31: IELM=',1I6,' TYPE D''ELEMENT NON PREVU')
99     FORMAT(1X,'VOISIN31: IELM=',1I6,' TYPE OF ELEMENT NOT AVAILABLE')
       CALL PLANTE(1)
       STOP
      ENDIF
!
! ALLOCATES TEMPORARY ARRAYS
      ALLOCATE(NBOR_INV(NPOIN),STAT=ERR)
      IF(ERR.NE.0) THEN
        IF(LNG.EQ.1) THEN
          WRITE(LU,*) 'VOISIN31 : ALLOCATION DE NBOR_INV DEFECTUEUSE'
        ENDIF
        IF(LNG.EQ.2) THEN
          WRITE(LU,*) 'VOISIN31 : WRONG ALLOCATION OF NBOR_INV'
        ENDIF
        STOP
      ENDIF
!
! ALLOCATES TEMPORARY ARRAYS
      ALLOCATE(NVOIS(NPOIN),STAT=ERR)
      IF(ERR.NE.0) THEN
        IF(LNG.EQ.1) THEN
          WRITE(LU,*) 'VOISIN31 : ALLOCATION DE NVOIS DEFECTUEUSE'
        ENDIF
        IF(LNG.EQ.2) THEN
          WRITE(LU,*) 'VOISIN31 : WRONG ALLOCATION OF NVOIS'
        ENDIF
        STOP
      ENDIF
!
!-----------------------------------------------------------------------
! STEP 1: COUNTS THE NUMBER OF ELEMENTS NEIGHBOURING A NODE
!-----------------------------------------------------------------------
! COMPUTES THE NUMBER OF ELEMENTS NEIGHBOURING EACH NODE OF THE MESH.
! RESULT: NVOIS(INOEUD) GIVES THE NUMBER OF ELEMENTS NEIGHBOURING
! NODE INOEUD
      ! INITIALISES THE NEIGHBOURING ELEMENT COUNTER TO 0
      !
      DO I = 1, NPOIN
        NVOIS(I) = 0
      END DO
      ! COUNTS THE NEIGHBOURING ELEMENTS
      ! USING THE CONNECTIVITY TABLE, THE COUNTER IS INCREMENTED
      ! EACH TIME THAT AN ELEMENT REFERENCES NODE IPOIN
      ! LOOP ON THE 4 NODES OF THE ELEMENT
      DO INOEUD = 1, 4
        ! LOOP ON THE ELEMENTS
        DO IELEM = 1,NELEM
          ! THE ID OF NODE I OF ELEMENT IELEM
          IPOIN        = IKLE( IELEM , INOEUD )
          ! INCREMENT THE COUNTER
          NVOIS(IPOIN) = NVOIS(IPOIN) + 1
        END DO
      END DO
!-----------------------------------------------------------------------
! STEP 2: DETERMINES THE SIZE OF ARRAY NEIGH() AND OF AUXILIARY
! ARRAY TO INDEX NEIGH. ALLOCATES NEIGH
!-----------------------------------------------------------------------
! CREATES AN ARRAY WHICH WILL CONTAIN THE IDENTIFIERS OF THE ELEMENTS
! NEIGHBOURING EACH NODE. SINCE THE NUMBER OF NEIGHBOURS IS A PRIORI
! DIFFERENT FOR EACH NODE, AND IN AN EFFORT NOT TO CREATE A (TOO) BIG
! ARRAY FOR NO REASON, AN AUXILIARY ARRAY IS REQUIRED THAT GIVES THE
! ADDRESS OF THE ENTRIES FOR A GIVEN NODE. THIS ARRAY HAS AS MANY
! ENTRIES AS THERE ARE NODES.
! WILL ALSO COMPUTE THE MAXIMUM NUMBER OF NEIGHBOURS, SOME TIME.
      ! THE FIRST ENTRY IN THE ID OF THE NEIGHBOURS ARRAY IS 1
      ADR       = 1
      IADR(1)   = ADR
      ! THE MAX NUMBER OF NEIGHBOURING ELEMENTS
      NV        = NVOIS(1)
      NMXVOISIN = NV
      DO IPOIN = 2,NPOIN
          ! ADDRESS FOR THE OTHER ENTRIES:
          ADR         = ADR + NV
          IADR(IPOIN) = ADR
          NV          = NVOIS(IPOIN)
          ! IDENTIFIES THE MAX. NUMBER OF NEIGHBOURS
          NMXVOISIN   = MAX(NMXVOISIN,NV)
      END DO
      ! THE TOTAL NUMBER OF NEIGHBOURING ELEMENTS FOR ALL THE NODES
      ! GIVES THE SIZE OF THE NEIGHBOURS ARRAY:
      IMAX = IADR(NPOIN) + NVOIS(NPOIN)
      ! ALLOCATES THE ARRAY CONTAINING THE IDENTIFIERS OF THE ELEMENTS
      ! NEIGHBOURING EACH NODE
      ALLOCATE(NEIGH(IMAX),STAT=ERR)
      IF(ERR.NE.0) GOTO 999
!
!-----------------------------------------------------------------------
! STEP 3: INITIALISES NEIGH
!-----------------------------------------------------------------------
! NEEDS TO FILL NEIGH NOW THAT IT'S BEEN ALLOCATED: I.E.
! STARTS AGAIN THE LOOP ON THE 4 NODES OF EACH ELEMENT AND THIS
! TIME, ALSO STORES THE IDENTIFIER IN ARRAY NEIGH.
!
!
      ! RE-INITIALISES THE COUNTER OF THE NEIGHBOURING ELEMENTS TO 0,
      ! TO KNOW WHERE WE ARE AT
      NVOIS(:) = 0
      ! FOR EACH NODE OF THE ELEMENTS, STORES THE IDENTIFIER
      DO INOEUD = 1, 4  ! LOOP ON THE ELEMENT NODES
        DO IELEM=1,NELEM ! LOOP ON THE ELEMENTS
          IPOIN     = IKLE( IELEM , INOEUD )
          ! ONE MORE NEIGHBOUR
          NV           = NVOIS(IPOIN) + 1
          NVOIS(IPOIN) = NV
          ! STORES THE IDENTIFIER OF THE NEIGHBOURING ELEMENT IN THE ARRAY
          NEIGH(IADR(IPOIN)+NV) = IELEM
        END DO ! END OF LOOP ELEMENTS
      END DO  ! END OF LOOP NODES
!
!-----------------------------------------------------------------------
! STEP 4: IDENTIFIES COMMON FACES OF THE TETRAHEDRONS AND FILLS IN
! ARRAY IFABOR
!-----------------------------------------------------------------------
! TO IDENTIFY FACES COMMON TO THE ELEMENTS :
! FROM THE ELEMENTS THAT SHARE A NODE, AT LEAST 2 SHARE A FACE
! (IF THE NODE IS NOT A BOUNDARY NODE).
! THE ALGORITHM PRINCIPLE:
! BUILDS THE TRIANGLES OF THE TETRAHEDRON FACES, ONCE HAVE IDENTIFIED
! THOSE THAT SHARE NODE IPOIN.
! IF 2 TRIANGLES SHARE THE SAME NODES, IT MEANS THAT THE TETRAHEDRONS
! DEFINING THEM ARE NEIGHBOURS.
! IF NO NEIGHBOUR CAN BE FOUND, IT MEANS THAT THE TRIANGLE IS A
! BOUNDARY FACE.
! BASED ON THE ASSUMPTION THAT A TRIANGLE CANNOT BE DEFINED BY MORE
! THAN 2 TETRAHEDRONS.
! IF THAT WAS NOT THE CASE, IT WOULD MEAN THAT THERE WAS A PROBLEM WITH
! THE MESH; AND THIS IS NOT CATERED FOR ...
!
! ADVANTAGES:
! SAVES QUITE A BIT OF MEMORY, BY STORING THE TRIANGLES AROUND A NODE.
! DISADVANTAGES:
! COULD BE DOING TOO MANY (USELESS) COMPUTATIONS (TO GET TO THE STAGE
! WHERE THE CONNECTIVITY TABLE FOR THE TRIANGLES IS DEFINED)
! COULD MAYBE SKIP THIS STEP BY CHECKING IF IFABOR ALREADY CONTAINS
! SOMETHING OR NOT ...
!
! BUILDS THE CONNECTIVITY TABLE FOR THE TRIANGLES
! THIS CONNECTIVITY TABLE IS NOT SUPPOSED TO MAKE A LIST OF ALL
! THE TRIANGLES, BUT MERELY THOSE AROUND A NODE.
! THE MAXIMUM NUMBER OF (TETRAHEDRONS) NEIGHBOURS IS KNOWN FOR A
! NODE. IN THE WORST CASE, THE NODE IS A BOUNDARY NODE.
! WILL MAXIMISE (A LOT) BY ASSUMING THAT THE MAXIMUM NUMBER OF
! TRIANGLES AROUND A NODE CAN BE THE NUMBER OF NEIGHBOURING
! TETRAHEDRONS.
! ALSO BUILDS THE ARRAY VOIS_TRI CONTAINING THE ID OF THE TETRAHEDRON
! ELEMENT THAT DEFINED IT FIRST (AND THAT WILL BE NEIGHBOUR TO THE
! TETRAHEDRON THAT WILL FIND THAT ANOTHER ONE ALREADY DEFINES IT)
! THIS ARRAY HAS 2 ENTRIES : THE ID OF THE ELEMENT AND THE ID OF THE SIDE.
!
      NBTRI = NMXVOISIN * 3
!
      ALLOCATE(IKLE_TRI(NBTRI,3),STAT=ERR)
      IF(ERR.NE.0) GOTO 999
      ALLOCATE(VOIS_TRI(NBTRI,2),STAT=ERR)
      IF(ERR.NE.0) GOTO 999
!
      IFABOR(:,:) = 0
!
      ! LOOP ON ALL THE NODES IN THE MESH
      DO IPOIN = 1, NPOIN
          ! FOR EACH NODE, CHECKS THE NEIGHBOURING TETRAHEDRON ELEMENTS
          ! (MORE PRECISELY: THE TRIANGULAR FACES THAT MAKE IT)
          ! RE-INITIALISES THE CONNECTIVITY TABLE FOR THE TETRAHEDRON
          ! TRIANGLES TO 0, AND THE NUMBER OF TRIANGLES WHICH HAVE BEEN
          ! FOUND:
          !
          IKLE_TRI(:,:) = 0
          ! SAME THING FOR THE ARRAY THAT IDENTIFIES WHICH ELEMENT HAS
          ! ALREADY DEFINED THE TRIANGLE :
          VOIS_TRI(:,:) = 0
          ! STARTS COUNTING THE TRIANGLES AGAIN:
          NBTRI         = 0
          NV            = NVOIS(IPOIN)
          ADR           = IADR(IPOIN)
          DO IVOIS = 1, NV
              ! THE IDENTIFIER OF THE NEIGHBOURING ELEMENT IVOIS TO
              ! THE NODE IPOIN:
              IELEM = NEIGH(ADR+IVOIS)
              ! LOOP ON THE 4 SIDES OF THIS ELEMENT
              DO IFACE = 1 , NFACE
                  ! IF THIS SIDE ALREADY HAS A NEIGHBOUR, THAT'S
                  ! ENOUGH AND GOES TO NEXT.
                  ! OTHERWISE, LOOKS FOR IT...
                  IF ( IFABOR(IELEM,IFACE) .EQ. 0 ) THEN
                  ! EACH FACE DEFINES A TRIANGLE. THE TRIANGLE IS
                  ! GIVEN BY 3 NODES.
                  I1 = IKLE(IELEM,SOMFAC(1,IFACE))
                  I2 = IKLE(IELEM,SOMFAC(2,IFACE))
                  I3 = IKLE(IELEM,SOMFAC(3,IFACE))
                  ! THESE 3 NODES ARE ORDERED, M1 IS THE NODE WITH
                  ! THE SMALLEST IDENTIFIER, M3 THAT WITH THE
                  ! LARGEST IDENTIFIER AND M2 IS IN THE MIDDLE:
                  M1 = MAX(I1,(MAX(I2,I3)))
                  M3 = MIN(I1,(MIN(I2,I3)))
                  M2 = I1+I2+I3-M1-M3
                  ! GOES THROUGH THE ARRAY WITH TRIANGLES ALREADY DEFINED
                  ! TO SEE IF ONE OF THEM BEGINS WITH M1.
                  ! IF THAT'S THE CASE, CHECKS THAT IT ALSO HAS NODES
                  ! M2 AND M3. IF THAT'S THE CASE, HAS FOUND A NEIGHBOUR.
                  ! OTHERWISE, A NEW TRIANGLE ENTRY IS CREATED.
                  !
                  FOUND = .FALSE.
                  DO ITRI = 1, NBTRI
                      IF ( IKLE_TRI(ITRI,1) .EQ. M1 ) THEN
                          IF ( IKLE_TRI(ITRI,2) .EQ. M2 .AND.
     &                         IKLE_TRI(ITRI,3) .EQ. M3 ) THEN
                               ! FOUND IT! ALL IS WELL.
                               ! STORES THE INFORMATION IN VOIS_TRI.
                               ! (I.E. THE ELEMENT THAT HAS ALREADY
                               ! DEFINED THE TRIANGLE AND THE FACE)
                               IELEM2 = VOIS_TRI(ITRI,1)
                               IFACE2 = VOIS_TRI(ITRI,2)
                               IF ( IELEM2 .EQ. IELEM ) THEN
                                  IF(LNG.EQ.1) WRITE(LU,908) IELM
                                  IF(LNG.EQ.2) WRITE(LU,909) IELM
908                               FORMAT(1X,'VOISIN: IELM=',1I6,',
     &                            PROBLEME DE VOISIN')
909                               FORMAT(1X,'VOISIN: IELM=',1I6,',
     &                            NEIGHBOUR PROBLEM')
                                  CALL PLANTE(1)
                                  STOP
                               END IF
                               ! TO BE SURE :
                               IF ( IELEM2 .EQ. 0 .OR.
     &                              IFACE2 .EQ. 0 ) THEN
                                IF(LNG.EQ.1) WRITE(LU,918) IELEM2,IFACE2
                                IF(LNG.EQ.2) WRITE(LU,919) IELEM2,IFACE2
918                            FORMAT(1X,'VOISIN31:TRIANGLE NON DEFINI,
     &                         IELEM=',1I6,'IFACE=',1I6)
919                            FORMAT(1X,'VOISIN31:UNDEFINED TRIANGLE,
     &                         IELEM=',1I6,'IFACE=',1I6)
                                CALL PLANTE(1)
                                STOP
                               END IF
                               ! THE ELEMENT AND ITS NEIGHBOUR : STORES
                               ! THE CONNECTION IN IFABOR.
                               IFABOR(IELEM ,IFACE ) = IELEM2
                               IFABOR(IELEM2,IFACE2) = IELEM
                               FOUND = .TRUE.
                          END IF
                      END IF
                  END DO
                  ! NO, THIS TRIANGLE WAS NOT ALREADY THERE; THEREFORE
                  ! CREATES A NEW ENTRY.
                  IF ( .NOT. FOUND) THEN
                      NBTRI             = NBTRI + 1
                      IKLE_TRI(NBTRI,1) = M1
                      IKLE_TRI(NBTRI,2) = M2
                      IKLE_TRI(NBTRI,3) = M3
                      VOIS_TRI(NBTRI,1) = IELEM
                      VOIS_TRI(NBTRI,2) = IFACE
                  END IF
              END IF ! IFABOR 0
              END DO ! END OF LOOP ON FACES OF THE NEIGHBOURING ELEMENTS
!
          END DO ! END OF LOOP ON ELEMENTS NEIGHBOURING THE NODE
      END DO ! END OF LOOP ON NODES
!
      DEALLOCATE(NEIGH)
      DEALLOCATE(IKLE_TRI)
      DEALLOCATE(VOIS_TRI)
!
!-----------------------------------------------------------------------
! STEP 5: FACES BETWEEN DIFFERENT COMPUTATION DOMAIN (DECOMPOSITION OF
! DOMAIN): LEAVE THIS TO DOMAIN SPECIALISTS !
!-----------------------------------------------------------------------
!
!  COULD TRY SOMETHING A BIT LIGHTER
!  USING INDPU FOR EXAMPLE
!
      IF (NCSIZE.GT.1) THEN
!
        DO 61 IFACE=1,NFACE
          DO 71 IELEM=1,NELEM
!
!  SOME BOUNDARY SIDES ARE INTERFACES BETWEEN SUB-DOMAINS IN
!  ACTUAL FACT: THEY ARE ASSIGNED A VALUE -2 INSTEAD OF 0
!
!      IF(IFABOR(IELEM,IFACE).EQ.-1) THEN
            IF (IFABOR(IELEM,IFACE).EQ.0) THEN
!
         I1 = IKLE( IELEM , SOMFAC(1,IFACE) )
         I2 = IKLE( IELEM , SOMFAC(2,IFACE) )
         I3 = IKLE( IELEM , SOMFAC(3,IFACE) )
!
         IR1=0
         IR2=0
         IR3=0
!
         DO J=1,NPTIR
           IF(I1.EQ.NACHB(1,J)) IR1=1
           IF(I2.EQ.NACHB(1,J)) IR2=1
           IF(I3.EQ.NACHB(1,J)) IR3=1
         ENDDO
!
! POSSIBLY SET TO -2 FR IFABOR --> INTERFACE MESH
! OTHERWISE VALUE STAYS 0 --> BOUNDARY MESH
              IF (IR1.EQ.1.AND.IR2.EQ.1.AND.IR3.EQ.1) THEN
!               PRINT*,'THESE ARE INTERFACE NODES'
! THESE 3 NODES ARE INTERFACE NODES; DO THEY CORRESPOND TO A
! (VIRTUAL) INTERFACE TRIANGLE OR TO A BOUNDARY TRIANGLE ?
                BORD=.FALSE.
                IR4=0
                IR5=0
                IR6=0
                DO 55 J=1,NPTFR
                  IF (I1.EQ.NBOR(J)) IR5=1
                  IF (I2.EQ.NBOR(J)) IR4=1
                  IF (I3.EQ.NBOR(J)) IR6=1
55              CONTINUE
! THEY ARE ALSO BOUNDARY NODES
                IF (IR5.EQ.1.AND.IR4.EQ.1.AND.IR6.EQ.1) THEN
!
                  DO J=1,NELEB2
! IT IS A BOUNDARY TRIANGLE
                    COMPT=0
                    DO I=1,3
!                     IF (IKLETR(J,I)==I1) COMPT=COMPT+1
!                     IF (IKLETR(J,I)==I2) COMPT=COMPT+10
!                     IF (IKLETR(J,I)==I3) COMPT=COMPT+100
! GOOD SCENARIO BUT PB OF COMPILATION WITH BIEF
                      IF (IKLESTR(J,I)==I1) COMPT=COMPT+1
                      IF (IKLESTR(J,I)==I2) COMPT=COMPT+10
                      IF (IKLESTR(J,I)==I3) COMPT=COMPT+100
                    ENDDO
! THESE 3 NODES INDEED BELONG TO THE SAME BOUNDARY TRIANGLE
                    IF (COMPT==111) THEN
                      BORD=.TRUE.
!                     PRINT*,'VERTICES OF A BOUNDARY TRIANGLE'
                      EXIT
                    ENDIF
                  ENDDO
                ENDIF
!                IF (IR5.EQ.0.OR.IR4.EQ.0.OR.IR6.EQ.0) THEN
                IF (.NOT.BORD) THEN
! THESE 3 NODES BELONG TO AN INTERFACE MESH
!                 PRINT*, 'INTERFACE NODES'
                  IFABOR(IELEM,IFACE)=-2
                ENDIF
              ENDIF
!
            ENDIF
!
71        CONTINUE
61      CONTINUE
!
      ENDIF
!
!-----------------------------------------------------------------------
!
!  IFABOR DISTINGUISHES BETWEEN THE BOUNDARY FACES AND THE LIQUID FACES
!
!  INITIALISES NBOR_INV TO 0
!
      DO IPOIN=1,NPOIN
        NBOR_INV(IPOIN) = 0
      ENDDO
!
!  CONNECTS GLOBAL NUMBERING TO BOUNDARY NUMBERING
!
      DO K = 1, NPTFR
        NBOR_INV(NBOR(K)) = K
      ENDDO
!
!  LOOP ON ALL THE SIDES OF ALL THE ELEMENTS:
!
      DO 90 IFACE = 1 , NFACE
      DO 100 IELEM = 1 , NELEM
!
      IF(IFABOR(IELEM,IFACE).EQ.-1) THEN
!
!      IT IS A TRUE BOUNDARY SIDE (IN PARALLEL MODE THE INTERNAL SIDES
!                                  ARE INDICATED WITH -2).
!      GLOBAL NUMBERS OF THE NODES OF THE SIDE :
!
       I1 = IKLE( IELEM , SOMFAC(1,IFACE) )
       I2 = IKLE( IELEM , SOMFAC(2,IFACE) )
       I3 = IKLE( IELEM , SOMFAC(3,IFACE) )
!
!      A LIQUID SIDE IS IDENTIFIED WITH THE BOUNDARY CONDITION ON H
!
       IF(NPTFR.GT.0) THEN
       IF(LIHBOR(NBOR_INV(I1)).NE.KLOG.AND.LIHBOR(NBOR_INV(I2)).NE.KLOG
     &     .AND.LIHBOR(NBOR_INV(I3)).NE.KLOG  ) THEN
!        LIQUID SIDE : IFABOR=0  SOLID SIDE : IFABOR=-1
         IFABOR(IELEM,IFACE)=0
       ENDIF
       ENDIF
!
      ENDIF
!
100    CONTINUE
90    CONTINUE
!
!-----------------------------------------------------------------------
!
      RETURN
!
!-----------------------------------------------------------------------
!
999   IF(LNG.EQ.1) WRITE(LU,1000) ERR
      IF(LNG.EQ.2) WRITE(LU,2000) ERR
1000  FORMAT(1X,'VOISIN31 : ERREUR A L''ALLOCATION DE MEMOIRE :',/,1X,
     &            'CODE D''ERREUR : ',1I6)
2000  FORMAT(1X,'VOISIN31: ERROR DURING ALLOCATION OF MEMORY: ',/,1X,
     &            'ERROR CODE: ',1I6)
      CALL PLANTE(1)
      STOP
!
!-----------------------------------------------------------------------
!
      END