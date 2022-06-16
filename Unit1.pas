unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IPPeerClient, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Datasnap.DBClient, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, Vcl.ComCtrls,
  IdSMTP, IdSSLOpenSSL, IdMessage, IdText, IdAttachmentFile, IdExplicitTLSClientServerBase;

type
  TCepThread = class(TThread)
  private
   FCep : Integer;
  protected
    procedure Execute; override;
  public
    constructor Create(ACep:Integer);
  end;

  TEmailThread = class(TThread)
  private
   FObjeto : TOBject;
  protected
    procedure Execute; override;
  public
    constructor Create(AObjeto:TObject);
  end;

  TfrmPrincipal = class(TForm)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    edNome: TLabeledEdit;
    edIdentidade: TMaskEdit;
    edCPF: TMaskEdit;
    edTelefone: TMaskEdit;
    edEmail: TMaskEdit;
    GroupBox1: TGroupBox;
    edCEP: TMaskEdit;
    edLogradouro: TLabeledEdit;
    edComplemento: TLabeledEdit;
    edBairro: TLabeledEdit;
    edCidade: TLabeledEdit;
    edEstado: TLabeledEdit;
    edPais: TLabeledEdit;
    Label1: TLabel;
    edNumero: TLabeledEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    btnGravar: TButton;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    btnEnviar: TButton;
    IndCep: TShape;
    LabelEmail: TLabel;
    PageControl1: TPageControl;
    tbCad: TTabSheet;
    tbSMTP: TTabSheet;
    edPorta: TMaskEdit;
    edHost: TLabeledEdit;
    edUsuario: TLabeledEdit;
    edSenha: TLabeledEdit;
    Label6: TLabel;
    edSSL: TComboBox;
    Label7: TLabel;
    procedure btnGravarClick(Sender: TObject);
    procedure edCEPChange(Sender: TObject);
    procedure btnEnviarClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
    procedure Gravar;
    procedure Limpar;
    procedure LoadRegistro;
    procedure EnviarEmail(Aobjeto:TObject);
    function ValidaSMTP:Boolean;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  uClasses, REST.Types, system.JSON;

{$R *.dfm}

procedure TfrmPrincipal.btnEnviarClick(Sender: TObject);
var
  loPessoa : TPessoa;
  loEmailThread : TEmailThread;
begin
  try
    With ClientDataSet1 do
      begin
       loPessoa := TPessoa.Create(FieldByName('nome').AsString,
                                  FieldByName('Identidade').AsString,
                                  FieldByName('Cpf').AsString,
                                  FieldByName('Telefone').AsString,
                                  FieldByName('Email').AsString,
                                  FieldByName('Cep').AsInteger,
                                  FieldByName('Logradouro').AsString,
                                  FieldByName('Numero').AsString,
                                  FieldByName('Complemento').AsString,
                                  FieldByName('Bairro').AsString,
                                  FieldByName('Cidade').AsString,
                                  FieldByName('Pais').AsString);
      end;

      if MessageDlg('Deseja Enviar E-mail para cadastrado ?', mtConfirmation, [mbYes, mbNo], 0)  = mrYes Then
         begin
            loEmailThread := TEmailThread.Create(loPessoa);
            loEmailThread.Execute;
         end;

  finally
    loPessoa.DisposeOf;
  end;
end;

procedure TfrmPrincipal.btnGravarClick(Sender: TObject);
begin
  Gravar;
  Limpar;
end;

procedure TfrmPrincipal.DBGrid1DblClick(Sender: TObject);
begin
 LoadRegistro;
end;

procedure TfrmPrincipal.edCEPChange(Sender: TObject);
Var
  loCepThread : TCepThread;
begin
  if Length(edCEP.Text) >= 8 then
     begin
       loCepThread := TCepThread.Create( StrToInt(edCEP.Text));
       loCepThread.Execute;
     end;
end;

procedure TfrmPrincipal.EnviarEmail(Aobjeto:TObject);
var
  // variáveis e objetos necessários para o envio
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
  IdSMTP: TIdSMTP;
  IdMessage: TIdMessage;
  IdText: TIdText;
  sAnexo: string;
