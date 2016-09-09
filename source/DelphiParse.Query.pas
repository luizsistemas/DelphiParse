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
    FLimit: Integer;
    FSkip: Integer;
    function FormatEqualTo: string;
    function FormatStartsWith: string;
    function FormatContains: string;
    function FormatLimit: string;
    function FormatWhereTerms: string;
    function FormatSkip: string;
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
end;

destructor TParseQuery.Destroy;
begin
  EqualToParams.Free;
  StartsWithParams.Free;
  ContainsParams.Free;
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
    ValueDec := TURI.URLDecode(EqualToParams.Items[Key]);
    KeyDec := TURI.URLDecode(Key);
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
    ValueDec := StartsWithParams.Items[Key];
    KeyDec := TURI.URLDecode(Key);
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
    ValueDec := ContainsParams.Items[Key];
    KeyDec := TURI.URLDecode(Key);
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

function TParseQuery.FormatSkip: string;
begin
  if FSkip > 0 then
    Result := 'skip=' + FSkip.ToString;
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
  Terms: Array[0..3] of string;
begin
  Terms[0] := FormatWhereTerms;
  Terms[1] := FormatLimit;
  Terms[2] := FormatSkip;
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

procedure TParseQuery.WhereContains(Key, Value: string);
begin
  if ContainsParams.ContainsKey(Key) then
    raise ExceptionParseKeyDuplicate.Create('J� existe Key com este nome');
  ContainsParams.Add(Key, Value);
end;

procedure TParseQuery.WhereEqualTo(Key, Value: string);
begin
  if EqualToParams.ContainsKey(Key) then
    raise ExceptionParseKeyDuplicate.Create('J� existe Key com este nome');
  EqualToParams.Add(Key, Value);
end;

procedure TParseQuery.WhereStartsWith(Key, Value: string);
begin
  if StartsWithParams.ContainsKey(Key) then
    raise ExceptionParseKeyDuplicate.Create('J� existe Key com este nome');
  StartsWithParams.Add(Key, Value);
end;

end.