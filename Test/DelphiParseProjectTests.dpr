program DelphiParseProjectTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  TestQuery in 'TestQuery.pas',
  DelphiParse.Query in '..\source\DelphiParse.Query.pas',
  DelphiParse.Utils in '..\source\DelphiParse.Utils.pas',
  DelphiParse.Interfaces in '..\source\DelphiParse.Interfaces.pas',
  TestParseUser in 'TestParseUser.pas',
  DelphiParse.User in '..\source\DelphiParse.User.pas',
  DelphiParse in '..\source\DelphiParse.pas',
  DelphiParse.Objects in '..\source\DelphiParse.Objects.pas',
  DelphiParse.Configuration in '..\source\DelphiParse.Configuration.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

