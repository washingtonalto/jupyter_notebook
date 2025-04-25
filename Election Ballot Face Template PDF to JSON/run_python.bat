@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
REM ==========================================================================
REM Universal Python Runner with Optional Logging
REM Author: Washington Alto (with help from ChatGPT-4o)
REM Last Updated: April 2025
REM ==========================================================================
REM DESCRIPTION:
REM   This batch script executes a Python script with optional logging.
REM   It handles script arguments, environment setups, and timestamped logs.
REM   It also supports virtual environment activation and custom Python paths.
REM --------------------------------------------------------------------------
REM USAGE:
REM   run_python.bat <script.py> [log_folder] [arg1] [arg2] ... [--flags]
REM
REM EXAMPLES:
REM   run_python.bat my_script.py
REM   run_python.bat my_script.py logs
REM   run_python.bat my_script.py logs input.txt output.txt --debug
REM
REM OPTIONAL ENVIRONMENT VARIABLES:
REM   PYTHON_HOME   - Path to a custom Python interpreter (e.g., C:\Python39)
REM   VIRTUAL_ENV   - Path to virtual environment directory (e.g., .venv)
REM ==========================================================================


REM --------------------------------------------------------------------------
REM Step 1: Configure Encoding
REM --------------------------------------------------------------------------
SET "PYTHONIOENCODING=utf-8"  REM Ensure UTF-8 encoding in Python I/O


REM --------------------------------------------------------------------------
REM Step 2: Determine Python Executable
REM --------------------------------------------------------------------------
IF NOT "%PYTHON_HOME%"=="" (
    SET "PYTHON_EXEC=%PYTHON_HOME%\python.exe"
) ELSE (
    SET "PYTHON_EXEC=python"
)


REM --------------------------------------------------------------------------
REM Step 3: Get Script Path
REM --------------------------------------------------------------------------
SET "SCRIPT=%~1"

REM --------------------------------------------------------------------------
REM Step 4: Check if Log Folder is Provided
REM --------------------------------------------------------------------------
REM If no log folder argument is given, just run the Python script directly
IF "%~2"=="" (
    IF "%SCRIPT%"=="" (
        ECHO ERROR: No Python script specified.
        ECHO Usage: run_python.bat script.py [log_folder] [script_args...]
        EXIT /B 1
    )

    ECHO Running without logging: %PYTHON_EXEC% %*
    %PYTHON_EXEC% %*
    ECHO Run completed for: %PYTHON_EXEC% %*
    ENDLOCAL
    EXIT /B 0
)


REM --------------------------------------------------------------------------
REM Step 5: Prepare for Logging
REM --------------------------------------------------------------------------
SET "LOG_DIR=%~2"

REM Shift first two arguments (script path and log folder) off the argument list
SHIFT
SHIFT

REM Create the log folder if it does not exist
IF NOT EXIST "%LOG_DIR%" (
    MKDIR "%LOG_DIR%"
)


REM --------------------------------------------------------------------------
REM Step 6: Generate Timestamp (Format: YYYYMMDD_HHMM)
REM --------------------------------------------------------------------------
FOR /F "tokens=1-4 delims=/- " %%A IN ("%DATE%") DO (
    SET "YYYY=%%D"
    SET "MM=%%B"
    SET "DD=%%C"
)
FOR /F "tokens=1-2 delims=:." %%A IN ("%TIME%") DO (
    SET "HH=%%A"
    SET "MIN=%%B"
)
SET "TIMESTAMP=%YYYY%%MM%%DD%_%HH%%MIN%"


REM --------------------------------------------------------------------------
REM Step 7: Get Script Base Name (without extension or path)
REM --------------------------------------------------------------------------
FOR %%F IN ("%SCRIPT%") DO (
    SET "SCRIPT_BASENAME=%%~nF"
)

REM Construct full log file path
SET "LOGFILE=%LOG_DIR%\%SCRIPT_BASENAME%_%TIMESTAMP%.log"


REM --------------------------------------------------------------------------
REM Step 8: Log Start Time and Metadata
REM --------------------------------------------------------------------------
ECHO === Starting script: %SCRIPT% === >> "%LOGFILE%"
ECHO Start Time: %DATE% %TIME% >> "%LOGFILE%"
ECHO Arguments: %* >> "%LOGFILE%"
ECHO. >> "%LOGFILE%"


REM --------------------------------------------------------------------------
REM Step 9: Activate Virtual Environment (if defined)
REM --------------------------------------------------------------------------
IF NOT "%VIRTUAL_ENV%"=="" (
    CALL "%VIRTUAL_ENV%\Scripts\activate.bat"
)


REM --------------------------------------------------------------------------
REM Step 10: Run Python Script with Logging
REM --------------------------------------------------------------------------
ECHO Running: %PYTHON_EXEC% %SCRIPT% %* >> "%LOGFILE%"
ECHO Running: %PYTHON_EXEC% %SCRIPT% %*
%PYTHON_EXEC% %SCRIPT% %* >> "%LOGFILE%" 2>&1


REM --------------------------------------------------------------------------
REM Step 11: Log End Time
REM --------------------------------------------------------------------------
ECHO. >> "%LOGFILE%"
ECHO End Time: %DATE% %TIME% >> "%LOGFILE%"
ECHO === Script completed === >> "%LOGFILE%"
ECHO Run completed for: %PYTHON_EXEC% %SCRIPT% %*


ENDLOCAL
EXIT /B 0
