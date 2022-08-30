unit UniCadastroProfessor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, acPNG, ExtCtrls, ComCtrls, StdCtrls, IBStoredProc, DB,
  IBCustomDataSet, IBQuery, IBDatabase, Grids, DBGrids;

type
  TFrmCadastroProfessor = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel2: TPanel;
    Edit1: TEdit;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Edit2: TEdit;
    Button1: TButton;
    PRO_DATA_NASCI: TDateTimePicker;
    Panel6: TPanel;
    Label4: TLabel;
    Image1: TImage;
    IBQuery1: TIBQuery;
    DataSource1: TDataSource;
    SP_CADASTRO_PROFESSORES: TIBStoredProc;
    TR_CADASTRO: TIBTransaction;
    QRY_BUSCAID: TIBQuery;
    DataSource2: TDataSource;
    DBGrid1: TDBGrid;
    IBQuery1PRO_CODIGO: TIntegerField;
    IBQuery1PRO_NOME: TIBStringField;
    IBQuery1PRO_CPF: TIntegerField;
    IBQuery1PRO_DATA_NASCI: TDateField;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure GravaCadastro();
    procedure BUSCA_ID_PROFESSOR();
    procedure limpatexto();
    procedure ATUALIZAQRY(NOME_QRY: TIBQuery);
    procedure FormCreate(Sender: TObject);
    procedure ExcluirCadastro(codigoProfessor:integer);
    procedure Button2Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    
  private
    codPro : integer;
    codigoProfessor : integer;
    AUX_CODIGO_PRO : string;
    editar : Boolean;
  public
    { Public declarations }
  end;

var
  FrmCadastroProfessor: TFrmCadastroProfessor;

implementation

uses UniCadastroUsuario;

{$R *.dfm}

procedure TFrmCadastroProfessor.Button1Click(Sender: TObject);
begin
  BUSCA_ID_PROFESSOR();
  GravaCadastro();
end;

procedure TFrmCadastroProfessor.Button2Click(Sender: TObject);
begin
   ExcluirCadastro(DBGrid1.DataSource.DataSet.FieldByName('PRO_CODIGO').AsInteger);
   ATUALIZAQRY(IBQuery1);
end;

procedure TFrmCadastroProfessor.DBGrid1DblClick(Sender: TObject);
begin
   Edit1.Text :=  DBGrid1.DataSource.DataSet.FieldByName ('PRO_NOME').AsString;
   Edit2.Text :=  IntToStr(DBGrid1.DataSource.DataSet.FieldByName ('PRO_CPF').AsInteger);
   AUX_CODIGO_PRO := IntToStr(DBGrid1.DataSource.DataSet.FieldByName ('PRO_CODIGO').AsInteger);
   editar := True;
end;

procedure TFrmCadastroProfessor.FormCreate(Sender: TObject);
begin
   IBQuery1.close;
   IBQuery1.Open;
end;

procedure TFrmCadastroProfessor.GravaCadastro();
begin
  if NOT(TR_CADASTRO.Active) then
  TR_CADASTRO.Active := TRUE;
  try
  SP_CADASTRO_PROFESSORES.ParamByName('PRO_CODIGO').AsInteger := codPro + 1;
  SP_CADASTRO_PROFESSORES.ParamByName('PRO_NOME').AsString := Edit1.text;
  SP_CADASTRO_PROFESSORES.ParamByName('PRO_CPF').AsInteger := StrToInt(Edit2.text);
  SP_CADASTRO_PROFESSORES.ParamByName('PRO_DATA_NASCI').AsDate := PRO_DATA_NASCI.DATE;
  SP_CADASTRO_PROFESSORES.ExecProc;
  ShowMessage('CADASTRADO COM SUCESSO');
  except on ERRO:exception do
  begin
  TR_CADASTRO.Rollback;
  ShowMessage('ERRO: '+Erro.Message + 'ERRO AO TENTAR GRAVAR CADASTRO!"');
  Abort;
  end;
  end;
  TR_CADASTRO.Commit;
  ATUALIZAQRY(IBQuery1);
  limpatexto();
end;


procedure TFrmCadastroProfessor.ExcluirCadastro(codigoProfessor:integer);
begin
  if NOT(TR_CADASTRO.Active) then
  TR_CADASTRO.Active := TRUE;
  try
  SP_CADASTRO_PROFESSORES.ParamByName('PRO_CODIGO').AsInteger := codigoProfessor;
  SP_CADASTRO_PROFESSORES.ParamByName('PRO_NOME').AsString := '-1';
  SP_CADASTRO_PROFESSORES.ParamByName('PRO_CPF').AsInteger := 0;
  SP_CADASTRO_PROFESSORES.ParamByName('PRO_DATA_NASCI').AsDate := Date;
  SP_CADASTRO_PROFESSORES.ExecProc;
  ShowMessage('CADASTRADO EXCLUIDO');
  except on ERRO:exception do
  begin
  TR_CADASTRO.Rollback;
  ShowMessage('ERRO: '+Erro.Message + ' ERRO AO TENTAR EXCLUIR CADASTRO!"');
  Abort;
  end;
  end;
  TR_CADASTRO.Commit;
  ATUALIZAQRY(IBQuery1);
  limpatexto();
end;

procedure TFrmCadastroProfessor.limpatexto();
begin
     Edit1.TEXT := '';
   Edit2.TEXT := '';
   PRO_DATA_NASCI.Date := 0;
end;

procedure TFrmCadastroProfessor.ATUALIZAQRY(NOME_QRY: TIBQuery);
begin
   NOME_QRY.Close();
   NOME_QRY.OPEN();
end;

procedure TFrmCadastroProfessor.BUSCA_ID_PROFESSOR();
begin
  QRY_BUSCAID.CLOSE;
  QRY_BUSCAID.SQL.CLEAR;
  QRY_BUSCAID.SQL.ADD('SELECT FIRST 1 PRO_CODIGO FROM PROFESSORES');
  QRY_BUSCAID.SQL.ADD('ORDER BY PRO_CODIGO DESC');
  QRY_BUSCAID.OPEN;
  codPro := QRY_BUSCAID.FieldByName('PRO_CODIGO').AsInteger;
end;
end.
