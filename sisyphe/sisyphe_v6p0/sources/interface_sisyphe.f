      ! ************************ !
        MODULE INTERFACE_SISYPHE 
      ! ************************ !

C**********************************************************************C
C SISYPHE VERSION 5.6  10/01/05  F. HUVELIN                            C
C**********************************************************************C


           ! ============================================= !
           ! Main declaration of the interfaces of sisyphe !
           ! ============================================= !


C COPYRIGHT EDF-DTMPL-SOGREAH-LHF-GRADIENT
C**********************************************************************C
C                                                                      C
C                 SSSS I   SSSS Y   Y PPPP  H   H EEEEE                C
C                S     I  S      Y Y  P   P H   H E                    C
C                 SSS  I   SSS    Y   PPPP  HHHHH EEEE                 C
C                    S I      S   Y   P     H   H E                    C
C                SSSS  I  SSSS    Y   P     H   H EEEEE                C
C                                                                      C
C----------------------------------------------------------------------C
C
      USE INTERFACE_SISYPHE_BEDLOAD
      USE INTERFACE_SISYPHE_SUSPENSION
C
      INTERFACE
        SUBROUTINE AFFECT_MAT(IELMU)
          USE BIEF_DEF
          IMPLICIT NONE
          INTEGER, INTENT(IN) :: IELMU
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE SIS_ARRET 
     &(ESM,EMAX,HN,VARSOR,NPOIN,MN,NRES,FMTRES,MAXVAR,AT0,RC,HIST,
     & BINRESSIS,TEXTE,SORLEO,SORIMP,T1,T2)
        USE BIEF_DEF
        IMPLICIT NONE
      TYPE(BIEF_OBJ),    INTENT(IN)    :: ESM, EMAX, HN, VARSOR
      INTEGER,           INTENT(IN)    :: NPOIN, MN, NRES, MAXVAR
      DOUBLE PRECISION,  INTENT(IN)    :: AT0, RC, HIST(1)
      CHARACTER(LEN=3),  INTENT(IN)    :: BINRESSIS
      CHARACTER(LEN=32), INTENT(IN)    :: TEXTE(MAXVAR)
      CHARACTER(LEN=8),  INTENT(IN)    :: FMTRES
      LOGICAL,           INTENT(IN)    :: SORLEO(*), SORIMP(*)
      TYPE(BIEF_OBJ),    INTENT(INOUT) :: T1, T2        
        END SUBROUTINE
      END INTERFACE
C      
      INTERFACE
        SUBROUTINE BILAN_SISYPHE
     *( E      , ESOMT  , QSX    , QSY    , MESH   , MSK    , MASKEL ,
     *  T1     , T2     , S      , IELMU  , VCUMU  , DT     , NPTFR  ,
     *  INFO   , ZFCL_C , QSCLXC , QSCLYC , NSICLA ,
     *  VOLTOT , DZF_GF , MASS_GF, LGRAFED, NUMLIQ , NFRLIQ)
      USE BIEF
      IMPLICIT NONE
      INTEGER, INTENT(IN)          :: NPTFR,NFRLIQ,IELMU,NSICLA
      INTEGER, INTENT(IN)          :: NUMLIQ(NPTFR)
      DOUBLE PRECISION, INTENT(IN) :: DT   
      LOGICAL, INTENT(IN)          :: MSK, INFO
      LOGICAL,          INTENT(IN)    :: LGRAFED
      DOUBLE PRECISION, INTENT(INOUT) :: MASS_GF,VCUMU
      DOUBLE PRECISION, INTENT(IN)    :: VOLTOT(10) 
      TYPE(BIEF_OBJ), INTENT(IN)    :: MASKEL,S,ZFCL_C,QSCLXC,QSCLYC
      TYPE(BIEF_OBJ), INTENT(IN)    :: E,ESOMT,QSX,QSY,DZF_GF
      TYPE(BIEF_OBJ), INTENT(INOUT) :: T1,T2 
      TYPE(BIEF_MESH) :: MESH
        END SUBROUTINE
      END INTERFACE 
