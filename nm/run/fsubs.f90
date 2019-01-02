      MODULE NMPRD4P
      USE SIZES, ONLY: DPSIZE
      USE NMPRD4,ONLY: VRBL
      IMPLICIT NONE
      SAVE
      REAL(KIND=DPSIZE), DIMENSION (:),POINTER ::COM
      REAL(KIND=DPSIZE), POINTER ::Vc,Vm,CLp,CLm,CLd1,CLd2,S1,S2,Ke1
      REAL(KIND=DPSIZE), POINTER ::Ke2,K12,K21,Y,A000032,A000034
      REAL(KIND=DPSIZE), POINTER ::A000035,A000036,A000037,A000038
      REAL(KIND=DPSIZE), POINTER ::E000005,E000006,F000118,F000123
      REAL(KIND=DPSIZE), POINTER ::F000124,F000120,F000122,E000022
      REAL(KIND=DPSIZE), POINTER ::E000023,F000173,F000169,F000174
      REAL(KIND=DPSIZE), POINTER ::F000171,F000175
      CONTAINS
      SUBROUTINE ASSOCNMPRD4
      COM=>VRBL
      Vc=>COM(000001);Vm=>COM(000002);CLp=>COM(000003)
      CLm=>COM(000004);CLd1=>COM(000005);CLd2=>COM(000006)
      S1=>COM(000007);S2=>COM(000008);Ke1=>COM(000009)
      Ke2=>COM(000010);K12=>COM(000011);K21=>COM(000012)
      Y=>COM(000013);A000032=>COM(000014);A000034=>COM(000015)
      A000035=>COM(000016);A000036=>COM(000017);A000037=>COM(000018)
      A000038=>COM(000019);E000005=>COM(000020);E000006=>COM(000021)
      F000118=>COM(000022);F000123=>COM(000023);F000124=>COM(000024)
      F000120=>COM(000025);F000122=>COM(000026);E000022=>COM(000027)
      E000023=>COM(000028);F000173=>COM(000029);F000169=>COM(000030)
      F000174=>COM(000031);F000171=>COM(000032);F000175=>COM(000033)
      END SUBROUTINE ASSOCNMPRD4
      END MODULE NMPRD4P
      SUBROUTINE MODEL (IDNO,NCM,NPAR,IR,IATT,LINK)                           
      USE PRMOD_CHAR, ONLY: NAME                                              
      USE SIZES,     ONLY: DPSIZE,ISIZE,SD
      USE PRDIMS,    ONLY: GPRD,HPRD,GERD,HERD,GPKD
      INTEGER(KIND=ISIZE) :: IDNO,NCM,NPAR,IR,IATT,LINK,I,J                   
      DIMENSION :: IATT(IR,*),LINK(IR,*)                                      
      SAVE
      INTEGER(KIND=ISIZE), DIMENSION (2,7) :: MOD
      CHARACTER(LEN=SD), DIMENSION(2) :: CMOD
      DATA (MOD(I,  1),I=  1,  2)/&
      1,1 /
      DATA (MOD(I,  2),I=  1,  2)/&
      1,1 /
      DATA (MOD(I,  3),I=  1,  2)/&
      1,1 /
      DATA (MOD(I,  4),I=  1,  2)/&
      1,0 /
      DATA (MOD(I,  5),I=  1,  2)/&
      1,0 /
      DATA (MOD(I,  6),I=  1,  2)/&
      0,0 /
      DATA (MOD(I,  7),I=  1,  2)/&
      0,0 /
      DATA (CMOD(I),I=  1,  2) &
      /'PARENT','METABOLITE'/
      FORALL (I=1:2) NAME(I)=CMOD(I)
      FORALL (I=1:2,J=1:7) IATT(I,J)=MOD(I,J)
      IDNO=9999                                                               
      NCM=  2
      NPAR=006
      RETURN
      END
      SUBROUTINE PK(ICALL,IDEF,THETA,IREV,EVTREC,NVNT,INDXS,IRGG,GG,NETAS)      
      USE NMPRD4P
      USE SIZES,     ONLY: DPSIZE,ISIZE
      USE PRDIMS,    ONLY: GPRD,HPRD,GERD,HERD,GPKD
      USE NMBAYES_REAL,    ONLY: PRIORINFO
      USE PRDATA, ONLY: MXSTEP=>MXSTP01
      USE NMPRD_REAL,ONLY: ETA,EPS                                            
      USE NMPRD_INT, ONLY: MSEC=>ISECDER,MFIRST=>IFRSTDER,COMACT,COMSAV,IFIRSTEM
      USE NMPRD_INT, ONLY: MDVRES,ETASXI,NPDE_MODE,NOFIRSTDERCODE
      USE NMPRD_REAL, ONLY: DV_LOQ,CDF_L,DV_LAQ,CDF_LA
      USE NMPRD_INT, ONLY: IQUIT
      USE PROCM_INT, ONLY: NEWIND=>PNEWIF                                       
      USE NMBAYES_REAL, ONLY: LDF                                             
      IMPLICIT REAL(KIND=DPSIZE) (A-Z)                                          
      REAL(KIND=DPSIZE) :: EVTREC                                               
      SAVE
      INTEGER(KIND=ISIZE) :: FIRSTEM
      INTEGER(KIND=ISIZE) :: ICALL,IDEF,IREV,NVNT,INDXS,IRGG,NETAS              
      DIMENSION :: IDEF(7,*),THETA(*),EVTREC(IREV,*),INDXS(*),GG(IRGG,GPKD+1,*) 
      FIRSTEM=IFIRSTEM
      IF (ICALL <= 1) THEN                                                      
      CALL ASSOCNMPRD4
      IDEF(   1,0001)=  -9
      IDEF(   1,0002)=  -1
      IDEF(   1,0003)=   0
      IDEF(   1,0004)=   0
      IDEF(   2,0003)=   0
      IDEF(   2,0004)=   0
      IDEF(   3,0001)=   7
      IDEF(   3,0002)=   8
      CALL GETETA(ETA)                                                          
      IF (IQUIT == 1) RETURN                                                    
      RETURN                                                                    
      ENDIF                                                                     
      IF (NEWIND /= 2) THEN
      IF (ICALL == 4) THEN
      CALL SIMETA(ETA)
      ELSE
      CALL GETETA(ETA)
      ENDIF
      IF (IQUIT == 1) RETURN
      ENDIF
 !  level            0
      B000001=DEXP(ETA(001)) 
      Vc=THETA(001)*B000001 
      Vm=THETA(002) 
      CLp=THETA(003) 
      CLm=THETA(004) 
      CLd1=THETA(005) 
      CLd2=THETA(006) 
      S1=Vc 
      S2=Vm 
      P000001=CLp 
      P000002=Vc 
      P000003=CLm 
      P000004=Vm 
      P000005=CLd1 
      P000006=CLd2 
      IF (FIRSTEM == 1) THEN
