============================================================
Zoneinst - Solaris zones configurator   (C) 2010 Yuri Voinov
============================================================

Введение
--------
Данный  скрипт  написан  для использования в целях массового
развертывания зон Solaris.

Для     развертывания     зоны    необходимо     подготовить
конфигурационный файл по шалбону, приложенному к скрипту.

Файл   зоны   именуется   в   соответствии   с  именем  зоны
и   сохраняется   для   возможного  последующего  повторного
использования и в целях документирования.

После подготовки конфигурационного файла он используется как
аргумент   при   вызове  конфигурационного  скрипта.  Скрипт
выполняет   создание   конфигурации   зоны,  ее  последующую
инсталляцию и установку квоты на датасет зоны.

Выполнение скрипта
------------------
Для  выполнения скрипта необходимо вызвать его со следующими
аргументами:

zoneinst.sh [-i] [-n] [-s] [-h] zoneX.cfg

где zoneX.cfg файл параметров зоны (обязательный).
-i  - необязательная опция, включающая вывод всех параметров
    зоны после ее конфигурирования и до инсталляции.
-n   -   необязательная  опция,  включающая  неинтерактивную
инсталляцию зоны после ее конфигурирования и установку квоты
на датасет зоны.
-s    -   необязательная   опция,   позволяющая   пропустить
инсталляцию  и  установку  квоты  датасета  зоны  (выполнить
только конфигурирование зоны).
-h - необязательная опция, печатающая данную подсказку.

Конфигурационный файл зоны
--------------------------
Конфигурационный  файл  зоны  создается с именем создаваемой
зоны,  имя  зоны  также дублируется в конфигурационном файле
параметром ZONE.

Пример  конфигурационного  файла зоны с пояснениями приведен
ниже.

Замечание:  НЕ  ПЕРЕИМЕНОВЫВАЙТЕ  конфигурационные параметры
зон!

<Cut here>
# -------------------- zoneX.cfg template ------------------

# Zone type. Sparse root or whole root.
# Default is sparse.
#ZONE_TYPE="whole"
ZONE_TYPE="sparse"
^^^^^^^^^^^^^^^^^^   Тип   создаваемой   зоны,  sparse  root
(default) или whole root.

# Zone name
ZONE="zone1"
^^^^^^^^^^^^Имя  создаваемой зоны. Должно совпадать с именем
конфигурационного файла.

# Zone storage pool mountpoint.
# Zone dataset will be created during installation.
# Note: In order to create DATASET for zone (with quota)
#       you MUST use top level storage pool at this parameter.
#       Otherwise directory will be created for zone with
#       global pool quota only!
ZONEDATA="/data"
^^^^^^^^^^^^^^^^   Имя   пула   хранения,  в  котором  будут
создаваться датасеты зон. Если вы укажете в данном параметре
ДАТАСЕТ,   для   зоны   будет  создана  директория  в  точке
монтирования  датасета  (определяется  следующим параметром)
и  вы  не  сможете назначить отдельную квоту для зоны. Будет
действовать   только   глобальная  квота  датасета.  Задание
датасета  как корневой точки создания файловых систем зон НЕ
РЕКОМЕНДУЕТСЯ.

# Zonepath forming from storage pool name and zonename
ZONEPATH="$ZONEDATA/$ZONE"

# CPU usage mode.
#  If  0,  shared CPU and FSS is using. If 1, then dedicated
CPU is using.
DEDICATED_CPU="0"
^^^^^^^^^^^^^^^^^  Режим  использования  процессоров в зоне.                    
По умолчанию - shared.

# Default scheduling class
SCHEDCLASS="FSS"
^^^^^^^^^^^^^^^^    Класс   планировщика   задач   в   зоне.
По умолчанию - FSS (Fair Share Scheduler).

# CPU shared
CPU="2"
^^^^^^^  Количество  разделяемых  CPU  в  зоне  при значении
параметра   DEDICATED_CPU=0.   Параметр   игнорируется   при
значении  параметра  DEDICATED_CPU=1 (соответствующие зонные
параметры являются взаимоисключающими).

# Capped CPU. Leave it blank if want to not set.
# Relative percent value.  Specified only when DEDICATED_CPU
# is set to 0.
CAPPED_CPU=""
^^^^^^^^^^^^^  Относительный  процент выделения CPU в shared
режиме.

# CPU dedicated.
# Can be specified as range (i.e. 1-3) or single value (2).
NCPU="1-2"
^^^^^^^^^^  Количество (диапазон) выделяемых процессоров при
включении режима зоны DEDICATED_CPU=1.

# Relative resource pool importance
IMPORTANCE="2"
^^^^^^^^^^^^^   Относительная   важность   ресурсного   пула
выделенных процессоров.

# Capped memory. Set to 1 to enable. Leave it blank for none.
#  If  set  to 1, at least one of next three parameters must
be specified.
CAPPED_MEM="1"
^^^^^^^^^^^^^^  Включение  capped  memory  зоны.  Для работы
требует       запущенного      демона      rcapd      (FMRI:
svc:/system/rcap:default).  Если  параметр  установлен  в 1,
один из следующих трех параметров должен быть задан.

#  Capped memory. If parameter is not specified, it will not
be set.
MPHYS="256m"
^^^^^^^^^^^^ Ограничение физической памяти зоны с включением
CAPPED_MEM.

MSWAP="256m"
^^^^^^^^^^^^   Ограничение памяти подкачки зоны с включением
CAPPED_MEM.

MLOCK="256m"
^^^^^^^^^^^^   Ограничение   заблокированной   памяти   зоны
с включением CAPPED_MEM.

# Filesystem
FS="/data/stage"
^^^^^^^^^^^^^^^^  Файловая  система глобальной зоны, которая
должна  быть  видна  в  режиме монтирования read-only внутри
неглобальной зоны.

# Special value for fs
SPEC="/stage"
^^^^^^^^^^^^^ Значение special для предыдущего параметра.

# Inherit pkg dir
IPD="/opt"
^^^^^^^^^^  Директория  inherit  package dir для sparse root
зоны.  Параметр  игнорируется  в случае установки whole root
зоны.

# Network address for zone
# Will be ignored if IP_TYPE specified to exclusive.
ADDR="192.168.192.10"
^^^^^^^^^^^^^^^^^^^^^  IP-адрес  зоны. Будет игнорироваться,
если параметр IP_TYPE задан равным exclusive.

# Physical interface for zone
PHYS="e1000g0"
^^^^^^^^^^^^^^ Имя физического интерфейса для привязки к зоне.

# Default router for zone. Leave it blank to none.
DEFROUTER=""
^^^^^^^^^^^^ Шлюз по умолчанию для зоны.

#   IP   type  for  zone.  Specify  "exclusive"  value  when
# appropriate.
# Leave it blank to default (shared).
IP_TYPE=""
^^^^^^^^^^  Тип  IP для зоны. По умолчанию параметр не задан
(shared).   Для  задания  эксклюзивного  IP  устанавливается
в exclusive.

# ZFS disk quota for zone
QUOTA="2G"
^^^^^^^^^^ Полная дисковая квота для зоны на ZFS. Определяет
максимальное доступное пространство в зоне.

# -------------------- zoneX.cfg template ------------------
<Cut here>

============================================================
Zoneinst - Solaris zones configurator   (C) 2010 Yuri Voinov
============================================================