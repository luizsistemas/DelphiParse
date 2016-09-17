unit DelphiParse.Constraints;

interface

uses
  DelphiParse.Interfaces, System.Generics.Collections;

type
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
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(ConstraintType: TConstraintType);
    function Items(Key: TConstraintType): TList<TParams>;
    function CountWhere: Integer;
  end;

implementation

{ TConstraints }

procedure TConstraints.Add(ConstraintType: TConstraintType);
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
  Self.Add(ctEqualTo);
  Self.Add(ctStartsWith);
  Self.Add(ctContains);
  Self.Add(ctLessThan);
  Self.Add(ctGreaterThan);
  Self.Add(ctOthers);
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