!                      A000032 = DERIVATIVE OF Vc W.R.T. ETA(001)
      A000032=THETA(001)*B000001 
!                      A000035 = DERIVATIVE OF S1 W.R.T. ETA(001)
      A000035=A000032 
!                      A000037 = DERIVATIVE OF P000002 W.R.T. ETA(001)
      A000037=A000032 
      GG(0001,1,1)=P000001
      GG(0002,1,1)=P000002
      GG(0002,0002,1)=A000037
      GG(0003,1,1)=P000003
      GG(0004,1,1)=P000004
      GG(0005,1,1)=P000005
      GG(0006,1,1)=P000006
      GG(0007,1,1)=S1
      GG(0007,0002,1)=A000035
      GG(0008,1,1)=S2
      ELSE
      GG(0001,1,1)=P000001
      GG(0002,1,1)=P000002
      GG(0003,1,1)=P000003
      GG(0004,1,1)=P000004
      GG(0005,1,1)=P000005
      GG(0006,1,1)=P000006
      GG(0007,1,1)=S1
      GG(0008,1,1)=S2
      ENDIF
      IF (MSEC == 1) THEN
!                      A000034 = DERIVATIVE OF A000032 W.R.T. ETA(001)
      A000034=THETA(001)*B000001 
!                      A000036 = DERIVATIVE OF A000035 W.R.T. ETA(001)
      A000036=A000034 
