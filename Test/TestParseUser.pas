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
  end;

implementation

{ TTestParseUser }

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
