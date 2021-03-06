C This file is part of the ESP-r system.
C Copyright Energy Systems Research Unit, University of
C Strathclyde, Glasgow Scotland, 2001.

C ESP-r is free software.  You can redistribute it and/or
C modify it under the terms of the GNU General Public
C License as published by the Free Software Foundation 
C (version 2 orlater).

C ESP-r is distributed in the hope that it will be useful
C but WITHOUT ANY WARRANTY; without even the implied
C warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
C PURPOSE. See the GNU General Public License for more
C details.

C You should have received a copy of the GNU General Public
C License along with ESP-r. If not, write to the Free
C Software Foundation, Inc., 59 Temple Place, Suite 330,
C Boston, MA 02111-1307 USA.

C *********************************************************************
C This file contains the following subroutines:

C INITPF is the main program for multi-dimensional gridding of the  
C        solid domain (air volumes gridding is not included).
C INTGRD initializes the gridding process by reading in the required 
C        geometry and construction data.

C ***************************  initpsfz  ********************************
C INITPFZ is the main program for multi-dimensional gridding of the  
C solid domain (air volumes gridding is not included).

C << calling routine could focus - 1D/3D ground etc. so the necessary
C << file names can be in place.

      program grd
      USE START_UP
#include "building.h"
#include "model.h"
#include "esprdbfile.h"
C esprdbfile.h supplies the following:
C LFMAT,IFMAT,LFMUL,IFMUL (for materials and constructions database)
#include "material.h"
#include "espriou.h"
#include "prj3dv.h"

      integer lnblnk  ! function definition
      integer igraphiclib  ! external definition

      COMMON/OUTIN/IUOUT,IUIN
      COMMON/FILEP/IFIL
      COMMON/SPAD/MMOD,LIMIT,LIMTTY
      integer ifs,itfs,imfs
      COMMON/GFONT/IFS,ITFS,IMFS
      integer menuchw,igl,igr,igt,igb,igw,igwh
      COMMON/VIEWPX/menuchw,igl,igr,igt,igb,igw,igwh
      common/appw/iappw,iappx,iappy
      common/appcols/mdispl,nifgrey,ncset,ngset,nzonec
      COMMON/gzonpik/izgfoc,nzg,nznog(mcom)
      COMMON/RAY2/ITDSP,ITBND,ITEPT,ITZNM,ITSNM,ITVNO,ITORG,ITSNR,
     &            ITOBS,ITHLS,ITHLZ,ITGRD,GRDIS,ITPPSW
      COMMON/RAY3/MODIFY,MODLEN,MODBND
      
      integer ncomp,ncon
      COMMON/C1/NCOMP,NCON

C Path to problem
      common/rpath/path
      common/rcmd/LCMDFL
      common/rzone/inzone

      COMMON/GR3D110/ICVS,ICNC,INDC,INDD,ITAQ,ITLW,ILWV,ITF3
      
C Significant figure reporting limit (NSIGFIG).
      common/SFIG/NSIGFIG

      COMMON/FOPENED/CFGOK,MLDBOK,MATDBOK,CTLOK,OPTKOK
      
C Name of current application
      common/APPNAME/cAppName
      
      character cAppName*12      
      
      LOGICAL        CFGOK,MLDBOK,MATDBOK,CTLOK,OPTKOK

      LOGICAL MODIFY,MODBND,MODLEN,XST,GRDOK

      DIMENSION ITEM(11)
      CHARACTER LFILE*72
      CHARACTER OUTSTR*124,ITEM*24,path*72,inf*144,LCMDFL*144
      character outs248*248,L144*144
      character inz*16,inzone*16,outs*124,MODE*4

      character cVnum*16      ! returned from ESPrVersionNum
      character pagestitle*44 ! for banner title via epages call

      integer iglib   ! if 1 then X11, if 2 then GTK, if 3 then text only.
