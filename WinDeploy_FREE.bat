@echo off
setlocal enabledelayedexpansion
title WinDeploy Pro v3.0 - Preparation Windows 11

:: ================================================================
:: WinDeploy Pro v3.0 - Preparation poste Windows 11
:: Usage entreprise - Lancer en tant qu'Administrateur
:: Log : C:\Logs\WinDeploy_AAAA-MM-JJ.log
:: ================================================================

:: ----------------------------------------------------------------
:: CONFIGURATION - Modifier selon les besoins
:: ----------------------------------------------------------------
set "COMPANY=VanooCONFIGE"
set "LOG_DIR=C:\Logs"
set "WALLPAPER=C:\Windows\Web\Wallpaper\Windows\img0.jpg"
set "VEILLE_AC=240"
set "VEILLE_DC=30"
set "ECRAN_AC=60"

:: Applications a installer par defaut (1=oui, 0=non)
set "INST_CHROME=1"
set "INST_FIREFOX=1"
set "INST_LIBREOFFICE=1"
set "INST_ACROBAT=1"
set "INST_VLC=1"
set "INST_7ZIP=1"
set "INST_NOTEPADPP=1"
set "INST_PDF24=1"
set "INST_WINSCP=1"
set "INST_PUTTY=1"
set "INST_MALWAREBYTES=1"

:: ----------------------------------------------------------------
:: INIT LOG
:: ----------------------------------------------------------------
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value 2^>nul') do set _DT=%%I
set "LOGDATE=%_DT:~0,4%-%_DT:~4,2%-%_DT:~6,2%"
set "LOGFILE=%LOG_DIR%\WinDeploy_%LOGDATE%.log"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1
echo WinDeploy Pro v3.0 - %DATE% %TIME% > "%LOGFILE%"

:: ----------------------------------------------------------------
:: VERIFICATION DROITS ADMIN
:: ----------------------------------------------------------------
net session >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo.
    echo  [ERREUR] Ce script doit etre execute en Administrateur.
    echo.
    echo  Clic droit sur le fichier .bat
    echo  puis "Executer en tant qu'administrateur"
    echo.
    pause
    exit /b 1
)

:: Detection winget
set "WINGET_OK=0"
winget --version >nul 2>&1
if %errorlevel% equ 0 set "WINGET_OK=1"

:: ================================================================
:: MENU PRINCIPAL
:: ================================================================
:MENU_PRINCIPAL
cls
echo.
echo  ============================================================
echo    WinDeploy Pro v3.0  -  %COMPANY%
echo    Preparation automatisee Windows 11
echo  ============================================================
echo.
echo   1.  Lancer le deploiement complet
echo   2.  Choisir les applications a installer
echo   3.  Quitter
echo.
set "CHOIX="
set /p "CHOIX=  Votre choix [1-3] : "

if "%CHOIX%"=="1" goto :DEPLOIEMENT
if "%CHOIX%"=="2" goto :MENU_APPS
if "%CHOIX%"=="3" exit /b 0
goto :MENU_PRINCIPAL

:: ================================================================
:: MENU SELECTION APPLICATIONS
:: ================================================================
:MENU_APPS
cls
echo.
echo  ============================================================
echo    Selection des applications
echo    [O] = sera installe    [N] = sera ignore
echo  ============================================================
echo.

call :AFF "1 " "Google Chrome"         INST_CHROME
call :AFF "2 " "Mozilla Firefox"       INST_FIREFOX
call :AFF "3 " "LibreOffice"           INST_LIBREOFFICE
call :AFF "4 " "Adobe Acrobat Reader"  INST_ACROBAT
call :AFF "5 " "VLC Media Player"      INST_VLC
call :AFF "6 " "7-Zip"                 INST_7ZIP
call :AFF "7 " "Notepad++"             INST_NOTEPADPP
call :AFF "8 " "PDF24 Creator"         INST_PDF24
call :AFF "9 " "WinSCP"                INST_WINSCP
call :AFF "10" "PuTTY"                 INST_PUTTY
call :AFF "11" "Malwarebytes"          INST_MALWAREBYTES

