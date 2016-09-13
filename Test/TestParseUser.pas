unit TestParseUser;

interface

uses
 TestFramework, DelphiParse.Interfaces, DelphiParse.User,
 DelphiParse.Query;

type
  TTestParseUser = class(TTestCase)
  private
    ParseUser: IParseUser;
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure NovoUsuarioDeveTerUsernameInformado;
    procedure NovoUsuarioDeveTerPasswordInformado;
    procedure NovoUsuarioDeveTerEmailInformado;
    procedure AdicionarCampoCustomizadoComNomeDoUserName;
    procedure AdicionarCampoCustomizadoComNomeDoPassword;
    procedure AdicionarCampoCustomizadoComNomeDoEmail;
  end;

implementation

{ TTestParseUser }

procedure TTestParseUser.AdicionarCampoCustomizadoComNomeDoPassword;
begin
  StartExpectingException(ExceptionParseKeyDuplicate);
  ParseUser.SetUserName('mauro');
  ParseUser.SetPassword('123456');
  ParseUser.SetEmail('test@tes');
  ParseUser.Add('password', '123456');
  ParseUser.SignUpInBackground;
  StopExpectingException('Inseriu custom field com nome de pasword');
end;

procedure TTestParseUser.AdicionarCampoCustomizadoComNomeDoUserName;
begin
  StartExpectingException(ExceptionParseKeyDuplicate);
  ParseUser.SetUserName('mauro');
  ParseUser.SetPassword('123456');
  ParseUser.SetEmail('test@tes');
  ParseUser.Add('username', 'mauro');
  ParseUser.SignUpInBackground;
  StopExpectingException('Inseriu custom field com nome de "username"');
end;

procedure TTestParseUser.AdicionarCampoCustomizadoComNomeDoEmail;
begin
  StartExpectingException(ExceptionParseKeyDuplicate);
  ParseUser.SetUserName('mauro');
  ParseUser.SetPassword('123456');
  ParseUser.SetEmail('test@tes');
  ParseUser.Add('email', 'pe@tes');
  ParseUser.SignUpInBackground;
  StopExpectingException('Inseriu custom field com nome de "email"');
end;

procedure TTestParseUser.NovoUsuarioDeveTerUsernameInformado;
begin
  StartExpectingException(ExceptionParseUserNameIsEmpty);
  ParseUser.SetPassword('123456');
  ParseUser.SetEmail('pe@tes');
  ParseUser.SignUpInBackground;
  StopExpectingException('Não informou username');
end;

procedure TTestParseUser.NovoUsuarioDeveTerEmailInformado;
begin
  StartExpectingException(ExcpetionParseEmailIsEmpty);
  ParseUser.SetUserName('mauro');
  ParseUser.SetPassword('123456');
  ParseUser.SignUpInBackground;
  StopExpectingException('Não informou email');
end;

procedure TTestParseUser.NovoUsuarioDeveTerPasswordInformado;
begin
  StartExpectingException(ExceptionParsePasswordIsEmpty);
  ParseUser.SetUserName('mauro');
  ParseUser.SetEmail('pe@tes');
  ParseUser.SignUpInBackground;
  StopExpectingException('Não informou password');
end;

procedure TTestParseUser.SetUp;
begin
  inherited;
  ParseUser := TParseUser.Create;
end;

procedure TTestParseUser.TearDown;
begin
  inherited;
end;

initialization
RegisterTest(TTestParseUser.Suite);

end.
