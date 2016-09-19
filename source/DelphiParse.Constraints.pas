unit DelphiParse.Constraints;

interface

uses
  DelphiParse.Interfaces, System.Generics.Collections,
  System.SysUtils;

type
  ExceptionParseKeyDuplicate = class(Exception);

  TConstraintType = (ctEqualTo, ctStartsWith, ctContains,
    ctLessThan, ctGreaterThan, ctOthers);

  TParams = record
    Key: string;
    Value: string;
    FieldType: TFieldType;
  end;

  TConstraints = class
  private
    List: TObjectDictionary<TConstraintType, TList<TParams>>;
    procedure ValidatesKey(Key: string; Params: TList<TParams>);
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddParams(Key, Value: string; ConstraintType: TConstraintType;
      FieldType: TFieldType = ftString);

    procedure AddConstraint(ConstraintType: TConstraintType);
    function Items(Key: TConstraintType): TList<TParams>;
    function CountWhere: Integer;
  end;

implementation

uses
  DelphiParse.Utils;

{ TConstraints }


procedure TConstraints.ValidatesKey(Key: string; Params: TList<TParams>);
begin
  if ContainsKey(Key, Params) then
    raise ExceptionParseKeyDuplicate.Create('Key already exists with that name');
end;

procedure TConstraints.AddParams(Key, Value: string; ConstraintType: TConstraintType; FieldType: TFieldType);
var
  Param: TParams;
begin
  Param.Key := Key;
  Param.Value := Value;
  Param.FieldType := FieldType;
  ValidatesKey(Key, Self.Items(ConstraintType));
  Items(ConstraintType).Add(Param);
end;

procedure TConstraints.AddConstraint(ConstraintType: TConstraintType);
begin
  List.Add(ConstraintType, TList<TParams>.Create);
end;

function TConstraints.CountWhere: Integer;
var
  Key: TConstraintType;
  Count: Integer;
begin
  Count := 0;
  for Key in List.Keys do
    Count := Count + List.Items[Key].Count;
  Result := Count;
end;

constructor TConstraints.Create;
begin
  inherited;
  List := TObjectDictionary<TConstraintType, TList<TParams>>.Create([doOwnsValues]);
  Self.AddConstraint(ctEqualTo);
  Self.AddConstraint(ctStartsWith);
  Self.AddConstraint(ctContains);
  Self.AddConstraint(ctLessThan);
  Self.AddConstraint(ctGreaterThan);
  Self.AddConstraint(ctOthers);
end;

destructor TConstraints.Destroy;
begin
  List.Clear;
  List.Free;
  inherited;
end;

function TConstraints.Items(Key: TConstraintType): TList<TParams>;
begin
  Result := List.Items[Key];
end;

end.
