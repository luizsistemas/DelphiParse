{******************************************************************************}
{ Projeto: Delphi Parse                                                        }
{                                                                              }
{ Direitos Autorais Reservados (c) 2016 Luiz Carlos Alves                      }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{    Luiz Carlos Alves - contato@luizsistemas.com.br                           }
{                                                                              }
{ Você pode obter a última versão desse arquivo no repositório                 }
{ https://github.com/luizsistemas/DelphiParse                                  }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{ Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{ Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Luiz Carlos Alves - contato@luizsistemas.com.br -  www.luizsistemas.com.br   }
{                                                                              }
{******************************************************************************}

unit DelphiParse.Utils;

interface

uses
  System.SysUtils, Generics.Collections;
type
  ExceptionParseKeyDuplicate = class(Exception);

  TParams = record
    Key: string;
    Value: string;
    FieldType: string;
  end;

function GetElementsNotEmpty(Separator: String; Elements: Array of string): string;
function FormatParams(CustomParameter: string; Params: TList<TParams>): string;
procedure AddParams(Key, Value, FieldType: string; Params: TList<TParams>);
procedure ValidatesKey(Key: string; Params: TList<TParams>);
function ContainsKey(Key: string; List: TList<TParams>): Boolean;
function GetIndexParams(Key: string; List: TList<TParams>): Integer;

implementation

uses
   System.Net.URLClient;

function GetIndexParams(Key: string; List: TList<TParams>): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to List.Count - 1 do
    if Key = List.Items[I].Key then
      Result := I;
end;

function ContainsKey(Key: string; List: TList<TParams>): Boolean;
var
  Param: TParams;
begin
  Result := False;
  for Param in List do
    if Key = Param.Key then
      Result := True;
end;

procedure ValidatesKey(Key: string; Params: TList<TParams>);
begin
  if ContainsKey(Key, Params) then
    raise ExceptionParseKeyDuplicate.Create('Key already exists with that name');
end;

procedure AddParams(Key, Value, FieldType: string; Params: TList<TParams>);
var
  Param: TParams;
begin
  Param.Key := Key;
  Param.Value := Value;
  Param.FieldType := FieldType;
  ValidatesKey(Key, Params);
  Params.Add(Param);
end;

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

function FormatParams(CustomParameter: string; Params: TList<TParams>): string;
var
  Param: TParams;
  KeyDec, ValueDec: string;
begin
  if Params.Count = 0 then
    Exit;
  for Param in Params do
  begin
    KeyDec := TURI.URLDecode(Param.Key);
    ValueDec := TURI.URLDecode(Param.Value);
    if Result <> '' then
      Result := Result + ',';
    Result := Result + Format(CustomParameter, [KeyDec, ValueDec]);
  end;
end;

end.
