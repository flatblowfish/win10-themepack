@echo off
for %%i in (*.themepack) do (
	echo install "%%i"
    "%%i"
	choice /t 1 /d y /n >nul
)
pause
