unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.ExtCtrls, Winapi.TlHelp32, Winapi.ShellAPI;

type
  TForm1 = class(TForm)
    grdpnl1: TGridPanel;
    pnl1: TPanel;
    processTable1: TStringGrid;
    btnRefresh: TButton;
    btnForceClose: TButton;
    selected: TLabel;
    btnRun: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure processTable1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnForceCloseClick(Sender: TObject);
    procedure processTable1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btnRunClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  aColWidth : array of Integer;

implementation
{$R *.dfm}
procedure populateList;
var handler: THandle;
    data   : TProcessEntry32;
    index  : Integer;

    function GetName: string;
    var i: Byte;
    begin
      Result := '';
      i := 0;
      while data.szExeFile[i] <> '' do
      begin
        Result := Result + data.szExeFile[i];
        Inc(i);
      end;
    end;
begin
   handler := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
   data.dwSize := SizeOf(TProcessEntry32);
   if Process32First(handler, data) then
   begin
         index := 0;
         while Process32Next(handler, data) do
         begin
              index := index + 1;
              Form1.processTable1.Cells[0,index] := IntToStr(data.th32ProcessID);
              Form1.processTable1.Cells[1,index] := IntToStr(data.th32ParentProcessID);
              Form1.processTable1.Cells[2,index] := IntToStr(data.cntThreads);
              Form1.processTable1.Cells[3,index] := GetName();

              Form1.processTable1.RowCount :=  Form1.processTable1.RowCount + 1;
         end;
         Form1.processTable1.RowCount :=  Form1.processTable1.RowCount - 1;
   end;
end;

procedure TForm1.btnForceCloseClick(Sender: TObject);
begin
     TerminateProcess(OpenProcess(PROCESS_ALL_ACCESS,False,StrToInt(processTable1.Cells[0,processTable1.Row])),0);
     btnRefreshClick(Sender);
end;

procedure TForm1.btnRefreshClick(Sender: TObject);
var
   I: Integer;
begin
     for I := 0 to processTable1.ColCount - 1 do
         processTable1.Cols[I].Clear;
     processTable1.RowCount := 2;
     FormShow(Sender);
end;

procedure TForm1.btnRunClick(Sender: TObject);
var
   fileName : string;
begin
     //Simulate pressing win+r to open the system run dialog
     keybd_event(VK_LWIN, 0, WM_KEYDOWN, 0);
     keybd_event(Ord('R'), 0, WM_KEYDOWN, 0);
     keybd_event(VK_LWIN, 0, KEYEVENTF_KEYUP, 0);
     keybd_event(Ord('R'), 0, KEYEVENTF_KEYUP, 0);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
i : Integer;
begin
     SetLength(aColWidth, processTable1.ColCount);
     for I := 0 to Length(aColWidth)-1 do
       aColWidth[i] := processTable1.ColWidths[i];
end;

procedure TForm1.FormShow(Sender: TObject);
begin
     processTable1.Cells[0,0] := 'PID';
     processTable1.Cells[1,0] := 'pPID';
     processTable1.Cells[2,0] := '#Th';
     processTable1.Cells[3,0] := 'Name';
     populateList;
end;

procedure TForm1.processTable1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
   iWidth : Integer;
begin
     iWidth := processTable1.Canvas.TextWidth(processTable1.Cells[ACol, ARow]);
     if iWidth > aColWidth[ACol] then
        aColWidth[ACol] := iWidth;

     processTable1.ColWidths[ACol] := aColWidth[ACol];
end;

procedure TForm1.processTable1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
     btnForceClose.Enabled := true;
     selected.Caption := 'Selected PID #' + processTable1.Cells[0, ARow] + #13 + processTable1.Cells[3, ARow];
end;

end.
