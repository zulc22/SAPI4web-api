@prompt $g

:checkvcs
if NOT "%ProgramFiles(x86)%"=="" (
	set "ProgramFiles=%ProgramFiles(x86)%"
)

call :trycall "%ProgramFiles%\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars32.bat"

echo.Unable to find Visual Studio
pause
exit /b

:trycall
call "%~1"
@echo on
where cl && goto compile
exit /b

:compile
cl sapi4.cpp ole32.lib user32.lib /MT /LD -Ox -I"%ProgramFiles%\Microsoft Speech SDK\Include"
cl sapi4out.cpp ole32.lib user32.lib sapi4.lib /MT -Ox -I"%ProgramFiles%\Microsoft Speech SDK\Include"
cl sapi4limits.cpp ole32.lib user32.lib sapi4.lib /MT -Ox -I"%ProgramFiles%\Microsoft Speech SDK\Include"
copy sapi4.dll SAPI4_web\
copy sapi4out.exe SAPI4_web\
copy sapi4limits.exe SAPI4_web\
pause
exit