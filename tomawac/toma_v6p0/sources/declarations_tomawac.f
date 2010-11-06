C                        ***************************
                         MODULE DECLARATIONS_TOMAWAC
C                        ***************************
C
C***********************************************************************
C  TOMAWAC 6.0               25/08/00           OPTIMER  02 98 44 24 51
C  SUIVI EDF ASSURE PAR D. VIOLEAU
C  TOMAWAC 5.2               14/06/00           OPTIMER  02 98 44 24 51
C  SUIVI EDF ASSURE PAR M. BENOIT / J.M HERVOUET
C***********************************************************************
C
C     DECLARATION DES STRUCTURES DE BIEF DANS TOMAWAC
C                                                                     
C  +-------------+-------------------------------------------- 
C  ! NOM         ! SIGNIFICATION - OBSERVATIONS                
C  +-------------+-------------------------------------------- 
C  ! VECTEURS ET MATRICES
C  ! ********************
C  ! F(-,-,-)    ! SPECTRE DIRECTIONNEL DE VARIANCE           
C  ! CX(-,-)     ! VITESSE DE TRANSFERT SUIVANT X            
C  ! CY(-,-)     ! VITESSE DE TRANSFERT SUIVANT Y            
C  ! CT(-,-)     ! VITESSE DE TRANSFERT SUIVANT TETA         
C  ! CF(-,-)     ! VITESSE DE TRANSFERT SUIVANT FREQ. RELAT.   
C  ! SHP1(-,-)   ! COORDONNEES BARYCENTRIQUES 2D AU PIED DES
C  ! SHP2(-,-)   ! COURBES CARACTERISTIQUES
C  ! SHP3(-,-)   !                                           
C  ! SHZ(-,-)    ! COORDONNEES BARYCENTRIQUES SUIVANT TETA DES
C  !             ! NOEUDS DANS LEURS ETAGES "ETA" ASSOCIES
C  ! SHF(-,-)    ! COORDONNEES BARYCENTRIQUES SUIVANT F DES
C  !             ! NOEUDS DANS LEURS FREQUENCES "FRE" ASSOCIEES
C  ! B(-,-)      ! JACOBIEN PASSAGE DE N(KX,KY) A F(FR,TETA)  
C  ! XK(-,-)     ! TABLEAU DES NOMBRES D'ONDE                  
C  ! CG(-,-)     ! TABLEAU DES VITESSES DE GROUPE
C  ! ZF(-)       ! COTE DU FOND (METRES)
C  ! DEPTH(-)    ! TABLEAU DES PROFONDEURS (METRES)
C  ! DZX(-)      ! GRADIENT DE PROFONDEUR PAR RAPPORT A X
C  ! DZHDT(-)    ! GRADIENT DE PROFONDEUR PAR RAPPORT A T   
C  ! DZY-)       ! GRADIENT DE PROFONDEUR PAR RAPPORT A Y
C  ! UC(-)       ! TABLEAU DES COMP. OUEST-EST DU COURANT (A T)
C  ! VC(-)       ! TABLEAU DES COMP. SUD-NORD  DU COURANT (A T)
C  ! UC1(-)      ! TABLEAU DES COMP. OUEST-EST DE COURANT A T1    
C  ! VC1(-)      ! TABLEAU DES COMP. SUD-NORD  DE COURANT A T1   
C  ! UC2(-)      ! TABLEAU DES COMP. OUEST-EST DE COURANT A T2    
C  ! VC2(-)      ! TABLEAU DES COMP. SUD-NORD  DE COURANT A T2   
C  ! UV(-)       ! TABLEAU DE VENT (COMP. OUEST-EST) (A T)
C  ! VV(-)       ! TABLEAU DE VENT (COMP. SUD-NORD)  (A T)
C  ! UV1(-)      ! TABLEAU DES COMP. OUEST-EST DE VENT A T1    
C  ! VV1(-)      ! TABLEAU DES COMP. SUD-NORD  DE VENT A T1   
C  ! UV2(-)      ! TABLEAU DES COMP. OUEST-EST DE VENT A T2    
C  ! VV2(-)      ! TABLEAU DES COMP. SUD-NORD  DE VENT A T2
C  ! ZM1(-)      ! TABLEAU DES HAUTEURS DE LA MAREE A T1
C  ! ZM2(-)      ! TABLEAU DES HAUTEURS DE LA MAREE A T2
C  ! XRELC(-)    ! ABSCISSES DES POINTS RELEVES DU COURANT
C  ! YRELC(-)    ! ORDONNEES DES POINTS RELEVES DU COURANT
C  ! XRELV(-)    ! ABSCISSES DES POINTS RELEVES DU VENT 
C  ! YRELV(-)    ! ORDONNEES DES POINTS RELEVES DU VENT
C  ! XRELM(-)    ! ABSCISSES DES POINTS RELEVES DE LA HAUTEUR DE MAREE
C  ! YRELM(-)    ! ORDONNEES DES POINTS RELEVES DE LA HAUTEUR DE MAREE
C  ! FREQ(-)     ! TABLEAU DES FREQUENCES DE DISCRETISATION  
C  ! DFREQ(-)    ! TABLEAU DES PAS DE FREQUENCE               
C  ! COEFNL(-)   ! VECTEUR DES COEFFICIENTS DE CALCUL POUR DIA 
C  ! COSF(-)     ! TABLEAU DES COSINUS DES LATITUDES        
C  ! TGF(-)      ! TABLEAU DES TANGENTES DES LATITUDES   
C  ! DUX(-)      ! GRADIENT DE COURANT U  PAR RAPPORT A X  
C  ! DUY-)       ! GRADIENT DE COURANT U  PAR RAPPORT A Y  
C  ! DVX(-)      ! GRADIENT DE COURANT V  PAR RAPPORT A X   
C  ! DVY-)       ! GRADIENT DE COURANT V  PAR RAPPORT A Y   
C  ! TETA(-)     ! VECTEUR DES DIRECTIONS DE DISCRETISATION   
C  ! SINTET(-)   ! VECTEUR DES   SINUS DES DIRECTIONS        
C  ! COSTET(-)   ! VECTEUR DES COSINUS DES DIRECTIONS     
C  ! FBOR(-)     ! TABLEAU DES POINTS FRONTIERES             
C  ! TSDER
C  ! TSTOT
C  ! DF_LIM(-,-) ! TABLEAU UTILISE POUR LE LIMITEUR DE CROISSANCE
C  ! LIFBOR      ! TYPE DES CONDITIONS A LA LIMITE (LIBRE / IMPOSE)
C  ! STDGEO      ! STANDARD DU FICHIER DE GEOMETRIE
C
C   COMPOSANTES DU MAILLAGE MESH
C   ****************************
C  ! MESH        ! STRUCTURE MAILLAGE
C  ! X           ! TABLEAU DES ABSCISSES DES POINTS MAILLAGE   
C  ! Y           ! TABLEAU DES ABSCISSES DES POINTS MAILLAGE  
C  ! XEL         ! ABSCISSES DES NOEUDS DES ELEMENTS 
C  ! YEL         ! ORDONNEES DES NOEUDS DES ELEMENTS
C  ! SURDET      ! TABLEAU DES 1./DETER DES ELEMENTS 2D
C  ! IKLE2       !
C  ! IFABOR      !
C  ! NBOR        ! NUMEROS GLOBAUX DES POINTS FRONTIERES
C  ! NELEM2      ! NOMBRE D'ELEMENTS DU MAILLAGE 2D
C  ! NPOIN2      ! NOMBRE DE POINTS DU MAILLAGE 2D
C  ! NPTFR       ! NOMBRE DE POINTS 'FRONTIERE'
C
C   MOTS CLES ENTIERS
C   *****************
C  ! NF          ! NOMBRE DE FREQUENCES DE DISCRETISATION
C  ! NPLAN       ! NOMBRE DE DIRECTIONS DE DISCRETISATION
C
C   MOTS CLES REELS
C   ***************
C CONSTANTES DU SPECTRE IMPOSE INITIALEMENT :
C   HM0   , FPIC  , GAMMA , SIGMAA  , SIGMAB, ALPHIL, FETCH
C   FREMAX, TETA1 , SPRED1  , TETA2 , SPRED2, XLAMDA
C   
C CONSTANTES DU SPECTRE IMPOSE A LA LIMITE :
C   HM0L  , FPICL , GAMMAL, SIGMAL  , SIGMBL, APHILL, FETCHL
C   FPMAXL, TETA1L, SPRE1L, TETA2L  , SPRE2L, XLAMDL
C 
C  ! XLAMB       ! QUADRUPLETS : DIA , PARAMETRE CONFIGURATION STANDARD
C
C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C=C
C
C***********************************************************************
C
      USE BIEF_DEF
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C     DECLARATION DES STRUCTURES DE BIEF
C
C-----------------------------------------------------------------------
C     ANCIENS ARGUMENTS DE WAC (VECTEURS ET MATRICES)
C-----------------------------------------------------------------------
C
      TYPE (BIEF_OBJ), TARGET ::
     * SF , SCX , SCY , SCT , SCF , SSHP1 , SSHP2 , SSHP3 , SSHZ , SSHF,
     * SB , SXK , SCG , SZF , SDEPTH ,SUC , SVC, SUC1, SVC1, SUC2, SVC2,
     * SDZHDT, SDZX , SDZY, SDF_LIM,
     * SUV, SVV, SUV1 , SVV1 , SUV2 , SVV2 , SZM1 , SZM2,
     * SXRELV, SYRELV ,SXRELC, SYRELC ,
     * SXRELM, SYRELM ,SFR, SDFR, SCOEF ,
     * SCOSF , STGF , SDUX , SDUY , SDVX , SDVY ,
     * STETA, SCOSTE , SSINTE , SSURDE , SFBOR , AM1 , STSDER , STSTOT,
     * XMESH , ST0 , ST1 , ST2 , ST3 , ST4 , ST5 , ST6 , ST7 , BST1 ,
     * VARSOR, ST00, STRA15, STRA16, STRA40,
     * BOUNDARY_COLOUR
      TYPE (BIEF_OBJ), TARGET ::
     * STRA01, STRAB1, STOLD , STNEW ,
     * STRA31, STRA32, STRA33, STRA34, STRA35, STRA36, 
     * STRA37, STRA38, STRA39, STRA41, STRA42, STRA43, STRA44,
     * STRA51, STRA52, STRA53, STRA54, STRA55, STRA56, STRA57,
     * STRA58, STRA59, STRA60, STRA61, STRA62, STRA63, STRA64,
     * STRA65, STRA66, STRA02, SW1   , SPRIVE,
     * SIBOR , SLIFBR, SLIQ  , SELT  , SETA  , SFRE  ,
     * SETAP1, SIAGNL, SITR11, SITR12, SITR13,
     * SITR01, SITRB1, SITR03, 
     * SKNI  , SKNOGL, SELI  , SKELGL, SITR31, SITR32, SITR33, SBETA
