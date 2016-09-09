object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Delphi x Parse'
  ClientHeight = 478
  ClientWidth = 711
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object memResult: TMemo
    Left = 0
    Top = 0
    Width = 711
    Height = 384
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 0
    ExplicitHeight = 400
  end
  object Panel1: TPanel
    Left = 0
    Top = 384
    Width = 711
    Height = 94
    Align = alBottom
    TabOrder = 1
    object editUser: TEdit
      Left = 8
      Top = 8
      Width = 121
      Height = 21
      TabOrder = 0
      TextHint = 'Usu'#225'rio...'
    end
    object editMessage: TEdit
      Left = 136
      Top = 8
      Width = 297
      Height = 21
      TabOrder = 1
      TextHint = 'Mensagem...'
    end
    object btnSend: TButton
      Left = 440
      Top = 8
      Width = 89
      Height = 21
      Caption = 'Send Messsage'
      TabOrder = 2
      OnClick = btnSendClick
    end
    object btnGetAll: TButton
      Left = 8
      Top = 64
      Width = 75
      Height = 25
      Caption = 'Get All'
      TabOrder = 3
      TabStop = False
      OnClick = btnGetAllClick
    end
    object btnJsonToObj: TButton
      Left = 628
      Top = 64
      Width = 75
      Height = 25
      Caption = 'JsonToObj'
      TabOrder = 4
      TabStop = False
      OnClick = btnJsonToObjClick
    end
    object btnJsonToMemo: TButton
      Left = 535
      Top = 64
      Width = 89
      Height = 25
      Caption = 'JsonToMemo'
      TabOrder = 5
      TabStop = False
      OnClick = btnJsonToMemoClick
    end
    object btnEqual: TButton
      Left = 88
      Top = 64
      Width = 75
      Height = 25
      Caption = 'EqualTo'
      TabOrder = 6
      TabStop = False
      OnClick = btnEqualClick
    end
    object btnStartsWith: TButton
      Left = 168
      Top = 64
      Width = 75
      Height = 25
      Caption = 'StartsWith'
      TabOrder = 7
      TabStop = False
      OnClick = btnStartsWithClick
    end
    object btnContains: TButton
      Left = 248
      Top = 64
      Width = 89
      Height = 25
      Caption = 'Contains'
      TabOrder = 8
      TabStop = False
      OnClick = btnContainsClick
    end
    object editEqual: TEdit
      Left = 88
      Top = 40
      Width = 73
      Height = 21
      TabStop = False
      TabOrder = 9
      TextHint = 'Usu'#225'rio...'
    end
    object editStarts: TEdit
      Left = 168
      Top = 40
      Width = 75
      Height = 21
      TabStop = False
      TabOrder = 10
      TextHint = 'Usu'#225'rio...'
    end
    object editContains: TEdit
      Left = 248
      Top = 40
      Width = 89
      Height = 21
      TabStop = False
      TabOrder = 11
      TextHint = 'Mensagem...'
    end
  end
end
