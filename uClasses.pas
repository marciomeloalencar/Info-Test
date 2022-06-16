unit uClasses;

interface

uses
  XMLDoc, Xml.XMLIntf, System.Classes;

type
  TPessoa = class;
  TEndereco = class;

  TPessoa = class
    private
      FNome: String;
      FIdentidade: String;
      FCpf: String;
      FTelefone: String;
      FEmail: String;
      FEndereco: TEndereco;
    protected
      function CreateXml: Boolean;
    public
     property Nome: String read FNome write FNome;
     property Identidade: String read FIdentidade write FIdentidade;
     property Cpf: String read FCpf write FCpf;
     property Telefone: String read FTelefone write FTelefone;
     property Email: String read FEmail write FEmail;
     property Endereco: TEndereco read FEndereco write Fendereco;
     function Xml: Boolean;
     constructor Create; overload;
     constructor Create(ANome, AIdentidade, ACpf, ATelefone, AEmail :String;
     ACep:Integer; ALogradouro, ANumero, ACompl, ABairro, ACidade, APais : String); overload;
  end;

  TEndereco = class
    private
      FCep: Integer;
      FLogradouro: String;
      FNumero: String;
      FComplemento: String;
      FBairro: String;
      FCidade: String;
      FPais: String;
    public
      property Cep: Integer read FCep write FCep;
      property Logradouro: String read FLogradouro write FLogradouro;
      property Numero: String read FNumero write FNumero;
      property Complemento: String read FComplemento write FComplemento;
      property Bairro: String read FBairro write FBairro;
      property Cidade: String read FCidade write FCidade;
      property Pais: String read FPais write FPais;
      constructor Create; overload;
      constructor Create(ACep: Integer; ALogradouro, ANumero, ACompl, ABairro, ACidade, APais: String); overload;
  end;


implementation

uses
  System.SysUtils;

{ TPessoa }

constructor TPessoa.Create(ANome, AIdentidade, ACpf, ATelefone, AEmail: String;
  ACep:Integer; ALogradouro, ANumero, ACompl, ABairro, ACidade, APais: String);
begin
 FNome := ANome;
 FIdentidade := AIdentidade;
 FCpf := ACpf;
 FTelefone := ATelefone;
 FEmail := AEmail;
 FEndereco := TEndereco.Create(ACep, ALogradouro, ANumero, ACompl, ABairro, ACidade, APais);
end;

constructor TPessoa.Create;
begin
 FEndereco := TEndereco.Create;
end;

function TPessoa.CreateXml: Boolean;
Var loxml : TXMLDocument;
    NodeRoot, NodeEnd : IXMLNode;
begin
  loxml := TXMLDocument.Create(nil);
  loxml.Active := True;
  loxml.Encoding := 'UTF-8';
  loxml.Options := [doNodeAutoIndent];
  Noderoot := loxml.AddChild('cadastro');
  Noderoot.AddChild('Nome').Text := FNome;
  Noderoot.AddChild('Identidade').Text := FIdentidade;
  Noderoot.AddChild('Cpf').Text := FCpf;
  Noderoot.AddChild('Telefone').Text := FTelefone;
  Noderoot.AddChild('Email').Text := FEmail;
  NodeEnd := Noderoot.AddChild('endereco');
  NodeEnd.AddChild('cep').Text := IntToStr(FEndereco.Cep);
  NodeEnd.AddChild('Logradouro').Text := FEndereco.Logradouro;
  NodeEnd.AddChild('Numero').Text := FEndereco.Numero;
  NodeEnd.AddChild('Complemento').Text := FEndereco.Complemento;
  NodeEnd.AddChild('Bairro').Text := FEndereco.Bairro;
  NodeEnd.AddChild('Cidade').Text := FEndereco.Cidade;
  NodeEnd.AddChild('Pais').Text := FEndereco.Pais;
  loxml.XML.SaveToFile( Format('file_%s.xml',[self.Cpf])  );
end;

function TPessoa.Xml: Boolean;
begin
   Result := self.CreateXml;
end;

{ TEndereco }

constructor TEndereco.Create(ACep: Integer; ALogradouro, ANumero, ACompl,
  ABairro, ACidade, APais: String);
begin
  FCep := ACep;
  FLogradouro := ALogradouro;
  FNumero := ANumero;
  FComplemento := ACompl;
  FBairro := ABairro;
  FCidade := ACidade;
  FPais := APais;
end;

constructor TEndereco.Create;
begin
 FPais := 'Brasil';
end;

end.
