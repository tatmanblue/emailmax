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
unit helpengine;

interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ToolWin, ComCtrls, OleCtnrs, ExtCtrls, StdCtrls;


{
   These constants must match values in the help include file
   'helpids.h' found in the help subfolder.   Its these ids that
   are used to access the help file in the correct place.
}
const KEY_CONTENTS                        = 1000;
const KEY_GETSTARTED                      = 1001;

const KEY_ABOUT_MICROOBJECTS              = 1010;
const KEY_GETTING_SUPPORT                 = 1011;
const KEY_HISTORY                         = 1012;
const KEY_WHY_EMAILMAX                    = 1013;
const KEY_ADDITIONAL_FEATURES             = 1014;
const KEY_WHATS_NEW                       = 1015;
const KEY_BUG_REPORT                      = 1016;
const KEY_APPLICATION_STABILITY           = 1017;

const KEY_EMAIL_ADDRESS                   = 1100;
const KEY_EULA                            = 1101;
const KEY_FAQ                             = 1102;
const KEY_STYLE_CONVENTIONS               = 1103;
const KEY_STYLE_CONVENTIONS_POPUP         = 1104;
const KEY_FOLDER_HOTKEYS                  = 1105;
const KEY_GLOBAL_HOTKEYS                  = 1106;
const KEY_WHY_POPDIFF                     = 1107;
const KEY_WHY_SMTPDIFF                    = 1108;

const KEY_FOLDERS                         = 2000;
const KEY_FOLDER_PREVIEW                  = 2001;
const KEY_MAIN_QUICKBAR                   = 2002;
const KEY_MAIN_SCREEN                     = 2003;
const KEY_TOOLBAR                         = 2004;
const KEY_PRINTING                        = 2005;
const KEY_PRINTING_SETUP                  = 2006;

const KEY_SPAMINATOR                      = 2100;
const KEY_SPAMINATOR_ERROR                = 2101;

const KEY_SETUP_MAIN                      = 3000;
const KEY_SETUP_RECEIVING                 = 3010;
const KEY_SETUP_RECEIVING_DLG             = 3011;
const KEY_SETUP_SENDING                   = 3020;
const KEY_SETUP_SENDING_DLG               = 3021;
const KEY_SETUP_PREFERENCES               = 3030;

const KEY_CREATE_EMAIL                    = 4000;
const KEY_CREATE_EMAIL_EDITOR             = 4001;
const KEY_CREATE_EMAIL_ERROR              = 4002;
const KEY_ATTACHMENTS                     = 4003;
const KEY_ATTACHMENTS_ADD                 = 4004;
const KEY_ATTACHMENTS_READ                = 4005;
const KEY_ATTACHMENTS_OPTIONS             = 4006;
const KEY_ATTACHMENTS_LIST                = 4007;
const KEY_EXPORT_MESSAGE                  = 4008;

const KEY_ADDRESS_BOOK                    = 4100;
const KEY_ADDRESS_BOOK_SELECTOR           = 4101;
const KEY_ADDRESS_BOOK_EDIT               = 4102;
const KEY_ADDRESS_BOOK_EDIT_GENERAL       = 4103;
const KEY_ADDRESS_BOOK_EDIT_ADDRESS       = 4104;
const KEY_ADDRESS_BOOK_EDIT_MORE          = 4105;
const KEY_ADDRESS_BOOK_EDIT_CONFIRM       = 4106;
const KEY_ADDRESS_BOOK_MDI                = 4200;

const KEY_EMAIL_RECEIVE                   = 5000;
const KEY_SENDING_EMAIL                   = 5001;
const KEY_ERRORS_RECEIVE                  = 5010;
const KEY_ERRORS_RECEIVE_AUTH             = 5011;
const KEY_ERRORS_SEND                     = 5020;

const KEY_ENCRYPTION                      = 6000;
const KEY_ENCRYPTION_CAESAR               = 6001;
const KEY_ENCRYPTION_MD5                  = 6002;
const KEY_ENCRYPTION_PGP                  = 6003;
const KEY_ENCRYPTION_PGP_WHERE            = 6004;

type
   THelpEngine = class(TObject)
   protected
       m_hParentWnd : HWND;
       m_nHelpId : Integer;

   public
       constructor Create;
       procedure Reset;
       procedure Show;
   published
       property HelpId : Integer read m_nHelpId write m_nHelpId default KEY_CONTENTS;
       property ParentWnd : HWND read m_hParentWnd write m_hParentWnd;
   end;

implementation

uses
   eglobal, edirectory;

constructor THelpEngine.Create;
begin
   inherited;
   Reset;
end;

procedure THelpEngine.Reset;
begin
   m_nHelpId := KEY_CONTENTS;
end;

procedure THelpEngine.Show;
var
   nCommand : Integer;
   helpFileName : String;
begin
   if KEY_CONTENTS = HelpId then
       nCommand := HELP_CONTENTS
   else
       nCommand := HELP_CONTEXT;

   helpFileName := g_oDirectories.ProgramPath + 'emailmax.hlp';
   WinHelp(ParentWnd, PChar(helpFileName), nCommand, HelpId);
end;

end.