echo.
echo   Tapez un numero pour activer/desactiver.
echo   [A] Tout activer    [D] Tout desactiver
echo   [V] Valider et lancer    [R] Retour
echo.
set "CHOIX="
set /p "CHOIX=  Votre choix : "

if /i "%CHOIX%"=="V" goto :DEPLOIEMENT
if /i "%CHOIX%"=="R" goto :MENU_PRINCIPAL

if /i "%CHOIX%"=="A" (
    set INST_CHROME=1 & set INST_FIREFOX=1 & set INST_LIBREOFFICE=1
    set INST_ACROBAT=1 & set INST_VLC=1 & set INST_7ZIP=1
    set INST_NOTEPADPP=1 & set INST_PDF24=1 & set INST_WINSCP=1
    set INST_PUTTY=1 & set INST_MALWAREBYTES=1
    goto :MENU_APPS
)
if /i "%CHOIX%"=="D" (
    set INST_CHROME=0 & set INST_FIREFOX=0 & set INST_LIBREOFFICE=0
    set INST_ACROBAT=0 & set INST_VLC=0 & set INST_7ZIP=0
    set INST_NOTEPADPP=0 & set INST_PDF24=0 & set INST_WINSCP=0
    set INST_PUTTY=0 & set INST_MALWAREBYTES=0
    goto :MENU_APPS
)

if "%CHOIX%"=="1"  ( call :TOGGLE INST_CHROME        & goto :MENU_APPS )
if "%CHOIX%"=="2"  ( call :TOGGLE INST_FIREFOX       & goto :MENU_APPS )
if "%CHOIX%"=="3"  ( call :TOGGLE INST_LIBREOFFICE   & goto :MENU_APPS )
if "%CHOIX%"=="4"  ( call :TOGGLE INST_ACROBAT       & goto :MENU_APPS )
if "%CHOIX%"=="5"  ( call :TOGGLE INST_VLC           & goto :MENU_APPS )
if "%CHOIX%"=="6"  ( call :TOGGLE INST_7ZIP          & goto :MENU_APPS )
if "%CHOIX%"=="7"  ( call :TOGGLE INST_NOTEPADPP     & goto :MENU_APPS )
if "%CHOIX%"=="8"  ( call :TOGGLE INST_PDF24         & goto :MENU_APPS )
if "%CHOIX%"=="9"  ( call :TOGGLE INST_WINSCP        & goto :MENU_APPS )
if "%CHOIX%"=="10" ( call :TOGGLE INST_PUTTY         & goto :MENU_APPS )
if "%CHOIX%"=="11" ( call :TOGGLE INST_MALWAREBYTES  & goto :MENU_APPS )
goto :MENU_APPS

:: ================================================================
:: DEPLOIEMENT
:: ================================================================
:DEPLOIEMENT
cls
echo.
echo  ============================================================
echo    Deploiement en cours - Ne pas fermer cette fenetre
echo  ============================================================
echo.
call :LOG "INFO" "=== DEBUT DEPLOIEMENT === %COMPUTERNAME% === %USERNAME%"

:: ----------------------------------------------------------------
:: ETAPE 1 - Alimentation
:: ----------------------------------------------------------------
echo  [1/7] Alimentation et performances...
powercfg /change standby-timeout-ac %VEILLE_AC% >nul 2>&1
powercfg /change standby-timeout-dc %VEILLE_DC% >nul 2>&1
powercfg /change monitor-timeout-ac %ECRAN_AC% >nul 2>&1
powercfg /change monitor-timeout-dc 10 >nul 2>&1
powercfg /hibernate off >nul 2>&1
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
echo       [OK] Veille secteur : %VEILLE_AC% min - Haute performance active
call :LOG "OK" "Alimentation configuree"

