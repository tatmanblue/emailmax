// copyright (c) 2000 by microObjects inc.
//
// Emailmax source is distributed under the public
// domain license arrangements.  You are free to
// modify, edit, copy, delete, or redistribute
// the emailmax code as long as you 1) indemnify amd
// hold harmless microObjects inc and its employees and
// owners from any and all liablity, directly or indirectly,
// related to the use, modification or distribution
// of this code 2) and make proper credit where
// applicable.

unit emailmaxhelpagent;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, OleCtrls, isp3, marsCap, registry; //, AgentObjects_TLB;

type
   TAgentCharacter = (acGenie, acMerlin, acRobby, acPeedy, acMax);
{   TAgentCharacterId = 'Geneie', 'Merlin', 'Robby','Peely','Max');
   TAgentCharacterFile = ('Geneie.acs', 'Merlin.acs', 'Robby.acs','Peely.acs','Max.acs'); }
   TEmailmaxAgent = class(TComponent)

   protected
       m_sCharacterId : String;
       // m_ctlAgent : TAgent;
       m_ctlAgent : TComponent;
       m_oSpeechList : TStringList;
       m_nAgentType : TAgentCharacter;
       m_nTimerId : Integer;

       function GetCharacterId : String;
       function GetCharacterFile : String;

   public
       constructor Create(oParent : TComponent); override;
       destructor Destroy; override;

       procedure StartTimer;
       procedure StopTimer;
       procedure AddSpeech(sItem : String);
       procedure SetShowState(bSet : Boolean);
       procedure SetAgentType(nType : TAgentCharacter);
       procedure TalkOneLine;

   published
       property AgentType : TAgentCharacter read m_nAgentType write SetAgentType default acPeedy;
       property SpeechList : TStringList read m_oSpeechList write m_oSpeechList;
       property Show : Boolean write SetShowState;
       property CharacterId : String read GetCharacterId;
       property CharacterFile : String read GetCharacterFile;
   end;

implementation

var
   u_oSpeechList : TStringList;
   u_oAgentObj : TEmailmaxAgent;

procedure AgentSpeechTimer(hWin : HWND; uMsg : UINT; uId : UINT; dwTime : DWORD);
begin
{   u_oAgentObj.StopTimer;

   if u_oAgentObj.m_oSpeechList.Count > 0 then
   begin
       u_oAgentObj.TalkOneLine;
       u_oAgentObj.StartTimer;
   end;
}
end;

constructor TEmailmaxAgent.Create(oParent : TComponent);
begin
   inherited;
   // m_ctlAgent := TAgent.Create(oParent);
   m_ctlAgent := nil;
   u_oSpeechList := TStringList.Create;
   m_oSpeechList := u_oSpeechList;
   u_oAgentObj := Self;
   m_nTimerId := -1;
   m_sCharacterId := 'Peedy';
end;

destructor TEmailmaxAgent.Destroy;
begin
   StopTimer;
   u_oSpeechList.free;
   m_ctlAgent.Free;
   inherited;
end;

procedure TEmailmaxAgent.StartTimer;
begin
//   if m_nTimerId = -1 then
//       m_nTimerId := SetTimer(0, 0, 1000, @AgentSpeechTimer);
end;

procedure TEmailmaxAgent.StopTimer;
begin
//   if m_nTimerId <> -1 then
//      KillTimer(0, m_nTimerId);

//   m_nTimerId := -1;
end;

procedure TEmailmaxAgent.AddSpeech(sItem : String);
begin
//   m_oSpeechList.Add(sItem);
//   if m_nTimerId = -1 then
//       StartTimer;
end;

function TEmailmaxAgent.GetCharacterId : String;
var
   sRet : String;
begin
   case m_nAgentType of
       acGenie:  sRet := 'Genie';
       acMerlin: sRet := 'Merlin';
       acRobby:  sRet := 'Robby';
       acPeedy:  sRet := 'Peedy';
       acMax:    sRet := 'Max';
   end;

   GetCharacterId := sRet;

end;

function TEmailmaxAgent.GetCharacterFile : String;
var
   sRet : String;
begin
   case m_nAgentType of
       acGenie:  sRet := 'Genie.acs';
       acMerlin: sRet := 'Merlin.acs';
       acRobby:  sRet := 'Robby.acs';
       acPeedy:  sRet := 'Peedy.acs';
       acMax:    sRet := 'Max.acs';
   end;

   GetCharacterFile := sRet;
end;

procedure TEmailmaxAgent.SetShowState(bSet : Boolean);
begin
{
   if bSet = TRUE then
       m_ctlAgent.Characters.Character(CharacterId).Show(0)
   else
       m_ctlAgent.Characters.Character(CharacterId).Hide(0);
}
end;

procedure TEmailmaxAgent.SetAgentType(nType : TAgentCharacter);
begin
{
   m_nAgentType := nType;
   m_ctlAgent.Characters.Load(CharacterId, CharacterFile);
   m_ctlAgent.Connected := TRUE;
}
end;

procedure TEmailmaxAgent.TalkOneLine;
var
   sText : String;
begin
{
   sText := m_oSpeechList.Strings[0];
   m_oSpeechList.Delete(0);
   m_ctlAgent.Characters.Character(CharacterId).Speak(sText, '');
}
end;


end.