#ifdef OSI
      integer numberofzones ! to pass to updwire rather than ncomp
      integer iigl,iigr,iigt,iigb,iigw,iigwh
      integer iiw1,iiw2,iiw3,iiw4,iimenu
      integer iicapture,iiazi    ! to pass to updcapt updazi
#else
      integer*8 numberofzones
      integer*8 iigl,iigr,iigt,iigb,iigw,iigwh
      integer*8 iiw1,iiw2,iiw3,iiw4,iimenu
      integer*8 iicapture,iiazi    ! to pass to updcapt updazi
#endif
      integer MITEM,INO ! max items and current menu item

C For help messages
      character helpinsub*24 ! subroutine name
      character helptopic*24 ! string (unique) for topic
      integer nbhelp     ! number of help lines found

C Initialize global common data.
      call ezero
      call curmodule('grd ')
      cAppName = 'grd'
      helpinapp='grd'  ! set once for the application
      helpinsub='grd'  ! set for MAIN
      ITRC=0
      IUOUT=6
      IUIN=5
      IFIL=11
      LIMTTY=8
      LIMIT =8
      IFS=1
      ITFS=0
      IMFS=1
      LIMTTY=20
      NSIGFIG=3
      matver=0.0   ! initial assumption of binary materials database
      path='./'
      IDRW1=0
      call parsfz(MODL,iappw,iappx,iappy,inf,inz)

C Assume configuration file is from IFIL+5, any leakage description
C is fom IFIL+6, revised config file on IFIL+3, updated geometry on
C IFILE+2 and ASCII viewing and geometry file reading on IFILE+1.
      IFMAT=IFIL+4
      IFCFG=IFIL+5
      IUF=IFIL+6
      ICVS=IFIL+8
      ICNC=IFIL+9
      INDC=IFIL+10
      ITAQ=IFIL+11

C Assume that the configuration and geometry files have not been read in.
      CFGOK=.FALSE.
      GRDOK=.FALSE.
      MLDBOK=.FALSE.
      MATDBOK=.FALSE.
      CTLOK=.FALSE.
      MODIFY=.FALSE.

C Initial coords for eyepoint, viewing point, angle of view.
      EYEM(1)=-100.
      EYEM(2)=-100.
      EYEM(3)=100.
      VIEWM(1)=10.
      VIEWM(2)=10.
      VIEWM(3)=10.
      ANG=40.

C General image option flags.
      ITDSP=1
      ITBND=1
      ITEPT=0
      ITZNM=0
      ITSNM=1
      ITVNO=1
      ITORG=1
      ITSNR=0
      ITGRD=1
      GRDIS=0.0
      ITPPSW=0

C Initialise output device, assume minimal trace, and a smallish
C display.
      MMOD=MODL
      if(iappw.eq.0.and.iappx.eq.0.and.iappy.eq.0)then
        iappw=510
        iappx=60
        iappy=60
      else
        if(iappx.le.0)iappx=60
        if(iappy.le.0)iappy=60
        if(iappw.le.200)then
          iappwi=int(510*iappw*0.01)
          iappw=iappwi
        elseif(iappw.gt.200)then
          continue
        endif
      endif

C Set pixels high to iappw and pixels wide to factor in monitor size.
      iapphi=iappw
      iappwi=int(real(iappw)*(1024.0/780.0))

      if(iappw.gt.0.and.iappw.lt.100)then
        menuchw = MAX0(int(28*iappw*0.01),12)
        LIMTTY=8
        LIMIT =8
      else
        menuchw = 28
        LIMTTY=8
        LIMIT =8
      endif
      IF(MMOD.EQ.8)THEN

C Set initial font sizes (IMFS is for graphs, IFS is for dialog & text feedback).
        IMFS=1
        IFS=1
        ITFS=1
        call userfonts(IFS,ITFS,IMFS)
      ELSE
        LIMTTY=16
        LIMIT =16
      ENDIF

