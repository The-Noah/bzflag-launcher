!include "MUI.nsh"

!define APPNAME "BZFlag Launcher"
!define APPID "bzflag-launcher"
!define COMPANYNAME "The Noah"
!define DESCRIPTION "Simple launcher for BZFlag which can handle a custom URI scheme on Windows"
# These three must be integers
!define VERSIONMAJOR 1
!define VERSIONMINOR 0
!define VERSIONREVISION 0
# These will be displayed by the "Click here for support information" link in "Add/Remove Programs"
# It is possible to use "mailto:" links in here to open the email client
!define HELPURL "http://github.com/The-Noah/bzflag-launcher" # "Support Information" link
!define ABOUTURL "http://github.com/The-Noah/" # "Publisher" link
# This is the size (in kB) of all the files copied into the install location
!define INSTALLSIZE 109

RequestExecutionLevel user

SetCompress auto
SetCompressor /SOLID lzma

InstallDir "$LOCALAPPDATA\Programs\${APPNAME}"

# rtf or txt file - remember if it is txt, it must be in the DOS text format (\r\n)
#LicenseData "LICENSE"
# This will be in the installer/uninstaller's title bar
Name "${APPNAME}"
OutFile "${APPID}.${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONREVISION}.exe"

!include LogicLib.nsh

!define MUI_ABORTWARNING
!define MUI_ICON "src\icon.ico"

!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

Section "install"
	# Files for the install directory - to build the installer, these should be in the same directory as the install script (this file)
	SetOutPath $INSTDIR
  
	# Files added here should be removed by the uninstaller (see section "uninstall")
	File "bin\Release\${APPID}.exe"
  File "LICENSE"
  File "README.md"
	# Add any other files for the install directory (license files, app data, etc) here
  
	# Uninstaller - See function un.onInit and section "uninstall" for configuration
	WriteUninstaller "$INSTDIR\uninstall.exe"
  
	# Start Menu
	CreateShortCut "$SMPROGRAMS\${APPNAME}.lnk" "$INSTDIR\${APPID}.exe" "" "$INSTDIR\${APPID}.exe"
  
	# Registry information for add/remove programs
	WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
	WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
	WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
	WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
	WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayIcon" "$\"$INSTDIR\${APPID}.exe$\""
	WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "Publisher" "${COMPANYNAME}"
	WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "HelpLink" "$\"${HELPURL}$\""
	WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "URLInfoAbout" "$\"${ABOUTURL}$\""
	WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayVersion" "${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONREVISION}"
	WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMajor" ${VERSIONMAJOR}
	WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMinor" ${VERSIONMINOR}
	# There is no option for modifying or repairing the install
	WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoModify" 1
	WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoRepair" 1
	# Set the INSTALLSIZE constant (!defined at the top of this script) so Add/Remove Programs can accurately report the size
	WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "EstimatedSize" ${INSTALLSIZE}
  
  # URI scheme handler
  WriteRegStr HKCR "${APPID}" "(Default)" "URL:${APPNAME} Protocol"
  WriteRegStr HKCR "${APPID}" "URL PROTOCOL" ""
  WriteRegStr HKCR "${APPID}\DefaultIcon" "(Default)" "${APPID}.exe,1"
  WriteRegStr HKCR "${APPID}\shell\open\command" "(Default)" "$\"$INSTDIR\${APPID}.exe$\" $\"%1$\""
  
  DetailPrint "Created URI scheme handler"
SectionEnd

# Uninstaller

Section "uninstall"
	# Remove Start Menu launcher
	Delete "$SMPROGRAMS\${APPNAME}.lnk"
  
	# Remove files
	Delete $INSTDIR\${APPID}.exe
  Delete $INSTDIR\LICENSE
  Delete $INSTDIR\README.md
  
	# Always delete uninstaller as the last action
	Delete $INSTDIR\uninstall.exe
  
	# Try to remove the install directory - this will only happen if it is empty
	RMDir $INSTDIR
  
	# Remove uninstaller information from the registry
	DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
  DeleteRegKey HKCR "${APPID}"
SectionEnd