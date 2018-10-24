@echo off

:: Set working dir
cd %~dp0 & cd ..

if not exist %CERT_FILE% goto certificate

:: AIR output
if not exist %AIR_PATH% md %AIR_PATH%
set OUTPUT_BUNDLE=%AIR_PATH%\%AIR_NAME%.%VER_NUM%
set OUTPUT_FILE=%AIR_PATH%\%AIR_NAME%.%VER_NUM%.air

:: Package
echo.
echo Creating Packages %VER_NUM%...
echo Packaging %AIR_NAME%%AIR_TARGET%.air using certificate %CERT_FILE%...
call adt -package %OPTIONS% %SIGNING_OPTIONS% -target bundle %OUTPUT_BUNDLE% %APP_XML% %FILE_OR_DIR%
call adt -package %OPTIONS% %SIGNING_OPTIONS% -target air %OUTPUT_FILE% %APP_XML% %FILE_OR_DIR%
call bat\zipjs.bat zipItem -source %OUTPUT_BUNDLE% -destination %OUTPUT_BUNDLE%.Release.zip -keep yes -force yes

if errorlevel 1 goto failed
goto end

:certificate
echo.
echo Certificate not found: %CERT_FILE%
echo.
echo Troubleshooting: 
echo - generate a default certificate using 'bat\CreateCertificate.bat'
echo.
if %PAUSE_ERRORS%==1 pause
exit

:failed
echo AIR setup creation FAILED.
echo.
echo Troubleshooting: 
echo - verify AIR SDK target version in %APP_XML%
echo.
if %PAUSE_ERRORS%==1 pause
exit

:end
echo.