C Find the current ESP-r version number and add it to application title.
      call ESPrVersionNum(cVnum)
      write(pagestitle,'(2a)') 'ESP-r Construction Gridding ',
     &  cVnum(1:lnblnk(cVnum))

      CALL EPAGES(MMOD,IUIN,IUOUT,iappwi,iapphi,iappx,iappy,menuchw,
     &  pagestitle)

C Open the text display box equal to LIMTTY if MMOD = 8.
      IF(MMOD.EQ.8)THEN

C Setup and pass in parameters to win3d.
        iiw1=3; iiw2=2; iiw3=2; iiw4=3; iimenu=menuchw
        iigl=igl; iigr=igr; iigt=igt; iigb=igb; iigw=igw; iigwh=igwh
        CALL win3d(iimenu,iiw1,iiw2,iiw3,iiw4,
     &    iigl,iigr,iigt,iigb,iigw,iigwh)
        igl=int(iigl); igr=int(iigr); igt=int(iigt); igb=int(iigb)
        igw=int(iigw); igwh=int(iigwh)
        iglib = igraphiclib()  ! find out if X11 or GTK or text support only.
        if(iglib.eq.1)then
          call opencpw
          call opensetup
          numberofzones=0
          call updwire(numberofzones)  ! pass local integer
          iicapture=1; iiazi=1
          call updcapt(iicapture)
          call updazi(iiazi)
        endif
        call setzscale()
        mdispl=0
        nifgrey=0
        ncset=0
        ngset=0
        nzonec=0
        call foundcolour(mdispl,nifgrey,ncset,ngset,nzonec)
        call startbuffer()
      ENDIF

      CALL ESPrVersion("summary",cAppName,IUOUT)

C Find the user's home folder then get users custom settings.
      call usrhome(upath)
      write(esprc,'(3a)') upath(1:lnblnk(upath)),'/.','esprc'
      call scesprc(esprc,IFIL+1,0,IIER)

C Scan the defaults file for default configuration.
C Make temporary use of file unit IFIL+1.  Note: escdef must come
C after scan of .esprc file.
      call escdef(IFIL+1,IER)

C Take command line file name as initial configuration file.
      if(inf(1:2).ne.'  '.and.inf(1:4).ne.'UNKN')then
        LCMDFL=inf
        call edisp(iuout,'  ')  ! echo blank line
        write(outs248,'(a,a)')'The input file is: ',LCMDFL
        call edisp248(iuout,outs248,80)
      else
        LCMDFL='  '
      endif

C Take command line zone name and
C determine if focus should be to a single zone.
      if(inz(1:1).ne.' ')then
        inzone=inz
        call edisp(iuout,'  ')  ! echo blank line
        write(outstr,'(a,a)')'The input zone is: ',inzone
        call edisp(iuout,outstr)
      else
        inzone='ALL'
      endif

C If an input file has been specified then load it.
      XST=.false.
      if(LCMDFL(1:2).ne.'  '.and.LCMDFL(1:4).ne.'UNKN')then
        INQUIRE (FILE=LCMDFL,EXIST=XST)
        if(XST)then

C Find the path and local file name.
          CALL FDROOT(LCMDFL,PATH,LCFGF)
          CALL EDISP(IUOUT,' Scanning the problem description')
          MODE='NONE'
          CALL ERSYS(LCFGF,IFCFG,IUF,MODE,ITRC,IER)
          IF(IER.EQ.0)THEN

C Open core of databases.
            call module_opendb(ier)
            if(ier.ne.0)then
              call usrmsg(
     &          'Possible problems with one or more of the con-',
     &          'struction and optical databases, please check.','W')
            endif

            NZONES=NCOMP
            CALL ZDATA (itrc,IER,NZONES,ISFSUM)
            CFGOK=.TRUE.
            numberofzones=ncomp
            call updwire(numberofzones)

C Initialize the 1D gridding variables.
            CALL INTGRD(GRDOK,ITRC)
            IF(GRDOK)THEN

