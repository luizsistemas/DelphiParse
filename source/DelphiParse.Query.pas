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

unit DelphiParse.Query;

interface

uses System.Generics.Collections, System.SysUtils,
  DelphiParse.Interfaces, System.Net.URLClient;

type
  ExceptionParseKeyDuplicate = class(Exception);

  TParseQuery = class(TInterfacedObject, IParseQuery)
  private
    EqualToParams: TDictionary<string, string>;
    StartsWithParams: TDictionary<string, string>;
    ContainsParams: TDictionary<string, string>;
    OthersParams: TDictionary<string, string>;
    Keys: TList<string>;
    Order: TList<string>;
    FLimit: Integer;
    FSkip: Integer;
    procedure ValidatesKey(Key: string; Params: TDictionary<string, string>);
    function FormatEqualTo: string;
    function FormatStartsWith: string;
    function FormatContains: string;
    function FormatLimit: string;
    function FormatWhereTerms: string;
    function FormatSkip: string;
    function FormatOthers: string;
    function FormatOrders: string;
    function FormatKeys: string;
  public
    constructor Create;
    destructor Destroy; override;

    function Count: Integer;

    //where
    procedure WhereEqualTo(Key, Value: string);
    procedure WhereStartsWith(Key, Value: string);
    procedure WhereContains(Key, Value: string);

    //others
    procedure SetLimit(Value: Integer);
    procedure SetSkip(Value: Integer);
    procedure Others(Key, Value: string);
    procedure AddRestrictFields(Field: string);

    //order
    procedure AscendingOrder(Field: string);
    procedure DescendingOrder(Field: string);

    //formatted
    function GetParamsFormatted: string;
  end;

implementation

{ TParseQuery }

uses DelphiParse.Utils, Dialogs;

function TParseQuery.Count: Integer;
begin
  Result := EqualToParams.Count +
            StartsWithParams.Count +
            ContainsParams.Count;
end;

constructor TParseQuery.Create;
begin
  inherited;
  EqualToParams := TDictionary<string, string>.Create;
  StartsWithParams := TDictionary<string,string>.Create;
  ContainsParams := TDictionary<string,string>.Create;
  OthersParams := TDictionary<string,string>.Create;
  Keys := TList<string>.Create;
  Order := TList<string>.Create;
end;

procedure TParseQuery.AddRestrictFields(Field: string);
begin
  Keys.Add(Field);
end;

procedure TParseQuery.AscendingOrder(Field: string);
begin
  Order.Add(Field);
end;

procedure TParseQuery.DescendingOrder(Field: string);
begin
  Order.Add('-' + Field);
end;

destructor TParseQuery.Destroy;
begin
  EqualToParams.Free;
  StartsWithParams.Free;
  ContainsParams.Free;
  OthersParams.Free;
  Keys.Free;
  Order.Free;
  inherited;
end;

function TParseQuery.FormatEqualTo: string;
var
  Key, KeyDec, ValueDec: string;
begin
  if EqualToParams.Count = 0 then
    Exit;
  for Key in EqualToParams.Keys do
  begin
    KeyDec := TURI.URLDecode(Key);
    ValueDec := TURI.URLDecode(EqualToParams.Items[Key]);
    if Result <> '' then
      Result := Result + ',';
    Result := Result + Format('"%s":"%s"', [KeyDec, ValueDec]);
  end;
end;

function TParseQuery.FormatStartsWith: string;
var
  Key, KeyDec, ValueDec: string;
begin
  if StartsWithParams.Count = 0 then
    Exit;

  for Key in StartsWithParams.Keys do
  begin
    KeyDec := TURI.URLDecode(Key);
    ValueDec := TURI.URLDecode(StartsWithParams.Items[Key]);
    if Result <> '' then
      Result := Result + ',';
    Result := Result + Format('"%s":{"$regex":"^%s"}', [KeyDec, ValueDec]);
  end;
end;

function TParseQuery.FormatContains: string;
var
  Key, KeyDec, ValueDec: string;
begin
  if ContainsParams.Count = 0 then
    Exit;

  for Key in ContainsParams.Keys do
  begin
    KeyDec := TURI.URLDecode(Key);
    ValueDec := TURI.URLDecode(ContainsParams.Items[Key]);
    if Result <> '' then
      Result := Result + ',';
    Result := Result + Format('"%s":{"$regex":"%s"}', [KeyDec, ValueDec]);
  end;
end;

function TParseQuery.FormatLimit: string;
begin
  if FLimit > 0 then
    Result := 'limit=' + FLimit.ToString;
end;

function TParseQuery.FormatOthers: string;
var
  Key, KeyDec, ValueDec: string;
begin
  if OthersParams.Count = 0 then
    Exit;
  for Key in OthersParams.Keys do
  begin
    KeyDec := TURI.URLDecode(Key);
    ValueDec := TURI.URLDecode(OthersParams.Items[Key]);
    if Result <> '' then
      Result := Result + ',';
    Result := Result + Format('"%s":"%s"', [KeyDec, ValueDec]);
  end;
end;

function TParseQuery.FormatSkip: string;
begin
  if FSkip > 0 then
    Result := 'skip=' + FSkip.ToString;
end;

function TParseQuery.FormatKeys: string;
begin
  if Keys.Count = 0 then
    Exit;
  Result := 'keys=' + String.Join(',', Keys.ToArray);
end;

function TParseQuery.FormatOrders: string;
begin
  if Order.Count = 0 then
    Exit;
  Result := 'order=' + String.Join(',', Order.ToArray);
end;

function TParseQuery.FormatWhereTerms: string;
var
  Formatos: Array[0..2] of string;
  Texto: string;
begin
  if Count = 0 then
    Exit;
  Formatos[0] := FormatEqualTo;
  Formatos[1] := FormatStartsWith;
  Formatos[2] := FormatContains;
  Texto := GetElementsNotEmpty(',', Formatos);
  Result := Format('where={%s}', [Texto]);
end;

function TParseQuery.GetParamsFormatted: string;
var
  Terms: Array[0..5] of string;
begin
  Terms[0] := FormatWhereTerms;
  Terms[1] := FormatLimit;
  Terms[2] := FormatSkip;
  Terms[3] := FormatOthers;
  Terms[4] := FormatOrders;
  Terms[5] := FormatKeys;
  Result := GetElementsNotEmpty('&', Terms);
end;

procedure TParseQuery.Others(Key, Value: string);
begin
  ValidatesKey(Key, OthersParams);
  OthersParams.Add(Key, Value);
end;

procedure TParseQuery.ValidatesKey(Key: string; Params: TDictionary<string, string>);
begin
  if Params.ContainsKey(Key) then
    raise ExceptionParseKeyDuplicate.Create('Key already exists with that name');
end;

procedure TParseQuery.SetLimit(Value: Integer);
begin
  FLimit := Value;
end;

procedure TParseQuery.SetSkip(Value: Integer);
begin
  FSkip := Value;
end;

procedure TParseQuery.WhereContains(Key, Value: string);
begin
  ValidatesKey(Key, ContainsParams);
  ContainsParams.Add(Key, Value);
end;

procedure TParseQuery.WhereEqualTo(Key, Value: string);
begin
  ValidatesKey(Key, EqualToParams);
  EqualToParams.Add(Key, Value);
end;

procedure TParseQuery.WhereStartsWith(Key, Value: string);
begin
  ValidatesKey(Key, StartsWithParams);
  StartsWithParams.Add(Key, Value);
end;

end.
