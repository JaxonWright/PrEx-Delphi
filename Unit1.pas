unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.ExtCtrls, Winapi.TlHelp32, Winapi.ShellAPI, System.Math;

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
    procedure FormResize(Sender: TObject);
    procedure processTable1FixedCellClick(Sender: TObject; ACol, ARow: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TStringGridHelper = class helper  for TStringGrid
    procedure SortColRow(IsColumn: Boolean; Index: Integer; IsNumbers: Boolean); overload;
    procedure SortColRow(IsColumn: Boolean; Index: Integer; FromIndex: Integer; ToIndex: Integer; IsNumbers: Boolean); overload;
  end;

var
  Form1: TForm1;
  aColWidth : array of Integer;

implementation
{$R *.dfm}
procedure TStringGridHelper.SortColRow(IsColumn: Boolean; Index: Integer; IsNumbers: Boolean);
begin
     if (IsColumn) then SortColRow(IsColumn, Index, FixedCols, ColCount - 1, IsNumbers)
     else SortColRow(IsColumn, Index, FixedRows, RowCount - 1, IsNumbers)
end;

procedure TStringGridHelper.SortColRow(IsColumn: Boolean; Index: Integer; FromIndex: Integer; ToIndex: Integer; IsNumbers: Boolean);
    var i, p, x, c : Integer;
    s1, s2 : String;
begin

    if (IsColumn) then
    begin
        for x := ToIndex downto FromIndex do
            for I := FromIndex to ToIndex - 1 do
            begin
                s1 := Cells[i, index];
                s2 := Cells[i + 1, index];

                if IsNumbers then
                begin
                    c := CompareValue(StrToInt(s1), StrToInt(s2));
                end
                else
                begin
                    c := AnsiCompareStr(s1, s2);
                end;

                if (c > 0) then
                begin
                    p := i + 1;
                    p := Max(p, FromIndex);
                    p := Min(p, ToIndex);

                    MoveColumn(i, p);
                end;
            end;
    end
    else
    begin
        for x := ToIndex downto FromIndex do
            for I := FromIndex to ToIndex - 1 do
            begin
                s1 := Cells[index, i];
                s2 := Cells[index, i + 1];
                if IsNumbers then
                begin
                    c := CompareValue(StrToInt(s1), StrToInt(s2));
                end
                else
                begin
                    c := AnsiCompareStr(s1, s2);
                end;

                if (c > 0) then
                begin
                    p := i + 1;
                    p := Max(p, FromIndex);
                    p := Min(p, ToIndex);

                    MoveRow(i, p);
                end;
            end;
    end;
end;

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
procedure SetColumnFullWidth(Grid: TStringGrid; ACol: Integer);
var
  I: Integer;
  FixedWidth: Integer;
begin
  with Grid do
    if ACol >= FixedCols then
    begin
      FixedWidth := 0;
      for I := 0 to FixedCols - 1 do
        Inc(FixedWidth, ColWidths[I] + GridLineWidth);
      ColWidths[ACol] := ClientWidth - FixedWidth - GridLineWidth - 110;
    end;
end;

procedure TForm1.btnForceCloseClick(Sender: TObject);
begin
     TerminateProcess(OpenProcess(PROCESS_ALL_ACCESS,False,StrToInt(processTable1.Cells[0,processTable1.Row])),0);
     btnRefreshClick(Sender);
     btnForceClose.Enabled := false;
     selected.Caption := '';
end;

procedure TForm1.btnRefreshClick(Sender: TObject);
var
   I: Integer;
begin
     for I := 0 to processTable1.ColCount - 1 do
         processTable1.Cols[I].Clear;
     processTable1.RowCount := 2;
     FormShow(Sender);
     btnForceClose.Enabled := false;
     selected.Caption := '';
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

procedure TForm1.FormResize(Sender: TObject);
begin
     SetColumnFullWidth(processTable1, 3);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
     processTable1.Cells[0,0] := 'PID';
     processTable1.Cells[1,0] := 'pPID';
     processTable1.Cells[2,0] := '#Th';
     processTable1.Cells[3,0] := 'Name';
     populateList;
     SetColumnFullWidth(processTable1, 3);
     processTable1.SortColRow(False, 3, False);
end;

procedure TForm1.processTable1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
   iWidth : Integer;
begin
     if ACol = 3 then Exit;
     
     iWidth := processTable1.Canvas.TextWidth(processTable1.Cells[ACol, ARow]);
     if iWidth > aColWidth[ACol] then
        aColWidth[ACol] := iWidth;

     processTable1.ColWidths[ACol] := aColWidth[ACol];
end;

procedure TForm1.processTable1FixedCellClick(Sender: TObject; ACol,
  ARow: Integer);
begin
     if ACol = 3 then
     begin
          processTable1.SortColRow(false, 3, false);
     end
     else
     begin
          processTable1.SortColRow(false, ACol, true);
     end;

end;

procedure TForm1.processTable1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
     btnForceClose.Enabled := true;
     selected.Caption := 'Selected PID #' + processTable1.Cells[0, ARow] + #13 + processTable1.Cells[3, ARow];

end;

end.