begin
  if not ValidaSMTP then
     begin
       LabelEmail.Caption := 'Sem as configurações do SMTP.';
       LabelEmail.Visible := True;
       Application.ProcessMessages;
       Exit;
     end
   else
     begin
       LabelEmail.Caption := '';
       LabelEmail.Visible := False;
       Application.ProcessMessages;
     end;

  // instanciação dos objetos
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(Self);
  IdSMTP := TIdSMTP.Create(Self);
  IdMessage := TIdMessage.Create(Self);

  try
    // Configuração do protocolo SSL (TIdSSLIOHandlerSocketOpenSSL)
    //TIdSSLVersion = (sslvSSLv2, sslvSSLv23, sslvSSLv3, sslvTLSv1,sslvTLSv1_1,sslvTLSv1_2);
    case EdSSl.ItemIndex of
     0:IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv2;
     1:IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
     2:IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv3;
     3:IdSSLIOHandlerSocket.SSLOptions.Method := sslvTLSv1;
     4:IdSSLIOHandlerSocket.SSLOptions.Method := sslvTLSv1_1;
     5:IdSSLIOHandlerSocket.SSLOptions.Method := sslvTLSv1_2;
    end;

    IdSSLIOHandlerSocket.SSLOptions.Mode := sslmClient;

    // Configuração do servidor SMTP (TIdSMTP)
    IdSMTP.IOHandler := IdSSLIOHandlerSocket;
    IdSMTP.ValidateAuthLoginCapability := True;
    IdSMTP.UseTLS := utUseExplicitTLS;
    IdSMTP.AuthType := satDefault;
    IdSMTP.Port := StrToInt( Trim(edPorta.Text) );
    IdSMTP.Host := edHost.Text;
    IdSMTP.Username := edUsuario.Text;
    IdSMTP.Password := edSenha.Text;

    // Configuração da mensagem (TIdMessage)
    IdMessage.From.Address := edUsuario.Text;
    IdMessage.From.Name := 'Teste de aplicação';
    IdMessage.ReplyTo.EMailAddresses := IdMessage.From.Address;
    IdMessage.Recipients.Add.Text := TPessoa(Aobjeto).Email;
    IdMessage.Subject := Format('Cadastro de %s',[TPessoa(Aobjeto).Nome]);
    IdMessage.Encoding := meMIME;

    // Configuração do corpo do email (TIdText)
    IdText := TIdText.Create(IdMessage.MessageParts);
    IdText.Body.Add( Format('Seque em anexo xml do cadastro de %s',[TPessoa(Aobjeto).Nome]));
    IdText.ContentType := 'text/plain; charset=iso-8859-1';

    // Opcional - Anexo da mensagem (TIdAttachmentFile)
    if TPessoa(Aobjeto).Xml then
        sAnexo := Format('%s\file_%s.xml',[ExtractFilePath(Application.ExeName), TPessoa(Aobjeto).cpf]);
    if FileExists(sAnexo) then
      begin
        TIdAttachmentFile.Create(IdMessage.MessageParts, sAnexo);
      end;

    // Conexão e autenticação
    try
      IdSMTP.Connect;
      IdSMTP.Authenticate;
    except
      on E:Exception do
        begin
          MessageDlg('Erro na conexão ou autenticação: ' +
          E.Message, mtWarning, [mbOK], 0);
          Exit;
        end;
    end;

    // Envio da mensagem
    try
      IdSMTP.Send(IdMessage);
      MessageDlg('Mensagem enviada com sucesso!', mtInformation, [mbOK], 0);
    except
      On E:Exception do
        begin
          MessageDlg('Erro ao enviar a mensagem: ' +
          E.Message, mtWarning, [mbOK], 0);
        end;
    end;
  finally
    // desconecta do servidor
    IdSMTP.Disconnect;
    // liberação da DLL
    UnLoadOpenSSLLibrary;
    // liberação dos objetos da memória
    FreeAndNil(IdMessage);
    FreeAndNil(IdSSLIOHandlerSocket);
    FreeAndNil(IdSMTP);
  end;
end;

procedure TfrmPrincipal.Gravar;
var
  loPessoa : TPessoa;
  loEmailThread : TEmailThread;
begin
  try
    loPessoa := TPessoa.Create(edNome.Text,
                               edIdentidade.Text,
                               edCPF.Text,
                               edTelefone.Text,
                               edEmail.Text,
                               StrToInt(edCEP.Text),
                               edLogradouro.Text,
                               edComplemento.Text,
                               edBairro.Text,
                               edCidade.Text,
                               edEstado.Text,
                               edPais.Text);

    //grava na memoria
    With ClientDataSet1 do
      begin
        if locate('cpf',loPessoa.cpf,[]) then
           Edit
        Else
           Append;
        FieldByName('nome').AsString := loPessoa.Nome;
        FieldByName('Identidade').AsString := loPessoa.Identidade;
        FieldByName('Cpf').AsString := loPessoa.Cpf;
        FieldByName('Telefone').AsString := loPessoa.Telefone;
        FieldByName('Email').AsString := loPessoa.Email;
        FieldByName('Cep').AsInteger := loPessoa.Endereco.Cep;
        FieldByName('Logradouro').AsString := loPessoa.Endereco.Logradouro;
        FieldByName('Numero').AsString := loPessoa.Endereco.Numero;
        FieldByName('Complemento').AsString := loPessoa.Endereco.Complemento;
        FieldByName('Bairro').AsString := loPessoa.Endereco.Bairro;
        FieldByName('Cidade').AsString := loPessoa.Endereco.Cidade;
        FieldByName('Pais').AsString := loPessoa.Endereco.Pais;
        Post;
      end;

      if MessageDlg('Deseja Enviar E-mail para cadastrado ?', mtConfirmation, [mbYes, mbNo], 0)  = mrYes Then
         begin
            loEmailThread := TEmailThread.Create(loPessoa);
            loEmailThread.Execute;
         end;

  finally
    loPessoa.DisposeOf;
  end;

