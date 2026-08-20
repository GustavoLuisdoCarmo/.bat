@echo off
setlocal EnableExtensions
title Configurador de PC - TI
color 05



REM ------------------------------------------
set "ORIGEM=%~dp0padrao usuario"
set "DESTINO=C:\padrao usuario\padrao usuario"
set "ORIGEM_bat=%~dp0"
REM ------------------------------------------



:MENU
cls
echo ==========================================
echo       CONFIGURADOR DE PC do gustavo
echo ==========================================
echo.
echo  [1] Ativar Administrador
echo  [2] finalizar o adm
echo  [3] Conectar Wifi
echo  [4] Instalar Programas
echo  [6] copiar programas
echo  [5] Sair
echo  [99] editar .bat
echo.
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto ADMIN
if "%opcao%"=="2" goto final
if "%opcao%"=="3" goto WIFI
if "%opcao%"=="4" goto PROGRAMAS
if "%opcao%"=="5" exit
if "%opcao%"=="6" goto COPIAR
if "%opcao%"=="99" goto BAT
echo.
echo Opcao invalida.
pause
goto MENU

:BAT
notepad d:\s.bat
pause
goto MENU


:COPIAR
cls
echo ==========================================
echo       COPIANDO PROGRAMAS PARA C:
echo ==========================================
echo.

if not exist "%ORIGEM%" (
    echo [ERRO] Pasta programas nao encontrada no pendrive.
    pause
    goto MENU
)

if not exist "C:\padrao usuario" mkdir "C:\padrao usuario"
if not exist "%DESTINO%" mkdir "%DESTINO%"

echo Copiando arquivos...
echo.

xcopy "%ORIGEM_bat%\*" "C:\padrao usuario\" /E /I /Y

if %errorlevel% LEQ 1 (
    echo.
    echo [OK] Programas copiados para:
    echo %DESTINO%
) else (
    echo.
    echo [ERRO] Falha ao copiar os programas.
)

ren "C:\padrao usuario\s.bat" "setup.bat"

powershell -Command "$s = (New-Object -ComObject WScript.Shell).CreateShortcut('C:\Users\Administrador\Desktop\setup.lnk'); $s.TargetPath = 'C:\padrao usuario\setup.bat'; $s.Save()"
start "" "C:padrao usuario\setup.bat"

if %errorlevel% LEQ 1 (
    echo.
    echo [OK] tudo certo, saindo
    exit
) else (
    echo.
    echo [ERRO] Falha ao copiar os programas.
)

echo.
pause
goto MENU



:WIFI
cls

echo ==========================================
echo          CONECTAR AO WIFI
echo ==========================================

echo Conectando ao Wi-Fi...

netsh wlan add profile filename="%~dp0wifi.xml" user=all
netsh wlan connect name="Wifi-Blue"

echo.
echo Verificando conexao...
netsh wlan show interfaces

pause
goto MENU








:final
cls

echo =========================================
echo        FINALIZANDO USUARIOS WINDOWS
echo =========================================

net user administrador "elev@&str@5"
net user temp /delete

if %errorlevel%==0 (
    echo [OK] Finalizado.

) else (
    echo [ERRO] Nao foi possivel finalizar.
)

pause
goto MENU












:ADMIN
cls
echo ==========================================
echo          ATIVANDO ADMINISTRADOR
echo ==========================================
echo.

net user Administrador /active:yes
net user Administrador "elev@&str@5"
start ms-cxh:localonly

if %errorlevel%==0 (
    echo [OK] Administrador ativado.
) else (
    echo [ERRO] Nao foi possivel ativar o Administrador.
)

echo.
pause
goto MENU









:PROGRAMAS

cls
echo ==========================================
echo          INSTALANDO PROGRAMAS
echo ==========================================
echo.

if not exist "%DESTINO%" (
    echo [ERRO] Os programas ainda nao foram copiados.
    echo Use a opcao 2 primeiro.
    echo.
    pause
    goto MENU
)

echo.
echo [1/5] Office...
if exist "%DESTINO%\OfficeSetup.exe" (
    start "" "%DESTINO%\OfficeSetup.exe"
    echo [OK]
) else (
    echo [NAO ENCONTRADO]
)

echo.
echo [2/5] Chrome...
if exist "%DESTINO%\ChromeSetup.exe" (
    start "" "%DESTINO%\ChromeSetup.exe"
    echo [OK]
) else (
    echo [NAO ENCONTRADO]
)

echo.
echo [3/5] TeamViewer...
if exist "%DESTINO%\TeamViewerCerto.exe" (
    start "" "%DESTINO%\TeamViewerCerto.exe"
    echo [OK]
) else (
    echo [NAO ENCONTRADO]
)

echo [4/5] AnyDesk...
if exist "%DESTINO%\AnyDesk.exe" (
    start /wait "" "%DESTINO%\AnyDesk.exe"
    echo [OK]
) else (
    echo [NAO ENCONTRADO]
)

echo.
echo [5/5] EPI Win...
if exist "%DESTINO%\epi_win_live_installer.exe" (
    start "" "%DESTINO%\epi_win_live_installer.exe"
    echo [OK]
) else (
    echo [NAO ENCONTRADO]
)

echo.
echo ==========================================
echo       INSTALACAO FINALIZADA
echo ==========================================
echo.
pause
goto MENU