inherited wndComplete: TwndComplete
  Left = 29
  Top = 132
  Width = 651
  Height = 484
  Caption = 'Sent -- email sent...'
  Menu = mnCompleteMenu
  PopupMenu = mnCompletePopup
  PixelsPerInch = 96
  TextHeight = 13
  inherited ctlSplitter: TSplitter
    Top = 245
    Width = 643
  end
  inherited ctlTop: TPanel
    Width = 643
    Height = 12
  end
  inherited ctlMessages: TListView
    Top = 12
    Width = 643
    Height = 233
    Columns = <
      item
        Caption = 'To'
      end
      item
        Caption = 'Subject'
        Width = 125
      end
      item
        Caption = 'Date'
        Width = 75
      end
      item
        Caption = 'Send From'
        Width = 75
      end>
  end
  inherited pnlPreview: TPanel
    Top = 252
    Width = 643
    inherited Panel2: TPanel
      Width = 643
      inherited Panel1: TPanel
        Left = 588
      end
    end
    inherited ctrlPreviewBody: TMemo
      Width = 643
    end
  end
  object mnCompleteMenu: TMainMenu
    AutoMerge = True
    Left = 178
    Top = 80
    object mnCompleteItem: TMenuItem
      Caption = '&Done'
      GroupIndex = 31
      object mnCompleteItemOpen: TMenuItem
        Caption = '&Open'
        Enabled = False
        OnClick = mnCompleteOpenClick
      end
      object mnCompMoveTo: TMenuItem
        Caption = '&Move To...'
        Enabled = False
        Hint = 'Move messages to another folder'
      end
      object mnCompSep1: TMenuItem
        Caption = '-'
      end
      object mnCompleteItemDelete: TMenuItem
        Caption = 'Dele&te'
        Enabled = False
        OnClick = mnCompleteDeleteClick
      end
      object mnCompleteItemDeleteAll: TMenuItem
        Caption = 'Delete &All'
        Enabled = False
      end
    end
  end
  object mnCompletePopup: TPopupMenu
    Left = 296
    Top = 85
    object mnCompletePopOpen: TMenuItem
      Caption = '&Open'
      OnClick = mnCompleteOpenClick
    end
    object mnCompletePopMoveTo: TMenuItem
      Caption = '&Move To...'
      OnClick = mnCompleteMoveClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnCompletePopDelete: TMenuItem
      Caption = '&Delete'
      OnClick = mnCompleteDeleteClick
    end
    object mnCompletePopDelAll: TMenuItem
      Caption = 'Delete &All'
      OnClick = mnCompleteDeleteAllClick
    end
  end
end
