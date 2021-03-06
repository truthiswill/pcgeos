COMMENT @%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	Copyright (c) GeoWorks 1992 -- All Rights Reserved


PROJECT:	PC GEOS
MODULE:		VGA8 Video Driver
FILE:		vga8Admin.asm

AUTHOR:		Jim DeFrisco

ROUTINES:
	Name		Description
	----		-----------
	VidScreenOn	turn on video
	VidScreenOff	turn off video

REVISION HISTORY:
	Name	Date	Description
	----	----	-----------
	jim	10/92	initial version

DESCRIPTION:
	This file contains routines to implement some of the administrative 
	parts of the driver.

	$Id: vga8Admin.asm,v 1.1 97/04/18 11:42:06 newdeal Exp $

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@

VidSegment	Misc


COMMENT @%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		VidScreenOff
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SYNOPSIS:	Disable video output, for a screen saver

CALLED BY:	GLOBAL

PASS:		nothing

RETURN:		nothing

DESTROYED:	nothing

PSEUDO CODE/STRATEGY:
		Disable the video output

KNOWN BUGS/SIDE EFFECTS/IDEAS:
		none

REVISION HISTORY:
	Name	Date		Description
	----	----		-----------
	Jim	12/89		Initial version

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@
VidScreenOff	proc	far
		.enter

		; first see if the screen is already blank

		dec	ss:videoEnabled		; is it enabled
		js	tooFar			;  oops, called it to often
		jne	done			; someone still wants it off

		; now do the disable thing. 

		mov	ah, ALT_SELECT		; choose BIOS function number
		mov	bl, VIDEO_SCREEN_ON_OFF ; choose sub-function number
		mov	al, VGA_DISABLE_VIDEO	; disable it this time
		int	VIDEO_BIOS
done:
		.leave
		ret

		; decremented too far, get back to zero
tooFar:
		mov	ss:videoEnabled, 0
		jmp	done
VidScreenOff	endp


COMMENT @%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		VidScreenOn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SYNOPSIS:	Enable video output, for a screen saver

CALLED BY:	GLOBAL

PASS:		nothing

RETURN:		nothing

DESTROYED:	nothing

PSEUDO CODE/STRATEGY:
		Disable the video output

KNOWN BUGS/SIDE EFFECTS/IDEAS:
		none

REVISION HISTORY:
	Name	Date		Description
	----	----		-----------
	Jim	12/89		Initial version

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@
VidScreenOn	proc	far
		.enter

		; first see if the screen is already enabled

		inc	ss:videoEnabled		; check for turn on
		cmp	ss:videoEnabled, 1	; is it enabled
		jg	done			;  yes, don't do it again
		mov	ss:videoEnabled, 1	;  no, make sure it;s one

		; enable video signal on card

		mov	ah, ALT_SELECT		; choose BIOS function number
		mov	bl, VIDEO_SCREEN_ON_OFF ; choose sub-function number
		mov	al, VGA_ENABLE_VIDEO	; disable video signal
		int	VIDEO_BIOS
done:
		.leave
		ret
VidScreenOn	endp


COMMENT @%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		VidTestTVGA8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SYNOPSIS:	Test for 640x400 8bit VESA mode

CALLED BY:	INTERNAL
		VidTestDevice
PASS:		nothing
RETURN:		ax	- DevicePresent enum
DESTROYED:	nothing

PSEUDO CODE/STRATEGY:
		
KNOWN BUGS/SIDE EFFECTS/IDEAS:
		
REVISION HISTORY:
		Name	Date		Description
		----	----		-----------
		jim	10/ 6/92	Initial version

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@
VidTestTVGA8	proc	near
		mov	ax, VM_640x400_8	; mode to check for
		call	VidTestVESA
		ret
VidTestTVGA8	endp


COMMENT @%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		VidTestVGA8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SYNOPSIS:	Test for 640x480 8bit VESA mode

CALLED BY:	INTERNAL
		VidTestDevice
PASS:		nothing
RETURN:		ax	- DevicePresent enum
DESTROYED:	nothing

PSEUDO CODE/STRATEGY:
		
KNOWN BUGS/SIDE EFFECTS/IDEAS:
		
REVISION HISTORY:
		Name	Date		Description
		----	----		-----------
		jim	10/ 6/92	Initial version

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@
VidTestVGA8	proc	near
		mov	ax, VM_640x480_8	; mode to check for
		call	VidTestVESA
		ret
VidTestVGA8	endp


COMMENT @%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		VidTestSVGA8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SYNOPSIS:	Test for 800x600 8bit VESA mode

CALLED BY:	INTERNAL
		VidTestDevice
PASS:		nothing
RETURN:		ax	- DevicePresent enum
DESTROYED:	nothing

PSEUDO CODE/STRATEGY:
		
KNOWN BUGS/SIDE EFFECTS/IDEAS:
		
REVISION HISTORY:
		Name	Date		Description
		----	----		-----------
		jim	10/ 6/92	Initial version

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@
VidTestSVGA8	proc	near
		mov	ax, VM_800x600_8	; mode to check for
		call	VidTestVESA
		ret
VidTestSVGA8	endp


COMMENT @%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		VidTestUVGA8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SYNOPSIS:	Test for 1024x768 8bit VESA mode

CALLED BY:	INTERNAL
		VidTestDevice
PASS:		nothing
RETURN:		ax	- DevicePresent enum
DESTROYED:	nothing

PSEUDO CODE/STRATEGY:
		
