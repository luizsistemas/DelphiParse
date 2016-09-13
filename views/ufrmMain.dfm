object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Delphi x Parse'
  ClientHeight = 490
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
    Height = 328
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 335
    Width = 711
    Height = 105
    Align = alBottom
    Caption = 'Messages'
    TabOrder = 1
    ExplicitTop = 312
    object btnGetAll: TButton
      Left = 264
      Top = 75
      Width = 75
      Height = 25
      Caption = 'Get All'
      TabOrder = 9
      TabStop = False
      OnClick = btnGetAllClick
    end
    object btnEqual: TButton
      Left = 8
      Top = 75
      Width = 75
      Height = 25
      Caption = 'EqualTo'
      TabOrder = 6
      TabStop = False
      OnClick = btnEqualClick
    end
    object btnStartsWith: TButton
      Left = 88
      Top = 75
      Width = 75
      Height = 25
      Caption = 'StartsWith'
      TabOrder = 7
      TabStop = False
      OnClick = btnStartsWithClick
    end
    object btnContains: TButton
      Left = 168
      Top = 75
      Width = 89
      Height = 25
      Caption = 'Contains'
      TabOrder = 8
      TabStop = False
      OnClick = btnContainsClick
    end
    object editEqual: TEdit
      Left = 8
      Top = 50
      Width = 73
      Height = 21
      TabStop = False
      TabOrder = 3
      TextHint = 'Usu'#225'rio...'
    end
    object editStarts: TEdit
      Left = 88
      Top = 50
      Width = 75
      Height = 21
      TabStop = False
      TabOrder = 4
      TextHint = 'Usu'#225'rio...'
    end
    object editContains: TEdit
      Left = 168
      Top = 50
      Width = 89
      Height = 21
      TabStop = False
      TabOrder = 5
      TextHint = 'Mensagem...'
    end
    object editUser: TEdit
      Left = 8
      Top = 24
      Width = 121
      Height = 21
      TabOrder = 0
      TextHint = 'Usu'#225'rio...'
    end
    object editMessage: TEdit
      Left = 136
      Top = 24
      Width = 297
      Height = 21
      TabOrder = 1
      TextHint = 'Mensagem...'
    end
    object btnSend: TButton
      Left = 440
      Top = 24
      Width = 89
      Height = 21
      Caption = 'Send Message'
      TabOrder = 2
      OnClick = btnSendClick
    end
    object btnJsonToMemo: TButton
      Left = 344
      Top = 75
      Width = 89
      Height = 25
      Caption = 'JsonToMemo'
      TabOrder = 10
      TabStop = False
      OnClick = btnJsonToMemoClick
    end
    object btnJsonToObj: TButton
      Left = 438
      Top = 75
      Width = 75
      Height = 25
      Caption = 'JsonToObj'
      TabOrder = 11
      TabStop = False
      OnClick = btnJsonToObjClick
    end
    object btnDelete: TButton
      Left = 536
      Top = 24
      Width = 89
      Height = 21
      Caption = 'Delete Message'
      TabOrder = 12
      OnClick = btnDeleteClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 440
    Width = 711
    Height = 50
    Align = alBottom
    Caption = 'Users'
    TabOrder = 2
    object edUsername: TEdit
      Left = 8
      Top = 16
      Width = 73
      Height = 25
      TabOrder = 0
      TextHint = 'Username...'
    end
    object edPassword: TEdit
      Left = 88
      Top = 16
      Width = 75
      Height = 25
      TabOrder = 1
      TextHint = 'Password...'
    end
    object edEmail: TEdit
      Left = 168
      Top = 16
      Width = 89
      Height = 25
      TabOrder = 2
      TextHint = 'E-mail....'
    end
    object btnInsertUser: TButton
      Left = 264
      Top = 16
      Width = 67
      Height = 25
      Caption = 'Insert'
      TabOrder = 3
      OnClick = btnInsertUserClick
    end
    object btnLogin: TButton
      Left = 336
      Top = 16
      Width = 67
      Height = 25
      Caption = 'Login'
      TabOrder = 4
      OnClick = btnLoginClick
    end
    object btnLogout: TButton
      Left = 408
      Top = 16
      Width = 67
      Height = 25
      Caption = 'LogOut'
      TabOrder = 5
      OnClick = btnLogoutClick
    end
    object btnCurrentUser: TButton
      Left = 480
      Top = 16
      Width = 73
      Height = 25
      Caption = 'CurrentUser'
      TabOrder = 6
      OnClick = btnCurrentUserClick
    end
  end
end