C
      INTERFACE
        SUBROUTINE CALCUW( UW, H, HW, TW, GRAV ,NPOIN)                                                    
        IMPLICIT NONE                                                                                                                                           
        INTEGER, INTENT(IN) :: NPOIN                                                             
        DOUBLE PRECISION, INTENT(INOUT) :: UW(NPOIN) 
        DOUBLE PRECISION, INTENT(IN) :: H(NPOIN)                                
        DOUBLE PRECISION, INTENT(IN) :: TW(NPOIN),HW(NPOIN) 
        DOUBLE PRECISION, INTENT(IN) :: GRAV 
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE CHECK2
     *  ( NVAR1 , NVAR   , KNO    , NUMEN  , DT  , ATDEB,
     *  NHIST , LOGPRE , NPOIN  , NPRE   , PERMA  , TEXTLU ,
     *  STD , CODE )
        USE BIEF_DEF
        IMPLICIT NONE
        INTEGER, INTENT (INOUT) :: NVAR,NVAR1
        INTEGER, INTENT (INOUT) ::  KNO,NUMEN
        INTEGER, INTENT (IN)    :: LOGPRE,NHIST,NPOIN,NPRE
        DOUBLE PRECISION, INTENT (INOUT):: ATDEB, DT
        LOGICAL, INTENT(IN):: PERMA
        CHARACTER(LEN=24) :: CODE
        CHARACTER*3  STD
        CHARACTER*32 TEXTLU(26)
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE COEFRO_SISYPHE
     *  (CF,H,KFROT,CHESTR,GRAV,NPOIN,HMIN,KARMAN)
        USE BIEF_DEF
        IMPLICIT NONE
        INTEGER, INTENT(IN):: NPOIN,KFROT
        DOUBLE PRECISION,INTENT(IN):: GRAV,KARMAN,HMIN
        TYPE(BIEF_OBJ), INTENT(INOUT) :: CF
        TYPE(BIEF_OBJ),INTENT(IN) :: CHESTR,H     
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE CONDIM_SISYPHE
     * (U      , V   , QU    , QV  , H   , ZF , Z ,
     *  ESOMT   , THETAW ,  Q     , HW  , TW  , 
     *  X      , Y   , NPOIN , AT  , PMAREE)
        IMPLICIT NONE
        INTEGER, INTENT(IN) :: NPOIN 
        DOUBLE PRECISION, INTENT(IN) :: X(NPOIN) , Y(NPOIN)
        DOUBLE PRECISION, INTENT(IN) :: AT , PMAREE 
        DOUBLE PRECISION, INTENT(INOUT) ::  ZF(NPOIN)
        DOUBLE PRECISION, INTENT (INOUT)::  ESOMT(NPOIN)
        DOUBLE PRECISION, INTENT(INOUT) ::  Z(NPOIN) , H(NPOIN)
        DOUBLE PRECISION, INTENT(INOUT) ::  U(NPOIN) , V(NPOIN)
        DOUBLE PRECISION, INTENT (INOUT)::  QU(NPOIN), QV(NPOIN)
        DOUBLE PRECISION, INTENT (INOUT):: Q(NPOIN)
        DOUBLE PRECISION, INTENT (INOUT)::  HW(NPOIN) , TW(NPOIN)
        DOUBLE PRECISION, INTENT (INOUT):: THETAW (NPOIN)
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE CONDIM_SUSP(CS,CS0,NSICLA,X,Y,AT,NPOIN)
        USE BIEF_DEF
        IMPLICIT NONE
        INTEGER, INTENT(IN)           :: NPOIN,NSICLA 
        DOUBLE PRECISION,INTENT(IN)   :: AT,CS0(NSICLA)
        DOUBLE PRECISION,INTENT(IN)   :: X(NPOIN),Y(NPOIN)
        TYPE(BIEF_OBJ), INTENT(INOUT) :: CS
        END SUBROUTINE
      END INTERFACE
C      
      INTERFACE
        SUBROUTINE CONDIS_SISYPHE (CONSTFLOW)
        USE BIEF_DEF
        IMPLICIT NONE
        LOGICAL, INTENT(INOUT) :: CONSTFLOW    
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE CONLIT(NBOR)
        USE BIEF_DEF
        IMPLICIT NONE
        INTEGER, INTENT(IN):: NBOR(*)      
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE CORSTR_SISYPHE                                                                
        IMPLICIT NONE                                                     
        END SUBROUTINE
      END INTERFACE

      INTERFACE
        SUBROUTINE DEBUG_SISYPHE (NAME, ILOOP, NLOOP)
        USE BIEF_DEF
        IMPLICIT NONE
        INTEGER, PARAMETER :: SIZE =100
        CHARACTER(LEN=SIZE)  , INTENT(IN) :: NAME
        INTEGER,   INTENT(IN), OPTIONAL :: ILOOP, NLOOP        
        END SUBROUTINE
      END INTERFACE
C  
      INTERFACE
       SUBROUTINE ENTETE_SISYPHE(IETAPE,AT,LT)
       IMPLICIT NONE
       DOUBLE PRECISION, INTENT(IN) :: AT
       INTEGER, INTENT(IN):: LT,IETAPE
       END SUBROUTINE
      END INTERFACE
