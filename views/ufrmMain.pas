unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  DelphiParse.Interfaces, DelphiParse.Objects, Mensagem,
  REST.Json, System.Json, DelphiParse.User, Vcl.ComCtrls;

type
  TfrmMain = class(TForm)
    memResult: TMemo;
    GroupBox1: TGroupBox;
    edUsername: TEdit;
    edPassword: TEdit;
    edEmail: TEdit;
    btnInsertUser: TButton;
    btnLogin: TButton;
    btnLogout: TButton;
    btnCurrentUser: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    editUser: TEdit;
    editMessage: TEdit;
    btnSend: TButton;
    TabSheet2: TTabSheet;
    btnGetAll: TButton;
    btnEqual: TButton;
    btnStartsWith: TButton;
    btnContains: TButton;
    btnJsonToMemo: TButton;
    btnJsonToObj: TButton;
    TabSheet3: TTabSheet;
    btnUpdate: TButton;
    btnDelete: TButton;
    Button3: TButton;
    memoOrderAsc: TMemo;
    Label1: TLabel;
    memoOrderDesc: TMemo;
    Label2: TLabel;
    memoKeys: TMemo;
    Label3: TLabel;
    btnLessThen: TButton;
    btnGreaterThan: TButton;
    edLevel: TEdit;
    procedure btnSendClick(Sender: TObject);
    procedure btnGetAllClick(Sender: TObject);
    procedure btnJsonToObjClick(Sender: TObject);
    procedure btnJsonToMemoClick(Sender: TObject);
    procedure btnEqualClick(Sender: TObject);
    procedure btnContainsClick(Sender: TObject);
    procedure btnStartsWithClick(Sender: TObject);
    procedure btnInsertUserClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
    procedure btnCurrentUserClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnLessThenClick(Sender: TObject);
    procedure btnGreaterThanClick(Sender: TObject);
  private
    procedure ObjetoToMemo(MensagemObj: TMensagem);
    procedure JsonToMemo(Value: TJsonValue);
    procedure SimpleList(Value: TJsonValue);
    function FormatStringLength(Value: string; Size: Integer): string;
    procedure LerResponse(Response: string);
  public
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Generics.Collections;

{$R *.dfm}

procedure TfrmMain.ObjetoToMemo(MensagemObj: TMensagem);
begin
  memResult.Lines.Add('================================');
  memResult.Lines.Add('ObjectId: ' + MensagemObj.objectId);
  memResult.Lines.Add('Username: ' + MensagemObj.Username);
  memResult.Lines.Add('Mensagem: ' + MensagemObj.Mensagem);
  memResult.Lines.Add('CreatedAt: ' + DateTimeToStr(MensagemObj.CreatedAt));
  memResult.Lines.Add('UpdatedAt: ' + DateTimeToStr(MensagemObj.updatedAt));
  memResult.Lines.Add('================================');
end;

procedure TfrmMain.JsonToMemo(Value: TJsonValue);
begin
  memResult.Lines.Add('================================');
  memResult.Lines.Add('ObjectId: ' + Value.GetValue<string>('objectId'));
  memResult.Lines.Add('Username: ' + Value.GetValue<string>('username'));
  memResult.Lines.Add('Mensagem: ' + Value.GetValue<string>('mensagem'));
  memResult.Lines.Add('CreatedAt: ' + Value.GetValue<string>('createdAt'));
  memResult.Lines.Add('UpdatedAt: ' + Value.GetValue<string>('updatedAt'));
  memResult.Lines.Add('================================');
end;

function tfrmMain.FormatStringLength(Value: string; Size: Integer): string;
begin
  Result := Value + StringOfChar(' ', Size - Length(Value));
end;

