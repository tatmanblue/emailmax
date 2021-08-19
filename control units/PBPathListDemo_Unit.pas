unit PBPathListDemo_Unit;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls, ExtCtrls, PBPathList;

type
  TForm1 = class(TForm)
    ComboBox1: TComboBox;
    Label2: TLabel;
		RadioGroup1: TRadioGroup;
		Bevel1: TBevel;
    Edit2: TEdit;
		Edit1: TEdit;
    Label1: TLabel;
		Perform: TButton;
		PBPathList1: TPBPathList;
		TotalLabel: TLabel;
		RadioGroup2: TRadioGroup;
    SimulateNotfound: TCheckBox;
		procedure ComboBox1Change(Sender: TObject);
		procedure PerformClick(Sender: TObject);
		procedure RadioGroup2Click(Sender: TObject);
		procedure UpdateComboBox;
    procedure SimulateNotfoundClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
	private
    { Private declarations }
  public
    { Public declarations }
  end;

var
	Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.UpdateComboBox;
var
	t : integer;
begin
	ComboBox1.Items.Clear;
	for t := 0 to PBPathList1.Count - 1 do
	begin
		ComboBox1.Items.Add(PBPathList1.List.Names[t]);
	end;
	if ComboBox1.ItemIndex = -1 then ComboBox1.ItemIndex := 0;
	ComboBox1Change(Self);
	TotalLabel.Caption := '(Count: ' + IntToStr(PBPathList1.Count) + ')';
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
	Edit1.Text := PBPathList1[ComboBox1.Text];
end;

procedure TForm1.PerformClick(Sender: TObject);
begin
	case RadioGroup1.ItemIndex of
		0: Edit2.Text := DisplayPath(Edit1.Text);
		1: Edit2.Text := FullPath(Edit1.Text);
		2: Edit2.Text := PBPathList1.BuildShellName(Edit1.Text);
		3: Edit2.Text := PBPathList1.ReplaceShellName(Edit1.Text);
		else;
	end;
end;

procedure TForm1.RadioGroup2Click(Sender: TObject);
begin
	PBPathList1.PathCase := TPathCase(RadioGroup2.ItemIndex);
	UpdateComboBox;
end;

procedure TForm1.SimulateNotfoundClick(Sender: TObject);
begin
	PBPathList1.SimulateNotFound := SimulateNotFound.Checked;
	UpdateComboBox;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
	UpdateComboBox;
	RadioGroup2.ItemIndex := Integer(PBPathList1.PathCase);
	SimulateNotFound.Checked := PBPathList1.SimulateNotFound;
end;

end.