!                      A000038 = DERIVATIVE OF A000037 W.R.T. ETA(001)
      A000038=A000034 
      GG(0002,0002,0002)=A000038
      GG(0007,0002,0002)=A000036
      ENDIF
      RETURN
      END
      SUBROUTINE ERROR (ICALL,IDEF,THETA,IREV,EVTREC,NVNT,INDXS,F,G,HH)       
      USE NMPRD4P
      USE SIZES,     ONLY: DPSIZE,ISIZE
      USE PRDIMS,    ONLY: GPRD,HPRD,GERD,HERD,GPKD
      USE NMPRD_REAL,ONLY: ETA,EPS                                            
      USE NMPRD_INT, ONLY: MSEC=>ISECDER,MFIRST=>IFRSTDER,IQUIT,IFIRSTEM
      USE NMPRD_INT, ONLY: MDVRES,ETASXI,NPDE_MODE,NOFIRSTDERCODE
      USE NMPRD_REAL, ONLY: DV_LOQ,CDF_L,DV_LAQ,CDF_LA
      USE NMPRD_INT, ONLY: NEWL2
      USE PROCM_INT, ONLY: NEWIND=>PNEWIF                                       
      IMPLICIT REAL(KIND=DPSIZE) (A-Z)                                        
      REAL(KIND=DPSIZE) :: EVTREC                                             
      SAVE
      INTEGER(KIND=ISIZE) :: ICALL,IDEF,IREV,NVNT,INDXS                       
      DIMENSION :: IDEF(*),THETA(*),EVTREC(IREV,*),INDXS(*)                   
      REAL(KIND=DPSIZE) :: G(GERD,*),HH(HERD,*)                               
      INTEGER(KIND=ISIZE) :: FIRSTEM
      FIRSTEM=IFIRSTEM
      IF (ICALL <= 1) THEN                                                    
      CALL ASSOCNMPRD4
      IDEF(2)=2
      IDEF(1)=1
      HH(1,1)=1.0D0
      IDEF(3)=000
      RETURN
      ENDIF
      IF (ICALL == 4) THEN
      IF (NEWL2 == 1) THEN
      CALL SIMEPS(EPS)
      IF (IQUIT == 1) RETURN
      ENDIF
      ENDIF
 !  level            0
      Y=F+F*EPS(001) 
      IF (FIRSTEM == 1) THEN !1
      ENDIF !1
      F=Y
      RETURN
      END
      SUBROUTINE TOL(NRD,ANRD,NRDC,ANRDC)
      USE SIZES,     ONLY: ISIZE
      INTEGER(KIND=ISIZE) :: NRD(0:*), ANRD(0:*), NRDC(0:*), ANRDC(0:*)
      NRD(1)=6 
      RETURN
      END
      SUBROUTINE DES (A,P,T,DADT,IR,DA,DP,DT)                                 
      USE NMPRD4P
      USE SIZES,     ONLY: DPSIZE,ISIZE
      USE PRDIMS,    ONLY: GPRD,HPRD,GERD,HERD,GPKD
      USE NMPRD_INT, ONLY: IERPRD,IERPRDU,NETEXT,IQUIT                        
      USE NMPRD_CHAR,ONLY: ETEXT                                              
      USE NMPRD_INT, ONLY: MSEC=>ISECDER,MFIRST=>IFRSTDER,IFIRSTEM,IFIRSTEMJAC
      USE PRCOM_INT, ONLY: MITER
      USE NMPRD_INT, ONLY: MDVRES,ETASXI,NPDE_MODE,NOFIRSTDERCODE
      USE NMPRD_REAL, ONLY: DV_LOQ,CDF_L,DV_LAQ,CDF_LA
      USE PRMOD_INT, ONLY: ICALL=>ICALLD,IDEFD,IDEFA
      IMPLICIT REAL(KIND=DPSIZE) (A-Z)                                        
      SAVE
      INTEGER(KIND=ISIZE) :: IR                                               
      DIMENSION :: A(*),P(*),DADT(*),DA(IR,*),DP(IR,*),DT(*)                  
      INTEGER(KIND=ISIZE) :: FIRSTEM,IFIRSTEMJACIN
      IF(MITER==1.OR.MITER==4) IFIRSTEM=1
      FIRSTEM=IFIRSTEM
      IFIRSTEMJACIN=IFIRSTEMJAC
      IF(NOFIRSTDERCODE/=1) THEN
      IFIRSTEMJAC=FIRSTEM
      ELSE
      IFIRSTEMJAC=0
      ENDIF
      IF(IFIRSTEMJACIN==-2) RETURN
      IF (ICALL == 1) THEN
      CALL ASSOCNMPRD4
      IDEFD(1)=  0
      IDEFD(2)=0
      DA(   1,1)=0000014280
      DA(   2,1)=0000014399
      DA(   3,1)=0000028441
      DA(   4,1)=0000028560
      DA(   5,1)=0000014311
      DA(   6,1)=0000014312
      DA(   7,1)=0000014315
      DA(   8,1)=0000028473
      DA(   9,1)=0000028475
      DA(  10,1)=0000028476
      DA(  11,1)=0000014431
      DA(  12,1)=0000014433
      DA(  13,1)=0000014435
      DA(  14,1)=0000028593
      DA(  15,1)=0000028594
      DA(  16,1)=0000028596
      DA(  17,1)=0000000000
      DP(   1,1)=0000014280
      DP(   2,1)=0000014399
      DP(   3,1)=0000014637
      DP(   4,1)=0000014756
      DP(   5,1)=0000014875
      DP(   6,1)=0000028560
      DP(   7,1)=0000028679
      DP(   8,1)=0000028798
      DP(   9,1)=0000028917
      DP(  10,1)=0000029036
      DP(  11,1)=0000014400
      DP(  12,1)=0000014282
      DP(  13,1)=0000014401
      DP(  14,1)=0000014639
      DP(  15,1)=0000014758
      DP(  16,1)=0000014877
      DP(  17,1)=0000028562
      DP(  18,1)=0000028800
      DP(  19,1)=0000028919
      DP(  20,1)=0000028801
      DP(  21,1)=0000014403
      DP(  22,1)=0000014641
      DP(  23,1)=0000014879
      DP(  24,1)=0000028564
      DP(  25,1)=0000028683
      DP(  26,1)=0000028802
      DP(  27,1)=0000028921
      DP(  28,1)=0000029040
      DP(  29,1)=0000014404
      DP(  30,1)=0000028565
      DP(  31,1)=0000028803
      DP(  32,1)=0000014405
      DP(  33,1)=0000014643
      DP(  34,1)=0000028804
      DP(  35,1)=0000000000
      DT(   1)=0000000000
      RETURN
      ENDIF
 !  level            0
 !  level            0
      Ke1=P(001)/P(002) 
      Ke2=P(003)/P(004) 
      K12=P(005)/P(002) 
      K21=P(006)/P(004) 
      DADT(1)=-Ke1*A(1)-K12*A(1)+K21*A(2)*P(002)/P(004) 
      DADT(2)=-Ke2*A(2)+K12*A(1)*P(004)/P(002)-K21*A(2) 
      IF (FIRSTEM == 1) THEN ! 1
      B000001=1.D0/P(002) 
      B000002=-P(001)/P(002)/P(002) 
      B000007=1.D0/P(004) 
      B000008=-P(003)/P(004)/P(004) 
      B000013=1.D0/P(002) 
      B000014=-P(005)/P(002)/P(002) 
      B000019=1.D0/P(004) 
      B000020=-P(006)/P(004)/P(004) 
