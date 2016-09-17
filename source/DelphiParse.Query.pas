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
  DelphiParse.Interfaces, DelphiParse.Utils, System.Net.URLClient;

type
  TParseQuery = class(TInterfacedObject, IParseQuery)
  private
    EqualToParams: TList<TParams>;
    StartsWithParams: TList<TParams>;
    ContainsParams: TList<TParams>;
    LessThenParams: TList<TParams>;
    OthersParams: TList<TParams>;
    ComparisonsParams: TList<TParams>;
    Keys: TList<string>;
    Order: TList<string>;
    FLimit: Integer;
    FSkip: Integer;
    function FormatEqualTo: string;

    //Comparisons
    procedure SetComparisons(ParameterValue: string; Params: TList<TParams>);
    procedure SetFormatStartsWith;
    procedure SetFormatContains;
    procedure SetFormatLessThen;

    function FormatComparisons: String;

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

implementation

{ TParseQuery }

uses Dialogs;

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
  LessThenParams := TList<TParams>.Create;
  ComparisonsParams := TList<TParams>.Create();
  OthersParams := TList<TParams>.Create;
  Keys := TList<string>.Create;
  Order := TList<string>.Create;
end;

destructor TParseQuery.Destroy;
begin
  EqualToParams.Free;
  StartsWithParams.Free;
  ContainsParams.Free;
  LessThenParams.Free;
  OthersParams.Free;
  ComparisonsParams.Free;
  Keys.Free;
  Order.Free;
  inherited;
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

function TParseQuery.FormatEqualTo: string;
begin
  Result := FormatParams('"%s":"%s"', EqualToParams);
end;

function TParseQuery.FormatComparisons: String;
begin
  SetFormatStartsWith;
  SetFormatContains;
  SetFormatLessThen;
  Result := FormatParams('"%s":{%s}', ComparisonsParams);
end;

procedure TParseQuery.SetComparisons(ParameterValue: string; Params: TList<TParams>);
var
  Param, ComparisonParam: TParams;
  Value: string;
  Index: Integer;
begin
  if Params.Count = 0 then
    Exit;

  for Param in Params do
  begin
    Value := Format(ParameterValue, [Param.Value]);
    ComparisonParam.Key := TURI.URLDecode(Param.Key);
    ComparisonParam.FieldType := Param.FieldType;
    if ContainsKey(Param.Key, ComparisonsParams) then
    begin
      Index := GetIndexParams(Param.Key, ComparisonsParams);
      Value := ComparisonsParams.Items[Index].Value + ',' + Value;
      ComparisonParam.Value := TURI.URLDecode(Value);
      ComparisonsParams.Items[Index] := ComparisonParam;
    end
    else
    begin
      ComparisonParam.Value := TURI.URLDecode(Value);
      ComparisonsParams.Add(ComparisonParam);
    end;
  end;
end;

procedure TParseQuery.SetFormatStartsWith;
begin
  SetComparisons('"$regex":"^%s"', StartsWithParams);
end;

procedure TParseQuery.SetFormatContains;
begin
  SetComparisons('"$regex":"%s"', ContainsParams);
end;

procedure TParseQuery.SetFormatLessThen;
begin
 SetComparisons('"$lte":"%s"', LessThenParams);
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
  Formats: Array[0..1] of string;
begin
  if Count = 0 then
    Exit;
  Formats[0] := FormatEqualTo;
  Formats[1] := FormatComparisons;
  Result := Format('where={%s}', [GetElementsNotEmpty(',', Formats)]);
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

procedure TParseQuery.SetLimit(Value: Integer);
begin
  FLimit := Value;
end;

procedure TParseQuery.SetSkip(Value: Integer);
begin
  FSkip := Value;
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