procedure TfrmMain.SimpleList(Value: TJsonValue);
begin
  if memResult.Lines.Count = 0 then
  begin
    memResult.Lines.Add(
      FormatStringLength('objectId', 12) +
      FormatStringLength('username', 10) +
      FormatStringLength('createdAt', 26) +
      FormatStringLength('updatedAt', 26) +
      FormatStringLength('level', 7) +
      FormatStringLength('mensagem', 25));

    memResult.Lines.Add(stringofChar('=',100));
  end;
  memResult.Lines.Add(
    FormatStringLength(Value.GetValue<string>('objectId'), 12) +
    FormatStringLength(Value.GetValue<string>('username'), 10) +
    FormatStringLength(Value.GetValue<string>('createdAt'), 26) +
    FormatStringLength(Value.GetValue<string>('updatedAt'), 26) +
    FormatStringLength(Value.GetValue<string>('level'), 7) +
    FormatStringLength(Value.GetValue<string>('mensagem'), 25));
end;

procedure TfrmMain.btnContainsClick(Sender: TObject);
var
  Parse: IParseObject;
  Response: string;
  Text: string;
begin
  Text := InputBox('Contains test in the Mensagem field', 'Text:','');
  Parse := TParseObjects.Create('Mensagens');
  Parse.WhereContains('mensagem', Text);
  Response := Parse.GetInBackGround;
  LerResponse(Response);
end;

procedure TfrmMain.btnGetAllClick(Sender: TObject);
var
  Parse: IParseObject;
  Resultado, Key: string;
begin
  Parse := TParseObjects.Create('Mensagens');
  for Key in memoKeys.Lines do
    Parse.AddRestrictFields(Key);
  Resultado := Parse.GetInBackGround();
  memResult.Lines.Clear;
  memResult.Lines.Add(Resultado);
end;

procedure TfrmMain.btnGreaterThanClick(Sender: TObject);
var
  Parse: IParseObject;
  Response: string;
begin
  Text := InputBox('GreaterThan test in the Level field', 'Text:','');
  Parse := TParseObjects.Create('Mensagens');
  Parse.WhereGreaterThan('level', Text, ftNumber);
  Response := Parse.GetInBackGround;
  LerResponse(Response);
end;

procedure TfrmMain.btnInsertUserClick(Sender: TObject);
var
  User: IParseUser;
  Resultado: string;
begin
  User := TParseUser.Create;
  User.SetUserName(edUserName.Text);
  User.SetPassword(edPassword.Text);
  User.SetEmail(edEmail.Text);
  Resultado := User.SignUpInBackground;
  memResult.Lines.Clear;
  memResult.Lines.Add(Resultado);
  memResult.Lines.Add('Token: ' + User.GetSessionToken);
end;

procedure TfrmMain.btnSendClick(Sender: TObject);
var
  Parse: IParseObject;
  Resultado: string;
begin
  Parse := TParseObjects.Create('Mensagens');
  Parse.Add('username', editUser.Text);
  Parse.Add('mensagem', editMessage.Text);
  Parse.Add('level', StrToInt(edLevel.Text));
  Resultado := Parse.SaveInBackGround;
  memResult.Lines.Clear;
  memResult.Lines.Add(Resultado);
end;

procedure TfrmMain.btnStartsWithClick(Sender: TObject);
var
  Parse: IParseObject;
  Response: string;
  Text: string;
begin
  Text := InputBox('StartsWith test in the Username field', 'Text:','');
  Parse := TParseObjects.Create('Mensagens');
  Parse.WhereStartsWith('username', Text);
  Response := Parse.GetInBackGround;
  LerResponse(Response);
end;

procedure TfrmMain.LerResponse(Response: string);
var
  JsonStr: TJSONObject;
  JsonArray: TJSONArray;
  MensagemJson: TJSONValue;
begin
  JsonStr := TJSONObject.ParseJSONValue(Response) as TJSONObject;
  try
    memResult.Lines.Clear;
    JsonArray := JsonStr.GetValue('results') as TJSONArray;
    for MensagemJson in JsonArray do
      SimpleList(MensagemJson);
  finally
    JsonStr.Free;
  end;
end;

procedure TfrmMain.btnLessThenClick(Sender: TObject);
var
  Parse: IParseObject;
  Response: string;
begin
  Text := InputBox('LessThen test in the Level field', 'Text:','');
  Parse := TParseObjects.Create('Mensagens');
  Parse.WhereLessThan('level', Text, ftNumber);
  Response := Parse.GetInBackGround;
  LerResponse(Response);