C
      TYPE(BIEF_MESH) :: MESH
C
C-----------------------------------------------------------------------
C     MOTS CLES ET PARAMETRES
C-----------------------------------------------------------------------
C
C     MOTS CLES ENTIERS
C
      INTEGER  NPLAN  , NF   
      INTEGER  GRAPRD, LISPRD, NIT   , LAM   , IDHMA
      INTEGER  GRADEB, LISFON
      INTEGER  SVENT , SMOUT , SFROT , STRIF , SBREK
      INTEGER  IQBBJ , IHMBJ , IFRBJ , IWHTG , IFRTG
      INTEGER  IDISRO, IEXPRO, IFRRO , IFRIH , NDTBRK, LIMIT
      INTEGER  INDIC , INDIV , INDIM , INISPE, LIMSPE, STRIA
      INTEGER  NSITS , IDTEL , NPTT  , LVMAC
      INTEGER  NPRIV , FRABI , FRABL , NPLEO , DEBUG 
C
C supprimer ensuite sorg2d
      INTEGER  SORG2D
C
C     Coordonnees de l'origine en (X,Y)
      INTEGER  I_ORIG, J_ORIG
C
C     MOTS CLES REELS
C
      DOUBLE PRECISION DT    , F1    , RAISF
      DOUBLE PRECISION DDC   , CFROT1, CMOUT1, CMOUT2
      DOUBLE PRECISION ROAIR , ROEAU , BETAM , XKAPPA, ALPHA
      DOUBLE PRECISION DECAL , ZVENT , CDRAG , GRAVIT
      DOUBLE PRECISION ALFABJ, GAMBJ1, GAMBJ2, BORETG, GAMATG  
      DOUBLE PRECISION ALFARO, GAMARO, GAM2RO, BETAIH, EM2SIH
      DOUBLE PRECISION COEFHS, XDTBRK, XLAMD , CIMPLI
      DOUBLE PRECISION ZREPOS, ALFLTA, RFMLTA, KSPB  , BDISPB, BDSSPB
      DOUBLE PRECISION HM0   , FPIC  , GAMMA , SIGMAA, SIGMAB, ALPHIL
      DOUBLE PRECISION FETCH , FREMAX, TETA1 , SPRED1, TETA2 , SPRED2
      DOUBLE PRECISION XLAMDA, TAILF , E2FMIN
      DOUBLE PRECISION HM0L  , FPICL , SIGMAL, SIGMBL, APHILL, FETCHL
      DOUBLE PRECISION FPMAXL, TETA1L, SPRE1L, TETA2L, SPRE2L, XLAMDL
      DOUBLE PRECISION GAMMAL
      DOUBLE PRECISION ALF1  , GAM1  , GAM2  , PROMIN, VX_CTE, VY_CTE