C Set flag so that bounds are checked.
              DO 30 ICOMP=1,NCOMP
                iZBFLG(ICOMP)=0
   30         CONTINUE
              CFGOK=.TRUE.
              MODIFY=.TRUE.
              MODLEN=.TRUE.
              MODBND=.TRUE.
            ENDIF
          ELSE
            CFGOK=.FALSE.
            IF(MMOD.EQ.8)CALL startbuffer()
          ENDIF
        endif
      endif

      ITRC=0
   10 INO=-3
      ITEM(1)='1 problem definition    '
      ITEM(2)='  --------------------- '
      ITEM(3)='a 1D gridding           '
      ITEM(4)='b Multi-gridding        '
      ITEM(5)='c ground-modelling      '
      ITEM(6)='d moisture 1D gridding  '
      ITEM(7)='  --------------------- '
      ITEM(8)='l look at ASCII file    '
      IF(ITRC.EQ.0)THEN
        ITEM(9)='r reporting >> silent  '
      ELSEIF(ITRC.EQ.1)THEN
        ITEM(9)='r reporting >> summary ' 
      ELSEIF(ITRC.EQ.2)THEN
        ITEM(9)='r reporting >> verbose '
      ENDIF
      ITEM(10)='? help                  '
      ITEM(11)='- Exit gridding module  '
      MITEM=11

C If user has defined problem and perhaps resized the display then
C redraw the problem image.
      IF(CFGOK.AND.(MODIFY.OR.IDRW1.NE.1))THEN
        ITZNM=0
        ITVNO=1
        IDRW1=1
        IDRW2=0
        CALL GRAAPH(IDRW1,IDRW2)
      ENDIF

C Use askabout to instanciate the initial help messages (2nd parameter is one).
      call askabout('grd ',1)

      CALL EMENU('   Building-Gridding',ITEM,MITEM,INO)

      IF(.NOT.CFGOK.AND.(INO.GE.3.AND.INO.LE.6))THEN

C Check if the problem is defined.
        CALL USRMSG(' ','the problem should be defined first.','W')
      ELSEIF(INO.EQ.1)THEN

C Define the problem.
        helptopic='grd_model_cfg_file'
        call gethelptext(helpinsub,helptopic,nbhelp)
        L144=LCMDFL

C Call EASKF depending on the current file name length.
C The X11 version will be returning only the name of the
C file, while the GTK version will be returning the
C name with the full path.
  289   llt=lnblnk(L144)
        iglib = igraphiclib()  ! find out if X11 or GTK or text support only.
        if(iglib.eq.1.or.iglib.eq.3)then
          if(llt.lt.96)then
            CALL EASKF(L144,' Model configuration file?',' ',96,' ',
     &        'config file name',IER,nbhelp)
          elseif(llt.ge.96.and.llt.lt.124)then
            CALL EASKF(L144,' Model configuration file?',' ',124,' ',
     &        'config file name',IER,nbhelp)
          elseif(llt.ge.124.and.llt.le.144)then
            CALL EASKF(L144,' Model configuration file?',' ',144,' ',
     &        'config file name',IER,nbhelp)
          endif
        elseif(iglib.eq.2)then
          CALL EASKF(L144,' Model configuration file?',' ',144,' ',
     &      'config file name',IER,nbhelp)
        else
          CALL EASKF(L144,' Model configuration file?',' ',96,' ',
     &      'config file name',IER,nbhelp)
        endif

        IF(L144(1:2).EQ.'  '.or.L144(1:4).eq.'UNKN')GOTO 289
        call st2file(L144,LCMDFL)

C Find the path and local file name.
        CALL FDROOT(LCMDFL,PATH,LCFGF)
        CALL EDISP(IUOUT,' ')
        CALL EDISP(IUOUT,' Scanning the problem description')
        MODE='NONE'
        CALL ERSYS(LCFGF,IFCFG,IUF,MODE,ITRC,IER)
        IF(IER.EQ.0)THEN

