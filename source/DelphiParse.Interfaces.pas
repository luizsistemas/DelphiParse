unit DelphiParse.Interfaces;

interface

uses System.JSON, System.SysUtils, System.Generics.Collections;

type
  IResponseParse = interface
    ['{D356B879-8FAC-47BC-8946-7418497C1047}']
    function ResponseAsString(const Encoding: TEncoding = nil): string;
  end;

  IDelphiParse = interface
    ['{87E940B9-D2F8-4197-84D8-A84A426049BA}']
    function Post(const UrlParams: array of string;
      ObjectJson: TJSONValue = nil;
      QueryParams: string = ''): IResponseParse;

    function Get(const UrlParams: array of string;
      ObjectJson: TJSONValue = nil;
      QueryParams: string = ''): IResponseParse;

    function Put(const UrlParams: array of string;
      ObjectJson: TJSONValue = nil;
      QueryParams: string = ''): IResponseParse;

    function Delete(const UrlParams: array of string;
      ObjectJson: TJSONValue = nil;
      QueryParams: string = ''): IResponseParse;
  end;

  IParseQuery = interface
    ['{A00E5771-50D0-44C2-86BC-2F0ED2418CF9}']

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

  IParseObject = interface
    ['{A6616D36-B794-46DC-BBC9-51CF0AC18E5F}']
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

end.