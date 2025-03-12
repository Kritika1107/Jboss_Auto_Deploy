@echo off
setlocal EnableDelayedExpansion

:: Set variables
set JBOSS_HOME=C:\Rajan_Dubey\DevOps_Journey\Jboss\EAP-7.4.0
set DEPLOY_DIR=%JBOSS_HOME%\standalone\deployments
set BACKUP_DIR=%JBOSS_HOME%\backup
set JBOSS_CLI=%JBOSS_HOME%\bin\jboss-cli.bat
set WAR_FILE=SampleWebApp.war

:: Step 1: Backup existing WAR file
if exist "%DEPLOY_DIR%\%WAR_FILE%" (
    echo Backing up existing WAR file...
    set datetime=%date:~10,4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
    if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
    move "%DEPLOY_DIR%\%WAR_FILE%" "%BACKUP_DIR%\app-backup-%datetime%.war"
    echo Backup completed.
) else (
    echo No existing WAR to back up.
)

:: Step 2: Deploy new WAR
echo Deploying new WAR file...
copy /Y "%WAR_FILE%" "%DEPLOY_DIR%"
if %ERRORLEVEL% neq 0 (
    echo Deployment failed! Exiting...
    exit /b 1
)
echo Deployment completed.

:: Step 3: Reload JBoss
echo Reloading JBoss...
"%JBOSS_CLI%" --connect "command=:reload"
if %ERRORLEVEL% neq 0 (
    echo Failed to reload JBoss! Exiting...
    exit /b 1
)

:: Step 4: Wait for 15 seconds to ensure JBoss is up
echo Waiting for JBoss to start...
ping 127.0.0.1 -n 16 > nul

echo JBoss restarted and deployment completed successfully!
exit 0
