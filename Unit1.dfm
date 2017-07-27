object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'PrEx'
  ClientHeight = 549
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  StyleElements = [seFont, seClient]
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object grdpnl1: TGridPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 388
    Height = 543
    Align = alClient
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 100.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = pnl1
        Row = 0
      end
      item
        Column = 1
        Control = processTable1
        Row = 0
      end>
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 0
    object pnl1: TPanel
      Left = 1
      Top = 1
      Width = 100
      Height = 541
      Align = alClient
      TabOrder = 0
      object selected: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 66
        Width = 92
        Height = 11
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 3
      end
      object btnRefresh: TButton
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 92
        Height = 25
        Align = alTop
        Caption = 'Refresh List'
        TabOrder = 0
        OnClick = btnRefreshClick
      end
      object btnForceClose: TButton
        AlignWithMargins = True
        Left = 4
        Top = 35
        Width = 92
        Height = 25
        Align = alTop
        Caption = 'Force Close'
        Enabled = False
        TabOrder = 1
        OnClick = btnForceCloseClick
      end
      object btnRun: TButton
        Left = 1
        Top = 515
        Width = 98
        Height = 25
        Align = alBottom
        Caption = 'Run...'
        TabOrder = 2
        OnClick = btnRunClick
      end
    end
    object processTable1: TStringGrid
      Left = 101
      Top = 1
      Width = 286
      Height = 541
      Align = alClient
      ColCount = 4
      Ctl3D = True
      DefaultColWidth = 100
      DragKind = dkDock
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goFixedRowClick]
      ParentCtl3D = False
      TabOrder = 1
      OnDrawCell = processTable1DrawCell
      OnFixedCellClick = processTable1FixedCellClick
      OnSelectCell = processTable1SelectCell
      ColWidths = (
        38
        38
        31
        152)
    end
  end
end
