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

  TParams = record
    Key: string;
    Value: string;
    FieldType: string;
  end;

  TParseQuery = class(TInterfacedObject, IParseQuery)
  private
    EqualToParams: TList<TParams>;
    StartsWithParams: TList<TParams>;
    ContainsParams: TList<TParams>;
    LessThenParams: TList<TParams>;
    OthersParams: TList<TParams>;
    Keys: TList<string>;
    Order: TList<string>;
    FLimit: Integer;
    FSkip: Integer;
    procedure ValidatesKey(Key: string; Params: TList<TParams>);
    function FormatEqualTo: string;
    function FormatStartsWith: string;
    function FormatContains: string;
    function FormatLimit: string;
    function FormatWhereTerms: string;
    function FormatSkip: string;
    function FormatOthers: string;
    function FormatOrders: string;
    function FormatKeys: string;
    procedure AddParams(Key, Value, FieldType: string; Params: TList<TParams>);
    function FormatParams(CustomParameter: string;
      Params: TList<TParams>): string;
  public
    constructor Create;
    destructor Destroy; override;

    function Count: Integer;

    //where
    procedure WhereEqualTo(Key, Value: string);
    procedure WhereStartsWith(Key, Value: string);
    procedure WhereContains(Key, Value: string);
    procedure WhereLessThen(Key, Value: string; FieldType: string = '');

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

function ContainsKey(Key: string; List: TList<TParams>): Boolean;

implementation

{ TParseQuery }

uses DelphiParse.Utils, Dialogs;

function ContainsKey(Key: string; List: TList<TParams>): Boolean;
var
  Param: TParams;
begin
  Result := False;
  for Param in List do
    if Key = Param.Key then
      Result := True;
end;

function TParseQuery.Count: Integer;
begin
  Result := EqualToParams.Count +
            StartsWithParams.Count +
            ContainsParams.Count;
end;

constructor TParseQuery.Create;
begin
  inherited;
  EqualToParams := TList<TParams>.Create;
  StartsWithParams := TList<TParams>.Create;
  ContainsParams := TList<TParams>.Create;
  OthersParams := TList<TParams>.Create;
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

function TParseQuery.FormatParams(CustomParameter: string; Params: TList<TParams>): string;
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

function TParseQuery.FormatEqualTo: string;
begin
  Result := FormatParams('"%s":"%s"', EqualToParams);
end;

function TParseQuery.FormatStartsWith: string;
begin
  Result := FormatParams('"%s":{"$regex":"^%s"}', StartsWithParams);
end;

function TParseQuery.FormatContains: string;
begin
  Result := FormatParams('"%s":{"$regex":"%s"}', ContainsParams);
end;

function TParseQuery.FormatOthers: string;
begin
  Result := FormatParams('"%s":"%s"', OthersParams);
end;

function TParseQuery.FormatLimit: string;
begin
  if FLimit > 0 then
    Result := 'limit=' + FLimit.ToString;
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

procedure TParseQuery.ValidatesKey(Key: string; Params: TList<TParams>);
begin
  if ContainsKey(Key, Params) then
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

procedure TParseQuery.AddParams(Key, Value, FieldType: string; Params: TList<TParams>);
var
  Param: TParams;
begin
  Param.Key := Key;
  Param.Value := Value;
  Param.FieldType := FieldType;
  ValidatesKey(Key, Params);
  Params.Add(Param);
end;

procedure TParseQuery.Others(Key, Value: string);
begin
  AddParams(Key, Value, '', OthersParams);
end;

procedure TParseQuery.WhereContains(Key, Value: string);
begin
  AddParams(Key, Value, '', ContainsParams);
end;

procedure TParseQuery.WhereEqualTo(Key, Value: string);
begin
  AddParams(Key, Value, '', EqualToParams);
end;

procedure TParseQuery.WhereLessThen(Key, Value, FieldType: string);
begin
  AddParams(Key, Value, '', LessThenParams);
end;

procedure TParseQuery.WhereStartsWith(Key, Value: string);
begin
  AddParams(Key, Value, '', StartsWithParams);
end;

end.
