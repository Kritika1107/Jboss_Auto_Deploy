@echo off
setlocal EnableDelayedExpansion

:: Set variables
set JBOSS_HOME=C:\Rajan_Dubey\DevOps_Journey\Jboss\EAP-7.4.0
set DEPLOY_DIR=%JBOSS_HOME%\standalone\deployments
set BACKUP_DIR=%JBOSS_HOME%\backup
set JBOSS_CLI=%JBOSS_HOME%\bin\jboss-cli.bat

:: Step 1: Check if JBoss is running
echo Checking if JBoss is running...
tasklist /FI "IMAGENAME eq java.exe" | findstr /I "Console" > nul
if %ERRORLEVEL% neq 0 (
    echo JBoss is not running. Proceeding with deployment...
    set JBOSS_RUNNING=false
) else (
    echo JBoss is running. Stopping JBoss...
    "%JBOSS_CLI%" --connect "command=:shutdown"
    set JBOSS_RUNNING=true
    timeout /t 5 > nul
)

:: Step 2: Backup existing WAR file
if exist "%DEPLOY_DIR%\SampleWebApp.war" (
    echo Backing up existing WAR file...
    set datetime=%date:~10,4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
    if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
    move "%DEPLOY_DIR%\SampleWebApp.war" "%BACKUP_DIR%\app-backup-%datetime%.war"
) else (
    echo No existing WAR to back up.
)

:: Step 3: Deploy new WAR
echo Deploying new WAR file...
copy /Y app.war "%DEPLOY_DIR%"

:: Step 4: Restart JBoss only if it was running before
if !JBOSS_RUNNING! == true (
    echo Starting JBoss...
    start "" "%JBOSS_HOME%\bin\standalone.bat"
) else (
    echo JBoss was not running earlier. No need to start.
)

echo Deployment completed successfully!
exit 0