end;

procedure TfrmPrincipal.Limpar;
begin
 edNome.Text := '';
 edIdentidade.Text := '';
 edCPF.Text:= '';
 edTelefone.Text:= '';
 edEmail.Text:= '';
 edCEP.Text:= '';
 edLogradouro.Text:= '';
 edComplemento.Text:= '';
 edBairro.Text:= '';
 edCidade.Text:= '';
 edEstado.Text:= '';
 edPais.Text := '';
end;


procedure TfrmPrincipal.LoadRegistro;
begin
  if ClientDataSet1.RecordCount >= 1 then
     With ClientDataSet1 do
      begin
         edNome.Text :=        FieldByName('nome').AsString;
         edIdentidade.Text :=  FieldByName('Identidade').AsString;
         edCPF.Text:=          FieldByName('Cpf').AsString ;
         edTelefone.Text:=     FieldByName('Telefone').AsString ;
         edEmail.Text:=        FieldByName('Email').AsString;
         edCEP.Text :=         FieldByName('Cep').AsString;
         edLogradouro.Text:=   FieldByName('Logradouro').AsString;
         edComplemento.Text:=  FieldByName('Numero').AsString;
         edBairro.Text:=       FieldByName('Complemento').AsString;
         edCidade.Text:=       FieldByName('Bairro').AsString;
         edEstado.Text:=       FieldByName('Cidade').AsString;
         edPais.Text :=        FieldByName('Pais').AsString;
      end;
end;

function TfrmPrincipal.ValidaSMTP: Boolean;
begin
  Result := (
      (edPorta.Text <> '') and
      (edHost.Text <> '') and
      (edUsuario.Text <> '') and
      (edSenha.Text <> '')
      );
end;

{ TCepThread }

constructor TCepThread.Create(ACep:Integer);
begin
  inherited Create(True);
  FCep := Acep;
  FreeOnTerminate := True; // Libera da memoria
  Priority := TpLower; //Prioridade na lista
  Resume; // Inicia
end;

procedure TCepThread.Execute;
var Objeto: TJSONObject;
    error:string;
begin
  inherited;
  Try
    frmPrincipal.IndCep.Visible := True;
    Application.ProcessMessages;

    frmPrincipal.RESTClient1.BaseURL := 'https://viacep.com.br';

    frmPrincipal.RESTRequest1.Resource := Format('/ws/%s/json/',[FCep.ToString]);
    frmPrincipal.RESTRequest1.Method := TRESTRequestMethod.rmGET;
    frmPrincipal.RESTRequest1.Execute;

    Objeto := frmPrincipal.RESTResponse1.JSONValue as TJSONObject;

    if (Objeto as TJSONValue).TryGetValue('erro', error) = false then
       begin
          frmPrincipal.edLogradouro.Text := Objeto.GetValue('logradouro').Value;
          frmPrincipal.edComplemento.Text := Objeto.GetValue('complemento').Value;
          frmPrincipal.edBairro.Text := Objeto.GetValue('bairro').Value;
          frmPrincipal.edCidade.Text := Objeto.GetValue('localidade').Value;
          frmPrincipal.edEstado.Text := Objeto.GetValue('uf').Value;
          frmPrincipal.edPais.Text := 'Brasil';
       end
    else
       begin
          frmPrincipal.edLogradouro.Text := '';
          frmPrincipal.edComplemento.Text := '';
          frmPrincipal.edBairro.Text := '';
          frmPrincipal.edCidade.Text := '';
          frmPrincipal.edEstado.Text := '';
          frmPrincipal.edPais.Text := '';
       end;
  finally
    frmPrincipal.IndCep.Visible := False;
    Application.ProcessMessages;
  End;
end;

{ TEmailThread }

constructor TEmailThread.Create(AObjeto: TObject);
begin
  inherited Create(True);
  FObjeto := AObjeto;
  FreeOnTerminate := True; // Libera da memoria
  Priority := TpLower; //Prioridade na lista
  Resume; // Inicia
end;

procedure TEmailThread.Execute;
begin
  inherited;
  Try
    frmPrincipal.LabelEmail.Caption := Format('Enviando E-mail para [%s]',[ TPessoa(FObjeto).Email ]);
    frmPrincipal.LabelEmail.Visible := True;
    Application.ProcessMessages;

    frmPrincipal.EnviarEmail( FObjeto );
  Finally
    frmPrincipal.LabelEmail.Caption := '';
    frmPrincipal.LabelEmail.Visible := False;
    Application.ProcessMessages;
  End;
end;

end.