KNOWN BUGS/SIDE EFFECTS/IDEAS:
		
REVISION HISTORY:
		Name	Date		Description
		----	----		-----------
		jim	10/ 6/92	Initial version

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@
VidTestUVGA8	proc	near
		mov	ax, VM_1Kx768_8		; mode to check for
		call	VidTestVESA
		ret
VidTestUVGA8	endp


COMMENT @%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                VidTestHVGA8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SYNOPSIS:       Test for 1280x1024 8bit VESA mode

CALLED BY:	INTERNAL
		VidTestDevice
PASS:		nothing
RETURN:		ax	- DevicePresent enum
DESTROYED:	nothing

PSEUDO CODE/STRATEGY:
		
KNOWN BUGS/SIDE EFFECTS/IDEAS:
		
REVISION HISTORY:
		Name	Date		Description
		----	----		-----------
		jim	10/ 6/92	Initial version

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@
VidTestHVGA8    proc    near
                mov     ax, VM_1280x1K_8	; mode to check for
		call	VidTestVESA
		ret
VidTestHVGA8    endp


COMMENT @%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		VidTestVESA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SYNOPSIS:	Test for VESA compatible board

CALLED BY:	INTERNAL
		VidTestDevice

PASS:		ax	- VESA mode to check for

RETURN:		ax	- DevicePresent enum

DESTROYED:	nothing

PSEUDO CODE/STRATEGY:
		call VESA inquiry functins

KNOWN BUGS/SIDE EFFECTS/IDEAS:
		none

REVISION HISTORY:
		Name	Date		Description
		----	----		-----------
		Jim	09/90		Initial version

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@

VidTestVESA	proc	near
		uses	es, di, bx, cx
		.enter

		; save away the mode number

		mov	ss:[vesaMode], ax	; save it

		; allocate fixed block to get vesa info

		CheckHack <(size VESAInfoBlock) eq (size VESAModeInfo)>

		mov	ax, size VESAInfoBlock
		mov	cx, ALLOC_FIXED
		call	MemAlloc

		; use extended BIOS function 0x4f - 0 to determine if this
		; is a VESA compatible board, then check the table of 
		; supported modes to determine if the 640x480x256-color mode
		; is supported.

		mov	es, ax
		clr	di			; es:di -> VESAInfoBlock
		mov	ah, VESA_BIOS_EXT 	; use VESA bios extensions
		mov	al, VESA_GET_SVGA_INFO 	; basic info call
		int	VIDEO_BIOS		; make bios call

		; if al = VESA_BIOS_EXT, then there is a VESA compatible board
		; there...actually, we need to check for the VESA signature too

		cmp	ax, VESA_BIOS_EXT ; is this a VESA board ?
		jne	notPresent	  ; no, exit
		cmp	{word} es:[di].VIB_sig, 'VE' ; gimme a VE
		jne	notPresent
		cmp	{word} es:[di].VIB_sig[2], 'SA' ; gimme a SA
		jne	notPresent

		; OK, there is a VESA board out there.  Check the mode table
		; for the correct mode.  

		les	di, es:[di].VIB_modes	; get pointer to mode info
		mov	ax, ss:[vesaMode]	; mode to check for
checkLoop:
		cmp	es:[di], 0xffff		; at mode table terminator?
		je	notPresent
		scasw				; check this word
		jne	checkLoop		;  nope, on to next mode

		; OK, the mode is supported in the BIOS.  Now check to see if
		; it is supported by the current card/monitor setup.  To do
		; this, we need to call the GetModeInfo function.

		call	MemDerefES
		clr	di			; es:di -> VESAModeInfo
		mov	cx, ax			; cx = mode number
		mov	ah, VESA_BIOS_EXT	; BIOS mode number
		mov	al, VESA_GET_MODE_INFO	; get info about mode
		int	VIDEO_BIOS		; get mode info

		; now see if the current hardware is cool.

		test	es:[di].VMI_modeAttr, mask VMA_SUPPORTED
		jz	notPresent

		; passed the acid test.  Use it.

 		mov	ax, DP_PRESENT		; yep, it's there
done:
		; free allocated memory block

		call	MemFree

		.leave
		ret

notPresent:
		mov	ax, DP_NOT_PRESENT	; 
		jmp	done
VidTestVESA	endp


COMMENT @%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		VidSetVESA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SYNOPSIS:	Set VESA 640x480 256-color mode

CALLED BY:	INTERNAL
		VidSetDevice

PASS:		nothing

RETURN:		nothing

DESTROYED:	nothing

PSEUDO CODE/STRATEGY:
		call VESA set mode function

KNOWN BUGS/SIDE EFFECTS/IDEAS:
		assumes that VidTestVESA has been called and passed.

REVISION HISTORY:
		Name	Date		Description
		----	----		-----------
		Jim	09/90		Initial version

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@

if ALLOW_BIG_MOUSE_POINTER
bigPointerCategory	char	"screen0",0
bigPointerKey		char	"bigMousePointer",0
endif ; ALLOW_BIG_MOUSE_POINTER

VidSetVESA	proc	near
		uses	ax,bx,cx,dx,ds,si,es
		.enter

if ALLOW_BIG_MOUSE_POINTER
		; default cursor size is big for 640x400, small for other modes
		; can override using screen0::bigMousePointer = true/false.
	
		mov	cx, cs
		mov	dx, offset bigPointerKey
		mov	ds, cx
		mov	si, offset bigPointerCategory
		call	InitFileReadBoolean
		jc	defaultCursor
		tst	al
		jz	afterCursor
		mov	ss:[cursorSize], CUR_SIZE * 2
		jmp	afterCursor
