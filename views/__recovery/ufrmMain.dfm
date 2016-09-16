object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Delphi x Parse'
  ClientHeight = 490
  ClientWidth = 752
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
    Width = 752
    Height = 247
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 440
    Width = 752
    Height = 50
    Align = alBottom
    Caption = 'Users'
    TabOrder = 1
    ExplicitWidth = 711
    object edUsername: TEdit
      Left = 8
      Top = 16
      Width = 73
      Height = 21
      TabOrder = 0
      TextHint = 'Username...'
    end
    object edPassword: TEdit
      Left = 88
      Top = 16
      Width = 75
      Height = 21
      TabOrder = 1
      TextHint = 'Password...'
    end
    object edEmail: TEdit
      Left = 168
      Top = 16
      Width = 89
      Height = 21
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
  object PageControl1: TPageControl
    Left = 0
    Top = 247
    Width = 752
    Height = 193
    ActivePage = TabSheet2
    Align = alBottom
    TabOrder = 2
    ExplicitLeft = 184
    ExplicitTop = 168
    ExplicitWidth = 489
    object TabSheet1: TTabSheet
      Caption = 'Send Message'
      ExplicitWidth = 281
      object editUser: TEdit
        Left = 8
        Top = 20
        Width = 121
        Height = 21
        TabOrder = 0
        TextHint = 'Usu'#225'rio...'
      end
      object editMessage: TEdit
        Left = 8
        Top = 44
        Width = 281
        Height = 21
        TabOrder = 1
        TextHint = 'Mensagem...'
      end
      object btnSend: TButton
        Left = 296
        Top = 44
        Width = 89
        Height = 21
        Caption = 'Send Message'
        TabOrder = 2
        OnClick = btnSendClick
      end
      object btnUpdate: TButton
        Left = 8
        Top = 84
        Width = 89
        Height = 21
        Caption = 'Update Message'
        TabOrder = 3
        OnClick = btnDeleteClick
      end
      object btnDelete: TButton
        Left = 104
        Top = 84
        Width = 89
        Height = 21
        Caption = 'Delete Message'
        TabOrder = 4
        OnClick = btnDeleteClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Query'
      ImageIndex = 1
      ExplicitWidth = 481
      object Label3: TLabel
        Left = 280
        Top = 0
        Width = 23
        Height = 13
        Caption = 'Keys'
      end
      object btnGetAll: TButton
        Left = 280
        Top = 76
        Width = 185
        Height = 25
        Caption = 'Get All'
        TabOrder = 0
        TabStop = False
        OnClick = btnGetAllClick
      end
      object btnEqual: TButton
        Left = 8
        Top = 39
        Width = 75
        Height = 25
        Caption = 'EqualTo'
        TabOrder = 1
        TabStop = False
        OnClick = btnEqualClick
      end
      object btnStartsWith: TButton
        Left = 88
        Top = 39
        Width = 81
        Height = 25
        Caption = 'StartsWith'
        TabOrder = 2
        TabStop = False
        OnClick = btnStartsWithClick
      end
      object btnContains: TButton
        Left = 173
        Top = 39
        Width = 89
        Height = 25
        Caption = 'Contains'
        TabOrder = 3
        TabStop = False
        OnClick = btnContainsClick
      end
      object editEqual: TEdit
        Left = 8
        Top = 14
        Width = 73
        Height = 21
        TabStop = False
        TabOrder = 4
        TextHint = 'Usu'#225'rio...'
      end
      object editStarts: TEdit
        Left = 88
        Top = 14
        Width = 81
        Height = 21
        TabStop = False
        TabOrder = 5
        TextHint = 'Usu'#225'rio...'
      end
      object editContains: TEdit
        Left = 173
        Top = 14
        Width = 89
        Height = 21
        TabStop = False
        TabOrder = 6
        TextHint = 'Mensagem...'
      end
      object btnJsonToMemo: TButton
        Left = 8
        Top = 68
        Width = 75
        Height = 25
        Caption = 'JsonToMemo'
        TabOrder = 7
        TabStop = False
        OnClick = btnJsonToMemoClick
      end
      object btnJsonToObj: TButton
        Left = 88
        Top = 68
        Width = 81
        Height = 25
        Caption = 'JsonToObj'
        TabOrder = 8
        TabStop = False
        OnClick = btnJsonToObjClick
      end
      object memoKeys: TMemo
        Left = 280
        Top = 16
        Width = 185
        Height = 57
        TabOrder = 9
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Order'
      ImageIndex = 2
      ExplicitWidth = 481
      object Label1: TLabel
        Left = 216
        Top = 8
        Width = 80
        Height = 13
        Caption = 'Ascending Order'
      end
      object Label2: TLabel
        Left = 216
        Top = 88
        Width = 86
        Height = 13
        Caption = 'Descending Order'
      end
      object edOrderBy: TEdit
        Left = 8
        Top = 14
        Width = 185
        Height = 21
        TabStop = False
        TabOrder = 0
        TextHint = 'Order by...'
      end
      object btnOrderAsc: TButton
        Left = 8
        Top = 37
        Width = 185
        Height = 25
        Caption = 'Add Ascending Order'
        TabOrder = 1
        TabStop = False
        OnClick = btnOrderAscClick
      end
      object btnOrderDesc: TButton
        Left = 8
        Top = 64
        Width = 185
        Height = 25
        Caption = 'Add Ascending Order'
        TabOrder = 2
        TabStop = False
        OnClick = btnOrderDescClick
      end
      object Button3: TButton
        Left = 424
        Top = 22
        Width = 185
        Height = 25
        Caption = 'Get Simple List'
        TabOrder = 3
        TabStop = False
        OnClick = Button3Click
      end
      object memoOrderAsc: TMemo
        Left = 216
        Top = 24
        Width = 185
        Height = 57
        TabOrder = 4
      end
      object Button1: TButton
        Left = 8
        Top = 91
        Width = 185
        Height = 25
        Caption = 'Clear Orders'
        TabOrder = 5
        TabStop = False
        OnClick = Button1Click
      end
      object memoOrderDesc: TMemo
        Left = 216
        Top = 104
        Width = 185
        Height = 57
        TabOrder = 6
      end
    end
  end
end
