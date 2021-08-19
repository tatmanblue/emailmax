inherited dlgDisplayYesNoCancel: TdlgDisplayYesNoCancel
  Caption = ''
  ClientHeight = 279
  ClientWidth = 391
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [2]
    Left = 9
    Top = 169
    Width = 74
    Height = 13
    Caption = 'Click on Yes to:'
  end
  object Label2: TLabel [3]
    Left = 9
    Top = 191
    Width = 70
    Height = 13
    Caption = 'Click on No to:'
  end
  object Label3: TLabel [4]
    Left = 9
    Top = 213
    Width = 89
    Height = 13
    Caption = 'Click on Cancel to:'
  end
  object txtYesAction: TLabel [5]
    Left = 110
    Top = 171
    Width = 264
    Height = 13
    AutoSize = False
  end
  object txtNoAction: TLabel [6]
    Left = 110
    Top = 192
    Width = 266
    Height = 13
    AutoSize = False
  end
  object txtCancelAction: TLabel [7]
    Left = 110
    Top = 212
    Width = 263
    Height = 13
    AutoSize = False
  end
  object pbNo: TButton [11]
    Left = 222
    Top = 244
    Width = 75
    Height = 25
    Caption = '&No'
    TabOrder = 2
    OnClick = pbNoClick
  end
  object pbYes: TButton [12]
    Left = 145
    Top = 244
    Width = 75
    Height = 25
    Caption = '&Yes'
    TabOrder = 3
    OnClick = pbYesClick
  end
  inherited pbClose: TButton
    Left = 298
    Top = 244
    Caption = 'Cancel'
  end
  inherited txtDetails: TMemo
    Top = 70
    Width = 367
    Height = 87
  end
end
