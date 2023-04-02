#!/sbin/sh

#
# Solaris Zones configurator/install tool.
#
# ident   "@(#)zoneinst.sh     1.0     11/24/10 YV"
#
# Copyright (C) 2010, Y.Voinov
#

#############
# Variables #
#############

# OS variables   
CUT=`which cut`
ECHO=`which echo`
EXPR=`which expr`
GETOPT=`which getopt`
GREP=`which grep`
ID=`which id`
SED=`which sed`
UNAME=`which uname`
ZONEADM=`which zoneadm`
ZONECFG=`which zonecfg`
ZFS=`which zfs`

OS_VER=`$UNAME -r|$CUT -f2 -d"."`
OS_NAME=`$UNAME -s|$CUT -f1 -d" "`

###############
# Subroutines #
###############

os_check ()
{
 if [ "$OS_NAME" != "SunOS" ]; then
  $ECHO "ERROR: Unsupported OS $OS_NAME. Exiting..."
  exit 1
 elif [ "$OS_VER" -lt "10" ]; then
  $ECHO "ERROR: Unsupported $OS_NAME version $OS_VER. Exiting..."
  exit 1
 fi
}

root_check ()
{
 if [ ! `$ID | $CUT -f1 -d" "` = "uid=0(root)" ]; then
  $ECHO "ERROR: You must be super-user to run this script."
  exit 1
 fi
}

usage ()
{
 # Print usage note
 $ECHO "Usage: $0 [-i] [-n] [-s] [-h] zoneX.cfg"
 $ECHO "Where zoneX.cfg is zone parameters file (required)."
 $ECHO "-i option prints zone info when configuration complete (optional)."
 $ECHO "-n option uses for non-interactive zone installation and quota assigning (optional)."
 $ECHO "-s options skips zone installation and quota assigning." 
 $ECHO "-h prints this note."
 exit 0
}

get_cfg_file ()
{
 par=$1

 if [ "x$par" = "x" ]; then
  $ECHO "ERROR: Config file not found."
  $ECHO "Exiting..."
  exit 1
 else
  # Source config file
  . $par
 fi
}

check_zone_name ()
{
 # Check is zone $ZONE already exists
 zone="`$ZONEADM list|$GREP $ZONE`"
 if [ "$zone" != "" ]; then
  $ECHO "ERROR: Zone $ZONE already exists! Exiting..."
  exit 1
 fi
}

common_zone_cfg ()
{
 # Common zone configuration routine
 dedicated=$1

 if [ "$dedicated" = "0" ]; then
  $ZONECFG -z $ZONE "set scheduling-class=$SCHEDCLASS; set cpu-shares=$CPU;"
  if [ "x$CAPPED_CPU" != "x" ]; then
   # Set capped CPU if specified
   $ZONECFG -z $ZONE "add capped-cpu; set ncpus=$CAPPED_CPU; end;"
  fi
 elif [ "$dedicated" = "1" ]; then
  # Set dedicated CPU if specified
  $ZONECFG -z $ZONE "add dedicated-cpu; set ncpus=$NCPU; set importance=$IMPORTANCE; end;"
 else
  $ECHO "ERROR: Unknown value DEDUCATED_CPU. Exiting..."
  exit 1
 fi
 # Set capped memory if parameter specified
 if [ "$CAPPED_MEM" = "1" -a ! -z "$MPHYS" -a ! -z "$MSWAP" -a ! -z "$MLOCK" ]; then
  $ZONECFG -z $ZONE "add capped-memory; set physical=$MPHYS; set swap=$MSWAP; set locked=$MLOCK; end;"
 fi
 # Set zone filesystem parameters
 $ZONECFG -z $ZONE "add fs; set dir=$FS; set special=$SPEC; set type=lofs; set options=ro; end;"
 # Set IP type for zone. Default is shared (when not specified IP type).
 if [ "x$IP_TYPE" != "x" -a "$IP_TYPE" = "exclusive" ]; then
  $ZONECFG -z $ZONE "set ip-type=exclusive"
  $ZONECFG -z $ZONE "add net; set physical=$PHYS; end;"
 else
  # Set zone network parameters
  if [ "x$DEFROUTER" != "x" ]; then
   $ZONECFG -z $ZONE "add net; set address=$ADDR; set physical=$PHYS; set defrouter=$DEFROUTER; end;"
  else
   $ZONECFG -z $ZONE "add net; set address=$ADDR; set physical=$PHYS; end;"
  fi
 fi
}

sparse_root_zone ()
{
 # Create sparce root zone
 $ZONECFG -z $ZONE "create; set autoboot=true; set zonepath=$ZONEPATH;"
 $ZONECFG -z $ZONE "add inherit-pkg-dir; set dir=$IPD; end;"
 # Add most common zone configuration
 common_zone_cfg $DEDICATED_CPU
}

whole_root_zone ()
{
 # Create whole root zone
 $ZONECFG -z $ZONE "create -b; set autoboot=true; set zonepath=$ZONEPATH;"
 # Add most common zone configuration
 common_zone_cfg $DEDICATED_CPU
}

install_configured_zone ()
{
 $ZONEADM -z $ZONE install
  retcode=`$ECHO $?`
 case "$retcode" in
  0) $ECHO "*** Zone $ZONE installation successful";;
  *) $ECHO "*** Zone $ZONE installation has errors. Exiting..."
     exit
  ;;
 esac
}

set_disk_quota ()
{
 # Get zone dataset from mountpoint
 dataset="`$ECHO $ZONEPATH | $SED 's/.\(.*\)/\1/'`"
 # Set disk quota for installed zone
 $ZFS set quota=$QUOTA $dataset
 retcode=`$ECHO $?`
 case "$retcode" in
  0) $ECHO "*** Quota $QUOTA installation successful";;
  *) $ECHO "*** Quota installation has errors";;
 esac
}

##############
# Main block #
##############

# OS version checking
os_check

# Superuser check
root_check

# Check command-line arguments
if [ "x$*" = "x" ]; then
 # If arguments list empty, show usage note
 usage
else
 arg_list=$*
 # Parse command line
 set -- `$GETOPT iInNsShH: $arg_list` || {
  usage
 }

 # Read arguments
 for i in $arg_list
  do
   case $i in
    -i|-I) print_zone_info="1";;
    -n|-N) non_interactive="1";;
    -s|-S) skip_installation="1";;
    -h|-H|\?) usage;;
    *) shift
       config_file=$1
       break;;
   esac
   shift
  done

 # Remove trailing --
 shift `$EXPR $OPTIND - 1`
fi

# Get zone config file
get_cfg_file $config_file

# Check zone exists
check_zone_name

# Check zone type and configure appropriate
if [ "$ZONE_TYPE" = "sparse" ]; then
 sparse_root_zone
elif [ "$ZONE_TYPE" = "whole" ]; then
 whole_root_zone
else
 $ECHO "ERROR: Unknown zone type. Must be 'sparce' or 'whole' value. Exiting..."
 exit 1
fi

$ECHO "Zone $ZONE configured."
$ECHO "______________________"
# Print configured zone info if requested
if [ "$print_zone_info" = "1" ]; then
 $ZONECFG -z $ZONE info
 $ECHO "______________________"
fi
# Skip installation if required
if [ "$skip_installation" = "1" ]; then
 $ECHO "Installation not performed. Exiting..."
 exit 0
fi
# Bypass interactive mode if required
if [ "$non_interactive" != "1" ]; then
 $ECHO "Press <Enter> to install zone or <Ctrl+C> to cancel."
 read p     
fi

# Install zone
install_configured_zone

# Setting disk quota
set_disk_quota

exit 0
