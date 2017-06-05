{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit main;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, KOL {$IF Defined(KOL_MCK)}{$ELSE}, mirror, Classes, Controls, mckCtrls,
  mckObjs, Graphics {$IFEND (place your units here->)};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mirror;
{$ENDIF}

type
  {$IF Defined(KOL_MCK)}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} {$I TForm1class.inc} {$ELSE OBJECTS} PMainForm = ^TMainForm; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm1.inc}{$ELSE} TMainForm = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TMainForm = class(TForm)
  {$IFEND KOL_MCK}
    KOLProj: TKOLProject;
    KOLForm: TKOLForm;
    Label1: TKOLLabel;
    esrc: TKOLEditBox;
    edata: TKOLEditBox;
    Label2: TKOLLabel;
    etime: TKOLEditBox;
    Label3: TKOLLabel;
    btnJudge: TKOLButton;
    cbTop: TKOLCheckBox;
    tvres: TKOLTreeView;
    pgb: TKOLProgressBar;
    emem: TKOLEditBox;
    Label4: TKOLLabel;
    iml: TKOLImageList;
    mres: TKOLMemo;
    bCfg: TKOLButton;
    pCfg: TKOLPanel;
    ecmptime: TKOLEditBox;
    Label5: TKOLLabel;
    GroupBox1: TKOLGroupBox;
    Label6: TKOLLabel;
    egcc: TKOLEditBox;
    Label7: TKOLLabel;
    egpp: TKOLEditBox;
    efpc: TKOLEditBox;
    Label8: TKOLLabel;
    procedure KOLFormCreate(Sender: PObj);
    procedure btnJudgeClick(Sender: PObj);
    procedure cbTopClick(Sender: PObj);
    procedure KOLFormDestroy(Sender: PObj);
    procedure KOLFormClose(Sender: PObj; var Accept: Boolean);
    procedure tvresChange(Sender: PObj);
    procedure bCfgClick(Sender: PObj);
  private
    //procedure JudgeOnce(const sCode, sData: String);
    procedure FindSingleProgram(const Fn, Reserved: String);
    procedure FindTestProgram(const Dir: String; const Reserved: String = '');
  public
    { Public declarations }
  end;

  _PROCESS_MEMORY_COUNTERS = packed record
    cb: DWORD;
    PageFaultCount: DWORD;
    PeakWorkingSetSize: DWORD;
    WorkingSetSize: DWORD;
    QuotaPeakPagedPoolUsage: DWORD;
    QuotaPagedPoolUsage: DWORD;
    QuotaPeakNonPagedPoolUsage: DWORD;
    QuotaNonPagedPoolUsage: DWORD;
    PagefileUsage: DWORD;
    PeakPagefileUsage: DWORD;
  end;
  PROCESS_MEMORY_COUNTERS = _PROCESS_MEMORY_COUNTERS;
  PPROCESS_MEMORY_COUNTERS = ^_PROCESS_MEMORY_COUNTERS;
  TProcessMemoryCounters = _PROCESS_MEMORY_COUNTERS;
  PProcessMemoryCounters = ^_PROCESS_MEMORY_COUNTERS;

  TGetProcessMemoryInfo = function (Process: THandle;
    ppsmemCounters: PPROCESS_MEMORY_COUNTERS; cb: DWORD): BOOL; stdcall;

var
  MainForm {$IF Defined(KOL_MCK)} : PMainForm {$ELSE} : TMainForm {$IFEND} ;

const
  sErr = '¥ÌŒÛ';

{$R WindowsXP.res}
{$IFDEF KOL_MCK}procedure NewMainForm( var Result: PMainForm; AParent: PControl );{$ENDIF}
implementation
{$IF Defined(KOL_MCK)}{$I Unit1_1.inc}{$ELSE}{$R *.DFM}{$IFEND}

procedure SecDeleteFile(const FN: String);
var
  PathName: String;
  TmpFile: array [0..MAX_PATH] of Char;
begin
  PathName := ExtractFilePath(FN);
  if 0 <> GetTempFileNameA(PChar(PathName), nil, 0, TmpFile) then
  begin
    if MoveFileExA(PChar(FN), TmpFile, MOVEFILE_REPLACE_EXISTING) then
    begin
      DeleteFile(TmpFile);
      Exit;
    end;
  end;
  DeleteFile(PChar(FN));
end;

procedure EmptyDir(const SourceDir: String; const Reserved: Boolean = False);
var
  FD: TFindFileData;
