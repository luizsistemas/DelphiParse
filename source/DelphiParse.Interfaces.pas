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
    procedure SetRevocableSession(Value: Boolean);

    function GetSessionToken: string;
    procedure SetSessionToken(Value: string);
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
    procedure Others(Key, Value: string);
    procedure AddRestrictFields(Field: string);

    //order
    procedure AscendingOrder(Field: string);
    procedure DescendingOrder(Field: string);

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
    procedure AddRestrictFields(Field: string);
    procedure AddOrderAsc(Field: string);
    procedure AddOrderDesc(Field: string);

    procedure Add(Key, Value: Variant);

    function SaveInBackGround: string;
    function GetInBackGround: string;
    function DeleteInBackGround(ObjectId: string): string;
  end;

  IParseUser = interface
    ['{D75AD7B0-21BA-4749-B4EB-A94FB66DAC34}']

    procedure SetUserName(Value: string);
    procedure SetEmail(Value: string);
    procedure SetPassword(Value: string);

    function GetSessionToken: string;

    //custom fields
    procedure Add(Key, Value: Variant);

    function Login(UserName, Password: string): string;
    function LogOut: string;
    function GetCurrencyUser: string;
    function SignUpInBackground: string;
  end;

implementation

end.