C
      INTERFACE
       SUBROUTINE FLUSEC_SISYPHE
     *(U,V,H,QSXC,QSYC,CHARR,QSXS,QSYS,SUSP,
     * IKLE,NELMAX,NELEM,X,Y,DT,NCP,CTRLSC,INFO,TPS,KNOGL)
         USE BIEF_DEF
         IMPLICIT NONE
         INTEGER, INTENT(IN)          :: NELMAX,NELEM,NCP
         INTEGER, INTENT(IN)          :: IKLE(NELMAX,*) 
         INTEGER, INTENT(IN)          :: CTRLSC(NCP),KNOGL(*) 
         DOUBLE PRECISION, INTENT(IN) :: X(*),Y(*),TPS,DT
         LOGICAL, INTENT(IN)          :: INFO,SUSP,CHARR
         TYPE(BIEF_OBJ), INTENT(IN)   :: U,V,H,QSXC,QSYC,QSXS,QSYS
       END SUBROUTINE
      END INTERFACE
C
      INTERFACE
       SUBROUTINE FLUXPR_SISYPHE
     *(NSEC, CTRLSC, FLX, VOLNEG, VOLPOS, INFO, TPS, NSEG, NCSIZE,  !jaj #### TPS
     * FLXS,VOLNEGS,VOLPOSS,SUSP,FLXC,VOLNEGC,VOLPOSC,CHARR)
      IMPLICIT NONE
      INTEGER, INTENT(IN)          :: NSEC,NCSIZE
      INTEGER, INTENT(IN)          :: CTRLSC(*)
      INTEGER, INTENT(IN)          :: NSEG(NSEC)
      LOGICAL, INTENT(IN)          :: INFO,SUSP,CHARR
      DOUBLE PRECISION, INTENT(IN) :: FLX(NSEC), TPS                !jaj #### TPS
      DOUBLE PRECISION, INTENT(IN) :: VOLNEG(NSEC),VOLPOS(NSEC)
      DOUBLE PRECISION, INTENT(IN) :: FLXS(NSEC),FLXC(NSEC)
      DOUBLE PRECISION, INTENT(IN) :: VOLNEGS(NSEC),VOLPOSS(NSEC)
      DOUBLE PRECISION, INTENT(IN) :: VOLNEGC(NSEC),VOLPOSC(NSEC)
       END SUBROUTINE
      END INTERFACE
C 
      INTERFACE    
       SUBROUTINE GF_USER(TBEG_GF,TEND_GF,AT0)
       IMPLICIT NONE
       DOUBLE PRECISION, INTENT(INOUT) :: TBEG_GF, TEND_GF
       DOUBLE PRECISION, INTENT(IN)    :: AT0
       END SUBROUTINE
      END INTERFACE
C
      INTERFACE    
       SUBROUTINE INIT_AVAI 
       USE BIEF_DEF
       IMPLICIT NONE
       END SUBROUTINE
      END INTERFACE
C
      INTERFACE    
        SUBROUTINE INIT_COMPO(NCOUCHES)
          USE BIEF_DEF
          IMPLICIT NONE
          INTEGER, INTENT(INOUT):: NCOUCHES(*)
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE    
        SUBROUTINE INIT_CONSTANT 
     &  (KARIM_HOLLY_YANG, KARMAN,  PI)
        IMPLICIT NONE
        DOUBLE PRECISION, INTENT(INOUT) :: KARIM_HOLLY_YANG
        DOUBLE PRECISION, INTENT(INOUT) :: KARMAN
         DOUBLE PRECISION, INTENT(INOUT) :: PI