!                      E000004 = DERIVATIVE OF DADT(1) W.R.T. A(001)
      E000004=-Ke1 
!                      E000005 = DERIVATIVE OF DADT(1) W.R.T. A(001)
      E000005=-K12+E000004 
      B000025=K21*P(002)/P(004) 
!                      E000006 = DERIVATIVE OF DADT(1) W.R.T. A(002)
      E000006=B000025 
!                      F000117 = DERIVATIVE OF DADT(1) W.R.T. P(002)
      F000117=-A(1)*B000002 
!                      F000118 = DERIVATIVE OF DADT(1) W.R.T. P(001)
      F000118=-A(1)*B000001 
!                      F000119 = DERIVATIVE OF DADT(1) W.R.T. P(002)
      F000119=-A(1)*B000014+F000117 
!                      F000120 = DERIVATIVE OF DADT(1) W.R.T. P(005)
      F000120=-A(1)*B000013 
      B000029=A(2)*P(002)/P(004) 
!                      F000121 = DERIVATIVE OF DADT(1) W.R.T. P(004)
      F000121=B000029*B000020 
!                      F000122 = DERIVATIVE OF DADT(1) W.R.T. P(006)
      F000122=B000029*B000019 
      B000030=K21*A(2)/P(004) 
!                      F000123 = DERIVATIVE OF DADT(1) W.R.T. P(002)
      F000123=B000030+F000119 
      B000031=-K21*A(2)*P(002)/P(004)/P(004) 
!                      F000124 = DERIVATIVE OF DADT(1) W.R.T. P(004)
      F000124=B000031+F000121 
!                      E000021 = DERIVATIVE OF DADT(2) W.R.T. A(002)
      E000021=-Ke2 
      B000044=K12*P(004)/P(002) 
!                      E000022 = DERIVATIVE OF DADT(2) W.R.T. A(001)
      E000022=B000044 
!                      E000023 = DERIVATIVE OF DADT(2) W.R.T. A(002)
      E000023=-K21+E000021 
!                      F000168 = DERIVATIVE OF DADT(2) W.R.T. P(004)
      F000168=-A(2)*B000008 
!                      F000169 = DERIVATIVE OF DADT(2) W.R.T. P(003)
      F000169=-A(2)*B000007 
      B000048=A(1)*P(004)/P(002) 
!                      F000170 = DERIVATIVE OF DADT(2) W.R.T. P(002)
      F000170=B000048*B000014 
!                      F000171 = DERIVATIVE OF DADT(2) W.R.T. P(005)
      F000171=B000048*B000013 
      B000049=K12*A(1)/P(002) 
!                      F000172 = DERIVATIVE OF DADT(2) W.R.T. P(004)
      F000172=B000049+F000168 
      B000050=-K12*A(1)*P(004)/P(002)/P(002) 
!                      F000173 = DERIVATIVE OF DADT(2) W.R.T. P(002)
      F000173=B000050+F000170 
!                      F000174 = DERIVATIVE OF DADT(2) W.R.T. P(004)
      F000174=-A(2)*B000020+F000172 
!                      F000175 = DERIVATIVE OF DADT(2) W.R.T. P(006)
      F000175=-A(2)*B000019 
      ENDIF !1
      IF (MSEC == 1) THEN 
      B000003=-1.D0/P(002)/P(002) 
!                      F000084 = DERIVATIVE OF F000081 W.R.T. P(002)
      F000084=B000003 
      B000004=-1.D0/P(002)/P(002) 
      B000005=P(001)/P(002)/P(002)/P(002) 
      B000006=P(001)/P(002)/P(002)/P(002) 
!                      F000087 = DERIVATIVE OF B000002 W.R.T. P(002)
      F000087=B000006+B000005 
!                      F000088 = DERIVATIVE OF F000082 W.R.T. P(002)
      F000088=F000087 
!                      F000089 = DERIVATIVE OF F000082 W.R.T. P(001)
      F000089=B000004 
      B000009=-1.D0/P(004)/P(004) 
!                      F000093 = DERIVATIVE OF F000090 W.R.T. P(004)
      F000093=B000009 
      B000010=-1.D0/P(004)/P(004) 
      B000011=P(003)/P(004)/P(004)/P(004) 
      B000012=P(003)/P(004)/P(004)/P(004) 
!                      F000096 = DERIVATIVE OF B000008 W.R.T. P(004)
      F000096=B000012+B000011 
!                      F000097 = DERIVATIVE OF F000091 W.R.T. P(004)
      F000097=F000096 
!                      F000098 = DERIVATIVE OF F000091 W.R.T. P(003)
      F000098=B000010 
      B000015=-1.D0/P(002)/P(002) 
!                      F000102 = DERIVATIVE OF F000099 W.R.T. P(002)
      F000102=B000015 
      B000016=-1.D0/P(002)/P(002) 
      B000017=P(005)/P(002)/P(002)/P(002) 
      B000018=P(005)/P(002)/P(002)/P(002) 
!                      F000105 = DERIVATIVE OF B000014 W.R.T. P(002)
      F000105=B000018+B000017 
!                      F000106 = DERIVATIVE OF F000100 W.R.T. P(002)
      F000106=F000105 
