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
  System.SysUtils, System.Generics.Collections,
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
    function Send(const UrlParams: array of string;
      const Command: TParseVerbs; ObjectJson: TJSONValue = nil;
      QueryParams: string = ''): IResponseParse;

    function FormatUrlParams(Params: array of string): string;
  public
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

implementation

uses
  System.Net.URLClient, System.Classes;

{ TDelphiParse }

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
  HttpCliente: THTTPClient;
  HttpResponse: IHTTPResponse;
  CompletURL: string;
  ObjectStream: TStringStream;
begin
  HttpCliente := THTTPClient.Create;
  try
    HttpCliente.ContentType := 'application/json';
    HttpCliente.CustomHeaders['X-Parse-Application-Id'] := APP_ID;
    HttpCliente.CustomHeaders['X-Parse-REST-API-Key'] := REST_KEY;
    ObjectStream := nil;
    if ObjectJson <> nil then
      ObjectStream := TStringStream.Create(ObjectJson.ToJSON);
    try
      CompletURL := BASE_URL + FormatUrlParams(UrlParams) +
        IfThen(QueryParams='','', '?' + QueryParams);

      case Command of
        pvPost:
          HttpResponse := HttpCliente.Post(CompletURL, ObjectStream);
        pvGet:
          HttpResponse := HttpCliente.Get(CompletURL);
        pvPut:
          HttpResponse := HttpCliente.Put(CompletURL);
        pvDelete:
          HttpResponse := HttpCliente.Delete(CompletURL);
      end;
      Result := TResponseParse.Create(HttpResponse);
    finally
      if Assigned(ObjectStream) then
        ObjectStream.Free;
    end;
  finally
    HttpCliente.Free;
  end;
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