C
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE INIT_MIXTE
     *(XMVS,NPOIN,AVAIL,NSICLA,ES,ELAY,NCOUCH_TASS,CONC_VASE,
     *  MS_SABLE,MS_VASE,ZF,ZR,AVA0)
      USE BIEF_DEF
      IMPLICIT NONE
      INTEGER, INTENT(IN)             :: NPOIN,NSICLA,NCOUCH_TASS 
      DOUBLE PRECISION, INTENT(IN)    :: XMVS
      DOUBLE PRECISION, INTENT(IN)    :: ZF(NPOIN), ZR(NPOIN)
      DOUBLE PRECISION, INTENT(INOUT) :: AVAIL(NPOIN,10,NSICLA)
      DOUBLE PRECISION, INTENT(INOUT) :: ES(NPOIN,10),ELAY(NPOIN)
      DOUBLE PRECISION,  INTENT(INOUT):: MS_SABLE(NPOIN,10)
      DOUBLE PRECISION,  INTENT(INOUT):: MS_VASE(NPOIN,10)
      DOUBLE PRECISION, INTENT(IN)    :: CONC_VASE(10)  
      DOUBLE PRECISION, INTENT(IN)    :: AVA0(NSICLA)
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE    
        SUBROUTINE INIT_SEDIMENT
     *(NSICLA,ELAY,ZF,ZR,NPOIN,AVAIL,FRACSED_GF,AVA0,  
     * LGRAFED,CALWC,XMVS,XMVE,GRAV,VCE,XWC,FDM, 
     * CALAC,AC, SEDCO, ES, NCOUCH_TASS,CONC_VASE,
     * MS_SABLE, MS_VASE,ACLADM, UNLADM)
      USE BIEF
      IMPLICIT NONE
      INTEGER,           INTENT(IN)     :: NSICLA,NPOIN
      INTEGER,           INTENT(IN)     :: NCOUCH_TASS
      TYPE(BIEF_OBJ),    INTENT(INOUT)  :: ELAY,ZF,ZR    
      TYPE(BIEF_OBJ), INTENT(INOUT)     :: MS_SABLE, MS_VASE
      TYPE(BIEF_OBJ), INTENT(INOUT)      :: ACLADM,UNLADM 
      LOGICAL,           INTENT(IN)     :: LGRAFED,CALWC,CALAC
      LOGICAL,           INTENT(IN)     :: SEDCO(NSICLA)       
      DOUBLE PRECISION,  INTENT(IN)     :: XMVS,XMVE,GRAV,VCE
      DOUBLE PRECISION,  INTENT(INOUT)  :: AVA0(NSICLA)
      DOUBLE PRECISION,  INTENT(INOUT)  :: AVAIL(NPOIN,10,NSICLA)
      DOUBLE PRECISION,  INTENT(INOUT)  :: FRACSED_GF(NSICLA)    
      DOUBLE PRECISION,  INTENT(INOUT)  :: FDM(NSICLA),XWC(NSICLA)
      DOUBLE PRECISION,  INTENT(INOUT)  :: AC(NSICLA)
      DOUBLE PRECISION, INTENT(IN)    :: CONC_VASE(10)
      DOUBLE PRECISION, INTENT(INOUT) :: ES(NPOIN,10)  
 
       END SUBROUTINE
      END INTERFACE
C
C
      INTERFACE    
        SUBROUTINE INIT_TRANSPORT
     *  (TROUVE,DEBU,HIDING,NSICLA,NPOIN,
     *   T1,T2,T3,T4,T5,T6,T7,T8,T9, T10,T11,T12,T14,
     *   CHARR,QS_C,QSXC, QSYC,CALFA,SALFA,COEFPN,SLOPEFF,
     *   SUSP, QS_S,QS,QSCL, QSCL_C,QSCL_S,QSCLXS,QSCLYS, 
     *   UNORM, U2D,V2D,HN,CF,MU,TOB,TOBW,UW,TW,THETAW, FW,HOULE,
     *   AVAIL, ACLADM,UNLADM,KSP, KSR,
     *   ICF,HIDFAC,XMVS,XMVE,GRAV,VCE,XKV,HMIN, KARMAN,
     *   ZERO,PI,AC,IMP_INFLOW_C,ZREF,ICQ,CSTAEQ,
     *   CMAX,CS,CS0,UCONV,VCONV,CORR_CONV,SECCURRENT,BIJK,
     *   IELMT, MESH, FDM,XWC,FD90,SEDCO,VITCE,PARTHENIADES,VITCD)
        USE BIEF
       IMPLICIT NONE
       INTEGER, INTENT(IN)              :: NSICLA,NPOIN,TROUVE(*),ICQ
       INTEGER, INTENT(IN)              :: ICF,HIDFAC,IELMT,SLOPEFF
       LOGICAL, INTENT(IN)              :: CHARR,DEBU,SUSP,IMP_INFLOW_C
       LOGICAL, INTENT(IN)              :: CORR_CONV,SECCURRENT,SEDCO(*)
       LOGICAL, INTENT(IN)              :: HOULE
       TYPE(BIEF_OBJ), INTENT(IN)    :: U2D,V2D,UNORM, HN,CF
       TYPE(BIEF_OBJ), INTENT(IN)    :: MU,TOB,TOBW,UW,TW,THETAW,FW
       TYPE(BIEF_OBJ), INTENT(IN)    :: ACLADM,UNLADM,KSP, KSR
       TYPE(BIEF_OBJ), INTENT(INOUT) :: HIDING
       TYPE(BIEF_OBJ), INTENT(INOUT) :: QS_C, QSXC, QSYC, CALFA,SALFA
       TYPE(BIEF_OBJ), INTENT(INOUT) :: T1,T2,T3,T4,T5,T6,T7,T8 
       TYPE(BIEF_OBJ), INTENT(INOUT) :: T9,T10,T11,T12,T14
       TYPE(BIEF_OBJ), INTENT(INOUT) :: ZREF,CSTAEQ,CS,UCONV,VCONV
       TYPE(BIEF_OBJ), INTENT(INOUT) :: QS_S,QS,QSCL_C,QSCL_S
       TYPE(BIEF_OBJ),  INTENT(INOUT) :: COEFPN
       TYPE(BIEF_OBJ),  INTENT(INOUT) :: QSCLXS,QSCLYS,QSCL
       TYPE(BIEF_MESH), INTENT(INOUT) :: MESH
       DOUBLE PRECISION, INTENT(IN)    :: XMVS,XMVE,GRAV,VCE
       DOUBLE PRECISION, INTENT(IN)    :: XKV,HMIN,KARMAN,ZERO,PI
       DOUBLE PRECISION,  INTENT(IN)    :: PARTHENIADES,BIJK,XWC(NSICLA)
       DOUBLE PRECISION,  INTENT(IN)    :: FD90(NSICLA),CS0(NSICLA)
       DOUBLE PRECISION,  INTENT(IN)    :: VITCE,VITCD
       DOUBLE PRECISION,  INTENT(INOUT) :: AC(NSICLA),CMAX,FDM(NSICLA)
       DOUBLE PRECISION,  INTENT(INOUT) :: AVAIL(NPOIN,10,NSICLA)
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE    
       SUBROUTINE INTEG ( A , B , IEIN , NPOIN)                              
       IMPLICIT NONE                                                             
       INTEGER, INTENT(IN):: NPOIN  
       DOUBLE PRECISION, INTENT(IN)::A(NPOIN), B(NPOIN) 
       DOUBLE PRECISION, INTENT(INOUT)::IEIN(NPOIN)
       END SUBROUTINE
      END INTERFACE
