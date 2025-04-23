@echo off
REM ==========================================================================
REM Universal Python Runner with Logging
REM Author: Washington Alto (with help from ChatGPT-4o)
REM Date: April 2025
REM ==========================================================================

REM --------------------------------
REM USAGE INSTRUCTION AND PARAMETERS
REM --------------------------------
REM run_python.bat script.py log_folder [arg1] [arg2] ... [--flags]
REM 
REM Examples:
REM   run_python.bat my_script.py log 
REM   run_python.bat my_script.py log input.txt output.txt
REM   run_python.bat my_script.py log --verbose --log-level=debug
REM
REM Optional Environment Variables:
REM   PYTHON_HOME      - Custom path to Python interpreter
REM   PYTHONPATH       - Add custom modules directory
REM   VIRTUAL_ENV      - Activate a virtual environment before running

REM -------------------------------
REM CONFIGURATION AND ENVIRONMENT
REM -------------------------------


REM Sets the encoding in stdin, stdout and stderr
SET PYTHONIOENCODING=utf-8


REM Optional: Set PYTHON_HOME if Python is not in PATH
IF NOT "%PYTHON_HOME%"=="" (
    SET PYTHON_EXEC=%PYTHON_HOME%\python.exe
) ELSE (
    SET PYTHON_EXEC=python
)

SET SCRIPT=%1
SET LOG_DIR=%2

IF "%SCRIPT%"=="" (
    ECHO ERROR: No Python script specified.
    ECHO Usage: run_python.bat script.py log_folder [script_args...]
    EXIT /B 1
)

IF "%LOG_DIR%"=="" (
    ECHO ERROR: No log folder specified.
    ECHO Usage: run_python.bat script.py log_folder [script_args...]
    EXIT /B 1
)

REM Shift parameters to forward the rest to Python
SHIFT
SHIFT

REM Create log folder if it doesn't exist
IF NOT EXIST "%LOG_DIR%" (
    MKDIR "%LOG_DIR%"
)

REM Get timestamp suffix
FOR /F "tokens=1-4 delims=/- " %%A IN ("%DATE%") DO (
    SET YYYY=%%D
    SET MM=%%B
    SET DD=%%C
)
FOR /F "tokens=1-2 delims=: " %%A IN ("%TIME%") DO (
    SET HH=%%A
    SET MIN=%%B
)
SET TIMESTAMP=%YYYY%%MM%%DD%_%HH%%MIN%

REM Construct log file path
SET SCRIPTNAME=%SCRIPT%
SET LOGFILE=%LOG_DIR%\%SCRIPTNAME%_%TIMESTAMP%.log

REM Log pre-run timestamp
ECHO === Starting script: %SCRIPT% === >> "%LOGFILE%"
ECHO Start Time: %DATE% %TIME% >> "%LOGFILE%"
ECHO. >> "%LOGFILE%"

REM Activate virtual environment if specified
IF NOT "%VIRTUAL_ENV%"=="" (
    CALL "%VIRTUAL_ENV%\Scripts\activate.bat"
)

ECHO Running: %PYTHON_EXEC% %SCRIPT% %* >> "%LOGFILE%" 
ECHO Running: %PYTHON_EXEC% %*

%PYTHON_EXEC% %SCRIPT% %* >> "%LOGFILE%" 2>&1

REM Log post-run timestamp
ECHO. >> "%LOGFILE%"
ECHO End Time: %DATE% %TIME% >> "%LOGFILE%"
ECHO === Script completed === >> "%LOGFILE%"
ECHO Run completed for  %PYTHON_EXEC% %*

EXIT /B %ERRORLEVEL%