C Open core of databases.
          call module_opendb(ier)
          if(ier.ne.0)then
            call usrmsg(
     &        'Possible problems with one or more of the',
     &        'construction and optical databases, please check.','W')
          endif

C Initialize the 1D gridding variables.
          NZONES=NCOMP
          CALL ZDATA (ITRC,IER,NZONES,ISFSUM)
          CALL INTGRD(GRDOK,ITRC)
          IF(GRDOK)THEN
            CFGOK=.TRUE.
            MODIFY=.TRUE.
            MODLEN=.TRUE.
            MODBND=.TRUE.

C Set flag so that bounds are checked.
          DO 20 ICOMP=1,NCOMP
            iZBFLG(ICOMP)=0
   20     CONTINUE
          ENDIF
        ELSE
          CFGOK=.FALSE.
          IF(MMOD.EQ.8)CALL startbuffer()
        ENDIF
      ELSEIF(INO.EQ.3)THEN

C Display 1D gridding menu.
        CALL MENU1D
      ELSEIF(INO.EQ.4)THEN

C Display Multi-gridding menu.
        CALL MENU3D(ITRC)
        MODIFY=.TRUE.
      ELSEIF(INO.EQ.5)THEN

C Display the ground modelling menu.
        CALL MENUGM(IDRW1)
      ELSEIF(INO.EQ.6)THEN

C Display the moisture 1D gridding menu.
        CALL MENU1M(IDRW1,IDRW2,ITRC)
      ELSEIF(INO.EQ.MITEM-3)THEN

C List out an ASCII file.
        CALL EASKS(LFILE,' File to look at ? ',
     &     ' ',72,' ','ascii file',IER,0)
        IUNIT=IFIL+1
        CALL EFOPSEQ(IUNIT,LFILE,1,IER)
        IF(IER.EQ.0)THEN

C Actual read of ASCII file.
   40     READ(IUNIT,'(A124)',IOSTAT=ISTAT,END=50)OUTSTR
          CALL EDISP(IUOUT,OUTSTR)
          GOTO 40

C End of file encountered, close the file and return to menu.
   50     CALL USRMSG(' ',' End of file reached','-')
          CALL ERPFREE(IUNIT,ISTAT)
        ELSE
          CALL USRMSG(' ','Problem opening file... ','W')
        ENDIF
      ELSEIF(INO.EQ.MITEM-2)THEN

C Toggle trace level.
        ITRC=ITRC+1
        IF(ITRC.GT.2)ITRC=0
      ELSEIF(INO.EQ.MITEM-1)THEN

C Help via the askabout facility in esru_ask.F The zero requests display
        call askabout('grd ',0)
      ELSEIF(INO.EQ.MITEM)THEN

C Exit program.
        call usrmsg(' Closing building gridding...',' ','P')
        IF(MATDBOK)CALL ERPFREE(IFMAT,ISTAT)
        CALL EPAGEND
        STOP
      ENDIF
      GOTO 10
      END

C **************************     INTGRD    ****************************
C INTGRD initializes the gridding process by reading in the required 
C geometry and construction data. It also initialises ground 
C coefficients.
C *********************************************************************
      SUBROUTINE INTGRD(GRDOK,ITRC)
#include "building.h"
#include "model.h"

#include "esprdbfile.h"
#include "material.h"

      COMMON/FILEP/IFIL
      COMMON/OUTIN/IUOUT,IUIN
      
      integer ncomp,ncon
      COMMON/C1/NCOMP,NCON
      COMMON/FOPENED/CFGOK,MLDBOK,MATDBOK,CTLOK,OPTKOK
      COMMON/GR1D01/NNDS,NNDZ(MCOM),NNDC(MCOM,MS),NNDL(MCOM,MS,ME)
      COMMON/GR1D02/IADP,IVAR,FMIN,FREF,FMAX,NSTP
      COMMON/GR1D03/BCNV,ILUMP(MCOM,MS)
      COMMON/GRND05/NDXG,NDYG,NDZG,DXG(MGXYZ),DYG(MGXYZ),DZG(MGXYZ)
      COMMON/GRND06/ITPGND(MGXYZ,MGXYZ,MGXYZ)
      COMMON/GRND07/VERTX(6,4)

      LOGICAL CFGOK,MLDBOK,MATDBOK,CTLOK,OPTKOK
      logical closemat1,closemat2
      LOGICAL GRDOK
      CHARACTER VERTX*2

