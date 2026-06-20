# 다운로드 기능을 위한 INetC 플러그인 매크로 포함
# (만약 컴파일 에러가 나면 NSIS용 INetC 플러그인을 설치해야 합니다)
!include "LogicLib.nsh"

Section "Install"

    # 1. 다운로드 창 상태 표시 변경
    SetDetailsPrint both
    DetailPrint "개발 도구 최신 버전 다운로드 중..."

    # -----------------------------------------------------------------
    # 파일 다운로드 (INetC 플러그인 사용)
    # 문법: inetc::get "URL" "저장할_로컬_경로"
    # -----------------------------------------------------------------
    
    # 1) .NET 9.0 Desktop Runtime
    DetailPrint ".NET 런타임 다운로드 중..."
    inetc::get "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.301/dotnet-sdk-10.0.301-win-x64.exe" "$PLUGINSDIR\dotnet_latest.exe"
    Pop $0
    ${If} $0 != "OK"
        MessageBox MB_OK|MB_ICONSTOP "Dotnet 다운로드 실패: $0"
        Abort
    ${EndIf}

    # 2) VS Code Installer
    DetailPrint "VS Code 다운로드 중..."
    inetc::get "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user" "$PLUGINSDIR\vscode_latest.exe"
    Pop $0
    ${If} $0 != "OK"
        MessageBox MB_OK|MB_ICONSTOP "VS Code 다운로드 실패: $0"
        Abort
    ${EndIf}

    # 3) Git for Windows
    DetailPrint "Git for Windows 다운로드 중..."
    inetc::get "https://github.com/git-for-windows/git/releases/download/v2.49.0.windows.1/Git-2.49.0-64-bit.exe" "$PLUGINSDIR\git_latest.exe"
    Pop $0
    ${If} $0 != "OK"
        MessageBox MB_OK|MB_ICONSTOP "Git 다운로드 실패: $0"
        Abort
    ${EndIf}