:: ----------------------------------------------------------------
:: ETAPE 2 - Bureau et explorateur
:: ----------------------------------------------------------------
echo  [2/7] Bureau et explorateur...
set "K_ICO=HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
set "K_ADV=HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
reg add "%K_ICO%" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "%K_ICO%" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "%K_ICO%" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "%K_ADV%" /v HideFileExt /t REG_DWORD /d 0 /f >nul 2>&1
reg add "%K_ADV%" /v Hidden /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%K_ADV%" /v LaunchTo /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%K_ADV%" /v TaskbarAl /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
ie4uinit.exe -show >nul 2>&1
echo       [OK] Icones bureau, explorateur, barre des taches configures
call :LOG "OK" "Bureau configure"

:: ----------------------------------------------------------------
:: ETAPE 3 - Applications
:: ----------------------------------------------------------------
echo  [3/7] Installation des applications...
if "%WINGET_OK%"=="0" (
    echo       [SKIP] winget non disponible - etape ignoree
    call :LOG "WARN" "winget absent - apps ignorees"
    goto :ETAPE4
)
winget source update >nul 2>&1

if "%INST_CHROME%"=="1"       call :INSTALL "Google Chrome"        "Google.Chrome"
if "%INST_FIREFOX%"=="1"      call :INSTALL "Mozilla Firefox"      "Mozilla.Firefox"
if "%INST_LIBREOFFICE%"=="1"  call :INSTALL "LibreOffice"          "TheDocumentFoundation.LibreOffice"
if "%INST_ACROBAT%"=="1"      call :INSTALL "Adobe Acrobat Reader" "Adobe.Acrobat.Reader.64-bit"
if "%INST_VLC%"=="1"          call :INSTALL "VLC Media Player"     "VideoLAN.VLC"
if "%INST_7ZIP%"=="1"         call :INSTALL "7-Zip"                "7zip.7zip"
if "%INST_NOTEPADPP%"=="1"    call :INSTALL "Notepad++"            "Notepad++.Notepad++"
if "%INST_PDF24%"=="1"        call :INSTALL "PDF24 Creator"        "geeksoftware.PDF24Creator"
if "%INST_WINSCP%"=="1"       call :INSTALL "WinSCP"               "WinSCP.WinSCP"
if "%INST_PUTTY%"=="1"        call :INSTALL "PuTTY"                "PuTTY.PuTTY"
if "%INST_MALWAREBYTES%"=="1" call :INSTALL "Malwarebytes"         "Malwarebytes.Malwarebytes"

echo       [INFO] uBlock Origin = extension Chrome/Firefox - installation manuelle requise
call :LOG "INFO" "uBlock : manuel"

:ETAPE4
:: ----------------------------------------------------------------
:: ETAPE 4 - Fond d'ecran
:: ----------------------------------------------------------------
echo  [4/7] Fond d'ecran...
if exist "%WALLPAPER%" (
    reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%WALLPAPER%" /f >nul 2>&1
    reg add "HKCU\Control Panel\Desktop" /v WallpaperStyle /t REG_SZ /d "10" /f >nul 2>&1
    reg add "HKCU\Control Panel\Desktop" /v TileWallpaper /t REG_SZ /d "0" /f >nul 2>&1
    powershell -ExecutionPolicy Bypass -Command "Add-Type -TypeDefinition 'using System.Runtime.InteropServices; public class W { [DllImport(\"user32.dll\",CharSet=CharSet.Unicode)] public static extern int SystemParametersInfo(int u,int p,string l,int f); }'; [W]::SystemParametersInfo(20,0,\"%WALLPAPER%\",3)" >nul 2>&1
    echo       [OK] Fond d'ecran applique
    call :LOG "OK" "Fond d'ecran OK"
) else (
    echo       [WARN] Fichier introuvable : %WALLPAPER%
    call :LOG "WARN" "Fond d'ecran introuvable"
)

:: ----------------------------------------------------------------
:: ETAPE 5 - Securite
:: ----------------------------------------------------------------
echo  [5/7] Securite systeme...
powershell -ExecutionPolicy Bypass -Command "Set-MpPreference -DisableRealtimeMonitoring $false" >nul 2>&1
netsh advfirewall set allprofiles state on >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 4 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 5 /f >nul 2>&1
echo       [OK] Defender, pare-feu, UAC, mises a jour automatiques
call :LOG "OK" "Securite configuree"

