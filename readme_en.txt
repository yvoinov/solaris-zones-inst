============================================================
Zoneinst - Solaris zones configurator   (C) 2010 Yuri Voinov
============================================================

Introduction
------------
This script was written for mass deployment Solaris zones.

For  zone  deployment you need to prepare zone configuration
file from template included.

Zone  configuration  file  name  is forming as zone name for
reuse and documentation purposes.

After   zone   configuration   file   preparation   it  uses
as argument during script call. Script configures zone, then
installs it and set quota on zone dataset.

Script call
-----------
For execure script you must call them with next arguments:

zoneinst.sh [-i] [-n] [-s] [-h] zoneX.cfg

where zoneX - zone configuration file (required).
-i    -   optional  parameter,  which  is  prints  all  zone
     parameters after configuration and before installation.
-n - optional parameter, which is turns on zone installation
     and set quote on zone dataset in non-interactive mode.
-s  -  optional parameter, which skips zone installation and
    set quota on dataset (will execute only zone
    configuration).
-h - optional parameter, which is prints this help screen.

Zone configuration file
-----------------------
Zone  configuration  file  is  named as zone, zone name also
specifies in configuration file as parameter ZONE.

Zone configuration file example with comments is below.

Note: DO NOT RENAME configuration parameters!

<Cut here>
# -------------------- zoneX.cfg template ------------------

# Zone type. Sparse root or whole root.
# Default is sparse.
#ZONE_TYPE="whole"
ZONE_TYPE="sparse"
^^^^^^^^^^^^^^^^^^ Zone type, sparse root or whole root.

# Zone name
ZONE="zone1"
^^^^^^^^^^^^  Zone  name.  Must be the same as configuration
file name.

# Zone storage pool mountpoint.
# Zone dataset will be created during installation.
# Note: In order to create DATASET for zone (with quota)
#       you MUST use top level storage pool at this parameter.
#       Otherwise directory will be created for zone with
#       global pool quota only!
ZONEDATA="/data"
^^^^^^^^^^^^^^^^ Storage pool name for zone dataset. If your
specify dataset here, zone will be created as directory into
specified  dataset mount point and you cannot use quota onto
zone  filesystem.  It  is  not  recommended  to  create zone
filesystem from dataset.

# Zonepath forming from storage pool name and zonename
ZONEPATH="$ZONEDATA/$ZONE"

# CPU usage mode.
#  If  0,  shared CPU and FSS is using. If 1, then dedicated
CPU is using.
DEDICATED_CPU="0"
^^^^^^^^^^^^^^^^^ CPU usage mode for zone. Shared by default.

# Default scheduling class
SCHEDCLASS="FSS"
^^^^^^^^^^^^^^^^ Shedule class for zone. FSS by default.

# CPU shared
CPU="2"
^^^^^^^   Shared   CPU  inside  zone  when  DEDICATED_CPU=0.
Parameter   will   be   ignore  when  DEDICATED_CPU=1  (zone
parameters is mutually exclusive).

# Capped CPU. Leave it blank if want to not set.
# Relative percent value.  Specified only when DEDICATED_CPU
# is set to 0.
CAPPED_CPU=""
^^^^^^^^^^^^^ Relative CPU percent limit in CPU shared mode.

# CPU dedicated.
# Can be specified as range (i.e. 1-3) or single value (2).
NCPU="1-2"
^^^^^^^^^^ CPU quantity (range) when DEDICATED_CPU=1.

# Relative resource pool importance
IMPORTANCE="2"
^^^^^^^^^^^^^  Relative  importance dedicated CPU's resource
pool.

# Capped memory. Set to 1 to enable. Leave it blank for none.
#  If  set  to 1, at least one of next three parameters must
be specified.
CAPPED_MEM="1"
^^^^^^^^^^^^^^ Memory capping in zone enable. Required rcapd
(FMRI:  svc:/system/rcap:default).  If  parameter is on (1),
one of next three parameters must be specified.

#  Capped memory. If parameter is not specified, it will not
be set.
MPHYS="256m"
^^^^^^^^^^^^ Zone physical memory limit with CAPPED_MEM=1.

MSWAP="256m"
^^^^^^^^^^^^ Zone swap memory limit with CAPPED_MEM=1.

MLOCK="256m"

# Filesystem
FS="/data/stage"
^^^^^^^^^^^^^^^^  Global zone filesystem which is mount with
read-only  inside  non-global  zone  with  lofs.

# Special value for fs
SPEC="/stage"
^^^^^^^^^^^^^ Spacial value for previous parameter.

# Inherit pkg dir
IPD="/opt"
^^^^^^^^^^  Inherit  package  dir for sparse root zone. Will
be ignored with whole root zone.

# Network address for zone
# Will be ignored if IP_TYPE specified to exclusive.
ADDR="192.168.192.10"
^^^^^^^^^^^^^^^^^^^^^   Zone   IP.   Will  be  ignored  when
IP_TYPE=exclusive.

# Physical interface for zone
PHYS="e1000g0"
^^^^^^^^^^^^^^ Physical network interface for zone.

# Default router for zone. Leave it blank to none.
DEFROUTER=""
^^^^^^^^^^^^ Zone default gateway.

#   IP   type  for  zone.  Specify  "exclusive"  value  when
# appropriate.
# Leave it blank to default (shared).
IP_TYPE=""
^^^^^^^^^^  Zone  IP  type.  Default  is blank (shared). For
exclusive mode just set to "exclusive".

# ZFS disk quota for zone
QUOTA="2G"
^^^^^^^^^^  Full  disk quote for zone ZFS dataset. Specifies
all available disk space inside zone.

# -------------------- zoneX.cfg template ------------------
<Cut here>
 
============================================================
Zoneinst - Solaris zones configurator   (C) 2010 Yuri Voinov
============================================================