!                      F000107 = DERIVATIVE OF F000100 W.R.T. P(005)
      F000107=B000016 
      B000021=-1.D0/P(004)/P(004) 
!                      F000111 = DERIVATIVE OF F000108 W.R.T. P(004)
      F000111=B000021 
      B000022=-1.D0/P(004)/P(004) 
      B000023=P(006)/P(004)/P(004)/P(004) 
      B000024=P(006)/P(004)/P(004)/P(004) 
!                      F000114 = DERIVATIVE OF B000020 W.R.T. P(004)
      F000114=B000024+B000023 
!                      F000115 = DERIVATIVE OF F000109 W.R.T. P(004)
      F000115=F000114 
!                      F000116 = DERIVATIVE OF F000109 W.R.T. P(006)
      F000116=B000022 
!                      F000127 = DERIVATIVE OF F000117 W.R.T. P(001)
      F000127=-A(1)*F000089 
!                      F000128 = DERIVATIVE OF F000117 W.R.T. P(002)
      F000128=-A(1)*F000088 
!                      F000129 = DERIVATIVE OF F000118 W.R.T. P(002)
      F000129=-A(1)*F000084 
!                      F000130 = DERIVATIVE OF F000119 W.R.T. P(005)
      F000130=-A(1)*F000107 
!                      F000131 = DERIVATIVE OF F000119 W.R.T. P(002)
      F000131=-A(1)*F000106 
!                      F000132 = DERIVATIVE OF F000119 W.R.T. P(002)
      F000132=F000128+F000131 
!                      F000133 = DERIVATIVE OF F000119 W.R.T. P(001)
      F000133=F000127 
!                      F000134 = DERIVATIVE OF F000120 W.R.T. P(002)
      F000134=-A(1)*F000102 
      B000033=A(2)/P(004) 
      B000034=-A(2)*P(002)/P(004)/P(004) 
!                      F000137 = DERIVATIVE OF F000121 W.R.T. P(004)
      F000137=B000020*B000034 
!                      F000138 = DERIVATIVE OF F000121 W.R.T. P(002)
      F000138=B000020*B000033 
!                      F000139 = DERIVATIVE OF F000121 W.R.T. P(006)
      F000139=B000029*F000116 
!                      F000140 = DERIVATIVE OF F000121 W.R.T. P(004)
      F000140=B000029*F000115+F000137 
!                      F000141 = DERIVATIVE OF F000122 W.R.T. P(004)
      F000141=B000019*B000034 
!                      F000142 = DERIVATIVE OF F000122 W.R.T. P(002)
      F000142=B000019*B000033 
!                      F000143 = DERIVATIVE OF F000122 W.R.T. P(004)
      F000143=B000029*F000111+F000141 
      B000035=A(2)/P(004) 
!                      F000144 = DERIVATIVE OF B000030 W.R.T. P(006)
      F000144=B000035*B000019 
!                      F000145 = DERIVATIVE OF B000030 W.R.T. P(004)
      F000145=B000035*B000020 
      B000036=-K21*A(2)/P(004)/P(004) 
!                      F000146 = DERIVATIVE OF B000030 W.R.T. P(004)
      F000146=B000036+F000145 
!                      F000147 = DERIVATIVE OF F000123 W.R.T. P(004)
      F000147=F000146 
!                      F000148 = DERIVATIVE OF F000123 W.R.T. P(006)
      F000148=F000144 
!                      F000149 = DERIVATIVE OF F000123 W.R.T. P(001)
      F000149=F000133 
!                      F000150 = DERIVATIVE OF F000123 W.R.T. P(002)
      F000150=F000132 
!                      F000151 = DERIVATIVE OF F000123 W.R.T. P(005)
      F000151=F000130 
      B000037=-A(2)*P(002)/P(004)/P(004) 
!                      F000152 = DERIVATIVE OF B000031 W.R.T. P(006)
      F000152=B000037*B000019 
!                      F000153 = DERIVATIVE OF B000031 W.R.T. P(004)
      F000153=B000037*B000020 
      B000038=-K21*A(2)/P(004)/P(004) 
      B000039=K21*A(2)*P(002)/P(004)/P(004)/P(004) 
!                      F000155 = DERIVATIVE OF B000031 W.R.T. P(004)
      F000155=B000039+F000153 
      B000040=K21*A(2)*P(002)/P(004)/P(004)/P(004) 
!                      F000156 = DERIVATIVE OF B000031 W.R.T. P(004)
      F000156=B000040+F000155 
!                      F000157 = DERIVATIVE OF F000124 W.R.T. P(004)
      F000157=F000156 
!                      F000158 = DERIVATIVE OF F000124 W.R.T. P(002)
      F000158=B000038 
!                      F000159 = DERIVATIVE OF F000124 W.R.T. P(006)
      F000159=F000152 
!                      F000160 = DERIVATIVE OF F000124 W.R.T. P(004)
      F000160=F000140+F000157 
!                      F000161 = DERIVATIVE OF F000124 W.R.T. P(006)
      F000161=F000139+F000159 
!                      F000162 = DERIVATIVE OF F000124 W.R.T. P(002)
      F000162=F000138+F000158 
!                      F000165 = DERIVATIVE OF F000125 W.R.T. P(006)
      F000165=F000116 
