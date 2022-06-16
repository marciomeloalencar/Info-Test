object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Principal'
  ClientHeight = 807
  ClientWidth = 697
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 15
    Top = 569
    Width = 676
    Height = 185
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
  end
  object btnEnviar: TButton
    Left = 616
    Top = 757
    Width = 75
    Height = 25
    Caption = 'Enviar E-mail'
    TabOrder = 1
    OnClick = btnEnviarClick
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 6
    Width = 683
    Height = 554
    ActivePage = tbSMTP
    TabOrder = 2
    object tbCad: TTabSheet
      Caption = 'Cadastro'
      ExplicitWidth = 693
      object Label2: TLabel
        Left = 3
        Top = 54
        Width = 46
        Height = 13
        Caption = 'Identidde'
      end
      object Label3: TLabel
        Left = 3
        Top = 107
        Width = 17
        Height = 13
        Caption = 'Cpf'
      end
      object Label4: TLabel
        Left = 3
        Top = 163
        Width = 42
        Height = 13
        Caption = 'Telefone'
      end
      object Label5: TLabel
        Left = 3
        Top = 219
        Width = 28
        Height = 13
        Caption = 'E-Mail'
      end
      object LabelEmail: TLabel
        Left = 3
        Top = 510
        Width = 3
        Height = 13
        Color = clBlue
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Visible = False
      end
      object edCPF: TMaskEdit
        Left = 3
        Top = 126
        Width = 232
        Height = 21
        EditMask = '999\.999\.999\-99;0; '
        MaxLength = 14
        TabOrder = 2
        Text = ''
      end
      object edEmail: TMaskEdit
        Left = 3
        Top = 238
        Width = 641
        Height = 21
        CharCase = ecLowerCase
        TabOrder = 4
        Text = ''
      end
      object edIdentidade: TMaskEdit
        Left = 3
        Top = 73
        Width = 232
        Height = 21
        EditMask = '999999999999999999999;0; '
        MaxLength = 21
        TabOrder = 1
        Text = ''
      end
      object edNome: TLabeledEdit
        Left = 3
        Top = 27
        Width = 641
        Height = 21
        CharCase = ecUpperCase
        EditLabel.Width = 27
        EditLabel.Height = 13
        EditLabel.Caption = 'Nome'
        TabOrder = 0
      end
      object edTelefone: TMaskEdit
        Left = 3
        Top = 182
        Width = 119
        Height = 21
        EditMask = '\(99\) 9 9999\-9999;0; '
        MaxLength = 16
        TabOrder = 3
        Text = ''
      end
      object GroupBox1: TGroupBox
        Left = 3
        Top = 278
        Width = 665
        Height = 217
        Caption = '   Endere'#231'o   '
        TabOrder = 5
        object Label1: TLabel
          Left = 24
          Top = 16
          Width = 19
          Height = 13
          Caption = 'Cep'
        end
        object IndCep: TShape
          Left = 150
          Top = 34
          Width = 13
          Height = 22
          Brush.Color = clBlue
          Shape = stCircle
          Visible = False
        end
        object edCEP: TMaskEdit
          Left = 24
          Top = 35
          Width = 120
          Height = 21
          EditMask = '99\.999\-999;0; '
          MaxLength = 10
          TabOrder = 0
          Text = ''
          OnChange = edCEPChange
        end
        object edLogradouro: TLabeledEdit
          Left = 24
          Top = 80
          Width = 529
          Height = 21
          EditLabel.Width = 55
          EditLabel.Height = 13
          EditLabel.Caption = 'Logradouro'
          TabOrder = 1
        end
        object edComplemento: TLabeledEdit
          Left = 24
          Top = 120
          Width = 633
          Height = 21
          EditLabel.Width = 65
          EditLabel.Height = 13
          EditLabel.Caption = 'Complemento'
          TabOrder = 3
        end
        object edBairro: TLabeledEdit
          Left = 24
          Top = 160
          Width = 121
          Height = 21
          EditLabel.Width = 28
          EditLabel.Height = 13
          EditLabel.Caption = 'Bairro'
          TabOrder = 4
        end
        object edCidade: TLabeledEdit
          Left = 176
          Top = 160
          Width = 121
          Height = 21
          EditLabel.Width = 33
          EditLabel.Height = 13
          EditLabel.Caption = 'Cidade'
          TabOrder = 5
        end
        object edEstado: TLabeledEdit
          Left = 360
          Top = 160
          Width = 121
          Height = 21
          EditLabel.Width = 33
          EditLabel.Height = 13
          EditLabel.Caption = 'Estado'
          TabOrder = 6
        end
        object edPais: TLabeledEdit
          Left = 538
          Top = 160
          Width = 121
          Height = 21
          EditLabel.Width = 19
          EditLabel.Height = 13
          EditLabel.Caption = 'Pais'
          TabOrder = 7
        end
        object edNumero: TLabeledEdit
          Left = 565
          Top = 80
          Width = 94
          Height = 21
          EditLabel.Width = 37
          EditLabel.Height = 13
          EditLabel.Caption = 'N'#250'mero'
          TabOrder = 2
        end
      end
      object btnGravar: TButton
        Left = 593
        Top = 501
        Width = 75
        Height = 25
        Caption = 'Gravar'
        TabOrder = 6
        OnClick = btnGravarClick
      end
    end
    object tbSMTP: TTabSheet
      Caption = 'Conf.. SMTP'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 28
      object Label6: TLabel
        Left = 24
        Top = 21
        Width = 26
        Height = 13
        Caption = 'Porta'
      end
      object Label7: TLabel
        Left = 125
        Top = 24
        Width = 56
        Height = 13
        Caption = 'SSL Metodo'
      end
      object edPorta: TMaskEdit
        Left = 24
        Top = 40
        Width = 64
        Height = 21
        EditMask = '999;0; '
        MaxLength = 3
        TabOrder = 0
        Text = '465'
      end
      object edHost: TLabeledEdit
        Left = 24
        Top = 96
        Width = 489
        Height = 21
        EditLabel.Width = 66
        EditLabel.Height = 13
        EditLabel.Caption = 'Host do SMTP'
        TabOrder = 2
        Text = 'smtp.gmail.com'
      end
      object edUsuario: TLabeledEdit
        Left = 24
        Top = 152
        Width = 489
        Height = 21
        EditLabel.Width = 36
        EditLabel.Height = 13
        EditLabel.Caption = 'Usuario'
        TabOrder = 3
      end
      object edSenha: TLabeledEdit
        Left = 24
        Top = 208
        Width = 289
        Height = 21
        EditLabel.Width = 30
        EditLabel.Height = 13
        EditLabel.Caption = 'Senha'
        TabOrder = 4
      end
      object edSSL: TComboBox
        Left = 120
        Top = 40
        Width = 145
        Height = 21
        ItemIndex = 0
        TabOrder = 1
        Text = 'sslvSSLv2'
        Items.Strings = (
          'sslvSSLv2'
          'sslvSSLv23'
          'sslvSSLv3'
          'sslvTLSv1'
          'sslvTLSv1_1'
          'sslvTLSv1_2')
      end
    end
  end
  object RESTClient1: TRESTClient
    Params = <>
    HandleRedirects = True
    Left = 728
    Top = 64
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 728
    Top = 120
  end
  object RESTResponse1: TRESTResponse
    Left = 728
    Top = 184
  end
  object ClientDataSet1: TClientDataSet
    PersistDataPacket.Data = {
      7D0100009619E0BD01000000180000000D0000000000030000007D01046E6F6D
      6501004900000001000557494454480200020064000A4964656E746964616465
      0100490000000100055749445448020002001500036370660100490000000100
      055749445448020002000B000874656C65666F6E650100490000000100055749
      44544802000200140005656D61696C0100490000000100055749445448020002
      0064000363657001004900000001000557494454480200020008000A6C6F6772
      61646F75726F0100490000000100055749445448020002003C00066E756D6572
      6F01004900000001000557494454480200020005000B636F6D706C656D656E74
      6F01004900000001000557494454480200020028000662616972726F01004900
      0000010005574944544802000200280006636964616465010049000000010005
      57494454480200020028000665737461646F0100490000000100055749445448
      0200020014000470616973010049000000010005574944544802000200280000
      00}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'nome'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'Identidade'
        DataType = ftString
        Size = 21
      end
      item
        Name = 'cpf'
        DataType = ftString
        Size = 11
      end
      item
        Name = 'telefone'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'email'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'cep'
        DataType = ftString
        Size = 8
      end
      item
        Name = 'logradouro'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'numero'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'complemento'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'bairro'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'cidade'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'estado'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'pais'
        DataType = ftString
        Size = 40
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 736
    Top = 256
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 736
    Top = 320
  end
end