CMB...Modif MB/GM nb points de sortie      
      DOUBLE PRECISION XLEO(99), YLEO (99)
CMB...Fin de modif
C
C     MOTS CLES LOGIQUES
C
      LOGICAL TSOU   , SPHE   , GLOB , SUIT   , PROINF
      LOGICAL COUSTA , COURAN , VENT , VENSTA , MAREE, TRIGO
      LOGICAL DONTEL , PROP   , VALID, SPEULI
C
C     MOTS CLES CHAINES DE CARACTERES
C
      CHARACTER*72 TITCAS , SORT2D
C     type de binaire des fichiers
      CHARACTER*3 BINGEO  , BINRBI , BINPRE , BINRES , BINLEO
      CHARACTER*3 BINCOU  , BINVEN , BINMAR , BINBI1
C
C     version
      CHARACTER*4 VERS
C
C.....DECLARATION DES VARIABLES FIGURANT DANS L'EX COMMON TELINT
      INTEGER NDP , STDGEO
C
C.....AUTRES DECLARATIONS QU'IL EST PRATIQUE DE METTRE EN COMMUM
      CHARACTER*20 EQUA
      INTEGER      IELM2,NPOIN3

C
C.....SORTIES GRAPHIQUES A LA TELEMAC
      INTEGER, PARAMETER :: MAXVAR = 35
      LOGICAL SORLEO(MAXVAR)   , SORIMP(MAXVAR)
      CHARACTER*32 VARCLA(10),TEXTE(MAXVAR),TEXTPR(MAXVAR)
      DOUBLE PRECISION HIST(1)