:: ----------------------------------------------------------------
:: ETAPE 6 - Nettoyage
:: ----------------------------------------------------------------
echo  [6/7] Nettoyage disque...
for %%G in ("Temporary Files" "Recycle Bin" "Internet Cache Files" "Thumbnails" "Delivery Optimization Files") do (
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\%%~G" /v StateFlags0001 /t REG_DWORD /d 2 /f >nul 2>&1
)
cleanmgr /sagerun:1 >nul 2>&1
powershell -ExecutionPolicy Bypass -Command "Remove-Item -Path $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue" >nul 2>&1
del /s /f /q "%SystemRoot%\Temp\*.*" >nul 2>&1
powershell -ExecutionPolicy Bypass -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
echo       [OK] TEMP, corbeille, cache nettoyes
call :LOG "OK" "Nettoyage termine"

:: ----------------------------------------------------------------
:: ETAPE 7 - Optimisations
:: ----------------------------------------------------------------
echo  [7/7] Optimisations finales...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "%K_ADV%" /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 1 /f >nul 2>&1
echo       [OK] Effets visuels, Cortana, GameBar, demarrage rapide
call :LOG "OK" "Optimisations terminees"

:: ================================================================
:: RECAPITULATIF
:: ================================================================
cls
echo.
echo  ============================================================
echo    DEPLOIEMENT TERMINE  -  WinDeploy Pro v3.0
echo  ============================================================
echo.
echo   Poste     : %COMPUTERNAME%
echo   Operateur : %USERNAME%
echo   Fin       : %DATE% %TIME%
echo   Log       : %LOGFILE%
echo.
echo  ------------------------------------------------------------
echo   BILAN APPLICATIONS
echo  ------------------------------------------------------------
call :RECAP "Google Chrome"         INST_CHROME
call :RECAP "Mozilla Firefox"       INST_FIREFOX
call :RECAP "LibreOffice"           INST_LIBREOFFICE
call :RECAP "Adobe Acrobat Reader"  INST_ACROBAT
call :RECAP "VLC Media Player"      INST_VLC
call :RECAP "7-Zip"                 INST_7ZIP
call :RECAP "Notepad++"             INST_NOTEPADPP
call :RECAP "PDF24 Creator"         INST_PDF24
call :RECAP "WinSCP"                INST_WINSCP
call :RECAP "PuTTY"                 INST_PUTTY
call :RECAP "Malwarebytes"          INST_MALWAREBYTES
echo   [!]  uBlock Origin           (installation manuelle requise)
echo.
echo  ------------------------------------------------------------
echo   Appuyez sur une touche pour fermer...
echo  ------------------------------------------------------------
echo.
call :LOG "INFO" "=== FIN DEPLOIEMENT === %DATE% %TIME%"
pause >nul
exit /b 0

:: ================================================================
:: SOUS-ROUTINES
:: ================================================================

:INSTALL
set "_ANAME=%~1"
set "_AID=%~2"
echo       Installation : %_ANAME%...
winget install --id "%_AID%" -e --silent --accept-source-agreements --accept-package-agreements >nul 2>&1
if %errorlevel% equ 0 (
    echo       [OK]   %_ANAME%
    call :LOG "OK" "%_ANAME% installe"
) else (
    echo       [WARN] %_ANAME% : echec ou deja installe
    call :LOG "WARN" "%_ANAME% echec ou deja present"
)
goto :EOF

:TOGGLE
if "!%~1!"=="1" ( set "%~1=0" ) else ( set "%~1=1" )
goto :EOF

:AFF
set "_N=%~1"
set "_NOM=%~2"
set "_V=%~3"
if "!%_V%!"=="1" (
    echo   [O]  %_N%.  %_NOM%
) else (
    echo   [N]  %_N%.  %_NOM%
)
goto :EOF

:RECAP
set "_NOM=%~1"
set "_V=%~2"
if "!%_V%!"=="1" (
    echo   [OK] %-25s %_NOM%
) else (
    echo   [--] %_NOM% (ignoree)
)
goto :EOF

:LOG
echo [%DATE% %TIME%] [%~1] %~2 >> "%LOGFILE%"
goto :EOF