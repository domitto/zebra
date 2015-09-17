#!../../bin/linux-x86_64/zebra

## You may have to change zebra to something else
## everywhere it appears in this file

< envPaths

cd "$(TOP)"

## Register all support components
dbLoadDatabase("dbd/zebra.dbd",0,0)
zebra_registerRecordDeviceDriver(pdbbase) 

#drvAsynSerialPortConfigure("ty_zebra", "/dev/ttyUSB0", 100, 0, 0)
#asynSetOption("ty_zebra", 0, "baud", "115200")
#asynSetOption("ty_zebra", 0, "parity", "None")
#asynSetOption("ty_zebra", 0, "stop", "1")
#asynSetOption("ty_zebra", 0, "bits", "8")

drvAsynIPPortConfigure("ty_zebra","moxa:PORT")

#zebraConfig(Port, SerialPort, MaxPosCompPoints)
zebraConfig("ZEBRA", "ty_zebra", 100000)


## Load record instances
dbLoadTemplate 'db/zebra.substitutions'

## autosave/restore machinery
save_restoreSet_Debug(0)
save_restoreSet_IncompleteSetsOk(1)
save_restoreSet_DatedBackupFiles(1)

set_savefile_path("${TOP}/as","/save")
set_requestfile_path("${TOP}/as","/req")

set_pass0_restoreFile("info_positions.sav")
set_pass0_restoreFile("info_settings.sav")
set_pass1_restoreFile("info_settings.sav")

iocInit()

## more autosave/restore machinery
cd ${TOP}/as/req
makeAutosaveFiles()
create_monitor_set("info_positions.req", 5 , "")
create_monitor_set("info_settings.req", 15 , "")

## Start any sequence programs
#seq snczebra,"user=domitto"