defaultCursor:
		cmp	ss:[vesaMode], VM_640x400_8
		jne	afterCursor
		mov	ss:[cursorSize], CUR_SIZE * 2
afterCursor:
endif ; ALLOW_BIG_MOUSE_POINTER
		
		; just use the BIOS extension

		mov	ah, VESA_BIOS_EXT
		mov	al, VESA_SET_MODE
		mov	bx, ss:[vesaMode] 	; mode number, clear memory
		int	VIDEO_BIOS

		segmov	es, ss, di		; es -> dgroup
		lea	di, ss:[vesaInfo]	; es:di -> info block
		mov	ah, VESA_BIOS_EXT	; use VESA bios extensions
		mov	al, VESA_GET_SVGA_INFO	; basic info call
		int	VIDEO_BIOS		; make bios call

		lea	di, ss:[modeInfo]	; es:di -> info block
		mov	ah, VESA_BIOS_EXT	; use VESA bios extensions
		mov	al, VESA_GET_MODE_INFO	; get info about mode
		mov	cx, bx			; cx = mode number
		int	VIDEO_BIOS		; make bios call

		; since we may be using this driver to support a number of
		; other resolutions at 8bits/pixel, copy the information 
		; that we gleaned from the mode info call and stuff the
		; appropriate fields into our own DeviceInfo structure.

		sub	bx, 0x100			; get number start at 0
		mov	al, cs:[vesaDtype][bx]
		mov	ss:[DriverTable].VDI_displayType, al
		shl	bx, 1				; bx = word table index
		mov	ax, cs:[vesaHeight][bx]
		mov	ss:[DriverTable].VDI_pageH, ax
		mov	ax, cs:[vesaWidth][bx]
		mov	ss:[DriverTable].VDI_pageW, ax
		mov	ax, cs:[vesaVres][bx]
		mov	ss:[DriverTable].VDI_vRes, ax
		mov	ax, cs:[vesaHres][bx]
		mov	ss:[DriverTable].VDI_hRes, ax
		mov	ax, ss:[modeInfo].VMI_scanSize	; bytes per scan line
		mov	ss:[DriverTable].VDI_bpScan, ax

		; initialize some things about the memory windows.
		; first determine the window that we write to

		mov	al, ss:[modeInfo].VMI_winAAttr
		mov	ah, ss:[modeInfo].VMI_winBAttr
		test	ah, mask VWA_SUPPORTED or mask VWA_WRITEABLE
		jz	winAWrite
		jnp	winAWrite			; if two not set...
		mov	bl, VW_WINDOW_B			; bl = write window
		mov	cx, ss:[modeInfo].VMI_winBSeg	; cx = write win addr
tryWinARead:
		test	al, mask VWA_SUPPORTED or mask VWA_READABLE
		jz	winBRead
		jnp	winBRead
		mov	bh, VW_WINDOW_A
		mov	dx, ss:[modeInfo].VMI_winASeg
storeRWWin:
		mov	{word} ss:[writeWindow], bx	; save results
		mov	ss:[writeSegment], cx
		mov	ss:[readSegment], dx
		
		; calculate the last offset in the window

		mov	bx, ss:[modeInfo].VMI_winSize	; bx = winSize
		mov	ax, bx
		xchg	al, ah				; *256
		shl	ax, 1				; *512
		shl	ax, 1				; *1024
		dec	ax				; last offset
		mov	ss:[curWinEnd], ax		; last offset in 64K

		; calculate the window bump when going to the next window.
		; It's the size divided by the granularity

		mov	ax, bx				; ax = winSize
		mov	bx, ss:[modeInfo].VMI_winGran	; bx = granularity
		div	bl				; al = #to bump
		mov	ss:[nextWinInc], ax		; set increment

		; initialize the palette.

		mov	dx, offset initDACs
		cmp	ss:[vesaMode], VM_640x400_8
		jne	setDACs
		mov	dx, offset initTVDACs
setDACs:
		mov	bx, handle VideoPalRegs
		call	MemLock
		mov	es, ax
		clr	bx
		mov	cx, 256
		mov	ax, SET_DACREGS
		int	VIDEO_BIOS
		mov	bx, handle VideoPalRegs
		call	MemUnlock

		.leave
		ret

		; window B doesn't exist or is not writeable.  Use window A
		; and try window B for reading.
winAWrite:
		mov	bl, VW_WINDOW_A
		mov	cx, ss:[modeInfo].VMI_winASeg
		test	ah, mask VWA_SUPPORTED or mask VWA_READABLE
		jz	tryWinARead
		jnp	tryWinARead
winBRead:
		mov	bh, VW_WINDOW_B
		mov	dx, ss:[modeInfo].VMI_winBSeg
		jmp	storeRWWin
VidSetVESA	endp


vesaDtype	label	DisplayType
		byte	VGA8_DISPLAY_TYPE
		byte	VGA8_DISPLAY_TYPE
		byte	SVGA_DISPLAY_TYPE
		byte	SVGA8_DISPLAY_TYPE
		byte	SVGA_DISPLAY_TYPE
		byte	SVGA8_DISPLAY_TYPE
		byte	SVGA_DISPLAY_TYPE
		byte	SVGA8_DISPLAY_TYPE

vesaHeight	label	word
		word	400, 480, 600, 600,  768,  768, 1024, 1024 

