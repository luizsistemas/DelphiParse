unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  DelphiParse.Interfaces, DelphiParse.Objects, Mensagem,
  REST.Json, System.Json, DelphiParse.User;

type
  TfrmMain = class(TForm)
    memResult: TMemo;
    GroupBox2: TGroupBox;
    btnGetAll: TButton;
    btnEqual: TButton;
    btnStartsWith: TButton;
    btnContains: TButton;
    editEqual: TEdit;
    editStarts: TEdit;
    editContains: TEdit;
    editUser: TEdit;
    editMessage: TEdit;
    btnSend: TButton;
    btnJsonToMemo: TButton;
    btnJsonToObj: TButton;
    GroupBox1: TGroupBox;
    edUsername: TEdit;
    edPassword: TEdit;
    edEmail: TEdit;
    btnInsertUser: TButton;
    btnLogin: TButton;
    btnLogout: TButton;
    btnCurrentUser: TButton;
    btnDelete: TButton;
    btnUpdate: TButton;
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
  private
    procedure ObjetoToMemo(MensagemObj: TMensagem);
    procedure JsonToMemo(Value: TJsonValue);
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

procedure TfrmMain.btnContainsClick(Sender: TObject);
var
  Parse: IParseObject;
  Resultado: string;
begin
    Parse := TParseObjects.Create('Mensagens');
    Parse.WhereContains('mensagem', editContains.Text);

    Resultado := Parse.GetInBackGround;
    memResult.Lines.Clear;
    memResult.Lines.Add(Resultado);
end;

procedure TfrmMain.btnGetAllClick(Sender: TObject);
var
  Parse: IParseObject;
  Resultado: string;
begin
  Parse := TParseObjects.Create('Mensagens');
  Resultado := Parse.GetAllInBackGround();
  memResult.Lines.Clear;
  memResult.Lines.Add(Resultado);
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
  Resultado := Parse.SaveInBackGround;
  memResult.Lines.Clear;
  memResult.Lines.Add(Resultado);
end;

procedure TfrmMain.btnStartsWithClick(Sender: TObject);
var
  Parse: IParseObject;
  Resultado: string;
begin
    Parse := TParseObjects.Create('Mensagens');
    Parse.WhereStartsWith('username', editStarts.Text);

    Resultado := Parse.GetInBackGround;
    memResult.Lines.Clear;
    memResult.Lines.Add(Resultado);
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
  Resultado: string;
begin
    Parse := TParseObjects.Create('Mensagens');
    Parse.WhereEqualTo('username', editEqual.Text);

    Resultado := Parse.GetInBackGround;
    memResult.Lines.Clear;
    memResult.Lines.Add(Resultado);
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
  Response := Parse.GetAllInBackGround();
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
  Response := Parse.GetAllInBackGround();
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