!                      F000166 = DERIVATIVE OF F000125 W.R.T. P(004)
      F000166=F000115 
!                      F000167 = DERIVATIVE OF F000126 W.R.T. P(004)
      F000167=F000111 
!                      E000007 = DERIVATIVE OF F000117 W.R.T. A(001)
      E000007=-B000002 
!                      E000008 = DERIVATIVE OF F000118 W.R.T. A(001)
      E000008=-B000001 
!                      E000009 = DERIVATIVE OF F000119 W.R.T. A(001)
      E000009=-B000014 
!                      E000010 = DERIVATIVE OF F000119 W.R.T. A(001)
      E000010=E000007+E000009 
!                      E000011 = DERIVATIVE OF F000120 W.R.T. A(001)
      E000011=-B000013 
      B000041=P(002)/P(004) 
!                      E000013 = DERIVATIVE OF F000121 W.R.T. A(002)
      E000013=B000020*B000041 
!                      E000014 = DERIVATIVE OF F000122 W.R.T. A(002)
      E000014=B000019*B000041 
      B000042=K21/P(004) 
!                      E000016 = DERIVATIVE OF F000123 W.R.T. A(002)
      E000016=B000042 
!                      E000017 = DERIVATIVE OF F000123 W.R.T. A(001)
      E000017=E000010 
      B000043=-K21*P(002)/P(004)/P(004) 
!                      E000019 = DERIVATIVE OF F000124 W.R.T. A(002)
      E000019=B000043 
!                      E000020 = DERIVATIVE OF F000124 W.R.T. A(002)
      E000020=E000013+E000019 
!                      F000178 = DERIVATIVE OF F000168 W.R.T. P(003)
      F000178=-A(2)*F000098 
!                      F000179 = DERIVATIVE OF F000168 W.R.T. P(004)
      F000179=-A(2)*F000097 
!                      F000180 = DERIVATIVE OF F000169 W.R.T. P(004)
      F000180=-A(2)*F000093 
      B000052=A(1)/P(002) 
      B000053=-A(1)*P(004)/P(002)/P(002) 
!                      F000183 = DERIVATIVE OF F000170 W.R.T. P(002)
      F000183=B000014*B000053 
!                      F000184 = DERIVATIVE OF F000170 W.R.T. P(004)
      F000184=B000014*B000052 
!                      F000185 = DERIVATIVE OF F000170 W.R.T. P(005)
      F000185=B000048*F000107 
!                      F000186 = DERIVATIVE OF F000170 W.R.T. P(002)
      F000186=B000048*F000106+F000183 
!                      F000187 = DERIVATIVE OF F000171 W.R.T. P(002)
      F000187=B000013*B000053 
!                      F000188 = DERIVATIVE OF F000171 W.R.T. P(004)
      F000188=B000013*B000052 
!                      F000189 = DERIVATIVE OF F000171 W.R.T. P(002)
      F000189=B000048*F000102+F000187 
      B000054=A(1)/P(002) 
!                      F000190 = DERIVATIVE OF B000049 W.R.T. P(005)
      F000190=B000054*B000013 
!                      F000191 = DERIVATIVE OF B000049 W.R.T. P(002)
      F000191=B000054*B000014 
      B000055=-K12*A(1)/P(002)/P(002) 
!                      F000192 = DERIVATIVE OF B000049 W.R.T. P(002)
      F000192=B000055+F000191 
!                      F000193 = DERIVATIVE OF F000172 W.R.T. P(002)
      F000193=F000192 
!                      F000194 = DERIVATIVE OF F000172 W.R.T. P(005)
      F000194=F000190 
!                      F000195 = DERIVATIVE OF F000172 W.R.T. P(004)
      F000195=F000179 
!                      F000196 = DERIVATIVE OF F000172 W.R.T. P(003)
      F000196=F000178 
      B000056=-A(1)*P(004)/P(002)/P(002) 
!                      F000197 = DERIVATIVE OF B000050 W.R.T. P(005)
      F000197=B000056*B000013 
!                      F000198 = DERIVATIVE OF B000050 W.R.T. P(002)
      F000198=B000056*B000014 
      B000057=-K12*A(1)/P(002)/P(002) 
      B000058=K12*A(1)*P(004)/P(002)/P(002)/P(002) 
!                      F000200 = DERIVATIVE OF B000050 W.R.T. P(002)
      F000200=B000058+F000198 
      B000059=K12*A(1)*P(004)/P(002)/P(002)/P(002) 
!                      F000201 = DERIVATIVE OF B000050 W.R.T. P(002)
      F000201=B000059+F000200 
!                      F000202 = DERIVATIVE OF F000173 W.R.T. P(002)
      F000202=F000201 
!                      F000203 = DERIVATIVE OF F000173 W.R.T. P(004)
      F000203=B000057 
!                      F000204 = DERIVATIVE OF F000173 W.R.T. P(005)
      F000204=F000197 
!                      F000205 = DERIVATIVE OF F000173 W.R.T. P(002)
      F000205=F000186+F000202 
!                      F000206 = DERIVATIVE OF F000173 W.R.T. P(005)
      F000206=F000185+F000204 
!                      F000207 = DERIVATIVE OF F000173 W.R.T. P(004)
      F000207=F000184+F000203 
