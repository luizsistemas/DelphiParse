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

unit DelphiParse;

interface

uses DelphiParse.Interfaces, System.JSON, System.Net.HttpClient,
  System.SysUtils,
  DelphiParse.Configuration, System.NetConsts, System.StrUtils;

type
  TParseVerbs = (pvPost, pvGet, pvPut, pvDelete);

  TResponseParse = class(TInterfacedObject, IResponseParse)
  private
    FHttpResponse: IHTTPResponse;
  public
    constructor Create(HTTPResponse: IHTTPResponse);
    function ResponseAsString(const Encoding: TEncoding = nil): string;
  end;

  TDelphiParse = class(TInterfacedObject, IDelphiParse)
  private
    FRevocableSession: Boolean;
    class var SessionToken: string;

    function Send(const UrlParams: array of string;
      const Command: TParseVerbs; ObjectJson: TJSONValue = nil;
      QueryParams: string = ''): IResponseParse;

    function FormatUrlParams(Params: array of string): string;
  public
    constructor Create;

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

    procedure SetRevocableSession(Value: Boolean);

    function GetSessionToken: string;
    procedure SetSessionToken(Value: string);
  end;

implementation

uses
  System.Net.URLClient, System.Classes;

{ TDelphiParse }

constructor TDelphiParse.Create;
begin
  inherited;
  FRevocableSession := False;
end;

function TDelphiParse.Delete(const UrlParams: array of string;
  ObjectJson: TJSONValue; QueryParams: string): IResponseParse;
begin
  Result := Send(UrlParams, TParseVerbs.pvDelete, nil, QueryParams);
end;

function TDelphiParse.Get(const UrlParams: array of string;
  ObjectJson: TJSONValue; QueryParams: string): IResponseParse;
begin
  Result := Send(UrlParams, TParseVerbs.pvGet, nil, QueryParams);
end;

function TDelphiParse.GetSessionToken: string;
begin
  Result := SessionToken;
end;

function TDelphiParse.Post(const UrlParams: array of string;
  ObjectJson: TJSONValue; QueryParams: string): IResponseParse;
begin
  Result := Send(UrlParams, TParseVerbs.pvPost, ObjectJson, QueryParams);
end;

function TDelphiParse.Put(const UrlParams: array of string;
  ObjectJson: TJSONValue; QueryParams: string): IResponseParse;
begin
  Result := Send(UrlParams, TParseVerbs.pvPut, ObjectJson, QueryParams);
end;

function TDelphiParse.FormatUrlParams(Params: array of string): string;
var
  Param: string;
begin
  Result := '';
  for Param in Params do
    Result := Result + '/' + TURI.URLEncode(Param);
end;

function TDelphiParse.Send(const UrlParams: array of string;
  const Command: TParseVerbs; ObjectJson: TJSONValue;
  QueryParams: string): IResponseParse;
var
  HttpClient: THTTPClient;
  HttpResponse: IHTTPResponse;
  CompletURL: string;
  ObjectStream: TStringStream;
begin
  HttpClient := THTTPClient.Create;
  try
    HttpClient.ContentType := 'application/json';
    HttpClient.CustomHeaders['X-Parse-Application-Id'] := APP_ID;
    HttpClient.CustomHeaders['X-Parse-REST-API-Key'] := REST_KEY;
    if FRevocableSession then
      HttpClient.CustomHeaders['X-Parse-Revocable-Session'] := '1';
    if not SessionToken.IsEmpty then
      HttpClient.CustomHeaders['X-Parse-Session-Token'] := SessionToken;
    ObjectStream := nil;
    if ObjectJson <> nil then
      ObjectStream := TStringStream.Create(ObjectJson.ToJSON);
    try
      CompletURL := BASE_URL + FormatUrlParams(UrlParams) +
        IfThen(QueryParams='','', '?' + QueryParams);
      case Command of
        pvPost:
          HttpResponse := HttpClient.Post(CompletURL, ObjectStream);
        pvGet:
          HttpResponse := HttpClient.Get(CompletURL);
        pvPut:
          HttpResponse := HttpClient.Put(CompletURL, ObjectStream);
        pvDelete:
          HttpResponse := HttpClient.Delete(CompletURL);
      end;
      Result := TResponseParse.Create(HttpResponse);
    finally
      if Assigned(ObjectStream) then
        ObjectStream.Free;
    end;
  finally
    HttpClient.Free;
  end;
end;

procedure TDelphiParse.SetRevocableSession(Value: Boolean);
begin
  FRevocableSession := Value;
end;

procedure TDelphiParse.SetSessionToken(Value: string);
begin
  SessionToken := Value;
end;

{ TResponseParse }

constructor TResponseParse.Create(HTTPResponse: IHTTPResponse);
begin
  inherited Create;
  FHttpResponse := HTTPResponse;
end;

function TResponseParse.ResponseAsString(const Encoding: TEncoding): string;
begin
  Result := FHttpResponse.ContentAsString(Encoding);
end;

end.
