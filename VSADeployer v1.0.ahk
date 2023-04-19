#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance,force ;
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines, -1

projName := "VSADeployer"
projVersion := "1.0"

;Write INI File Values
IniWrite,XXXXXXXX,practices.ini,ABC Dentist,Package
IniWrite,XXXXXXXX,practices.ini,Acme Doctors,Package
IniWrite,XXXXXXXX,practices.ini,X-Ray Xperts,Package
IniWrite,XXXXXXXX,practices.ini,Canyon Periodontics,Package
IniWrite,XXXXXXXX,practices.ini,Example Office,Package

Data := []
Gui, Add, Text,x10,Search:
Gui, Add, Edit, w325 x10 vSearchTerm gSearch
Gui, Add, ListView, grid xm w326 r25 x10 y50 -Multi vmyList1 Sort gListViewHandler, Practice|Package
Gui, Add, Button, gButtonInstallVSA, Download && Install MSI
gui, add, button, x+22 Default gButtonDownloadVSA,Download MSI
Gui, Add, Button, x+22 gButtonBAT, Generate BAT

Gui, Add, Button, xs gButtonAddPackage, Add Package
Gui, Add, Button, x+22 gButtonDeletePackage, Delete Package
Gui, Add, Button, x+22 gButtonReloadConfig, Reload Config
Gui, Font, s8 not bold, Tahoma
Gui, Add, Button, x+23 gButtonSelfDestruct, !

LV_ModifyCol(1,235)  ; Auto-size each column to fit its contents.
LV_ModifyCol(2,70)

IniFile := "practices.ini"
IniRead, NameList, % IniFile
Names := StrSplit(NameList, "`n")
for Each, Name in Names {
	IniRead, package, % IniFile, % Name, package
	Data[Name] := package
	LV_Add("",Name,package)
	Gui, ListView, vmyList1
}

TotalItems := Data.Length()

Gui, Add, StatusBar, , % "   " . TotalItems . " of " . TotalItems . " Practices"
Gui, Show, , % projName " v" projVersion
Return

GuiClose:
ExitApp

Search:
GuiControlGet, SearchTerm
GuiControl, -Redraw, LV
LV_Delete()
for key, name In Data {
    ; if search is not blank
    if (SearchTerm != "") {
        ; if search term is in name
        if (InStr(key, SearchTerm) || InStr(name, SearchTerm)) {
            LV_Add("", key, name)
        }
    } else {
        ; blank search area; just all all
        LV_Add("", key, name)
    }
}
Items := LV_GetCount()
SB_SetText("   " . Items . " of " . Data.count() . " Practices")
GuiControl, +Redraw, LV
Return

ButtonInstallVSA:
    FileCreateDir C:\VSA
    Row := LV_GetNext()
    If (Row) {
        LV_GetText(Practice, Row, 1)
		LV_GetText(Package, Row, 2)
		FileCreateDir C:\VSA
		url1 =https://vsa132.kaseya.net/mkDefault.asp?id=%Package%
		SplitPath,url1,name1, dir, ext, name_no_ext, drive
		F1=C:\VSA\
		X1=.msi
		; Option "1" is "OK/Cancel"
		MsgBox, 1, Proceed with Install?
		IfMsgBox, Cancel
		{
			return
		}
		;Update the path to the appropriate file
		if FileExist("C:\Program Files (x86)\Kaseya\KSAAS123456789123456\KASetup.exe"){
			MsgBox, VSA Agrent currently installed.  Uninstalling and reinstalling VSA Agent for %Practice%.
			RunWait , "C:\Program Files (x86)\Kaseya\KSAAS123456789123456\KASetup.exe" /s /r /g KSAAS123456789123456 /l "%TEMP%\kasetup.log"
		}
		MsgBox Downloading VSA Package for %Practice% from https://vsa132.kaseya.net/mkDefault.asp?id=%Package%.  This may take a few moments.  We will let you know when we start the install.
		UrlDownloadToFile,%URL1%,%F1%%Practice% VSA Setup%X1%
		FileGetSize, FS, %F1%%Practice% VSA Setup%X1%
		if (FS<1000){
			MsgBox This file could not be downloaded.
		}
		else
		{
			MsgBox VSA package download for %Practice% is complete and has been placed within C:\VSA\ directory.  Now installing VSA Agent package...
			run,%F1%%Practice% VSA Setup%X1%
		}
    }
	return
	