!                      F000208 = DERIVATIVE OF F000174 W.R.T. P(006)
      F000208=-A(2)*F000116 
!                      F000209 = DERIVATIVE OF F000174 W.R.T. P(004)
      F000209=-A(2)*F000115 
!                      F000210 = DERIVATIVE OF F000174 W.R.T. P(003)
      F000210=F000196 
!                      F000211 = DERIVATIVE OF F000174 W.R.T. P(004)
      F000211=F000195+F000209 
!                      F000212 = DERIVATIVE OF F000174 W.R.T. P(005)
      F000212=F000194 
!                      F000213 = DERIVATIVE OF F000174 W.R.T. P(002)
      F000213=F000193 
!                      F000214 = DERIVATIVE OF F000175 W.R.T. P(004)
      F000214=-A(2)*F000111 
!                      F000217 = DERIVATIVE OF F000176 W.R.T. P(005)
      F000217=F000107 
!                      F000218 = DERIVATIVE OF F000176 W.R.T. P(002)
      F000218=F000106 
!                      F000219 = DERIVATIVE OF F000177 W.R.T. P(002)
      F000219=F000102 
!                      E000024 = DERIVATIVE OF F000168 W.R.T. A(002)
      E000024=-B000008 
!                      E000025 = DERIVATIVE OF F000169 W.R.T. A(002)
      E000025=-B000007 
      B000060=P(004)/P(002) 
!                      E000027 = DERIVATIVE OF F000170 W.R.T. A(001)
      E000027=B000014*B000060 
!                      E000028 = DERIVATIVE OF F000171 W.R.T. A(001)
      E000028=B000013*B000060 
      B000061=K12/P(002) 
!                      E000030 = DERIVATIVE OF F000172 W.R.T. A(001)
      E000030=B000061 
!                      E000031 = DERIVATIVE OF F000172 W.R.T. A(002)
      E000031=E000024 
      B000062=-K12*P(004)/P(002)/P(002) 
!                      E000033 = DERIVATIVE OF F000173 W.R.T. A(001)
      E000033=B000062 
!                      E000034 = DERIVATIVE OF F000173 W.R.T. A(001)
      E000034=E000027+E000033 
!                      E000035 = DERIVATIVE OF F000174 W.R.T. A(002)
      E000035=-B000020 
!                      E000036 = DERIVATIVE OF F000174 W.R.T. A(002)
      E000036=E000031+E000035 
!                      E000037 = DERIVATIVE OF F000174 W.R.T. A(001)
      E000037=E000030 
