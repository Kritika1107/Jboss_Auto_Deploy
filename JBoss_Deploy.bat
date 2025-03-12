@echo off
set JBOSS_HOME=C:\Rajan_Dubey\DevOps_Journey\Jboss\EAP-7.4.0
set DEPLOY_DIR=%JBOSS_HOME%\standalone\deployments
set BACKUP_DIR=%JBOSS_HOME%\backup
set JBOSS_CLI=%JBOSS_HOME%\bin\jboss-cli.bat

:: Step 1: Shutdown JBoss gracefully
echo Shutting down JBoss...
"%JBOSS_CLI%" --connect command=:shutdown

:: Step 2: Backup existing WAR file
if exist "%DEPLOY_DIR%\SampleWebApp.war" (
    echo Backing up existing WAR file...
    set datetime=%date:~10,4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
    if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
    move "%DEPLOY_DIR%\app.war" "%BACKUP_DIR%\app-backup-%datetime%.war"
) else (
    echo No existing WAR to back up.
)

:: Step 3: Deploy new WAR
echo Deploying new WAR file...
copy /Y app.war "%DEPLOY_DIR%"

:: Step 4: Start JBoss
echo Starting JBoss...
start "" "%JBOSS_HOME%\bin\standalone.bat"

echo Deployment completed.