C     7 Variables sont retenues pour la validation
C          Hauteur significative      HM0       ( 2)
C          Direction moyenne          DMOY      ( 3)
C          Etalement directionnel     SPD       ( 4)
C          Force motrice suivant x    FX        (11)
C          Force motrice suivant y    FY        (12)
C          Frequence moyenne Fm-10    FMOY      (18)
C          Frequence moyenne Fm01     FM01      (19)
      INTEGER ALIRE(MAXVAR)
C JMH20/04/2009, IL MANQUAIT UN 0 (?)
      DATA ALIRE /0,1,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,
     *0,0,0,0,0,0,0,0/
      DATA HIST /9999.D0/
C
C-----------------------------------------------------------------------
C   DECLARATION DE POINTEURS POUR ALIAS
C   LES CIBLES SONT DEFINIES DANS POINT
C-----------------------------------------------------------------------
C
C       COMPOSANTES DU MAILLAGE MESH AVEC UN DOUBLE OU UN ALIAS
C
      DOUBLE PRECISION, DIMENSION(:), POINTER :: X,Y,XEL,YEL 
      DOUBLE PRECISION, DIMENSION(:), POINTER :: SURDET
      INTEGER, DIMENSION(:) , POINTER :: IKLE2 , IFABOR , NBOR
