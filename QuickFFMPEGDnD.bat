@ECHO OFF & SETLOCAL EnableDelayedExpansion
TITLE QuickFFMPEG to MP4
SET /A LastArg=0
FOR %%A in (%*) DO (
    IF NOT [%%A]==[] (
        SET /A LastArg+=1
        SET "INPUT!LastArg!="%%~A""
    )
)

REM Check if ffmpeg.exe is available
IF NOT EXIST "%~dp0ffmpeg.exe" (
    ECHO.ffmpeg.exe is not available at the script location.
    TIMEOUT /T 5 /NOBREAK >NUL
    EXIT /B 1
)

REM Check if program was not ran with drag and drop
IF !LastArg! EQU 0 (
    ECHO.This program cannot be called directly.
    TIMEOUT /T 5 /NOBREAK >NUL
    EXIT /B 42
)

ECHO.Provided !LastArg! files to process.

FOR /l %%A IN (1,1,!LastArg!) DO (
    TITLE Processing file %%A of !LastArg!
    ECHO.Input file: !INPUT%%A!
    SET "OUTPUT=!INPUT%%A:~0,-5!.mp4""
    ECHO.Output file: !OUTPUT!
    %~dp0ffmpeg.exe -i !INPUT%%A! -map 0 !OUTPUT!
    IF NOT !ERRORLEVEL! EQU 0 (
        SET "ERRMSG=!ERRMSG!     -!INPUT%%A!"
        ECHO. ---
        ECHO.ERROR: !ERRORLEVEL!
        ECHO.There was an error in the process of the conversion.
        TIMEOUT /T 2 /NOBREAK >NUL
    )
)
TITLE Processed !LastArg! files.
ECHO. ---
IF NOT DEFINED ERRMSG (
    ECHO.Conversion has finished.
    TIMEOUT /T 5 /NOBREAK >NUL
    PAUSE >NUL
    EXIT /B 0
) ELSE (
    ECHO.Conversion has finished, however there was an error with the following files:
    ECHO.!ERRMSG!
    TIMEOUT /T 5 /NOBREAK >NUL
    PAUSE >NUL
    EXIT /B 0
)