vesaWidth	label	word
		word	640, 640, 800, 800, 1024, 1024, 1280, 1280

vesaVres	label	word
		word	 60,  72,  80,  80,  102,  102,  136,  136 

vesaHres	label	word
		word	 72,  72,  80,  80,  102,  102,  136,  136 

VidEnds		Misc


VidSegment	PalRegs
initDACs	label	byte
	byte	0x00, 0x00, 0x00 	; index 0
	byte	0x00, 0x00, 0x2a
	byte	0x00, 0x2a, 0x00
	byte	0x00, 0x2a, 0x2a	
	byte	0x2a, 0x00, 0x00	; index 4
	byte	0x2a, 0x00, 0x2a
	byte	0x2a, 0x15, 0x00
	byte	0x2a, 0x2a, 0x2a	
	byte	0x15, 0x15, 0x15	; index 8
	byte	0x15, 0x15, 0x3f
	byte	0x15, 0x3f, 0x15
	byte	0x15, 0x3f, 0x3f
	byte	0x3f, 0x15, 0x15	; index c
	byte	0x3f, 0x15, 0x3f
	byte	0x3f, 0x3f, 0x15
	byte	0x3f, 0x3f, 0x3f		

	; 16 shades of grey

	byte	0x00, 0x00, 0x00	; index 10	 0.0%
	byte	0x04, 0x04, 0x04	;		 6.7%
	byte	0x08, 0x08, 0x08	;		13.3%
	byte	0x0c, 0x0c, 0x0c	;		20.0%
	byte	0x11, 0x11, 0x11	; index 14	26.7%
	byte	0x15, 0x15, 0x15	;		33.3%
	byte	0x19, 0x19, 0x19	;		40.0%
	byte	0x1d, 0x1d, 0x1d	;		46.7%
	byte	0x22, 0x22, 0x22	; index 18	53.3%
	byte	0x26, 0x26, 0x26	;		60.0%
	byte	0x2a, 0x2a, 0x2a	;		67.7%
	byte	0x2e, 0x2e, 0x2e	;		73.3%
	byte	0x33, 0x33, 0x33	; index 1c	80.0%
	byte	0x37, 0x37, 0x37	;		87.7%
	byte	0x3b, 0x3b, 0x3b	;		93.3%
	byte	0x3f, 0x3f, 0x3f	;	       100.0%	

	; 8 extra slots

	byte	0x00, 0x00, 0x00	; index 20
	byte	0x00, 0x00, 0x00
	byte	0x00, 0x00, 0x00
	byte	0x00, 0x00, 0x00		
	byte	0x00, 0x00, 0x00	; index 24
	byte	0x00, 0x00, 0x00
	byte	0x00, 0x00, 0x00
	byte	0x00, 0x00, 0x00		

	; 216 entries, evenly spaced throughout the RGB space

	byte	0x00, 0x00, 0x00	; index 28
	byte	0x00, 0x00, 0x0c
	byte	0x00, 0x00, 0x19
	byte	0x00, 0x00, 0x26	
	byte	0x00, 0x00, 0x33	; index 2c
	byte	0x00, 0x00, 0x3f
	byte	0x00, 0x0c, 0x00
	byte	0x00, 0x0c, 0x0c
	byte	0x00, 0x0c, 0x19	; inxed 30
	byte	0x00, 0x0c, 0x26	
	byte	0x00, 0x0c, 0x33
	byte	0x00, 0x0c, 0x3f
	byte	0x00, 0x19, 0x00	; index 34
	byte	0x00, 0x19, 0x0c
	byte	0x00, 0x19, 0x19
	byte	0x00, 0x19, 0x26	
	byte	0x00, 0x19, 0x33	; index 38
	byte	0x00, 0x19, 0x3f
	byte	0x00, 0x26, 0x00
	byte	0x00, 0x26, 0x0c
	byte	0x00, 0x26, 0x19	; index 3c
	byte	0x00, 0x26, 0x26	
	byte	0x00, 0x26, 0x33
	byte	0x00, 0x26, 0x3f
	byte	0x00, 0x33, 0x00	; index 40
	byte	0x00, 0x33, 0x0c
	byte	0x00, 0x33, 0x19
	byte	0x00, 0x33, 0x26	
	byte	0x00, 0x33, 0x33	; index 44
	byte	0x00, 0x33, 0x3f
	byte	0x00, 0x3f, 0x00
	byte	0x00, 0x3f, 0x0c
	byte	0x00, 0x3f, 0x19	; index 48
	byte	0x00, 0x3f, 0x26	
	byte	0x00, 0x3f, 0x33
	byte	0x00, 0x3f, 0x3f
	byte	0x0c, 0x00, 0x00	; index 4c
	byte	0x0c, 0x00, 0x0c
	byte	0x0c, 0x00, 0x19
	byte	0x0c, 0x00, 0x26	
	byte	0x0c, 0x00, 0x33	; index 50
	byte	0x0c, 0x00, 0x3f
	byte	0x0c, 0x0c, 0x00
	byte	0x0c, 0x0c, 0x0c
	byte	0x0c, 0x0c, 0x19	; index 54
	byte	0x0c, 0x0c, 0x26	
	byte	0x0c, 0x0c, 0x33
	byte	0x0c, 0x0c, 0x3f
	byte	0x0c, 0x19, 0x00	; index 58
	byte	0x0c, 0x19, 0x0c
	byte	0x0c, 0x19, 0x19
	byte	0x0c, 0x19, 0x26	
	byte	0x0c, 0x19, 0x33	; index 5c
	byte	0x0c, 0x19, 0x3f
	byte	0x0c, 0x26, 0x00
	byte	0x0c, 0x26, 0x0c
	byte	0x0c, 0x26, 0x19	; index 60
	byte	0x0c, 0x26, 0x26	
	byte	0x0c, 0x26, 0x33
	byte	0x0c, 0x26, 0x3f
	byte	0x0c, 0x33, 0x00	; index 64
	byte	0x0c, 0x33, 0x0c
	byte	0x0c, 0x33, 0x19
	byte	0x0c, 0x33, 0x26	
	byte	0x0c, 0x33, 0x33	; index 68
	byte	0x0c, 0x33, 0x3f
	byte	0x0c, 0x3f, 0x00
	byte	0x0c, 0x3f, 0x0c
	byte	0x0c, 0x3f, 0x19	; index 6c
	byte	0x0c, 0x3f, 0x26	
	byte	0x0c, 0x3f, 0x33
	byte	0x0c, 0x3f, 0x3f
	byte	0x19, 0x00, 0x00	; index 70
	byte	0x19, 0x00, 0x0c
	byte	0x19, 0x00, 0x19
	byte	0x19, 0x00, 0x26	
	byte	0x19, 0x00, 0x33	; index 74
	byte	0x19, 0x00, 0x3f
	byte	0x19, 0x0c, 0x00
	byte	0x19, 0x0c, 0x0c
	byte	0x19, 0x0c, 0x19	; index 78
	byte	0x19, 0x0c, 0x26	
	byte	0x19, 0x0c, 0x33
	byte	0x19, 0x0c, 0x3f
	byte	0x19, 0x19, 0x00	; index 7c
	byte	0x19, 0x19, 0x0c
	byte	0x19, 0x19, 0x19
	byte	0x19, 0x19, 0x26	
	byte	0x19, 0x19, 0x33	; index 80
	byte	0x19, 0x19, 0x3f
	byte	0x19, 0x26, 0x00
	byte	0x19, 0x26, 0x0c
	byte	0x19, 0x26, 0x19	; index 84
	byte	0x19, 0x26, 0x26	
	byte	0x19, 0x26, 0x33
	byte	0x19, 0x26, 0x3f
	byte	0x19, 0x33, 0x00	; index 88
	byte	0x19, 0x33, 0x0c
	byte	0x19, 0x33, 0x19
	byte	0x19, 0x33, 0x26	
	byte	0x19, 0x33, 0x33	; index 8c
	byte	0x19, 0x33, 0x3f
	byte	0x19, 0x3f, 0x00
	byte	0x19, 0x3f, 0x0c
	byte	0x19, 0x3f, 0x19	; index 90
	byte	0x19, 0x3f, 0x26	
	byte	0x19, 0x3f, 0x33
	byte	0x19, 0x3f, 0x3f
	byte	0x26, 0x00, 0x00	; index 94
	byte	0x26, 0x00, 0x0c
	byte	0x26, 0x00, 0x19
	byte	0x26, 0x00, 0x26	
	byte	0x26, 0x00, 0x33	; index 98
	byte	0x26, 0x00, 0x3f
	byte	0x26, 0x0c, 0x00
	byte	0x26, 0x0c, 0x0c
	byte	0x26, 0x0c, 0x19	; index 9c
	byte	0x26, 0x0c, 0x26	
	byte	0x26, 0x0c, 0x33
	byte	0x26, 0x0c, 0x3f
	byte	0x26, 0x19, 0x00	; index a0
	byte	0x26, 0x19, 0x0c
	byte	0x26, 0x19, 0x19
	byte	0x26, 0x19, 0x26	
	byte	0x26, 0x19, 0x33	; index a4
	byte	0x26, 0x19, 0x3f
	byte	0x26, 0x26, 0x00
	byte	0x26, 0x26, 0x0c
	byte	0x26, 0x26, 0x19	; index a8
	byte	0x26, 0x26, 0x26	
	byte	0x26, 0x26, 0x33
	byte	0x26, 0x26, 0x3f
	byte	0x26, 0x33, 0x00	; index ac
	byte	0x26, 0x33, 0x0c
	byte	0x26, 0x33, 0x19
	byte	0x26, 0x33, 0x26	
	byte	0x26, 0x33, 0x33	; index b0
	byte	0x26, 0x33, 0x3f
	byte	0x26, 0x3f, 0x00
	byte	0x26, 0x3f, 0x0c
	byte	0x26, 0x3f, 0x19	; index b4
	byte	0x26, 0x3f, 0x26	
	byte	0x26, 0x3f, 0x33
	byte	0x26, 0x3f, 0x3f
	byte	0x33, 0x00, 0x00	; index b8
	byte	0x33, 0x00, 0x0c
	byte	0x33, 0x00, 0x19
	byte	0x33, 0x00, 0x26	
	byte	0x33, 0x00, 0x33	; index bc
	byte	0x33, 0x00, 0x3f
	byte	0x33, 0x0c, 0x00
	byte	0x33, 0x0c, 0x0c
	byte	0x33, 0x0c, 0x19	; index c0
	byte	0x33, 0x0c, 0x26	
	byte	0x33, 0x0c, 0x33
	byte	0x33, 0x0c, 0x3f
	byte	0x33, 0x19, 0x00	; index c4
	byte	0x33, 0x19, 0x0c
	byte	0x33, 0x19, 0x19
	byte	0x33, 0x19, 0x26	
	byte	0x33, 0x19, 0x33	; index c8
	byte	0x33, 0x19, 0x3f
	byte	0x33, 0x26, 0x00
	byte	0x33, 0x26, 0x0c
	byte	0x33, 0x26, 0x19	; index cc
	byte	0x33, 0x26, 0x26	
	byte	0x33, 0x26, 0x33
	byte	0x33, 0x26, 0x3f
	byte	0x33, 0x33, 0x00	; index d0
	byte	0x33, 0x33, 0x0c
	byte	0x33, 0x33, 0x19
	byte	0x33, 0x33, 0x26	
	byte	0x33, 0x33, 0x33	; index d4
	byte	0x33, 0x33, 0x3f
	byte	0x33, 0x3f, 0x00
	byte	0x33, 0x3f, 0x0c
	byte	0x33, 0x3f, 0x19	; index d8
	byte	0x33, 0x3f, 0x26	
	byte	0x33, 0x3f, 0x33
	byte	0x33, 0x3f, 0x3f
	byte	0x3f, 0x00, 0x00	; index dc
	byte	0x3f, 0x00, 0x0c
	byte	0x3f, 0x00, 0x19
	byte	0x3f, 0x00, 0x26	
	byte	0x3f, 0x00, 0x33	; index e0
	byte	0x3f, 0x00, 0x3f
	byte	0x3f, 0x0c, 0x00
	byte	0x3f, 0x0c, 0x0c
	byte	0x3f, 0x0c, 0x19	; index e4
	byte	0x3f, 0x0c, 0x26	
	byte	0x3f, 0x0c, 0x33
	byte	0x3f, 0x0c, 0x3f
	byte	0x3f, 0x19, 0x00	; index e8
	byte	0x3f, 0x19, 0x0c
	byte	0x3f, 0x19, 0x19
	byte	0x3f, 0x19, 0x26	
	byte	0x3f, 0x19, 0x33	; index ec
	byte	0x3f, 0x19, 0x3f
	byte	0x3f, 0x26, 0x00
	byte	0x3f, 0x26, 0x0c
	byte	0x3f, 0x26, 0x19	; index f0
	byte	0x3f, 0x26, 0x26	
	byte	0x3f, 0x26, 0x33
	byte	0x3f, 0x26, 0x3f
	byte	0x3f, 0x33, 0x00	; index f4
	byte	0x3f, 0x33, 0x0c
	byte	0x3f, 0x33, 0x19
	byte	0x3f, 0x33, 0x26	
	byte	0x3f, 0x33, 0x33	; index f8
	byte	0x3f, 0x33, 0x3f
	byte	0x3f, 0x3f, 0x00
	byte	0x3f, 0x3f, 0x0c
	byte	0x3f, 0x3f, 0x19	; index fc
	byte	0x3f, 0x3f, 0x26	
	byte	0x3f, 0x3f, 0x33
	byte	0x3f, 0x3f, 0x3f

