@echo off
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync_planilha.ps1"
echo.
echo Pressione qualquer tecla para fechar esta janela...
pause >nul
