// copyright (c) 2002 by microObjects inc.
//
// Emailmax source is distributed under the public
// domain license arrangements.  You are free to
// modify, edit, copy, delete, or redistribute
// the emailmax code as long as you 1) indemnify and hold harmless
// microObjects inc and its employees and owners
// from any and all liablity, directly or indirectly,
// related to the use, modification or distribution
// of this code 2) and make proper credit where
// applicable.
library emailex;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  mainwiz in 'mainwiz.pas' {dlgWizard},
  basepane in 'basepane.pas' {wndBasePane},
  panesend in 'panesend.pas' {wndSendEmail},
  panerecv in 'panerecv.pas' {wndReceivePane},
  paneconf in 'paneconf.pas' {wndConfirm},
  global in 'global.pas',
  why in 'why.pas' {dlgWhy},
  encryption in '..\objects\encryption.pas',
  edirectory in '..\objects\edirectory.pas';

exports
   ShowSetupWizard index 1,
   ShowSetupWizardNoParent index 2,
   SetApplicationTitle index 3,
   InstallCreateDirs index 4,
   WizardVersionStr index 5;

{$R *.res}

begin
   g_oSytemFile := Nil;
   g_sApplicationTitle := 'Emailmax Setup Wizard' + GetDllVerInfo();
end.
