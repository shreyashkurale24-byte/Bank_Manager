; ============================================================================
;  BANK MANAGER PRO — INTERNAL DEV / TEST INSTALLER
;  Inno Setup Script
;
;  Scope: internal development & QA testing only.
;  This installer is intentionally NOT branded as a customer-facing product.
;  Do not rebrand or redistribute this build externally without a security
;  review (auth, access control, audit logging) of app.py first.
; ============================================================================

#define MyAppName "Bank Manager Pro [DEV-TEST BUILD]"
#define MyAppVersion "0.8.0-dev"
#define MyAppPublisher "Internal Engineering - Not for External Distribution"
#define MyAppExeName "BankManagerPro_DEV.exe"

[Setup]
AppId={{8F3C2A41-9B7D-4E2F-AE6C-DEV0BANK0V8}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\BankManagerPro-DEV
DefaultGroupName=Bank Manager Pro (DEV)
DisableProgramGroupPage=yes
OutputDir=output
OutputBaseFilename=BankManagerPro_DEV_Setup_v0.8
SetupIconFile=assets\icon.ico
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayIcon={app}\{#MyAppExeName}
UninstallDisplayName={#MyAppName}
; Watermark every wizard page so this never gets mistaken for a finished product
WizardSmallImageFile=assets\icon.bmp

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Additional icons:"

[Files]
Source: "dist\BankManagerPro_DEV.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "README_DEV_BUILD.txt"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\Bank Manager Pro (DEV-TEST)"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\Read Me - Internal Use Only"; Filename: "{app}\README_DEV_BUILD.txt"
Name: "{group}\Uninstall Bank Manager Pro (DEV)"; Filename: "{uninstallexe}"
Name: "{commondesktop}\Bank Manager Pro (DEV-TEST)"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\README_DEV_BUILD.txt"; Description: "View internal-use notice"; Flags: postinstall shellexec skipifsilent
Filename: "{app}\{#MyAppExeName}"; Description: "Launch Bank Manager Pro (DEV-TEST)"; Flags: nowait postinstall skipifsilent unchecked

[Code]
function InitializeSetup(): Boolean;
begin
  Result := (MsgBox(
    'BANK MANAGER PRO — INTERNAL DEV / TEST BUILD' + #13#10 + #13#10 +
    'This installer is for INTERNAL development and QA testing only.' + #13#10 + #13#10 +
    'This build has NOT been reviewed for:' + #13#10 +
    '  - Authentication / access control' + #13#10 +
    '  - Audit logging of changes' + #13#10 +
    '  - Production data safety' + #13#10 + #13#10 +
    'It provides direct create/edit/delete access to all banking tables ' +
    '(ATM cards, cheque issuance, cash balances, limits, etc.) with no ' +
    'restrictions. Do NOT install on customer-facing or production systems, ' +
    'and do NOT point it at real customer data.' + #13#10 + #13#10 +
    'Continue installing this internal test build?',
    mbConfirmation, MB_YESNO) = IDYES);
end;
