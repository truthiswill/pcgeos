##############################################################################
#
#	Copyright (c) GeoWorks 1991 -- All Rights Reserved
#
# PROJECT:	PC GEOS
# MODULE:	Kernel
# FILE:		kbde_sf.gp
#
# AUTHOR:	Gene
#
# Parameters file for: kbde_sf.geo
#
#	$Id: kbde_sf.gp,v 1.1 97/04/18 11:47:11 newdeal Exp $
#
##############################################################################
#
# Specify permanent name first
#
name	kbde_sf.drvr
#
# Specify geode type
#
type	driver, single
#
# Import kernel routine definitions
#
library	geos
#
# Desktop-related things
#
longname	"Swiss-French Extended Keyboard"
tokenchars	"KBDD"
tokenid		0
#
# Define resources other than standard discardable code
#
resource Resident fixed code read-only
resource Movable preload code read-only
