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
    Height = 292
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
    Top = 292
    Width = 752
    Height = 148
    ActivePage = TabSheet3
    Align = alBottom
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Send Message'
      object editUser: TEdit
        Left = 8
        Top = 20
        Width = 121
        Height = 21
        TabOrder = 0
        TextHint = 'Usu'#225'rio...'
      end
      object editMessage: TEdit
        Left = 136
        Top = 20
        Width = 281
        Height = 21
        TabOrder = 1
        TextHint = 'Mensagem...'
      end
      object btnSend: TButton
        Left = 424
        Top = 20
        Width = 89
        Height = 21
        Caption = 'Send Message'
        TabOrder = 2
        OnClick = btnSendClick
      end
      object btnUpdate: TButton
        Left = 520
        Top = 20
        Width = 89
        Height = 21
        Caption = 'Update Message'
        TabOrder = 3
        OnClick = btnDeleteClick
      end
      object btnDelete: TButton
        Left = 616
        Top = 20
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
      ExplicitLeft = 36
      ExplicitTop = 32
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
        TabOrder = 6
        TabStop = False
        OnClick = btnGetAllClick
      end
      object btnEqual: TButton
        Left = 8
        Top = 7
        Width = 75
        Height = 25
        Caption = 'EqualTo'
        TabOrder = 0
        TabStop = False
        OnClick = btnEqualClick
      end
      object btnStartsWith: TButton
        Left = 88
        Top = 7
        Width = 81
        Height = 25
        Caption = 'StartsWith'
        TabOrder = 1
        TabStop = False
        OnClick = btnStartsWithClick
      end
      object btnContains: TButton
        Left = 173
        Top = 7
        Width = 89
        Height = 25
        Caption = 'Contains'
        TabOrder = 2
        TabStop = False
        OnClick = btnContainsClick
      end
      object btnJsonToMemo: TButton
        Left = 576
        Top = 7
        Width = 75
        Height = 25
        Caption = 'JsonToMemo'
        TabOrder = 3
        TabStop = False
        OnClick = btnJsonToMemoClick
      end
      object btnJsonToObj: TButton
        Left = 656
        Top = 7
        Width = 81
        Height = 25
        Caption = 'JsonToObj'
        TabOrder = 4
        TabStop = False
        OnClick = btnJsonToObjClick
      end
      object memoKeys: TMemo
        Left = 280
        Top = 16
        Width = 185
        Height = 57
        Hint = 'Enter the fields or leave blank for all fields'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
      object btnLessThen: TButton
        Left = 8
        Top = 36
        Width = 75
        Height = 25
        Caption = 'Less Then'
        TabOrder = 7
        TabStop = False
        OnClick = btnLessThenClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Order'
      ImageIndex = 2
      object Label1: TLabel
        Left = 8
        Top = 5
        Width = 80
        Height = 13
        Caption = 'Ascending Order'
      end
      object Label2: TLabel
        Left = 200
        Top = 5
        Width = 86
        Height = 13
        Caption = 'Descending Order'
      end
      object Button3: TButton
        Left = 200
        Top = 83
        Width = 185
        Height = 25
        Caption = 'Get Simple List'
        TabOrder = 3
        TabStop = False
        OnClick = Button3Click
      end
      object memoOrderAsc: TMemo
        Left = 8
        Top = 21
        Width = 185
        Height = 57
        TabOrder = 1
      end
      object Button1: TButton
        Left = 8
        Top = 83
        Width = 185
        Height = 25
        Caption = 'Clear Orders'
        TabOrder = 0
        TabStop = False
      end
      object memoOrderDesc: TMemo
        Left = 200
        Top = 21
        Width = 185
        Height = 57
        TabOrder = 2
      end
    end
  end
end