C If materials database not opened warn the user.
      call eclose(matver,1.1,0.001,closemat1)
      call eclose(matver,1.2,0.001,closemat2)
      if(closemat1.or.closemat2)then
        continue
      else
        call usrmsg('No readable material database was found.',
     &              'check other warnings for advise.','W')
        MATDBOK=.FALSE.
        return
      endif

      GRDOK=.true.
      IUNIT=IFIL+1
      FMIN=0.45
      FREF=0.5
      FMAX=0.55
      NSTP=1
      IADP=0
      IVAR=0
      BCNV=5.0
      NNDS=0
      DO 10 ICOMP=1,NCOMP
        call georead(IUNIT,LGEOM(ICOMP),ICOMP,1,IUOUT,IER)
        IF(IER.NE.0)THEN
          GRDOK=.FALSE.
          RETURN
        ENDIF
        CALL ECONST(LTHRM(ICOMP),IUNIT,ICOMP,ITRC,IUOUT,IER)
        IF(IER.NE.0)THEN
          GRDOK=.FALSE.
          RETURN
        ENDIF
        CALL MZMISC(ICOMP)
        CALL NODTWO(ICOMP)
        NNDS=NNDS+NNDZ(ICOMP)
   10 CONTINUE

C Initialise ground coefficients.
      NDXG=1
      DXG(1)=50.
      NDYG=1
      DYG(1)=50.
      NDZG=1
      DZG(1)=20.
      DO 20 IL=1,MGXYZ
      DO 20 IY=1,MGXYZ
      DO 20 IX=1,MGXYZ
        ITPGND(IX,IY,IL)=263
   20 CONTINUE
      WRITE(VERTX(1,1),'(A1)')'1'
      WRITE(VERTX(1,2),'(A1)')'2'
      WRITE(VERTX(1,3),'(A1)')'6'
      WRITE(VERTX(1,4),'(A1)')'5'
      WRITE(VERTX(2,1),'(A1)')'2'
      WRITE(VERTX(2,2),'(A1)')'3'
      WRITE(VERTX(2,3),'(A1)')'7'
      WRITE(VERTX(2,4),'(A1)')'6'
      WRITE(VERTX(3,1),'(A1)')'3'
      WRITE(VERTX(3,2),'(A1)')'4'
      WRITE(VERTX(3,3),'(A1)')'8'
      WRITE(VERTX(3,4),'(A1)')'7'
      WRITE(VERTX(4,1),'(A1)')'4'
      WRITE(VERTX(4,2),'(A1)')'1'
      WRITE(VERTX(4,3),'(A1)')'5'
      WRITE(VERTX(4,4),'(A1)')'8'
      WRITE(VERTX(5,1),'(A1)')'5'
      WRITE(VERTX(5,2),'(A1)')'6'
      WRITE(VERTX(5,3),'(A1)')'7'
      WRITE(VERTX(5,4),'(A1)')'8'
      WRITE(VERTX(6,1),'(A1)')'4'
      WRITE(VERTX(6,2),'(A1)')'3'
      WRITE(VERTX(6,3),'(A1)')'2'
      WRITE(VERTX(6,4),'(A1)')'1'
      RETURN
      END

C ***** Dummy display of images.
      subroutine imgdisp(iforce,focus,ier)
      character focus*4

      return
      end

C Dummy subroutine needed to compile (called from library code).
      SUBROUTINE PLELEV(direc)
      CHARACTER direc*1

      return
      end


