program DelphiParseProject;

uses
  FastMM4,
  Vcl.Forms,
  ufrmMain in 'views\ufrmMain.pas' {frmMain},
  DelphiParse.Configuration in 'source\DelphiParse.Configuration.pas',
  DelphiParse.Interfaces in 'source\DelphiParse.Interfaces.pas',
  DelphiParse.Objects in 'source\DelphiParse.Objects.pas',
  DelphiParse in 'source\DelphiParse.pas',
  Mensagem in 'model\Mensagem.pas',
  DelphiParse.Query in 'source\DelphiParse.Query.pas',
  DelphiParse.Utils in 'source\DelphiParse.Utils.pas',
  DelphiParse.User in 'source\DelphiParse.User.pas',
  DelphiParse.Constraints in 'source\DelphiParse.Constraints.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
