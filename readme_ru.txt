============================================================
Zoneinst - Solaris zones configurator   (C) 2010 Yuri Voinov
============================================================

��������
--------
������  ������  �������  ��� ������������� � ����� ���������
������������� ��� Solaris.

���     �������������     ����    ����������     �����������
���������������� ���� �� �������, ������������ � �������.

����   ����   ���������   �   ������������   �  ������  ����
�   �����������   ���   ����������  ������������  ����������
������������� � � ����� ����������������.

����� ���������� ����������������� ����� �� ������������ ���
��������   ���   ������  �����������������  �������.  ������
���������   ��������   ������������   ����,  ��  �����������
����������� � ��������� ����� �� ������� ����.

���������� �������
------------------
���  ���������� ������� ���������� ������� ��� �� ����������
�����������:

zoneinst.sh [-i] [-n] [-s] [-h] zoneX.cfg

��� zoneX.cfg ���� ���������� ���� (������������).
-i  - �������������� �����, ���������� ����� ���� ����������
    ���� ����� �� ���������������� � �� �����������.
-n   -   ��������������  �����,  ����������  ���������������
����������� ���� ����� �� ���������������� � ��������� �����
�� ������� ����.
-s    -   ��������������   �����,   �����������   ����������
�����������  �  ���������  �����  ��������  ����  (���������
������ ���������������� ����).
-h - �������������� �����, ���������� ������ ���������.

���������������� ���� ����
--------------------------
����������������  ����  ����  ��������� � ������ �����������
����,  ���  ����  ����� ����������� � ���������������� �����
���������� ZONE.

������  �����������������  ����� ���� � ����������� ��������
����.

���������:  ��  ����������������  ���������������� ���������
���!

<Cut here>
# -------------------- zoneX.cfg template ------------------

# Zone type. Sparse root or whole root.
# Default is sparse.
#ZONE_TYPE="whole"
ZONE_TYPE="sparse"
^^^^^^^^^^^^^^^^^^   ���   �����������   ����,  sparse  root
(default) ��� whole root.

# Zone name
ZONE="zone1"
^^^^^^^^^^^^���  ����������� ����. ������ ��������� � ������
����������������� �����.

# Zone storage pool mountpoint.
# Zone dataset will be created during installation.
# Note: In order to create DATASET for zone (with quota)
#       you MUST use top level storage pool at this parameter.
#       Otherwise directory will be created for zone with
#       global pool quota only!
ZONEDATA="/data"
^^^^^^^^^^^^^^^^   ���   ����   ��������,  �  �������  �����
����������� �������� ���. ���� �� ������� � ������ ���������
�������,   ���   ����   �����  �������  ����������  �  �����
������������  ��������  (������������  ��������� ����������)
�  ��  ��  ������� ��������� ��������� ����� ��� ����. �����
�����������   ������   ����������  �����  ��������.  �������
��������  ��� �������� ����� �������� �������� ������ ��� ��
�������������.

# Zonepath forming from storage pool name and zonename
ZONEPATH="$ZONEDATA/$ZONE"

# CPU usage mode.
#  If  0,  shared CPU and FSS is using. If 1, then dedicated
CPU is using.
DEDICATED_CPU="0"
^^^^^^^^^^^^^^^^^  �����  �������������  ����������� � ����.                    
�� ��������� - shared.

# Default scheduling class
SCHEDCLASS="FSS"
^^^^^^^^^^^^^^^^    �����   ������������   �����   �   ����.
�� ��������� - FSS (Fair Share Scheduler).

# CPU shared
CPU="2"
^^^^^^^  ����������  �����������  CPU  �  ����  ��� ��������
���������   DEDICATED_CPU=0.   ��������   ������������   ���
��������  ���������  DEDICATED_CPU=1 (��������������� ������
��������� �������� ������������������).

# Capped CPU. Leave it blank if want to not set.
# Relative percent value.  Specified only when DEDICATED_CPU
# is set to 0.
CAPPED_CPU=""
^^^^^^^^^^^^^  �������������  ������� ��������� CPU � shared
������.

# CPU dedicated.
# Can be specified as range (i.e. 1-3) or single value (2).
NCPU="1-2"
^^^^^^^^^^  ���������� (��������) ���������� ����������� ���
��������� ������ ���� DEDICATED_CPU=1.

# Relative resource pool importance
IMPORTANCE="2"
^^^^^^^^^^^^^   �������������   ��������   ����������   ����
���������� �����������.

# Capped memory. Set to 1 to enable. Leave it blank for none.
#  If  set  to 1, at least one of next three parameters must
be specified.
CAPPED_MEM="1"
^^^^^^^^^^^^^^  ���������  capped  memory  ����.  ��� ������
�������       �����������      ������      rcapd      (FMRI:
svc:/system/rcap:default).  ����  ��������  ����������  � 1,
���� �� ��������� ���� ���������� ������ ���� �����.

#  Capped memory. If parameter is not specified, it will not
be set.
MPHYS="256m"
^^^^^^^^^^^^ ����������� ���������� ������ ���� � ����������
CAPPED_MEM.

MSWAP="256m"
^^^^^^^^^^^^   ����������� ������ �������� ���� � ����������
CAPPED_MEM.

MLOCK="256m"
^^^^^^^^^^^^   �����������   ���������������   ������   ����
� ���������� CAPPED_MEM.

# Filesystem
FS="/data/stage"
^^^^^^^^^^^^^^^^  ��������  ������� ���������� ����, �������
������  ����  �����  �  ������ ������������ read-only ������
������������ ����.

# Special value for fs
SPEC="/stage"
^^^^^^^^^^^^^ �������� special ��� ����������� ���������.

# Inherit pkg dir
IPD="/opt"
^^^^^^^^^^  ����������  inherit  package dir ��� sparse root
����.  ��������  ������������  � ������ ��������� whole root
����.

# Network address for zone
# Will be ignored if IP_TYPE specified to exclusive.
ADDR="192.168.192.10"
^^^^^^^^^^^^^^^^^^^^^  IP-�����  ����. ����� ��������������,
���� �������� IP_TYPE ����� ������ exclusive.

# Physical interface for zone
PHYS="e1000g0"
^^^^^^^^^^^^^^ ��� ����������� ���������� ��� �������� � ����.

# Default router for zone. Leave it blank to none.
DEFROUTER=""
^^^^^^^^^^^^ ���� �� ��������� ��� ����.

#   IP   type  for  zone.  Specify  "exclusive"  value  when
# appropriate.
# Leave it blank to default (shared).
IP_TYPE=""
^^^^^^^^^^  ���  IP ��� ����. �� ��������� �������� �� �����
(shared).   ���  �������  �������������  IP  ���������������
� exclusive.

# ZFS disk quota for zone
QUOTA="2G"
^^^^^^^^^^ ������ �������� ����� ��� ���� �� ZFS. ����������
������������ ��������� ������������ � ����.

# -------------------- zoneX.cfg template ------------------
<Cut here>

============================================================
Zoneinst - Solaris zones configurator   (C) 2010 Yuri Voinov
============================================================