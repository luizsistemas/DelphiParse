unit DelphiParse.Utils;

interface

uses
  System.SysUtils;

function GetElementsNotEmpty(Separator: String; Elements: Array of string): string;

implementation

uses Generics.Collections;

function GetElementsNotEmpty(Separator: String; Elements: Array of string): string;
var
  ListElements: TList<string>;
  Param: string;
begin
  if Length(Elements) = 0 then
    Exit;
  ListElements := TList<string>.Create;
  try
    for Param in Elements do
    begin
      if Param.IsEmpty then
        Continue;
      ListElements.Add(Param);
    end;
    Result := String.Join(Separator, ListElements.ToArray);
  finally
    ListElements.Free;
  end;
end;

end.