initTVDACs	label	byte
	byte	0x08, 0x08, 0x08 	; index 0
	byte	0x0c, 0x0c, 0x2a
	byte	0x08, 0x2a, 0x08
	byte	0x08, 0x2a, 0x2a	
	byte	0x2a, 0x0c, 0x0c	; index 4
	byte	0x2a, 0x0c, 0x2a
	byte	0x2a, 0x19, 0x08
	byte	0x26, 0x26, 0x26	
	byte	0x15, 0x15, 0x15	; index 8
	byte	0x19, 0x19, 0x3f
	byte	0x19, 0x3a, 0x19
	byte	0x19, 0x3a, 0x3a
	byte	0x3a, 0x15, 0x15	; index c
	byte	0x3a, 0x19, 0x3a
	byte	0x3a, 0x3a, 0x19
	byte	0x32, 0x32, 0x32		

	; 16 shades of grey

	byte	0x00, 0x00, 0x00	; index 10	 0.0%
	byte	0x04, 0x04, 0x04	;		 6.7%
	byte	0x08, 0x08, 0x08	;		13.3%
	byte	0x0c, 0x0c, 0x0c	;		20.0%
	byte	0x11, 0x11, 0x11	; index 14	26.7%
	byte	0x15, 0x15, 0x15	;		33.3%
	byte	0x19, 0x19, 0x19	;		40.0%
	byte	0x1d, 0x1d, 0x1d	;		46.7%
	byte	0x22, 0x22, 0x22	; index 18	53.3%
	byte	0x26, 0x26, 0x26	;		60.0%
	byte	0x2a, 0x2a, 0x2a	;		67.7%
	byte	0x2e, 0x2e, 0x2e	;		73.3%
	byte	0x33, 0x33, 0x33	; index 1c	80.0%
	byte	0x37, 0x37, 0x37	;		87.7%
	byte	0x3b, 0x3b, 0x3b	;		93.3%
	byte	0x3f, 0x3f, 0x3f	;	       100.0%	

	; 8 extra slots

	byte	0x00, 0x00, 0x00	; index 20
	byte	0x00, 0x00, 0x00
	byte	0x00, 0x00, 0x00
	byte	0x00, 0x00, 0x00		
	byte	0x00, 0x00, 0x00	; index 24
	byte	0x00, 0x00, 0x00
	byte	0x00, 0x00, 0x00
	byte	0x00, 0x00, 0x00		

	; 216 entries, evenly spaced throughout the RGB space

	byte	0x00, 0x00, 0x00	; index 28
	byte	0x00, 0x00, 0x0c
	byte	0x00, 0x00, 0x19
	byte	0x00, 0x00, 0x26	
	byte	0x00, 0x00, 0x33	; index 2c
	byte	0x00, 0x00, 0x3f
	byte	0x00, 0x0c, 0x00
	byte	0x00, 0x0c, 0x0c
	byte	0x00, 0x0c, 0x19	; inxed 30
	byte	0x00, 0x0c, 0x26	
	byte	0x00, 0x0c, 0x33
	byte	0x00, 0x0c, 0x3f
	byte	0x00, 0x19, 0x00	; index 34
	byte	0x00, 0x19, 0x0c
	byte	0x00, 0x19, 0x19
	byte	0x00, 0x19, 0x26	
	byte	0x00, 0x19, 0x33	; index 38
	byte	0x00, 0x19, 0x3f
	byte	0x00, 0x26, 0x00
	byte	0x00, 0x26, 0x0c
	byte	0x00, 0x26, 0x19	; index 3c
	byte	0x00, 0x26, 0x26	
	byte	0x00, 0x26, 0x33
	byte	0x00, 0x26, 0x3f
	byte	0x00, 0x33, 0x00	; index 40
	byte	0x00, 0x33, 0x0c
	byte	0x00, 0x33, 0x19
	byte	0x00, 0x33, 0x26	
	byte	0x00, 0x33, 0x33	; index 44
	byte	0x00, 0x33, 0x3f
	byte	0x00, 0x3f, 0x00
	byte	0x00, 0x3f, 0x0c
	byte	0x00, 0x3f, 0x19	; index 48
	byte	0x00, 0x3f, 0x26	
	byte	0x00, 0x3f, 0x33
	byte	0x00, 0x3f, 0x3f
	byte	0x0c, 0x00, 0x00	; index 4c
	byte	0x0c, 0x00, 0x0c
	byte	0x0c, 0x00, 0x19
	byte	0x0c, 0x00, 0x26	
	byte	0x0c, 0x00, 0x33	; index 50
	byte	0x0c, 0x00, 0x3f
	byte	0x0c, 0x0c, 0x00
	byte	0x0c, 0x0c, 0x0c
	byte	0x0c, 0x0c, 0x19	; index 54
	byte	0x0c, 0x0c, 0x26	
	byte	0x0c, 0x0c, 0x33
	byte	0x0c, 0x0c, 0x3f
	byte	0x0c, 0x19, 0x00	; index 58
	byte	0x0c, 0x19, 0x0c
	byte	0x0c, 0x19, 0x19
	byte	0x0c, 0x19, 0x26	
	byte	0x0c, 0x19, 0x33	; index 5c
	byte	0x0c, 0x19, 0x3f
	byte	0x0c, 0x26, 0x00
	byte	0x0c, 0x26, 0x0c
	byte	0x0c, 0x26, 0x19	; index 60
	byte	0x0c, 0x26, 0x26	
	byte	0x0c, 0x26, 0x33
	byte	0x0c, 0x26, 0x3f
	byte	0x0c, 0x33, 0x00	; index 64
	byte	0x0c, 0x33, 0x0c
	byte	0x0c, 0x33, 0x19
	byte	0x0c, 0x33, 0x26	
	byte	0x0c, 0x33, 0x33	; index 68
	byte	0x0c, 0x33, 0x3f
	byte	0x0c, 0x3f, 0x00
	byte	0x0c, 0x3f, 0x0c
	byte	0x0c, 0x3f, 0x19	; index 6c
	byte	0x0c, 0x3f, 0x26	
	byte	0x0c, 0x3f, 0x33
	byte	0x0c, 0x3f, 0x3f
	byte	0x19, 0x00, 0x00	; index 70
	byte	0x19, 0x00, 0x0c
	byte	0x19, 0x00, 0x19
	byte	0x19, 0x00, 0x26	
	byte	0x19, 0x00, 0x33	; index 74
	byte	0x19, 0x00, 0x3f
	byte	0x19, 0x0c, 0x00
	byte	0x19, 0x0c, 0x0c
	byte	0x19, 0x0c, 0x19	; index 78
	byte	0x19, 0x0c, 0x26	
	byte	0x19, 0x0c, 0x33
	byte	0x19, 0x0c, 0x3f
	byte	0x19, 0x19, 0x00	; index 7c
	byte	0x19, 0x19, 0x0c
	byte	0x19, 0x19, 0x19
	byte	0x19, 0x19, 0x26	
	byte	0x19, 0x19, 0x33	; index 80
	byte	0x19, 0x19, 0x3f
	byte	0x19, 0x26, 0x00
	byte	0x19, 0x26, 0x0c
	byte	0x19, 0x26, 0x19	; index 84
	byte	0x19, 0x26, 0x26	
	byte	0x19, 0x26, 0x33
	byte	0x19, 0x26, 0x3f
	byte	0x19, 0x33, 0x00	; index 88
	byte	0x19, 0x33, 0x0c
	byte	0x19, 0x33, 0x19
	byte	0x19, 0x33, 0x26	
	byte	0x19, 0x33, 0x33	; index 8c
	byte	0x19, 0x33, 0x3f
	byte	0x19, 0x3f, 0x00
	byte	0x19, 0x3f, 0x0c
	byte	0x19, 0x3f, 0x19	; index 90
	byte	0x19, 0x3f, 0x26	
	byte	0x19, 0x3f, 0x33
	byte	0x19, 0x3f, 0x3f
	byte	0x26, 0x00, 0x00	; index 94
	byte	0x26, 0x00, 0x0c
	byte	0x26, 0x00, 0x19
	byte	0x26, 0x00, 0x26	
	byte	0x26, 0x00, 0x33	; index 98
	byte	0x26, 0x00, 0x3f
	byte	0x26, 0x0c, 0x00
	byte	0x26, 0x0c, 0x0c
	byte	0x26, 0x0c, 0x19	; index 9c
	byte	0x26, 0x0c, 0x26	
	byte	0x26, 0x0c, 0x33
	byte	0x26, 0x0c, 0x3f
	byte	0x26, 0x19, 0x00	; index a0
	byte	0x26, 0x19, 0x0c
	byte	0x26, 0x19, 0x19
	byte	0x26, 0x19, 0x26	
	byte	0x26, 0x19, 0x33	; index a4
	byte	0x26, 0x19, 0x3f
	byte	0x26, 0x26, 0x00
	byte	0x26, 0x26, 0x0c
	byte	0x26, 0x26, 0x19	; index a8
	byte	0x26, 0x26, 0x26	
	byte	0x26, 0x26, 0x33
	byte	0x26, 0x26, 0x3f
	byte	0x26, 0x33, 0x00	; index ac
	byte	0x26, 0x33, 0x0c
	byte	0x26, 0x33, 0x19
	byte	0x26, 0x33, 0x26	
	byte	0x26, 0x33, 0x33	; index b0
	byte	0x26, 0x33, 0x3f
	byte	0x26, 0x3f, 0x00
	byte	0x26, 0x3f, 0x0c
	byte	0x26, 0x3f, 0x19	; index b4
	byte	0x26, 0x3f, 0x26	
	byte	0x26, 0x3f, 0x33
	byte	0x26, 0x3f, 0x3f
	byte	0x33, 0x00, 0x00	; index b8
	byte	0x33, 0x00, 0x0c
	byte	0x33, 0x00, 0x19
	byte	0x33, 0x00, 0x26	
	byte	0x33, 0x00, 0x33	; index bc
	byte	0x33, 0x00, 0x3f
	byte	0x33, 0x0c, 0x00
	byte	0x33, 0x0c, 0x0c
	byte	0x33, 0x0c, 0x19	; index c0
	byte	0x33, 0x0c, 0x26	
	byte	0x33, 0x0c, 0x33
	byte	0x33, 0x0c, 0x3f
	byte	0x33, 0x19, 0x00	; index c4
	byte	0x33, 0x19, 0x0c
	byte	0x33, 0x19, 0x19
	byte	0x33, 0x19, 0x26	
	byte	0x33, 0x19, 0x33	; index c8
	byte	0x33, 0x19, 0x3f
	byte	0x33, 0x26, 0x00
	byte	0x33, 0x26, 0x0c
	byte	0x33, 0x26, 0x19	; index cc
	byte	0x33, 0x26, 0x26	
	byte	0x33, 0x26, 0x33
	byte	0x33, 0x26, 0x3f
	byte	0x33, 0x33, 0x00	; index d0
	byte	0x33, 0x33, 0x0c
	byte	0x33, 0x33, 0x19
	byte	0x33, 0x33, 0x26	
	byte	0x33, 0x33, 0x33	; index d4
	byte	0x33, 0x33, 0x3f
	byte	0x33, 0x3f, 0x00
	byte	0x33, 0x3f, 0x0c
	byte	0x33, 0x3f, 0x19	; index d8
	byte	0x33, 0x3f, 0x26	
	byte	0x33, 0x3f, 0x33
	byte	0x33, 0x3f, 0x3f
	byte	0x3f, 0x00, 0x00	; index dc
	byte	0x3f, 0x00, 0x0c
	byte	0x3f, 0x00, 0x19
	byte	0x3f, 0x00, 0x26	
	byte	0x3f, 0x00, 0x33	; index e0
	byte	0x3f, 0x00, 0x3f
	byte	0x3f, 0x0c, 0x00
	byte	0x3f, 0x0c, 0x0c
	byte	0x3f, 0x0c, 0x19	; index e4
	byte	0x3f, 0x0c, 0x26	
	byte	0x3f, 0x0c, 0x33
	byte	0x3f, 0x0c, 0x3f
	byte	0x3f, 0x19, 0x00	; index e8
	byte	0x3f, 0x19, 0x0c
	byte	0x3f, 0x19, 0x19
	byte	0x3f, 0x19, 0x26	
	byte	0x3f, 0x19, 0x33	; index ec
	byte	0x3f, 0x19, 0x3f
	byte	0x3f, 0x26, 0x00
	byte	0x3f, 0x26, 0x0c
	byte	0x3f, 0x26, 0x19	; index f0
	byte	0x3f, 0x26, 0x26	
	byte	0x3f, 0x26, 0x33
	byte	0x3f, 0x26, 0x3f
	byte	0x3f, 0x33, 0x00	; index f4
	byte	0x3f, 0x33, 0x0c
	byte	0x3f, 0x33, 0x19
	byte	0x3f, 0x33, 0x26	
	byte	0x3f, 0x33, 0x33	; index f8
	byte	0x3f, 0x33, 0x3f
	byte	0x3f, 0x3f, 0x00
	byte	0x3f, 0x3f, 0x0c
	byte	0x3f, 0x3f, 0x19	; index fc
	byte	0x3f, 0x3f, 0x26	
	byte	0x3f, 0x3f, 0x33
	byte	0x3f, 0x3f, 0x3f

VidEnds		PalRegs