ButtonDownloadVSA:
    SetWorkingDir %A_ScriptDir%
	FileCreateDir VSA Installers
    Row := LV_GetNext()
    If (Row) {
        LV_GetText(Practice, Row, 1)
		LV_GetText(Package, Row, 2)
		url1 =https://vsa132.kaseya.net/mkDefault.asp?id=%Package%
		SplitPath,url1,name1, dir, ext, name_no_ext, drive
		F1=VSA Installers\
		X1=.msi
		MsgBox Downloading VSA Package for %Practice% from https://vsa132.kaseya.net/mkDefault.asp?id=%Package%.  We let you know when download is complete.
		UrlDownloadToFile,%URL1%,%F1%%Practice% VSA Setup%X1%
		FileGetSize, FS, %F1%%Practice% VSA Setup%X1%
		if (FS<1000){
			MsgBox This file could not be downloaded.
		}
		else
		{
			MsgBox VSA package download for %Practice% complete and has been stored in "VSA Installers\" within the parent directory of this application.
		}

    }
return

ButtonBAT:
    SetWorkingDir %A_ScriptDir%
	FileCreateDir VSA Batch Files
    Row := LV_GetNext()
    If (Row) {
        LV_GetText(Practice, Row, 1)
		LV_GetText(Package, Row, 2)
		url1 =https://vsa132.kaseya.net/mkDefault.asp?id=%Package%
		P1=VSA Batch Files\%Practice% VSA Install.bat
		SplitPath,url1,name1, dir, ext, name_no_ext, drive
		MsgBox Generating BATCH file for VSA MSI installation.
		FileDelete, %P1%
		FileAppend,
		(
@Echo off
@echo off
mkdir c:\vsa
powershell -Command "Invoke-WebRequest https://vsa132.kaseya.net/mkDefault.asp?id=%Package% -OutFile c:\vsa\%Practice% VSA Install.msi"
powershell -Command "Start-Process C:\vsa\%Practice% VSA Install.msi"
		), VSA Batch Files\%Practice% VSA Install.bat
	
		MsgBox BATCH file generation complete and has been stored in "VSA Batch Files\" within the parent directory of this application
		if errorlevel
		msgbox error %errorlevel%
    }
	return

ButtonReloadConfig:
LV_Delete()  ; Clear the ListView, but keep icon cache intact for simplicity.

Data := []
IniFile := "practices.ini"
IniRead, NameList, % IniFile
Names := StrSplit(NameList, "`n")
for Each, Name in Names {
	IniRead, package, % IniFile, % Name, package
	;MsgBox, % Name "`t" package
	Data[Name] := package
	Gui, ListView, vmyList1
	LV_Add(,Name,package)
	}
return

ButtonAddPackage:
InputBox, pract, Practice Name, Please enter a practice name., ,
if ErrorLevel
    MsgBox, CANCEL was pressed.
else
	InputBox, pack, Package ID, Please enter a VSA package id, ,
	if ErrorLevel
		MsgBox, CANCEL was pressed.
	else
		IniWrite,%pack%,practices.ini,%pract%,Package
LV_Delete()  ; Clear the ListView, but keep icon cache intact for simplicity.
;Refresh ListView after add
Data := []
IniFile := "practices.ini"
IniRead, NameList, % IniFile
Names := StrSplit(NameList, "`n")
for Each, Name in Names {
	IniRead, package, % IniFile, % Name, package
	Data[Name] := package
	Gui, ListView, vmyList1
	LV_Add(,Name,package)
	}
return

ButtonDeletePackage:
    Row := LV_GetNext()
    If (Row) {
        LV_GetText(Practice, Row, 1)
		LV_GetText(Package, Row, 2)

		;msgbox error %errorlevel%
		IniDelete, practices.ini, %Practice%
		LV_Delete()  ; Clear the ListView, but keep icon cache intact for simplicity.
		;Refresh ListView after delete
		Data := []
		IniFile := "practices.ini"
		IniRead, NameList, % IniFile
		Names := StrSplit(NameList, "`n")
		for Each, Name in Names {
			IniRead, package, % IniFile, % Name, package
			;MsgBox, % Name "`t" package
			Data[Name] := package
			Gui, ListView, vmyList1
			LV_Add(,Name,package)
			}
	}
	
	return

ButtonSelfDestruct:
;projName := "VSADeployer"
	MsgBox, 1, Remove VSADeployer and config?
	IfMsgBox, Cancel
	{
		return
	}
If A_IsCompiled {
FileAppend,
(
	sleep 5
	del %A_ScriptDir%\%projName%*
	del %A_ScriptDir%\practices.ini
), %A_Temp%\selfDelete.bat
Run, %A_Temp%\selfDelete.bat
ExitApp
}
return 

ListViewHandler:
if A_GuiEvent = DoubleClick
{
    LV_GetText(package, A_EventInfo, 2) ; Get the text of the first field.
    MsgBox, % Name "`t" package
}
return

Execute:
    Row := LV_GetNext()
    If (Row) {
        LV_GetText(FileName, Row, 2)
        ;Execute(Filename)
		UrlDownloadToFile, https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.76-installer.msi, C:\VSA\SimplyKidsVSA.msi
    }
Return

Execute(Filename) {
    Run %FileName%,, UseErrorLevel
    if ErrorLevel
        MsgBox Could not open "%FileName%".
}