begin
  if Find_First(SourceDir+'\*', FD) then
	begin
		repeat
			if (FD.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) <> 0 then
			begin
				if (StrComp(FD.cFileName,'.') <> 0) and (StrComp(FD.cFileName,'..') <> 0) then
          EmptyDir(SourceDir+'\'+FD.cFileName, True);
			end else
			begin
        DeleteFile(PChar(SourceDir+'\'+FD.cFileName));
			end;
		until not Find_Next(FD);
	end;
  Find_Close(FD);
  if Reserved then RemoveDirectory(PChar(SourceDir));
end;

function IsWin64: Boolean;
var  
  Kernel32Handle: THandle;   
  IsWow64Process: function(Handle: Windows.THandle; var Res: Windows.BOOL): Windows.BOOL; stdcall;   
  GetNativeSystemInfo: procedure(var lpSystemInfo: TSystemInfo); stdcall;   
  isWoW64: Bool;   
  SystemInfo: TSystemInfo;   
const  
  PROCESSOR_ARCHITECTURE_AMD64 = 9;   
  PROCESSOR_ARCHITECTURE_IA64 = 6;   
begin
  Kernel32Handle := GetModuleHandle('KERNEL32.DLL');   
  if Kernel32Handle = 0 then  
    Kernel32Handle := LoadLibrary('KERNEL32.DLL');   
  if Kernel32Handle <> 0 then  
  begin  
    IsWOW64Process := GetProcAddress(Kernel32Handle, 'IsWow64Process');
    GetNativeSystemInfo := GetProcAddress(Kernel32Handle, 'GetNativeSystemInfo');
    if Assigned(IsWow64Process) then
    begin  
      IsWow64Process(GetCurrentProcess,isWoW64);   
      Result := isWoW64 and Assigned(GetNativeSystemInfo);
      if Result then  
      begin  
        GetNativeSystemInfo(SystemInfo);   
        Result := (SystemInfo.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64) or  
                  (SystemInfo.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_IA64);   
      end;   
    end  
    else Result := False;   
  end  
  else Result := False;   
end;

function iGetFileAttributes(const Fn: PChar): DWORD;
var
  e: DWORD;
begin
  e := SetErrorMode( SEM_NOOPENFILEERRORBOX or SEM_FAILCRITICALERRORS );
  Result := GetFileAttributes(Fn);
  SetErrorMode( e );
end;

type
  HDROP = Longint;

function DragQueryFile(Drop: HDROP; FileIndex: UINT; FileName: PAnsiChar; cb: UINT): UINT; stdcall;
         external 'shell32.dll' name 'DragQueryFileA';
procedure DragFinish(Drop: HDROP); stdcall;
          external 'shell32.dll' name 'DragFinish';
procedure DragAcceptFiles(Wnd: HWND; Accept: BOOL); stdcall;
          external 'shell32.dll' name 'DragAcceptFiles';

function WndProcDropFiles( Sender: PControl; var Msg: TMsg; var Rslt: Integer ): Boolean;
var
  Buf: array[ 0..MAX_PATH ] of KOLChar;
begin
  if Msg.message = WM_DROPFILES then
  begin
    DragQueryFile( Msg.wParam, 0, Buf, MAX_PATH );
    SetWindowText( Msg.hwnd, Buf);
    DragFinish( Msg.wParam );

    Rslt := 0;
    Result := TRUE; Exit;
  end;
  Result := FALSE;
end;

{function iTrim(const sIn: String): String;
var
  sl: PStrList;
  I, Cnt: Integer;
  S: String;
begin
  sl := NewStrList;
  sl.SetText(sIn, False);

  Cnt := sl.Count;
  I := 0;
  while I < Cnt do
  begin
    S := Trim(sl.Items[I]);
    if S = '' then
    begin
      sl.Delete(I);
      Dec(Cnt);
    end else
    begin
      sl.Items[I] := S;
      Inc(I);
    end;
  end;

  Result := sl.Join(#13);
  sl.Free;
end;}

function StandardCmp(const FOut, FAns: String; var Info: String): Boolean;
var
  FHOut, FHAns: THandle;
  strOut, strAns: String;
  pStOut, pStAns, pOut, pAns, pRtOut, pRtAns: PChar;

  size: Cardinal;
  I, CountLine: Integer;
  R1,R2: Boolean;
  function isBlank1(const C: Char): Boolean; inline;
  begin
    Result := (C = ' ') or (C = #13) or (C = #9);
  end;
  function isBlank2(const C: Char): Boolean; inline;
  begin
    Result := (C = ' ') or (C = #13) or (C = #9) or (C = #10);
  end;
  function SkipBlank(P: PChar): PChar; inline;
  begin
    while IsBlank2(P^) do
    begin
      if P^ = #10 then Inc(CountLine);
      Inc(P);
    end;
    Result := P;
  end;
  function EndOfFile(P: PChar): Boolean; inline;
  begin
    while IsBlank2(P^) do Inc(P);
    Result := P^ = #0;
  end;
  function EndOfLine(P: PChar; var Ret: PChar): Boolean; inline;
  begin
    while IsBlank1(P^) do Inc(P);
    Ret := P;
    Result := (P^ = #0) or (P^ = #10);
  end;
  function Max(A,B: PChar): PChar; inline;
  begin
    if A > B then Result := A
    else Result := B;
  end;
begin
  Result := False;
  FHOut := FileCreate(FOut, ofOpenRead or ofShareDenyWrite or ofOpenExisting);
  if FHOut <> INVALID_HANDLE_VALUE then
  begin
    FHAns := FileCreate(FAns, ofOpenRead or ofShareDenyWrite or ofOpenExisting);
    if FHAns <> INVALID_HANDLE_VALUE then
    begin
      size := GetFileSize(FHOut, nil);
      SetString(strOut, nil, size);
      FileRead(FHOut, strOut[1], size);

      size := GetFileSize(FHAns, nil);
      SetString(strAns, nil, size);
      FileRead(FHAns, strAns[1], size);

      Result := True;
      pStOut := PChar(strOut);
      pStAns := PChar(strAns);

      pOut := pStOut;
      pAns := pStAns;
      CountLine := 1;
      while (pOut^ <> #0) and (pAns^ <> #0) do
      begin
        if pAns^ = #10 then Inc(CountLine);
        if pAns^ <> pOut^ then
        begin
          R1 := EndOfLine(pOut, pRtOut);
          R2 := EndOfLine(pAns, pRtAns);
          if R1 and R2 then
          begin
            pOut := pRtOut;
            pAns := pRtAns;
          end else
          begin
            pOut := SkipBlank(pRtOut);
            pAns := SkipBlank(pRtAns);
          end;
          if (pOut^ <> pAns^) and (pOut^ <> #0) and (pAns^ <> #0) then
          begin
            Result := False;
            Break;
          end;
        end;
        Inc(pOut);
        Inc(pAns);
      end;
      if (not EndOfFile(pOut)) or (not EndOfFile(pAns)) then Result := False;

      if not Result then
      begin
        pRtOut := Max(pStOut, pOut-10);
        pRtAns := Max(pStAns, pAns-10);
        Info := 'On line '+Int2Str(CountLine)+':'+#13#10+'Answer:'+#13#10+'========================'+#13#10;

        if pRtAns <> pStAns then Info := Info + '...';
        while pRtAns <> pAns do
        begin
          Info := Info + pRtAns^;
          Inc(pRtAns);
        end;
        for I := 1 to 10 do
        begin
          if pRtAns^ = #0 then Break;
          Info := Info + pRtAns^;
          Inc(pRtAns);
        end;
        if pRtAns^ <> #0 then Info := Info + '...';

        Info := Info + #13#10 + '========================' + #13#10 + 'Yours:' + #13#10;

        if pRtOut <> pStOut then Info := Info + '...';
        while pRtOut <> pOut do
        begin
          Info := Info + pRtOut^;
          Inc(pRtOut);
        end;
        for I := 1 to 10 do
        begin
          if pRtOut^ = #0 then Break;
          Info := Info + pRtOut^;
          Inc(pRtOut);
        end;
        if pRtOut^ <> #0 then Info := Info + '...';

      end;

      CloseHandle(FHAns);
    end else
      Info := 'Failed to load answer file.';
    CloseHandle(FHOut);
  end else
    Info := 'Output file does not exist.';
end;

////////Thread Marking////////
type
  PTestPoint = ^TTestPoint;
  TTestPoint = record
    Next: PTestPoint;
    Name, Info: String;
    Time, Memory: DWORD;
    Pass: Boolean;
  end;

  PDestItem = ^TDestItem;
  TDestItem = record
     Next: PDestItem;
     Name, inFullPath, outFullPath: String;
  end;

  PDestData = ^TDestData;
  TDestData = record
    Next: PDestData;
    Name: String;
    Items: PDestItem;
  end;

  PDestProgram = ^TDestProgram;
  TDestProgram = record
    Next: PDestProgram;
    Name, FullPath, Info: String;
    Mark, MaxMark: DWORD;

    TestData: PDestData;
    Points: PTestPoint;
    TVNode: THandle;
  end;

var
  TestData: PDestData = nil;
  DestProgram: PDestProgram = nil;
  szTempPath: String;
  bRunning: Boolean = True;
  bIsJudge: Boolean = False;

  GetProcessMemoryInfo: TGetProcessMemoryInfo = nil;
  sGCC, sGPP, sFPC, szDefEnv: String;

procedure ClearData;
var
  Ptr: Pointer;
begin
  while TestData <> nil do
  begin
    TestData.Name := '';
    while TestData.Items <> nil do
    begin
      TestData.Items.Name := '';
      TestData.Items.inFullPath := '';
      TestData.Items.outFullPath := '';
      Ptr := TestData.Items;
      TestData.Items := TestData.Items.Next;
      FreeMem(Ptr, SizeOf(TDestItem));
    end;
    Ptr := TestData;
    TestData := TestData.Next;
    FreeMem(Ptr, SizeOf(TDestData));
  end;
  while DestProgram <> nil do
  begin
    DestProgram.Name := '';
    DestProgram.FullPath := '';
    DestProgram.Info := '';
    while DestProgram.Points <> nil do
    begin
      DestProgram.Points.Name := '';
      DestProgram.Points.Info := '';
      Ptr := DestProgram.Points;
      DestProgram.Points := DestProgram.Points.Next;
      FreeMem(Ptr, SizeOf(TTestPoint));
    end;

    Ptr := DestProgram;
    DestProgram := DestProgram.Next;
    FreeMem(Ptr, SizeOf(TDestProgram));
  end;
end;

procedure FindTestData(const Dir: String);
var
  F: TFindFileData;
  Ext, Name, NOut: String;

  procedure AddPoint;
  var
    RealName, RealID: String;
    I: Integer;
    p: PDestData;
    d: PDestItem;
  begin
    RealName := '';
    RealID := '';
    for I := 1 to Length(Name) do
    begin
      if ((Name[I] >= 'a') and (Name[I] <= 'z')) or ((Name[I] >= 'A') and (Name[I] <= 'Z')) then RealName := RealName + Name[I]
      else RealID := RealID + Name[I];
    end;

    d := AllocMem(SizeOf(TDestItem));
    d.inFullPath := Dir+F.cFileName;
    d.outFullPath := NOut;
    d.Name := RealID;

    p := TestData;
    while p <> nil do
    begin
      if p.Name = RealName then
      begin
        d.Next := p.Items;
        p.Items := d;
        Exit;
      end;
      p := p.Next;
    end;

    p := AllocMem(SizeOf(TDestData));
    p.Name := RealName;
    p.Items := d;
    d.Next := nil;
    p.Next := TestData;
    TestData := p;
  end;
begin
  if Find_First(Dir+'*', F) then
  begin
    repeat
      if (F.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
      begin
        Ext := ExtractFileExt(F.cFileName);
        if StrComp_NoCase(PChar(Ext), '.in') = 0 then
        begin
          Name := ExtractFileName(F.cFileName);
          Name := Copy(Name, 1, Length(Name) - Length(Ext));
          NOut := Dir + Name + '.out';
          if iGetFileAttributes(PChar(NOut)) <> INVALID_HANDLE_VALUE then
          begin
             AddPoint;
          end else
          begin
            NOut := Dir + Name + '.ans';
            if iGetFileAttributes(PChar(NOut)) <> INVALID_HANDLE_VALUE then
            begin
              AddPoint;
            end;
          end;
        end;
      end else
      begin
        if (StrComp(F.cFileName,'.') <> 0) and (StrComp(F.cFileName,'..') <> 0) then
          FindTestData(Dir+F.cFileName+'\');
      end;
    until (not Find_Next(F));
  end;
end;

procedure TMainForm.FindTestProgram(const Dir: String; const Reserved: String = '');
var
  F: TFindFileData;
begin
  if Find_First(Dir+'*', F) then
  begin
    repeat
      if (F.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
      begin
        FindSingleProgram(Dir+F.cFileName, Reserved);
      end else
      begin
        if (StrComp(F.cFileName,'.') <> 0) and (StrComp(F.cFileName,'..') <> 0) then
          FindTestProgram(Dir+F.cFileName+'\', Reserved+F.cFileName+'\');
      end;
    until (not Find_Next(F));
  end;
end;

procedure TMainForm.FindSingleProgram(const Fn, Reserved: String);
var
  Ext, Name, Temp, Node: String;
  p: PDestData;
  g: PDestProgram;
  Av: PDestData;
  TreeParent, T: Cardinal;
  I: Integer;
  Fnd: Boolean;
begin
  Ext := ExtractFileExt(Fn);
  if (StrComp_NoCase(PChar(Ext), '.c') = 0) or (StrComp_NoCase(PChar(Ext), '.cpp') = 0) or (StrComp_NoCase(PChar(Ext), '.pas') = 0) then
  begin
    Name := ExtractFileName(Fn);
    Name := Copy(Name, 1, Length(Name) - Length(Ext));
    //available?
    Av := nil;
    p := TestData;
    while p <> nil do
    begin
      if p.Name = Name then
      begin
        Av := p;
        Break;
      end;
      p := p.Next;
    end;

    if Av <> nil then
    begin
      g := AllocMem(SizeOf(TDestProgram));
      g.Name := Name;
      g.FullPath := Fn;
      g.TestData := Av;
      g.Next := DestProgram;
      DestProgram := g;

      //new tree
      Temp := Reserved;
      //if Temp <> '' then Delete(Temp, Length(Temp), 1);

      TreeParent := 0;
      while Temp <> '' do
      begin
        I := Pos('\', Temp);
        Node := Copy(Temp, 0, I-1);
        Temp := Copy(Temp, I+1, Length(Temp)-I);
        //search node
        Fnd := False;

        T := tvres.TVItemChild[TreeParent];

        while T <> 0 do
        begin
          if tvres.TVItemText[T] = Node then
          begin
            Fnd := True;
            TreeParent := T;
            Break;
          end;
          T := tvres.TVItemNext[T];
        end;

        if not Fnd then
        begin
          TreeParent := tvres.TVInsert(TreeParent, MAXDWORD, Node);
          tvres.TVItemData[TreeParent] := nil;
          tvres.TVItemStateImg[TreeParent] := 0;
          //tvres.TVExpand(TreeParent, TVE_EXPAND);
        end;
      end;

      T := tvres.TVInsert(TreeParent, MAXDWORD, Name);
      tvres.TVItemData[T] := Pointer(g);
      tvres.TVItemStateImg[T] := 1;
      g.TVNode := T;
    end;
  end;
end;

procedure TMainForm.cbTopClick(Sender: PObj);
begin
  Form.StayOnTop := cbTop.Checked;
end;

procedure formatPath(var s: String); inline;
begin
  if s[Length(s)] <> '\' then s := s + '\';
end;

var
  thrJudge: THandle = 0;
  MaxMem: DWORD = 0;
  MaxTime: DWORD = 0;
  MaxCompileTime: DWORD = 0;

function JudgeThread(Param: Pointer): HRESULT; stdcall;
var
  p: PDestProgram;
  d: PDestItem;
  pt: PTestPoint;
  T: THandle;

  ProcessInfo: _PROCESS_INFORMATION;
  StartupInfo: TStartupInfo;

  szzEnv, sCompilerDir, sCmdline, sEXE, sExt, sInFile, sOutFile, sTime: String;
  RunTime, MemSize: DWORD;
  imgIdx: Integer;
  bRtErr: Boolean;

  function Compile: String; inline;
  var
    SecurityAttributes: SECURITY_ATTRIBUTES;
    I, Total: DWORD;
    hRead, hWrite: THandle;
  begin
    Result := '';

    SecurityAttributes.nLength := SizeOf(SECURITY_ATTRIBUTES);
    SecurityAttributes.lpSecurityDescriptor := nil;
    SecurityAttributes.bInheritHandle := True;

    if CreatePipe(hRead, hWrite, @SecurityAttributes, 0) then
    begin
      FillChar(ProcessInfo, SizeOf(_PROCESS_INFORMATION), 0);
      FillChar(StartupInfo, SizeOf(TStartupInfo), 0);

      StartupInfo.cb := SizeOf(TStartupInfo);
      StartupInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      StartupInfo.wShowWindow := SW_HIDE;

      StartupInfo.hStdOutput := hWrite;
      StartupInfo.hStdError := hWrite;
      StartupInfo.hStdInput := 0;

      if CreateProcess(nil, PChar(sCmdline), nil, nil, True, 0, nil, PChar(sCompilerDir), StartupInfo, ProcessInfo) then
      begin
        if WaitForSingleObject(ProcessInfo.hProcess, MaxCompileTime) = WAIT_OBJECT_0 then
        begin
          Total := 0;
          if PeekNamedPipe(hRead, nil, 0, nil, @Total, nil) then
          begin
            if Total <> 0 then
            begin
              SetLength(Result, Total);
              if not ReadFile(hRead, Result[1], Total, I, nil) then
                Result := '';
            end;
          end else begin
            TerminateProcess(ProcessInfo.hProcess, 0);
            Result := '±‡“Î≥¨ ±';
          end;
        end;
        CloseHandle(ProcessInfo.hProcess);
        CloseHandle(ProcessInfo.hThread);
      end;

      CloseHandle(hRead);
      CloseHandle(hWrite);
    end;
  end;

  function TestRun: Boolean; inline;
  var
    tBegin, dwExitCode: DWORD;
    hPsApi: THandle;
    MemCtr: TProcessMemoryCounters;
  begin
    Result := False;
    bRtErr := False;
    MemSize := 0;
    FillChar(ProcessInfo, SizeOf(_PROCESS_INFORMATION), 0);
    FillChar(StartupInfo, SizeOf(TStartupInfo), 0);

    StartupInfo.cb := SizeOf(TStartupInfo);
    StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
    StartupInfo.wShowWindow := SW_HIDE;
    if CreateProcess(PChar(sEXE), nil, nil, nil, True, CREATE_SUSPENDED, PChar(szzEnv), PChar(szTempPath), StartupInfo, ProcessInfo) then
    begin
      ResumeThread(ProcessInfo.hThread);
      tBegin := GetTickCount;

      if WaitForSingleObject(ProcessInfo.hProcess, MaxTime) = WAIT_TIMEOUT then
      begin
        TerminateProcess(ProcessInfo.hProcess, 0);
      end else begin
        RunTime := GetTickCount - tBegin;
        if GetExitCodeProcess(ProcessInfo.hProcess, dwExitCode) then
          bRtErr := dwExitCode <> 0;
        if not bRtErr then
        begin
          if @GetProcessMemoryInfo = nil then
          begin
            hPsApi := LoadLibrary('PSAPI.dll');
            if hPsApi >= 32 then @GetProcessMemoryInfo := GetProcAddress(hPsApi, 'GetProcessMemoryInfo');
          end;
          if @GetProcessMemoryInfo <> nil then
          begin
            GetProcessMemoryInfo(ProcessInfo.hProcess, @MemCtr, SizeOf(MemCtr));
            MemSize := MemCtr.PeakPagefileUsage + MemCtr.PeakWorkingSetSize;
          end;
          Result := True;
        end;
      end;
      CloseHandle(ProcessInfo.hProcess);
      CloseHandle(ProcessInfo.hThread);
    end else
      bRtErr := True;
  end;
begin
  Result := 0;
  try
    while bRunning do
    begin
      p := DestProgram;
      while p <> nil do
      begin
        if not bIsJudge then Break;

        //Compile!
        sExt := ExtractFileExt(p.FullPath);
        sEXE := szTempPath + p.Name + '.exe';
        DeleteFile(PChar(sEXE));

        if StrComp_NoCase(PChar(sExt), '.pas') = 0 then
        begin
          if sFPC <> '' then
          begin
            sCompilerDir := ExtractFilePath(sFPC);
            sCmdline := '"'+sFPC+'" "'+p.FullPath+'"';
            p.Info := Compile;
  
            DeleteFile(PChar(ExtractFilePath(p.FullPath) + p.Name + '.o'));
            MoveFile(PChar(ExtractFilePath(p.FullPath) + p.Name + '.exe'), PChar(sEXE));
          end else
            p.Info := '±‡“Î∆˜≤ª¥Ê‘⁄';
        end else
        begin
          if StrComp_NoCase(PChar(sExt), '.c') = 0 then
          begin
            sCmdline := sGCC;
            sCompilerDir := ExtractFilePath(sGCC);
          end else begin
            sCmdline := sGPP;
            sCompilerDir := ExtractFilePath(sGPP);
          end;

          if sCmdline = '' then p.Info := '±‡“Î∆˜≤ª¥Ê‘⁄'
          else begin
            sCmdline := '"'+sCmdline+'" "'+p.FullPath+'" -o "'+sEXE+'"';
  
            p.Info := Compile;
          end;
        end;

        szzEnv := szDefEnv+sCompilerDir+#0;
  
        if iGetFileAttributes(PChar(sEXE)) = INVALID_HANDLE_VALUE then
        begin
          MainForm.tvres.TVItemStateImg[p.TVNode] := 3;
          MainForm.tvres.TVItemText[p.TVNode] := p.Name + ' [±‡“Î¥ÌŒÛ]';
  
          //calc maxmark
          d := p.TestData.Items;
          while d <> nil do
          begin
            Inc(p.MaxMark);
            d := d.Next;
          end;
        end else
        begin
          //begin!
          sInFile := szTempPath + p.Name + '.in';
          sOutFile := szTempPath + p.Name + '.out';
  
          d := p.TestData.Items;
          while d <> nil do
          begin
            //begin test
            SecDeleteFile(sOutFile);
            if CopyFile(PChar(d.inFullPath), PChar(sInFile), False) then
            begin
              imgIdx := 2;

              pt := AllocMem(SizeOf(TTestPoint));
              pt.Next := p.Points;
              pt.Name := d.Name;
              p.Points := pt;
  
              Inc(p.MaxMark);
              sTime := '';
              if TestRun then
              begin
                pt.Time := RunTime;
                pt.Memory := MemSize;

                sTime := Int2Str(RunTime) + 'ms, ' + Extended2StrDigits(MemSize/1048576, 2)+'MB';
                if MemSize > MaxMem then
                begin
                  sTime := 'ƒ⁄¥Ê“Á≥ˆ, ' + sTime;
                  imgIdx := 7;
                end else
                begin
                  if StandardCmp(sOutFile, d.outFullPath, pt.Info) then
                  begin
                    pt.Pass := True;
                    Inc(p.Mark);
                  end else begin
                    sTime := '¥∞∏¥ÌŒÛ, ' + sTime;
                    imgIdx := 6;
                  end;
                end;
              end else
              begin
                pt.Time := MAXDWORD;
                if bRtErr then
                begin
                  sTime := '‘À–– ±¥ÌŒÛ';
                  imgIdx := 4;
                end else
                begin
                  sTime := '≥¨ ±';
                  imgIdx := 5;
                end;
              end;

              T := MainForm.tvres.TVInsert(p.TVNode, MAXDWORD, pt.Name + ' ('+sTime+')');
              MainForm.tvres.TVItemData[T] := pt;
              MainForm.tvres.TVItemStateImg[T] := imgIdx;
              if not pt.Pass then MainForm.tvres.TVItemBold[T] := True;
            end;
            d := d.Next;

            //calc mark
            MainForm.tvres.TVItemText[p.TVNode] := p.Name + ' ('+Int2Str(p.Mark)+'/'+Int2Str(p.MaxMark)+')';
            MainForm.tvres.TVItemBold[p.TVNode] := True;
            MainForm.tvres.TVExpand(p.TVNode, TVE_EXPAND);

            //stop judge
            if not bIsJudge then Break;
          end;
        end;

        MainForm.pgb.Progress := MainForm.pgb.Progress + 1;
        p := p.Next;
      end;

      bIsJudge := False;

      MainForm.btnJudge.Enabled := True;
      MainForm.btnJudge.Caption := '÷«ƒ‹∆¿≤‚';
      MainForm.pgb.Hide;

      if not bRunning then Exit;
      
      SuspendThread(thrJudge);
    end;
  finally
    CloseHandle(thrJudge);
    thrJudge := 0;
  end;
end;

procedure TMainForm.bCfgClick(Sender: PObj);
var
  v: Boolean;
begin
  v := pCfg.Visible;
  pCfg.Visible := not v;
  tvres.Visible := v;
  mres.Visible := v;
  if v then bCfg.Caption := '≈‰÷√ >>'
  else bCfg.Caption := '≈‰÷√ <<';
end;

procedure TMainForm.btnJudgeClick(Sender: PObj);
var
  sCode, sData: String;
  attrCode, attrData: DWORD;
  p: PDestProgram;
begin
  if bIsJudge then
  begin
    btnJudge.Enabled := False;
    bIsJudge := False;
    Exit;
  end;

  //validate
  sCode := esrc.Text;
  sData := edata.Text;

  sGCC := egcc.Text;
  sGPP := egpp.Text;
  sFPC := efpc.Text;

  if iGetFileAttributes(PChar(sGCC)) = INVALID_HANDLE_VALUE then sGCC := '';
  if iGetFileAttributes(PChar(sGPP)) = INVALID_HANDLE_VALUE then sGPP := '';
  if iGetFileAttributes(PChar(sFPC)) = INVALID_HANDLE_VALUE then sFPC := '';

  attrCode := iGetFileAttributes(PChar(sCode));
  if attrCode = INVALID_HANDLE_VALUE then
  begin
    MessageBoxA(Form.Handle, '≥Ã–Ú¥˙¬Î≤ª¥Ê‘⁄', sErr, MB_ICONHAND);
    Exit;
  end;

  attrData := iGetFileAttributes(PChar(sData));
  if (attrData = INVALID_HANDLE_VALUE) or (attrData and FILE_ATTRIBUTE_DIRECTORY = 0) then
  begin
    MessageBoxA(Form.Handle, ' ‰»Îƒø¬º≤ª¥Ê‘⁄', sErr, MB_ICONHAND);
    Exit;
  end;

  ClearData;
  formatPath(sData);
  FindTestData(sData);

  tvres.BeginUpdate;
  tvres.Clear;
  if (attrCode and FILE_ATTRIBUTE_DIRECTORY) = 0 then FindSingleProgram(sCode, '')
  else begin
    formatPath(sCode);
    FindTestProgram(sCode);
  end;
  //expand all
  tvres.TVExpand(0, TVE_EXPAND);
  tvres.EndUpdate;

  if DestProgram <> nil then
  begin
    MaxTime := Str2Int(etime.Text);
    MaxCompileTime := Str2Int(ecmptime.Text);
    MaxMem := 1048576*Str2Int(emem.Text);

    attrCode := 0;
    p := DestProgram;
    while p <> nil do
    begin
      Inc(attrCode);
      p := p.Next;
    end;

    pgb.MaxProgress := attrCode;
    pgb.Progress := 0;
    pgb.Show;

    bIsJudge := True;
    btnJudge.Caption := 'Õ£÷π';

    IsMultiThread := TRUE;
    if thrJudge = 0 then thrJudge := CreateThread(nil, 0, @JudgeThread, nil, 0, attrCode)
    else ResumeThread(thrJudge);
  end;
end;
{var
  sCode, sData, sExt: String;
  attrCode, attrData: DWORD;
  F: TFindFileData;
begin
  //validate
  sCode := esrc.Text;
  sData := edata.Text;

  attrCode := iGetFileAttributes(PChar(sCode));
  if attrCode = INVALID_HANDLE_VALUE then
  begin
    MessageBoxA(Form.Handle, '≥Ã–Ú¥˙¬Î≤ª¥Ê‘⁄', sErr, MB_ICONHAND);
    Exit;
  end;

  attrData := iGetFileAttributes(PChar(sData));
  if (attrData = INVALID_HANDLE_VALUE) or (attrData and FILE_ATTRIBUTE_DIRECTORY = 0) then
  begin
    MessageBoxA(Form.Handle, ' ‰»Îƒø¬º≤ª¥Ê‘⁄', sErr, MB_ICONHAND);
    Exit;
  end;
  formatPath(sData);

  //judge type
  lvres.Clear;
  btnJudge.Enabled := False;
  if (attrCode and FILE_ATTRIBUTE_DIRECTORY) = 0 then JudgeOnce(sCode, sData)
  else begin
    formatPath(sCode);
    if Find_First(sCode + '*', F) then
    begin
      repeat
        if F.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY = 0 then
        begin
          sExt := LowerCase(ExtractFileExt(F.cFileName));
          if (sExt = '.pas') or (sExt = '.c') or (sExt = '.cpp') then JudgeOnce(sCode + F.cFileName, sData);
        end;
      until (not Find_Next(F));
      Find_Close(F);
    end;
  end;
  btnJudge.Enabled := True;
end;}

procedure TMainForm.KOLFormClose(Sender: PObj; var Accept: Boolean);
begin
  Accept := True;
  bIsJudge := False;
  bRunning := False;
  ResumeThread(thrJudge);
  WaitForSingleObject(thrJudge, MaxTime*2);
end;

procedure TMainForm.KOLFormCreate(Sender: PObj);
var
  szCompiler, szDir: String;
  D: DWORD;
begin
  szDir := ExtractFilePath(ParamStr(0)) + 'compiler\';
  if IsWin64 then szCompiler := szDir + 'x64\bin\'
  else szCompiler := szDir + 'x86\bin\';

  D := GetTempPath(0, nil);
  SetLength(szTempPath, D-1);
  GetTempPath(D, PChar(szTempPath));
  formatPath(szTempPath);
  szTempPath := szTempPath + 'ijudge\';

  if iGetFileAttributes(PChar(szCompiler)) <> INVALID_HANDLE_VALUE then
  begin
    egcc.Text := szCompiler + 'gcc.exe';
    egpp.Text := szCompiler + 'g++.exe';
    efpc.Text := szCompiler + 'fpc.exe';

    egcc.Enabled := False;
    egpp.Enabled := False;
    efpc.Enabled := False;
  end;

  esrc.AttachProc(@WndProcDropFiles);
  edata.AttachProc(@WndProcDropFiles);

  DragAcceptFiles(esrc.Handle, True);
  DragAcceptFiles(edata.Handle, True);

  if egcc.Enabled then
  begin
    egcc.AttachProc(@WndProcDropFiles);
    DragAcceptFiles(egcc.Handle, True);
  end;

  if egpp.Enabled then
  begin
    egpp.AttachProc(@WndProcDropFiles);
    DragAcceptFiles(egpp.Handle, True);
  end;

  if efpc.Enabled then
  begin
    efpc.AttachProc(@WndProcDropFiles);
    DragAcceptFiles(efpc.Handle, True);
  end;

  cbTopClick(nil);

  if iGetFileAttributes(PChar(szTempPath)) <> INVALID_HANDLE_VALUE then EmptyDir(szTempPath);
  CreateDirectory(PChar(szTempPath), nil);

  //Build ENV
  D := GetSystemDirectory(nil, 0);
  SetLength(szDefEnv, D-1);
  GetSystemDirectory(PChar(szDefEnv), D);
  szDefEnv := 'PATH='+szDefEnv+';';
end;

procedure TMainForm.KOLFormDestroy(Sender: PObj);
begin
  ClearData;
end;

var
  lastData: Pointer = nil;

procedure TMainForm.tvresChange(Sender: PObj);
const
  HTVRes = 364;
  HLTVRes = HTVRes-64-5;

var
  Data: Pointer;
  Img: Integer;

  procedure HideMRes;
  begin
    tvres.Height := HTVRes;
    mres.Hide;
  end;
  procedure ShowMRes;
  begin
    tvres.Height := HLTVRes;
    mres.Show;
  end;
begin
  Img := tvres.TVSelected;
  Data := tvres.TVItemData[Img];
  if Data <> lastData then
  begin
    if Data = nil then HideMRes
    else begin
      Img := tvres.TVItemStateImg[Img];
      if Img = 3 then //compile error
      begin
        mres.Text := PDestProgram(Data).Info;
        ShowMRes;
      end else if Img = 6 then
      begin
        mres.Text := PTestPoint(Data).Info;
        ShowMRes;
      end else
        HideMRes;
    end;
    lastData := Data;
  end;
end;

end.