C
      INTEGER, POINTER        :: NELEM2
      INTEGER, POINTER        :: NPTFR
      INTEGER, POINTER        :: NPOIN2
C
C       POINTEURS SUR LES TABLEAUX DE DONNEES DES BIEF OBJ
C
      DOUBLE PRECISION, DIMENSION(:) , POINTER :: 
     * F   , CX   , CY  , CT , CF   , SHP1 , SHP2 , SHP3 , SHZ , SHF ,
     * B   , XK   , CG  , ZF , DEPTH, UC   , VC  , UC1 , VC1 , UC2, VC2,
     * DZHDT, DZX  , DZY, DF_LIM,
     * UV  , VV   , UV1  , VV1 , UV2   , VV2   , ZM1 , ZM2 ,
     * XRELV, YRELV,XRELC, YRELC,
     * XRELM, YRELM,FREQ, DFREQ, COEFNL,
     * COSF , TGF   , DUX, DUY , DVX , DVY , TETA,
     * COSTET , SINTET , FBOR , TSDER , TSTOT ,
     * T0 , T1 , T2 , T3 , T4 , T5 , T6 , T7 ,
     * T00, TRA15, TRA16, TRA40,BETA
      DOUBLE PRECISION, DIMENSION(:) , POINTER :: 
     * TRA01 , TRAB1 , TOLD , TNEW ,
     * TRA31 , TRA32 , TRA33 , TRA34 , TRA35 , TRA36 , TRA37 , 
     * TRA38 , TRA39 , TRA41 , TRA42 , TRA43 , TRA44 ,
     * TRA51 , TRA52 , TRA53 , TRA54 , TRA55 , TRA56 , TRA57 ,
     * TRA58 , TRA59 , TRA60 , TRA61 , TRA62 , TRA63 , TRA64 ,
     * TRA65 , TRA66 , TRA02 , W1    , PRIVE

      INTEGER, DIMENSION(:), POINTER :: 
     * IBOR  , LIFBOR, NUMLIQ , ELT  , ETA  , FRE   , ETAP1 , IANGNL ,
     * ITR11 , ITR12 , ITR13 ,
     * ITR01 , ITRB1 , ITR03 ,
     * KNI   , KNOGL , ELI   , KELGL ,
     * ITR31 , ITR32 , ITR33
!BD_INCKA pour lecture med definition d'un WAC_FILES et des unites 
!logiques associees
      INTEGER :: WACGEO,WACCAS,WACCLI,WACFON,WACRES,WACLEO,WACPRE,
     *           WACRBI,WACCOB,WACCOF,WACBI1,WACFO1,WACVEB,WACVEF,
     *           WACPAR,WACREF,WACMAB,WACMAF
      TYPE(BIEF_FILE) :: WAC_FILES(44)      
!BD_INCKA
C
      SAVE
C
      END MODULE DECLARATIONS_TOMAWAC