C
      INTERFACE    
        SUBROUTINE LAYER 
     &(ZFCL_W,NLAYER,ZR,ZF,ESTRAT,ELAY,MASBAS,
     & ACLADM,NSICLA,NPOIN,ELAY0,VOLTOT,
     & ES,AVAIL,CONST_ALAYER,DTS,ESTRATNEW,NLAYNEW)
      USE BIEF_DEF
      IMPLICIT NONE
      TYPE (BIEF_OBJ),  INTENT(IN)    :: ZFCL_W,ZR,ZF,MASBAS,ACLADM
      INTEGER,          INTENT(IN)    :: NSICLA, NPOIN
      DOUBLE PRECISION, INTENT(IN)    :: DTS
      LOGICAL,          INTENT(IN)    :: CONST_ALAYER 
      TYPE (BIEF_OBJ),  INTENT(INOUT) :: NLAYER,ESTRAT,ELAY
      DOUBLE PRECISION, INTENT(INOUT) :: ELAY0
      DOUBLE PRECISION, INTENT(INOUT) :: ES(NPOIN,10)
      DOUBLE PRECISION, INTENT(INOUT) :: AVAIL(NPOIN,10,NSICLA)
      DOUBLE PRECISION, INTENT(INOUT) :: VOLTOT(10),ESTRATNEW(NPOIN)
      INTEGER         , INTENT(INOUT) :: NLAYNEW(NPOIN)
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE LECDON_SISYPHE(MOTCAR,FILE_DESC,PATH,NCAR,CODE)
          IMPLICIT NONE
          INTEGER, INTENT(IN)               :: NCAR
          CHARACTER(LEN=24), INTENT(IN)     :: CODE
          CHARACTER(LEN=250), INTENT(IN)    :: PATH
          CHARACTER*144, INTENT(INOUT)      :: MOTCAR(*)
          CHARACTER(LEN=144), INTENT(INOUT) :: FILE_DESC(4,300)
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE    
       SUBROUTINE LECLIS 
     *  (LIEBOR,EBOR,NPTFR,NBOR,STDGEO,NLIM,KENT,ISEG,XSEG,YSEG ,    
     &   NACHB,NUMLIQ,NSICLA,AFBOR,BFBOR,BOUNDARY_COLOUR,MESH)
        USE BIEF_DEF
        IMPLICIT NONE            
        INTEGER, INTENT(IN)           :: NPTFR
        INTEGER, INTENT(INOUT)        :: LIEBOR(NPTFR)
        INTEGER, INTENT(INOUT)        :: BOUNDARY_COLOUR(NPTFR)
        TYPE(BIEF_OBJ),INTENT(INOUT)  :: EBOR
        INTEGER, INTENT(INOUT)        :: NBOR(NPTFR)
        INTEGER, INTENT(IN) ::       STDGEO,NLIM,KENT
        INTEGER, INTENT(IN) :: NSICLA
        double precision, INTENT(INOUT):: xseg(nptfr),yseg(nptfr)
        integer, INTENT(INOUT):: iseg(nptfr),nachb(5,*),numliq(*)
        DOUBLE PRECISION, INTENT(INOUT):: AFBOR(NPTFR),BFBOR(NPTFR)
        TYPE(BIEF_MESH), INTENT(INOUT) :: MESH
        END SUBROUTINE
      END INTERFACE