!                      E000038 = DERIVATIVE OF F000175 W.R.T. A(002)
      E000038=-B000019 
      ENDIF !msec
      IF (FIRSTEM == 1) THEN !2
      DA(   1,1)=E000005
      DA(   2,1)=E000006
      DA(   3,1)=E000022
      DA(   4,1)=E000023
      DP(   1,1)=F000118
      DP(   2,1)=F000123
      DP(   3,1)=F000124
      DP(   4,1)=F000120
      DP(   5,1)=F000122
      DP(   6,1)=F000173
      DP(   7,1)=F000169
      DP(   8,1)=F000174
      DP(   9,1)=F000171
      DP(  10,1)=F000175
      ENDIF !2
      IF (MSEC == 1) THEN
      DA(   5,1)=E000008
      DA(   6,1)=E000017
      DA(   7,1)=E000011
      DA(   8,1)=E000034
      DA(   9,1)=E000037
      DA(  10,1)=E000028
      DA(  11,1)=E000016
      DA(  12,1)=E000020
      DA(  13,1)=E000014
      DA(  14,1)=E000025
      DA(  15,1)=E000036
      DA(  16,1)=E000038
      DP(  11,1)=F000149
      DP(  12,1)=F000129
      DP(  13,1)=F000150
      DP(  14,1)=F000162
      DP(  15,1)=F000134
      DP(  16,1)=F000142
      DP(  17,1)=F000205
      DP(  18,1)=F000213
      DP(  19,1)=F000189
      DP(  20,1)=F000210
      DP(  21,1)=F000147
      DP(  22,1)=F000160
      DP(  23,1)=F000143
      DP(  24,1)=F000207
      DP(  25,1)=F000180
      DP(  26,1)=F000211
      DP(  27,1)=F000188
      DP(  28,1)=F000214
      DP(  29,1)=F000151
      DP(  30,1)=F000206
      DP(  31,1)=F000212
      DP(  32,1)=F000148
      DP(  33,1)=F000161
      DP(  34,1)=F000208
      ENDIF
      RETURN
      END
      SUBROUTINE FSIZESR(NAME_FSIZES,F_SIZES)
      USE SIZES, ONLY: ISIZE
      INTEGER(KIND=ISIZE), DIMENSION(*) :: F_SIZES
      CHARACTER(LEN=*),    DIMENSION(*) :: NAME_FSIZES
      NAME_FSIZES(01)='LTH'; F_SIZES(01)=6
      NAME_FSIZES(02)='LVR'; F_SIZES(02)=2
      NAME_FSIZES(03)='LVR2'; F_SIZES(03)=0
      NAME_FSIZES(04)='LPAR'; F_SIZES(04)=8
      NAME_FSIZES(05)='LPAR3'; F_SIZES(05)=0
      NAME_FSIZES(06)='NO'; F_SIZES(06)=0
      NAME_FSIZES(07)='MMX'; F_SIZES(07)=1
      NAME_FSIZES(08)='LNP4'; F_SIZES(08)=0
      NAME_FSIZES(09)='LSUPP'; F_SIZES(09)=1
      NAME_FSIZES(10)='LIM7'; F_SIZES(10)=0
      NAME_FSIZES(11)='LWS3'; F_SIZES(11)=0
      NAME_FSIZES(12)='MAXIDS'; F_SIZES(12)=2
      NAME_FSIZES(13)='LIM1'; F_SIZES(13)=0
      NAME_FSIZES(14)='LIM2'; F_SIZES(14)=0
      NAME_FSIZES(15)='LIM3'; F_SIZES(15)=0
      NAME_FSIZES(16)='LIM4'; F_SIZES(16)=0
      NAME_FSIZES(17)='LIM5'; F_SIZES(17)=0
      NAME_FSIZES(18)='LIM6'; F_SIZES(18)=0
      NAME_FSIZES(19)='LIM8'; F_SIZES(19)=0
      NAME_FSIZES(20)='LIM10'; F_SIZES(20)=0
      NAME_FSIZES(21)='LIM11'; F_SIZES(21)=0
      NAME_FSIZES(22)='LIM13'; F_SIZES(22)=0
      NAME_FSIZES(23)='LIM15'; F_SIZES(23)=0
      NAME_FSIZES(24)='LIM16'; F_SIZES(24)=0
      NAME_FSIZES(25)='MAXRECID'; F_SIZES(25)=0
      NAME_FSIZES(26)='PC'; F_SIZES(26)=0
      NAME_FSIZES(27)='PCT'; F_SIZES(27)=1
      NAME_FSIZES(28)='PIR'; F_SIZES(28)=35
      NAME_FSIZES(29)='PD'; F_SIZES(29)=8
      NAME_FSIZES(30)='PAL'; F_SIZES(30)=0
      NAME_FSIZES(31)='MAXFCN'; F_SIZES(31)=0
      NAME_FSIZES(32)='MAXIC'; F_SIZES(32)=0
      NAME_FSIZES(33)='PG'; F_SIZES(33)=0
      NAME_FSIZES(34)='NPOPMIXMAX'; F_SIZES(34)=0
      NAME_FSIZES(35)='MAXOMEG'; F_SIZES(35)=1
      NAME_FSIZES(36)='MAXPTHETA'; F_SIZES(36)=7
      NAME_FSIZES(37)='MAXITER'; F_SIZES(37)=20
      NAME_FSIZES(38)='ISAMPLEMAX'; F_SIZES(38)=0
      NAME_FSIZES(39)='DIMTMP'; F_SIZES(39)=0
      NAME_FSIZES(40)='DIMCNS'; F_SIZES(40)=0
      NAME_FSIZES(41)='DIMNEW'; F_SIZES(41)=0
      NAME_FSIZES(42)='PDT'; F_SIZES(42)=1
      NAME_FSIZES(43)='LADD_MAX'; F_SIZES(43)=0
      NAME_FSIZES(44)='MAXSIDL'; F_SIZES(44)=0
      NAME_FSIZES(45)='NTT'; F_SIZES(45)=6
      NAME_FSIZES(46)='NOMEG'; F_SIZES(46)=1
      NAME_FSIZES(47)='NSIGM'; F_SIZES(47)=1
      NAME_FSIZES(48)='PPDT'; F_SIZES(48)=1
      RETURN
      END SUBROUTINE FSIZESR
      SUBROUTINE MUMODEL2(THETA,MU_,ICALL,IDEF,NEWIND,&
      EVTREC,DATREC,IREV,NVNT,INDXS,F,G,H,IRGG,GG,NETAS)
      USE NMPRD4P
      USE SIZES,     ONLY: DPSIZE,ISIZE
      USE PRDIMS,    ONLY: GPRD,HPRD,GERD,HERD,GPKD
      USE NMBAYES_REAL,    ONLY: PRIORINFO
      USE PRDATA, ONLY: MXSTEP=>MXSTP01
      USE NMPRD_REAL,ONLY: ETA,EPS
      USE NMPRD_INT, ONLY: MSEC=>ISECDER,MFIRST=>IFRSTDER,COMACT,COMSAV,IFIRSTEM
      USE NMPRD_INT, ONLY: MDVRES,ETASXI,NPDE_MODE,NOFIRSTDERCODE
      USE NMPRD_REAL, ONLY: DV_LOQ,CDF_L,DV_LAQ,CDF_LA
      USE NMPRD_INT, ONLY: IQUIT
      USE NMBAYES_REAL, ONLY: LDF
      IMPLICIT REAL(KIND=DPSIZE) (A-Z)
      REAL(KIND=DPSIZE)   :: MU_(*)
      INTEGER NEWIND
      REAL(KIND=DPSIZE) :: EVTREC
      SAVE
      INTEGER(KIND=ISIZE) :: FIRSTEM
      INTEGER(KIND=ISIZE) :: ICALL,IDEF,IREV,NVNT,INDXS,IRGG,NETAS
      DIMENSION :: IDEF(7,*),THETA(*),EVTREC(IREV,*),INDXS(*),GG(IRGG,GPKD+1,*)
      RETURN
      END
