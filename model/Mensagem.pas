unit Mensagem;

interface

type
  TMensagem = class
  private
    FObjectId: string;
    FCreatedAt: TDateTime;
    FUpdatedAt: TDateTime;
    FUsername: string;
    FMensagem: string;
  public
    property ObjectId: string read FObjectId write FObjectId;
    property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;
    property UpdatedAt: TDateTime read FUpdatedAt write FUpdatedAt;
    property Username: string read FUsername write FUsername;
    property Mensagem: string read FMensagem write FMensagem;
  end;

implementation

end.
