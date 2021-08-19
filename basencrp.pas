// copyright (c) 2000 by microObjects inc.
//
// Emailmax source is distributed under the public
// domain license arrangements.  You are free to
// modify, edit, copy, delete, or redistribute
// the emailmax code as long as you 1) indemnify
// microObjects inc and its employees and owners
// from any and all liablity, directly or indirectly,
// related to the use, modification or distribution
// of this code 2) and make proper credit where
// applicable.
unit basencrp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  basepost, StdCtrls, Menus, ExtCtrls;

Type
   TEcnryptException = class(Exception);
   TBaseEncryption = class(TObject)

   private
       m_sDestinationFile,
       m_sSourceFile : String;

   public
       constructor Create;
       procedure Encrypt; virtual; abstract;
       procedure Decrypt; virtual; abstract;
   published
       property SourceFile : String read m_sSourceFile write m_sSourceFile;
       property DestinationFile : String read m_sDestinationFile;
   end;


implementation

constructor TBaseEncryption.Create;
begin
   inherited;
end;

end.
