unit DelphiParse.Objects;

interface

uses DelphiParse, DelphiParse.Interfaces, System.JSON,
  System.Generics.Collections, DelphiParse.Configuration,
  DelphiParse.Query;

type
  TParseObjects = class(TInterfacedObject, IParseObject)
  private
    FClassName: string;
    Obj: TJSonObject;
    Parse: IDelphiParse;
    Query: IParseQuery;
  public
    constructor Create(ClassName: string);
    destructor Destroy; override;

    procedure WhereEqualTo(Key, Value: string);
    procedure WhereStartsWith(Key, Value: string);
    procedure WhereContains(Key, Value: string);
    procedure Limit(Value: Integer);
    procedure Skip(Value: Integer);

    procedure Add(Key, Value: Variant);

    function SaveInBackGround: string;
    function GetInBackGround: string;
    function GetAllInBackGround: string;
    function DeleteInBackGround(ObjectId: string): string;
  end;

implementation

uses
  System.SysUtils;

{ TDelphiParseObjects }

constructor TParseObjects.Create(ClassName: string);
begin
  inherited Create;
  FClassName := ClassName;
  Obj := TJSONObject.Create;
  Parse := TDelphiParse.Create;
  Query := TParseQuery.Create;
end;

destructor TParseObjects.Destroy;
begin
  Obj.Free;
  inherited;
end;

function TParseObjects.GetInBackGround: string;
begin
  Result := Parse.Get(['classes', FClassName], nil, Query.GetParamsFormatted).ResponseAsString();
end;

function TParseObjects.GetAllInBackGround: string;
begin
  Result := Parse.Get(['classes', FClassName]).ResponseAsString();
end;

procedure TParseObjects.Add(Key, Value: Variant);
begin
  Obj.AddPair(Key, Value);
end;

function TParseObjects.SaveInBackGround: string;
begin
  if (Obj.Count = 0) then
    raise Exception.Create('Objeto JSON não preenchido!');
  Result := Parse.Post(['classes', FClassName], Obj).ResponseAsString();
end;

procedure TParseObjects.WhereContains(Key, Value: string);
begin
  Query.WhereContains(Key, Value);
end;

procedure TParseObjects.WhereEqualTo(Key, Value: string);
begin
  Query.WhereEqualTo(Key, Value);
end;

procedure TParseObjects.WhereStartsWith(Key, Value: string);
begin
  Query.WhereStartsWith(Key, Value);
end;

procedure TParseObjects.Limit(Value: Integer);
begin
  Query.SetLimit(Value);
end;

procedure TParseObjects.Skip(Value: Integer);
begin
  Query.SetSkip(Value);
end;

function TParseObjects.DeleteInBackGround(ObjectId: string): string;
begin
  if (ObjectId = '') then
    raise Exception.Create('ObjectId não informado!');
  Result := Parse.Post(['classes', FClassName, ObjectId]).ResponseAsString();
end;

end.
