{Author:	Poul Bak}
{Copyright © 2001-2002 : BakSoft-Denmark (Poul Bak). All rights reserved.}
{http://home11.inet.tele.dk/BakSoft/}
{Mailto: baksoft-denmark@dk2net.dk}
{}
{Component Version: 4.00.00.00}
{}
{PBPathList is a component that makes it easier to use to the Windows built-in
shellfolders.}
{Depending on your Windows version it makes a list with 20-50 paths.}
{The individual paths can be called like: PBPathList1['%PERSONAL%'].}
{The component can simulate paths not present on the system.}
{Included is the free 'SHFolder.dll' (version 6.00.2600.0000) which let you
access shell-folders on older systems - even those not defined.}
{You can build system-independent paths like '%PERSONAL%\MyFolder' and get the
actual path at runtime.}
{You decide the case of the returned paths: pcDontCare, pcLower, pcUpper,
pcUpperName (First letter upper - the rest lower).}
{Also included are some functions to work with paths: 'DisplayPath', 'FullPath',
'CreateShellfolder' and 'UpperName'.}
{Version 3.00.00.00 can also get the displaynames of virtual folders.}
{}
{To use this component you must ensure that 'SHFolder.dll' is on the end-user's
computer - the easiest is to distribute it with your program (that's legal).
Remember to use InstallShield's 'check version' option to avoid replacing a
newer version.}

unit PBPathList;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ShlObj, ShellAPI, ActiveX;

type
{The case of the paths returned.}
{See also PathCase }
	TPathCase = (pcDontCare, pcLower, pcUpper, pcUpperName);

{Author:	Poul Bak}
{Copyright © 2001-2002 : BakSoft-Denmark (Poul Bak). All rights reserved.}
{http://home11.inet.tele.dk/BakSoft/}
{Mailto: baksoft-denmark@dk2net.dk}
{}
{Component Version: 4.00.00.00}
{}
{PBPathList is a component that makes it easier to use to the Windows built-in
shellfolders.}
{Depending on your Windows version it makes a list with 20-50 paths.}
{The individual paths can be called like: PBPathList1['%PERSONAL%'].}
{The component can simulate paths not present on the system.}
{Included is the free 'SHFolder.dll' (version 6.00.2600.0000) which let you access shell-folders on
older systems - even those not defined.}
{You can build system-independent paths like '%PERSONAL%\MyFolder' and get the
actual path at runtime.}
{You decide the case of the returned paths: pcDontCare, pcLower, pcUpper,
pcUpperName (First letter upper - the rest lower).}
{Also included are some functions to work with paths: 'DisplayPath', 'FullPath',
'CreateShellfolder' and 'UpperName'.}
{Version 3.00.00.00 can also get the displaynames of virtual folders.}
{}
{To use this component you must ensure that 'SHFolder.dll' is on the end-user's
computer - the easiest is to distribute it with your program (that's legal).
Remember to use InstallShield's 'check version' option to avoid replacing a
newer version.}
	TPBPathList = class(TComponent)
	private
		{ Private declarations }
		FPathCase : TPathCase;
		FVersion : string;
		FSimulateNotFound : Boolean;
		function GetList : TStringList;
		function GetVirtualNames : TStringList;
		function GetCount : integer;
		function ChangeCase(Name : string) : string;
		function GetValues(Name : string) : string;
		procedure DontSetCount(Value : integer);
		procedure DontSetValues(Name : string; const Value : string);
		procedure Dummy(Value : string);
		procedure DontSetList(Value : TStringList);
	protected
		{ Protected declarations }
	public
		{ Public declarations }
		constructor Create(AOwner : Tcomponent); override;
{Builds a complex shellname in the form '%SHELLFOLDER%\MyFolder' when you have
the actual path.}
{Use the complex form in for instance INI-files.}
{See also ReplaceShellName }
		function BuildShellName(Path : string) : string;
{Creates a shellfolder if it doesn't exist. For instance when passed
'%MYPICTURES%' as Name it will create the shellfolder with localized foldername
 ('C:\Dokumenter\Billeder' on my danish computer).}
{Don't use this function without asking the end-user - once created they are
hard to remove again - involves the Registry.}
		function CreateShellFolder(Name : string) : Boolean;
{Replaces a complex shellname in the form '%SHELLFOLDER%\Myfolder' with the
actual path for instance 'C:Windows\System\MyFolder'.}
{See also BuildShellName }
		function ReplaceShellName(NamePath : string) : string;
{The default property. Getting a path from the list is done by calling the
components default property like this: PBPathList1['%SHELLFOLDER%'] - assuming
the components name is PBPathList1.}
{Read only}
		property Values[Name : string] : string read GetValues
			write DontSetValues; default;
	published
		{ Published declarations }
{For informational purpose: the number of paths in the list on this computer.}
{Read only}
		property Count : integer read GetCount write DontSetCount stored False;
{The actual list of shellnames and corresponding path-values.}
{Normally not used directly.}
{Getting a path from the list is done by calling the components default property
like this: PBPathList1['%SHELLFOLDER%'] - assuming the components name is
PBPathList1.}
{Read only}
		property List : TStringList read GetList write DontSetList stored False;
{The case of the returned paths.}
{See also TPathCase and UpperName }
		property PathCase : TPathCase read FPathCase
			write FPathCase default pcUpperName;
{The component can simulate some paths that are undefined on older systems.}
{Especially many of the 'COMMON' paths are undefined on Windows9x.}
{If SimulateNotFound is True the component returns the path to the users folders.}
		property SimulateNotFound : Boolean read FSimulateNotFound
			write FSimulateNotFound default True;
{Read only}
		property Version : string read FVersion write Dummy stored False;
{DisplayNames of virtual folders. See also List.}
		property VirtualNames : TStringList read GetVirtualNames
			write DontSetList stored False;
	end;

{A function that translates a string so that the first letter of each word is
uppercase and the rest is lowercase.}
function UpperName(const S: string): string;
{A function that turns a path (for instance returned by ExtractFilePath) into
a standard windows path - for instance 'C:\' or 'C:\Myfolder'.}
{See also: FullPath }
function DisplayPath(const Path: string) : string;
{A function that ensures that a path ends with a backslash '\'.}
{makes it easy to build a path simply add the path and filename.}
{See also: DisplayPath }
function FullPath(const Path: string) : string;
procedure Register;

const
	MAX_NAMES = $3D;
	PBPathNames : array[0..MAX_NAMES] of string = ('%DESKTOP%', '%INTERNET%',
		'%PROGRAMS%', '%CONTROLS%', '%PRINTERS%', '%PERSONAL%',	'%FAVORITES%',
		'%STARTUP%', '%RECENT%', '%SENDTO%', '%BITBUCKET%', '%STARTMENU%',
		'%MYDOCUMENTS%', '%MYMUSIC%', '%MYVIDEO%', '%%', '%DESKTOPDIRECTORY%',
		'%DRIVES%', '%NETWORK%', '%NETHOOD%', '%FONTS%', '%TEMPLATES%',
		'%COMMON_STARTMENU%', '%COMMON_PROGRAMS%', '%COMMON_STARTUP%',
		'%COMMON_DESKTOPDIRECTORY%', '%APPDATA%', '%PRINTHOOD%', '%LOCAL_APPDATA%',
		'%ALTSTARTUP%', '%COMMON_ALTSTARTUP%', '%COMMON_FAVORITES%',
		'%INTERNET_CACHE%', '%COOKIES%', '%HISTORY%',	'%COMMON_APPDATA%',
		'%WINDOWS%', '%SYSTEM%', '%PROGRAM_FILES%',	'%MYPICTURES%', '%PROFILE%',
		'%SYSTEMX86%',	'%PROGRAM_FILESX86%',	'%PROGRAM_FILES_COMMON%',
		'%PROGRAM_FILES_COMMONX86%', '%COMMON_TEMPLATES%', '%COMMON_DOCUMENTS%',
		'%COMMON_ADMINTOOLS%', '%ADMINTOOLS%', '%CONNECTIONS%',	'%%', '%%', '%%',
		'%COMMON_MUSIC%', '%COMMON_PICTURES%', '%COMMON_VIDEO%', '%RESOURCES%',
		'%RESOURCES_LOCALIZED%', '%COMMON_OEM_LINKS%', '%CDBURN_AREA%', '%%',
		'%COMPUTERSNEARME%');
	CSIDL_FLAG_PER_USER_INIT = $0800;
	CSIDL_FLAG_NO_ALIAS = $1000;
	CSIDL_FLAG_DONT_VERIFY = $4000;
	CSIDL_FLAG_CREATE = $8000;
	CSIDL_FLAG_MASK = $FF00;


implementation

var
	FList, FVirtualNames : TStringList;

function DisplayPath(const Path: string) : string;
begin
	if Path = '' then Result := ''
	else if Length(ExtractFileDrive(Path)) = Length(Path)
		then Result := Path + '\'
	else if (Length(ExtractFileDrive(Path)) = Length(Path) - 1)
		and (Path[Length(Path)] = '\')
		then Result := Path
	else if Path[Length(Path)] = '\'
		then Result := Copy(Path, 1, Length(Path) - 1)
	else Result := Path;
end;

function FullPath(const Path: string) : string;
begin
	if Path = '' then Result := ''
	else if Path[Length(Path)] = '\' then Result := Path
	else Result := Path + '\';
end;

function UpperName(const S: string): string;
var
	s1 : string;
	p : boolean;
	t : integer;
begin
	if Pos(':/', S) > 0 then Result := S
	else
	begin
		p := True;
		Result := '';
		for t := 1 to Length(S) do
		begin
			s1 := Copy(S, t, 1);
			if p = True then Result := Result + AnsiUpperCase(s1)
			else Result := Result + AnsiLowerCase(s1);
			if Pos(s1, ' .,;-+*/?=()&!\<>:_"{|}[]%') <> 0 then p := True
			else p := False;
		end;
		s1 := ExtractFileExt(Result);
		if s1 <> '' then Result := ChangeFileExt(Result, AnsiLowerCase(s1));
	end;
end;

procedure MakeTheList;
type
	TSHGetFolderPath = function(HwndOwner : HWND; nFolder : LongInt; hToken : THandle;
		dwFlags : DWord; PPath : PChar) : HRESULT; stdcall;
var
	t : integer;
	TempPath : array[0..MAX_PATH] of Char;
	PIDL : PItemIDList;
	FileInfo : TSHFileInfo;
	Handle: THandle;
	SHGetFolderPath : TSHGetFolderPath;
begin
	FList.Clear;
	FVirtualNames.Clear;
	Handle := LoadLibrary('SHFolder.dll');
	if Handle <> 0 then
	begin
		@SHGetFolderPath := GetProcAddress(Handle, 'SHGetFolderPathA');
		if @SHGetFolderPath <> nil then
		begin
			for t := 0 to MAX_NAMES do if PBPathNames[t] <> '%%' then
			begin // Use SHFolder.dll (version 6.00.2600.0000)
				SHGetFolderPath(Application.Handle, t, 0, 0, TempPath);
				if TempPath <> '' then FList.Add(PBPathNames[t] + '='
					+ DisplayPath(TempPath))
				else 	// Is it a virtual folder without a path?
				begin
					if (Pos(PBPathNames[t], '%DESKTOP%%INTERNET%%CONTROLS%%PRINTERS%%BITBUCKET%'
						+ '%MYDOCUMENTS%%DRIVES%%NETWORK%%FONTS%%PRINTHOOD%%CONNECTIONS%'
						+ '%COMPUTERSNEARME%') > 0) and (SHGetSpecialFolderLocation
						(Application.Handle, t, PIDL) = NOERROR) then
					begin
						if SHGetFileInfo(PChar(PIDL), 0, FileInfo, SizeOf(FileInfo),
							SHGFI_PIDL or SHGFI_DISPLAYNAME) <> 0
							then FVirtualNames.Add(PBPathNames[t] + '='
							+ FileInfo.szDisplayName);
						CoTaskMemFree(PIDL);
					end;
				end;
			end;
		end;
		FreeLibrary(Handle);
	end;
	GetTempPath(MAX_PATH, TempPath);
	if DisplayPath(TempPath) <> DisplayPath(GetCurrentDir)
		then FList.Add('%TEMP%=' + DisplayPath(TempPath));
	FList.Sort;
	FVirtualNames.Sort;
end;

// ----------------------- PBPathList ------------------------------
constructor TPBPathList.Create(AOwner : Tcomponent);
begin
	inherited;
	FPathCase := pcUpperName;
	FSimulateNotFound := True;
	FVersion := '4.00.00.00';
end;

function TPBPathList.ChangeCase(Name : string) : string;
begin
	case FPathCase of
		pcDontCare : Result := Name;
		pcLower : Result := AnsiLowerCase(Name);
		pcUpper : Result := AnsiUpperCase(Name);
		pcUpperName : Result := UpperName(Name);
	end;
end;

function TPBPathList.BuildShellName(Path : string) : string;
var
	t, Len, ResultNumber : integer;
	Name, Val : string;
begin
	ResultNumber := -1;
	Len := 0;
	for t := 0 to FList.Count - 1 do
	begin
		Name := FList.Names[t];
		Val := UpperName(Values[Name]);
		if (Pos(Val, UpperName(Path)) = 1) and (Length(Val) > Len)
			and ((Length(Val) = Length(Path)) or (Copy(Path, Length(Val) + 1, 1) = '\')
			or (Copy(Val, Length(Val), 1) = '\')) then
		begin
			ResultNumber := t;
			Len := Length(Val);
		end;
	end;
	if ResultNumber = -1 then
	begin
		for t := 0 to FVirtualNames.Count - 1 do if UpperName(FVirtualNames.Values
			[FVirtualNames.Names[t]])	= UpperName(Path) then ResultNumber := t;
		if ResultNumber = -1 then	Result := Path
		else Result := FVirtualNames.Names[ResultNumber];
	end
	else Result := FList.Names[ResultNumber]
		+ ChangeCase(Copy(Path, Len + 1, Length(Path) - Len));
end;

function TPBPathList.ReplaceShellName(NamePath : string) : string;
var
	EndPos : integer;
	Name : string;
begin
	if Copy(NamePath, 1, 1) = '%' then
	begin
		EndPos := Pos('%', Copy(NamePath, 2, Length(NamePath) - 1));
		if (EndPos = 0) then Result := NamePath
		else
		begin
			Name := Copy(NamePath, 1, EndPos + 1);
			Result := Values[Name];
			if Result = '' then
			begin
				Result := FVirtualNames.Values[Name];
				if Result = '' then Result := NamePath;
			end
			else
			begin
				Delete(NamePath, 1, Length(Name));
				if Copy(NamePath, 1, 1) = '\' then Delete(NamePath, 1, 1);
				Result := ChangeCase(DisplayPath(FullPath(Result) + NamePath));
			end;
		end;
	end
	else Result := NamePath;
end;

function TPBPathList.GetValues(Name : string) : string;
var
	t : integer;
begin
	Result := ChangeCase(FList.Values[AnsiUpperCase(Name)]);
	if (Result = '') and FSimulateNotFound then
	begin
		for t := 0 to MAX_NAMES do if (PBPathNames[t] = Name) then
		begin
			case t of
				$27 : Result := Self['%PERSONAL%']; // CSIDL_MYPICTURES
				$2F : Result := Self['%ADMINTOOLS%']; // CSIDL_COMMON_ADMINTOOLS
				$1D : Result := Self['%STARTUP%']; // CSIDL_ALTSTARTUP
				$1E : Result := Self['%ALTSTARTUP%']; // CSIDL_COMMON_ALTSTARTUP
				$23 : Result := Self['%APPDATA%']; // CSIDL_COMMON_APPDATA
				$19 : Result := Self['%DESKTOPDIRECTORY%']; // CSIDL_COMMON_DESKTOPDIRECTORY
				$2E : Result := Self['%PERSONAL%']; // CSIDL_COMMON_DOCUMENTS
				$1F : Result := Self['%FAVORITES%']; // CSIDL_COMMON_FAVORITES
				$17 : Result := Self['%PROGRAMS%']; // CSIDL_COMMON_PROGRAMS
				$16 : Result := Self['%STARTMENU%']; // CSIDL_COMMON_STARTMENU
				$18 : Result := Self['%STARTUP%']; // CSIDL_COMMON_STARTUP
				$2D : Result := Self['%TEMPLATES%']; // CSIDL_COMMON_TEMPLATES
				$0C : Result := Self['%PERSONAL%']; // CSIDL_MYDOCUMENTS
				$0D : Result := Self['%PERSONAL%']; // CSIDL_MYMUSIC
				$0E : Result := Self['%PERSONAL%']; // CSIDL_MYVIDEO
				$2B : Result := Self['%PROGRAM_FILES%']; // CSIDL_PROGRAM_FILES_COMMON
				$2C : Result := Self['%PROGRAM_FILESX86%']; // CSIDL_PROGRAM_FILES_COMMONX86
				$35 : Result := Self['%MYMUSIC%']; // CSIDL_COMMON_MUSIC
				$36 : Result := Self['%MYPICTURES%']; // CSIDL_COMMON_PICTURES
				$37 : Result := Self['%MYVIDEO%']; // CSIDL_COMMON_VIDEO
				$39 : Result := Self['%RESOURCES%']; // CSIDL_RESOURCES_LOCALIZED
			end;
		end;
	end;
end;

function TPBPathList.GetList : TStringList;
begin
	Result := FList;
end;

function TPBPathList.GetVirtualNames : TStringList;
begin
	Result := FVirtualNames;
end;

function TPBPathList.GetCount : integer;
begin
	Result := FList.Count;
end;

function TPBPathList.CreateShellFolder(Name : string) : Boolean;
type
	TSHGetFolderPath = function(HwndOwner : HWND; nFolder : LongInt; hToken : THandle;
		dwFlags : DWord; PPath : PChar) : HRESULT; stdcall;
var
	t : integer;
	TempPath : array[0..MAX_PATH] of Char;
	Handle: THandle;
	SHGetFolderPath : TSHGetFolderPath;
begin
	if FList.Values[Name] <> '' then Result := True
	else
	begin
		Result := False;
		Handle := LoadLibrary('SHFolder.dll');
		if Handle <> 0 then
		begin
			@SHGetFolderPath := GetProcAddress(Handle, 'SHGetFolderPathA');
			if @SHGetFolderPath <> nil then
			begin
				Result := True;
				t := 0;
				while (t < MAX_NAMES) and (AnsiUpperCase(Name) <> PBPathNames[t]) do Inc(t);
				if (AnsiUpperCase(Name) <> PBPathNames[t]) then Result := False
				else if SHGetFolderPath(Application.Handle, t or CSIDL_FLAG_CREATE,
					0, 0, TempPath) <> 0 then Result := False;
				if Result and (FList.Values[PBPathNames[t]]
					<> DisplayPath(TempPath)) then GetList;
			end;
			FreeLibrary(Handle);
		end;
	end;
end;

// Dummy set-procedures (read only) !
procedure TPBPathList.DontSetCount(Value : integer); begin end;
procedure TPBPathList.DontSetValues(Name : string; const Value : string); begin end;
procedure TPBPathList.Dummy(Value : string); begin end;
procedure TPBPathList.DontSetList(Value : TStringList); begin end;

procedure Register;
begin
	RegisterComponents('PB', [TPBPathList]);
end;

initialization
	FList := TStringList.Create;
	FVirtualNames := TStringList.Create;
	MakeTheList;

finalization
	FVirtualNames.Free;
	FVirtualNames := nil;
	FList.Free;
	FList := nil;

end.