C      
      INTERFACE    
       SUBROUTINE MASKAB(HN , Q , QU , QV , NPOIN)
       IMPLICIT NONE
       INTEGER, INTENT(IN):: NPOIN
       DOUBLE PRECISION , INTENT(IN)::HN(NPOIN)
       DOUBLE PRECISION, INTENT(INOUT):: Q(NPOIN),QU(NPOIN),QV(NPOIN)   
       END SUBROUTINE
      END INTERFACE
C
      INTERFACE                      
        SUBROUTINE MAXSLOPE                                                                      
     *(SLOPE,ZF,ZR,XEL,YEL,NELEM,NELMAX,NPOIN,IKLE,EVOL,UNSV2D,MESH)
      USE BIEF_DEF                                                                       
      IMPLICIT NONE                                                     
      INTEGER, INTENT(IN)             :: NELEM,NELMAX,NPOIN
      INTEGER, INTENT(IN)             :: IKLE(NELMAX,3)                                                                       
      DOUBLE PRECISION, INTENT(IN   ) :: SLOPE
      DOUBLE PRECISION, INTENT(INOUT) :: ZF(NPOIN)   
      DOUBLE PRECISION, INTENT(IN)    :: ZR(NPOIN)
      DOUBLE PRECISION, INTENT(IN)    :: XEL(NELMAX,3),YEL(NELMAX,3)
      TYPE(BIEF_OBJ), INTENT(INOUT)   :: EVOL
      TYPE(BIEF_OBJ), INTENT(IN)      :: UNSV2D
      TYPE(BIEF_MESH)                 :: MESH 
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE    
        SUBROUTINE MEAN_GRAIN_SIZE
          USE BIEF
          IMPLICIT NONE            
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE NOMVAR_SISYPHE(TEXTE,TEXTPR,MNEMO,NSICLA,UNIT)
          IMPLICIT NONE
          INTEGER, INTENT(IN)         :: NSICLA
          CHARACTER*8, INTENT(INOUT)  :: MNEMO(100)
          CHARACTER*32, INTENT(INOUT) :: TEXTE(100),TEXTPR(100)
          LOGICAL,INTENT(IN)          :: UNIT
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE    
       SUBROUTINE NOEROD 
     * (H , ZF , ZR , Z , X , Y , NPOIN , CHOIX , NLISS )
       INTEGER, INTENT(IN):: NPOIN , CHOIX 
        INTEGER, INTENT(INOUT):: NLISS 
       DOUBLE PRECISION, INTENT(IN)::  Z(NPOIN) , ZF(NPOIN)    
       DOUBLE PRECISION , INTENT(IN)::  X(NPOIN) , Y(NPOIN), H(NPOIN)
       DOUBLE PRECISION , INTENT(INOUT)::  ZR(NPOIN)
       END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE PREDES(LLT,AAT)
          IMPLICIT NONE
          INTEGER, INTENT(IN) :: LLT
          DOUBLE PRECISION, INTENT(IN) :: AAT
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE QSFORM
          IMPLICIT NONE
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE
       SUBROUTINE RESCUE_SISYPHE                                                                                                           
     *(QU,QV,Q,U,V,H,S,ZF,HW,TW,THETAW,NPOIN,TROUVE,ALIRE,PASS,
     * ICF,LISTI)                                                                           
       IMPLICIT NONE                                                     
       INTEGER, INTENT(IN) :: TROUVE(100),ALIRE(100),NPOIN,ICF
       LOGICAL, INTENT(IN) :: PASS,LISTI                                                                       
       DOUBLE PRECISION, INTENT(INOUT) :: QU(NPOIN), QV(NPOIN), Q(NPOIN)
       DOUBLE PRECISION, INTENT(INOUT) :: U(NPOIN) , V(NPOIN)   
       DOUBLE PRECISION, INTENT(INOUT) :: S(NPOIN) , ZF(NPOIN), H(NPOIN) 
       DOUBLE PRECISION, INTENT(INOUT) :: HW(NPOIN), TW(NPOIN)
       DOUBLE PRECISION, INTENT(INOUT) :: THETAW(NPOIN) 
       END SUBROUTINE
      END INTERFACE
C
      INTERFACE
       SUBROUTINE RESCUE_SISYPHE_NOTPERMA                                                                                                           
     * (QU,QV,Q,U,V,H,S,ZF,HW,TW,THETAW,NPOIN,TROUVE,ALIRE,ICF,
     *  ENTET)                                                   
C
       IMPLICIT NONE                                                     
C
       INTEGER, INTENT(IN) :: TROUVE(100),ALIRE(100),NPOIN,ICF
       LOGICAL, INTENT(IN) :: ENTET
