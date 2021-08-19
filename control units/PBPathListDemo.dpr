program PBPathListDemo;

uses
  Forms,
  PBPathListDemo_Unit in 'PBPathListDemo_Unit.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'PBPathListDemo';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