end;

procedure TfrmMain.Button3Click(Sender: TObject);
var
  Parse: IParseObject;
  Response, Field: string;
begin
  Parse := TParseObjects.Create('Mensagens');
  for Field in memoOrderAsc.Lines do
     Parse.AddOrderAsc(Field);
  for Field in memoOrderDesc.Lines do
     Parse.AddOrderDesc(Field);
  Response := Parse.GetInBackGround();
  LerResponse(Response);
end;

procedure TfrmMain.btnCurrentUserClick(Sender: TObject);
var
  User: IParseUser;
  Resultado: string;
begin
  User := TParseUser.Create;
  Resultado := User.GetCurrencyUser;
  memResult.Lines.Clear;
  if Resultado.IsEmpty then
    memResult.Lines.Add('Session not created!')
  else
    memResult.Lines.Add(Resultado);
end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
var
  Parse: IParseObject;
  ObjectId: string;
  Response: string;
begin
  ObjectId := inputBox('Delete Message', 'Id:', '');
  if Trim(ObjectId) = EmptyStr then
    Exit;
  Parse := TParseObjects.Create('Mensagens');
  Parse.Add('objectId', ObjectId);
  Parse.Add('mensagem', 'nova mensagem...');
  Response := Parse.SaveInBackGround;
  memResult.Lines.Clear;
  memResult.Lines.Add(Response);
end;

procedure TfrmMain.btnEqualClick(Sender: TObject);
var
  Parse: IParseObject;
  Response: string;
  Text: string;
begin
  Text := InputBox('EqualTo test in the Username field', 'Text:','');
  Parse := TParseObjects.Create('Mensagens');
  Parse.WhereEqualTo('username', Text);

  Response := Parse.GetInBackGround;
  LerResponse(Response);
end;

procedure TfrmMain.btnJsonToMemoClick(Sender: TObject);
var
  Parse: IParseObject;
  Response: string;
  JsonStr: TJSONObject;
  JsonArray: TJSONArray;
  MensagemJson: TJSONValue;
begin
  Parse := TParseObjects.Create('Mensagens');
  Response := Parse.GetInBackGround();
  JsonStr := TJSONObject.ParseJSONValue(Response) as TJSONObject;
  try
    memResult.Lines.Clear;
    JsonArray := JsonStr.GetValue('results') as TJSONArray;
    for MensagemJson in JsonArray do
      JsonToMemo(MensagemJson);
  finally
    JsonStr.Free;
  end;
end;

procedure TfrmMain.btnJsonToObjClick(Sender: TObject);
var
  Parse: IParseObject;
  Response: string;
  JsonStr: TJSONObject;
  JsonArray: TJSONArray;
  MensagemJson: TJSONValue;
  MensagemObj: TMensagem;
begin
  Parse := TParseObjects.Create('Mensagens');
  Response := Parse.GetInBackGround();
  JsonStr := TJSONObject.ParseJSONValue(Response) as TJSONObject;
  try
    memResult.Lines.Clear;
    JsonArray := JsonStr.GetValue('results') as TJSONArray;
    for MensagemJson in JsonArray do
    begin
      MensagemObj := TJson.JsonToObject<TMensagem>(MensagemJson.ToString);
      ObjetoToMemo(MensagemObj);
      MensagemObj.Free;
    end;
  finally
    JsonStr.Free;
  end;
end;

procedure TfrmMain.btnLoginClick(Sender: TObject);
var
  User: IParseUser;
  Resultado: string;
begin
  User := TParseUser.Create;
  Resultado := User.Login(edUsername.Text, edPassword.Text);
  memResult.Lines.Clear;
  memResult.Lines.Add(Resultado);
  memResult.Lines.Add('Token: ' + User.GetSessionToken);
end;

procedure TfrmMain.btnLogoutClick(Sender: TObject);
var
  User: IParseUser;
  Resultado: string;
begin
  User := TParseUser.Create;
  Resultado := User.LogOut;
  memResult.Lines.Clear;
  memResult.Lines.Add(Resultado);
  memResult.Lines.Add('Token: ' + User.GetSessionToken);
end;

end.