C                                                                       
       DOUBLE PRECISION, INTENT(INOUT) :: QU(NPOIN), QV(NPOIN), Q(NPOIN)
       DOUBLE PRECISION, INTENT(INOUT) :: U(NPOIN) , V(NPOIN)   
       DOUBLE PRECISION, INTENT(INOUT) :: S(NPOIN) , ZF(NPOIN), H(NPOIN) 
       DOUBLE PRECISION, INTENT(INOUT) :: HW(NPOIN), TW(NPOIN)
       DOUBLE PRECISION, INTENT(INOUT) :: THETAW(NPOIN) 
C
       END SUBROUTINE
      END INTERFACE     
C
      INTERFACE
        SUBROUTINE RIDE                                      
     * (KS,TW,UW,UNORM,GRAV,XMVE,XMVS,VCE,NPOIN,KSPRATIO,ACLADM)
        IMPLICIT NONE                                                             
        INTEGER, INTENT(IN) ::NPOIN
        DOUBLE PRECISION, INTENT(INOUT) :: KS(NPOIN)
        DOUBLE PRECISION, INTENT(IN) :: GRAV,XMVE,XMVS, VCE                    
        DOUBLE PRECISION, INTENT(IN) :: UNORM(NPOIN)
        DOUBLE PRECISION, INTENT(IN) :: UW(NPOIN), TW(NPOIN)
        DOUBLE PRECISION, INTENT(IN) :: KSPRATIO
        DOUBLE PRECISION, INTENT(IN) :: ACLADM(NPOIN)
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE RIDE_VR                                      
     * (KSR,KS,UNORM,HN,GRAV,XMVE,XMVS,NPOIN,ACLADM)
      IMPLICIT NONE
      INTEGER, INTENT(IN)            :: NPOIN
      DOUBLE PRECISION, INTENT(IN)   :: GRAV,XMVE,XMVS   
      DOUBLE PRECISION, INTENT(INOUT):: KSR(NPOIN),KS(NPOIN)
      DOUBLE PRECISION, INTENT(IN)   :: HN(NPOIN), UNORM(NPOIN)
      DOUBLE PRECISION, INTENT(IN)   :: ACLADM(NPOIN) 
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE SIS_ERODE                                      
     *  (ZFCL_S,FLUDP,FLUER,DT,NPOIN,XMVS,XKV,QFLUX,SEDCO,CONC_VASE,
     *   NCOUCH_TASS,MS_SABLE, MS_VASE)
      USE BIEF_DEF
      IMPLICIT NONE
      TYPE (BIEF_OBJ),  INTENT(INOUT) :: ZFCL_S,FLUDP,FLUER,QFLUX
      DOUBLE PRECISION, INTENT(IN)    :: DT, XMVS,XKV
      INTEGER, INTENT(IN) :: NPOIN,NCOUCH_TASS
      LOGICAL, INTENT(IN) :: SEDCO 
      DOUBLE PRECISION, INTENT(IN) :: CONC_VASE(10)
      DOUBLE PRECISION,  INTENT(INOUT) :: MS_SABLE(NPOIN,10)
      DOUBLE PRECISION,  INTENT(INOUT) :: MS_VASE(NPOIN,10)
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE SISYPHE(PART,LOOPCOUNT,GRAFCOUNT,LISTCOUNT,TELNIT,
     *                     U_TEL,V_TEL,H_TEL,HN_TEL,
     *                     ZF_SIS,UETCAR,CF_TEL,
     *                     CONSTFLOW,NSIS_CFD,SISYPHE_CFD,CODE,PERICOU,
     *                     U3D,V3D,T_TEL,VISC_TEL,
     *                     DT_TEL,CHARR_TEL,SUSP_TEL,FLBOR_TEL,
     *                     SOLSYS,DM1,UCONV_TEL,VCONV_TEL,ZCONV)
          USE BIEF_DEF
          IMPLICIT NONE
          INTEGER,          INTENT(IN)   :: PART,LOOPCOUNT,GRAFCOUNT
          INTEGER,          INTENT(IN)   :: LISTCOUNT,TELNIT,PERICOU
          CHARACTER(LEN=24),INTENT(IN)   :: CODE
          TYPE(BIEF_OBJ),   INTENT(IN)   :: U_TEL,V_TEL,H_TEL,HN_TEL
          TYPE(BIEF_OBJ),   INTENT(INOUT):: ZF_SIS, UETCAR 
          INTEGER,          INTENT(INOUT):: NSIS_CFD
          LOGICAL,          INTENT(INOUT):: CONSTFLOW,SISYPHE_CFD
          TYPE(BIEF_OBJ),   INTENT(IN)   :: U3D,V3D,VISC_TEL
          TYPE(BIEF_OBJ),   INTENT(INOUT):: CF_TEL
          DOUBLE PRECISION, INTENT(IN)   :: T_TEL
          LOGICAL, INTENT(INOUT)         :: CHARR_TEL,SUSP_TEL
          DOUBLE PRECISION,  INTENT(IN)  :: DT_TEL
          INTEGER,           INTENT(IN)  :: SOLSYS
          TYPE(BIEF_OBJ), INTENT(IN)     :: FLBOR_TEL,DM1,ZCONV
          TYPE(BIEF_OBJ), INTENT(IN)     :: UCONV_TEL,VCONV_TEL
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE TASSEMENT 
     &(ZF,NPOIN,DTS,ELAY,DZF_TASS,T2,LT,AVAIL,NSICLA,ES,XMVS,
     * XKV,TRANS_MASS,CONC_VASE,NCOUCH_TASS,MS_SABLE, MS_VASE)
      USE BIEF_DEF
      IMPLICIT NONE
      INTEGER, INTENT(IN) :: NPOIN,NSICLA
      TYPE (BIEF_OBJ),  INTENT(INOUT) :: DZF_TASS,ZF,ELAY,T2
      DOUBLE PRECISION,  INTENT(INOUT):: MS_SABLE(NPOIN,10)
      DOUBLE PRECISION,  INTENT(INOUT):: MS_VASE(NPOIN,10)
      DOUBLE PRECISION, INTENT(IN)    :: DTS
      INTEGER, INTENT(IN)             :: LT,NCOUCH_TASS
      DOUBLE PRECISION, INTENT(INOUT) :: AVAIL(NPOIN,10,NSICLA)
      DOUBLE PRECISION, INTENT(INOUT) :: ES(NPOIN,10)
      DOUBLE PRECISION, INTENT(IN) :: TRANS_MASS(10), CONC_VASE(10) 
      DOUBLE PRECISION, INTENT(IN) :: XMVS, XKV
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE TOBW_SISYPHE(TOBW ,CF, FW, UW,TW,HN,NPOIN,XMVE)                                         
          IMPLICIT NONE                                                                      
          INTEGER, INTENT(IN) :: NPOIN                                                                    
          DOUBLE PRECISION, INTENT(IN) :: CF(NPOIN)
          DOUBLE PRECISION, INTENT(IN) :: UW(NPOIN),TW(NPOIN),HN(NPOIN)                                         
          DOUBLE PRECISION, INTENT(IN)    :: XMVE
          DOUBLE PRECISION, INTENT(INOUT) :: TOBW(NPOIN),FW(NPOIN) 
        END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE TOB_SISYPHE                                                                       
     * (TOB, TOBW, MU, KS,KSP,KSR, CF,FW,CHESTR,UETCAR,CF_TEL,CODE,
     *  KFROT,ICR, KSPRATIO, HOULE,GRAV,XMVE,XMVS, VCE, KARMAN,
     *    ZERO,HMIN, HN, ACLADM, UNORM,UW, TW,  NPOIN)
      USE BIEF                                                                     
      IMPLICIT NONE                                                                  
      INTEGER, INTENT(IN) :: NPOIN,KFROT,ICR
      LOGICAL, INTENT(IN) :: HOULE
      CHARACTER(LEN=24),  INTENT(IN) :: CODE
      DOUBLE PRECISION,   INTENT(IN) :: XMVE,XMVS, VCE,GRAV,KARMAN
      DOUBLE PRECISION,   INTENT(IN) :: ZERO,HMIN,KSPRATIO
      TYPE(BIEF_OBJ), INTENT(IN)   :: UETCAR
      TYPE(BIEF_OBJ), INTENT(IN)   :: HN,UNORM
      TYPE(BIEF_OBJ), INTENT(IN)   :: TW,UW
      TYPE(BIEF_OBJ), INTENT(INOUT)   :: KS,KSP,KSR
      TYPE(BIEF_OBJ), INTENT(INOUT)   :: CHESTR,MU
      TYPE(BIEF_OBJ), INTENT(IN)   :: ACLADM
      TYPE(BIEF_OBJ), INTENT(INOUT) :: CF,TOB
      TYPE(BIEF_OBJ), INTENT(INOUT) :: FW,TOBW 
      TYPE(BIEF_OBJ), INTENT(IN)    :: CF_TEL
      END SUBROUTINE
      END INTERFACE
C
      INTERFACE
        SUBROUTINE VITCHU_SISYPHE( WS , DENS , DM , GRAV , VCE )                  
          IMPLICIT NONE                                                                                                                                            
          DOUBLE PRECISION, INTENT(IN)    :: DENS,  DM,  GRAV, VCE
          DOUBLE PRECISION, INTENT(INOUT) :: WS 
        END SUBROUTINE
      END INTERFACE
!
!======================================================================!
!======================================================================!
!
      END MODULE INTERFACE_SISYPHE

