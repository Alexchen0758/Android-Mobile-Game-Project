@ECHO OFF

REM (Universal) Unreal Project Clean-up batch script
REM Written by Nelson Su 2016/12/29

REM You can set the project's name here or let the script get it automatically by
REM scanning from the Unreal's ".uproject" file and using it.
SET ProjectName=

CD "%~DP0"

IF [%ProjectName%] == [] GOTO :GET_PROJECT_NAME
GOTO :CLEAN_PROJECT

:GET_PROJECT_NAME
FOR /F %%I IN ('DIR "%~DP0*.uproject" /B 2^>NUL') DO SET "ProjectName=%%~nI"
IF [%ProjectName%] == [] GOTO :ERROR_NO_PROJECT_NAME
GOTO :CLEAN_PROJECT

:CLEAN_PROJECT
REM The "Binaries" & "Intermediate" folder of the project
ECHO Cleaning up the [%ProjectName%] project's "Binaries" folder ...
RMDIR /S /Q "%~DP0Binaries" 1>NUL 2>NUL
ECHO Cleaning up the [%ProjectName%] project's "Intermediate" folder ...
RMDIR /S /Q "%~DP0Intermediate" 1>NUL 2>NUL

:CLEAN_PLUGIN
REM The "Binaries" & "Intermediate" folder of the project's plugin(s)
PUSHD "%~DP0Plugins" 2>NUL && POPD
IF NOT ERRORLEVEL 1 (GOTO :CLEAN_PLUGIN_CONTINUE) ELSE (GOTO :CLEAN_VS)
:CLEAN_PLUGIN_CONTINUE
ECHO Cleaning up the [Plugins] "Binaries" folder(s) ...
FOR /F %%I IN ('DIR "%~DP0Plugins" /A:D /B 2^>NUL') DO (RMDIR /S /Q "%~DP0Plugins\%%I\Binaries" 1>NUL 2>NUL)
ECHO Cleaning up the [Plugins] "Intermediate" folder(s) ...
FOR /F %%I IN ('DIR "%~DP0Plugins" /A:D /B 2^>NUL') DO (RMDIR /S /Q "%~DP0Plugins\%%I\Intermediate" 1>NUL 2>NUL)

:CLEAN_VS
REM Microsoft Visual Studio's files
ECHO Cleaning up the Visual Studio files ...
RMDIR /S /Q "%~DP0.vs" 1>NUL 2>NUL
DEL /Q "%~DP0%ProjectName%.sdf" 1>NUL 2>NUL
DEL /Q "%~DP0%ProjectName%.sln" 1>NUL 2>NUL
DEL /Q "%~DP0%ProjectName%.VC.db" 1>NUL 2>NUL
DEL /Q "%~DP0%ProjectName%.VC.VC.opendb" 1>NUL 2>NUL

:CLEAN_BUILD_WINNOEDITOR
REM The "Build\WindowsNoEditor" folder of the project
PUSHD "%~DP0Build\WindowsNoEditor" 2>NUL && POPD
IF NOT ERRORLEVEL 1 (GOTO :CLEAN_BUILD_WINNOEDITOR_CONTINUE) ELSE (GOTO :CLEAN_SAVED)
:CLEAN_BUILD_WINNOEDITOR_CONTINUE
SET CleanBuildWinNoEditorDir=
SET /P CleanBuildWinNoEditorDir=Do you want to clean the "Build\WindowsNoEditor" directory ? [Y/N(default)]:
IF "%CleanBuildWinNoEditorDir%" EQU "y" GOTO :PROCESS_CLEAN_BUILD_WINNOEDITOR
IF "%CleanBuildWinNoEditorDir%" EQU "Y" GOTO :PROCESS_CLEAN_BUILD_WINNOEDITOR
GOTO :CLEAN_SAVED
:PROCESS_CLEAN_BUILD_WINNOEDITOR
ECHO Cleaning up the [%ProjectName%] project's "Build\WindowsNoEditor" folder ...
RMDIR /S /Q "%~DP0Build\WindowsNoEditor" 1>NUL 2>NUL

:CLEAN_SAVED
REM The "Saved" folder of the project
PUSHD "%~DP0Saved" 2>NUL && POPD
IF NOT ERRORLEVEL 1 (GOTO :CLEAN_SAVED_CONTINUE) ELSE (GOTO :CLEAN_CONTENT_COLLECTIONS)
:CLEAN_SAVED_CONTINUE
SET CleanSavedDir=
SET /P CleanSavedDir=Do you want to clean the "Saved" directory ? [Y/N(default)]:
IF "%CleanSavedDir%" EQU "y" GOTO :PROCESS_CLEAN_SAVED
IF "%CleanSavedDir%" EQU "Y" GOTO :PROCESS_CLEAN_SAVED
GOTO :CLEAN_CONTENT_COLLECTIONS
:PROCESS_CLEAN_SAVED
ECHO Cleaning up the [%ProjectName%] project's "Saved" folder ...
RMDIR /S /Q "%~DP0Saved" 1>NUL 2>NUL

:CLEAN_CONTENT_COLLECTIONS
REM The "Collections" folder of the project
PUSHD "%~DP0Content\Collections" 2>NUL && POPD
IF NOT ERRORLEVEL 1 (GOTO :CLEAN_CONTENT_COLLECTIONS_CONTINUE) ELSE (GOTO :CLEAN_CONTENT_DEVELOPERS)
:CLEAN_CONTENT_COLLECTIONS_CONTINUE
SET CleanContentCollectionsDir=
SET /P CleanContentCollectionsDir=Do you want to clean the "Collections" directory ? [Y/N(default)]:
IF "%CleanContentCollectionsDir%" EQU "y" GOTO :PROCESS_CLEAN_CONTENT_COLLECTIONS
IF "%CleanContentCollectionsDir%" EQU "Y" GOTO :PROCESS_CLEAN_CONTENT_COLLECTIONS
GOTO :CLEAN_CONTENT_DEVELOPERS
:PROCESS_CLEAN_CONTENT_COLLECTIONS
ECHO Cleaning up the [%ProjectName%] project's "Collections" folder ...
RMDIR /S /Q "%~DP0Content\Collections" 1>NUL 2>NUL

:CLEAN_CONTENT_DEVELOPERS
REM The "Developers" folder of the project
PUSHD "%~DP0Content\Developers" 2>NUL && POPD
IF NOT ERRORLEVEL 1 (GOTO :CLEAN_CONTENT_DEVELOPERS_CONTINUE) ELSE (GOTO :CLEAN_END)
:CLEAN_CONTENT_DEVELOPERS_CONTINUE
SET CleanContentDevelopersDir=
SET /P CleanContentDevelopersDir=Do you want to clean the "Developers" directory ? [Y/N(default)]:
IF "%CleanContentDevelopersDir%" EQU "y" GOTO :PROCESS_CLEAN_CONTENT_DEVELOPERS
IF "%CleanContentDevelopersDir%" EQU "Y" GOTO :PROCESS_CLEAN_CONTENT_DEVELOPERS
GOTO :CLEAN_END
:PROCESS_CLEAN_CONTENT_DEVELOPERS
ECHO Cleaning up the [%ProjectName%] project's "Developers" folder ...
RMDIR /S /Q "%~DP0Content\Developers" 1>NUL 2>NUL

:CLEAN_END
PAUSE
GOTO :END

:ERROR_NO_PROJECT_NAME
ECHO ERROR: `ProjectName` is not set or cannot be got automatically !
GOTO :END

:END
