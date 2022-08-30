unit UniCadastroInstrumento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, acPNG, ExtCtrls, DB, IBDatabase, IBStoredProc,
  IBCustomDataSet, IBQuery, Grids, DBGrids;

type
  TFrmCadastroInstrumento = class(TForm)
    IBQuery1: TIBQuery;
    SP_CADASTRO_INSTRUMENTOS: TIBStoredProc;
    TR_CADASTRO: TIBTransaction;
    QRY_BUSCAID: TIBQuery;
    DataSource2: TDataSource;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    IBQuery1INS_CODIGO: TIntegerField;
    IBQuery1INS_DESCRICAO: TIBStringField;
    IBQuery1INS_TIPO: TIBStringField;
    IBQuery1INS_AFINACAO: TIBStringField;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Image1: TImage;
    Panel2: TPanel;
    Edit1: TEdit;
    Panel3: TPanel;
    Button1: TButton;
    Panel5: TPanel;
    Panel4: TPanel;
    Edit2: TEdit;
    Panel6: TPanel;
    Panel7: TPanel;
    Edit3: TEdit;
    Button2: TButton;
    procedure GravaCadastro();
    procedure Button1Click(Sender: TObject); 
    procedure BUSCA_ID_INSTRUMENTO();
    procedure limpatexto();
    procedure ATUALIZAQRY(NOME_QRY: TIBQuery);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ExcluirCadastro(codigoInstrumento:integer);
    procedure DBGrid1DblClick(Sender: TObject);
  
  private
    codIns : integer;
    codigoInstrumento:integer;
    AUX_CODIGO_INS : string;
    editar : Boolean;
  public
    { Public declarations }
  end;

var
  FrmCadastroInstrumento: TFrmCadastroInstrumento;

implementation

uses UniCadastroUsuario;

{$R *.dfm}


procedure TFrmCadastroInstrumento.Button1Click(Sender: TObject);
begin
     BUSCA_ID_INSTRUMENTO();
     GravaCadastro();
     ATUALIZAQRY(IBQuery1);
     limpatexto();
end;

procedure TFrmCadastroInstrumento.Button2Click(Sender: TObject);
begin
     ExcluirCadastro(DBGrid1.DataSource.DataSet.FieldByName('INS_CODIGO').AsInteger);
   
end;

procedure TFrmCadastroInstrumento.DBGrid1DblClick(Sender: TObject);
begin
  Edit1.Text :=  DBGrid1.DataSource.DataSet.FieldByName ('INS_DESCRICAO').AsString;
  Edit2.Text :=  DBGrid1.DataSource.DataSet.FieldByName ('INS_TIPO').AsString;
  Edit3.Text :=  DBGrid1.DataSource.DataSet.FieldByName ('INS_AFINACAO').AsString;
  AUX_CODIGO_INS := IntToStr(DBGrid1.DataSource.DataSet.FieldByName ('INS_CODIGO').AsInteger);
  editar := True;
end;

procedure TFrmCadastroInstrumento.FormCreate(Sender: TObject);
begin
     IBQuery1.close;
     IBQuery1.Open;
end;

procedure TFrmCadastroInstrumento.GravaCadastro();
begin
  if NOT(TR_CADASTRO.Active) then
  TR_CADASTRO.Active := TRUE;
  try
  SP_CADASTRO_INSTRUMENTOS.ParamByName('INS_CODIGO').AsInteger := codIns + 1;
  SP_CADASTRO_INSTRUMENTOS.ParamByName('INS_DESCRICAO').AsString := Edit1.text;
  SP_CADASTRO_INSTRUMENTOS.ParamByName('INS_TIPO').AsString := Edit2.text;
  SP_CADASTRO_INSTRUMENTOS.ParamByName('INS_AFINACAO').AsString := Edit3.text;
  SP_CADASTRO_INSTRUMENTOS.ExecProc;
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
end;

procedure TFrmCadastroInstrumento.ExcluirCadastro(codigoInstrumento:integer);
begin
  if NOT(TR_CADASTRO.Active) then
  TR_CADASTRO.Active := TRUE;
  try
  SP_CADASTRO_INSTRUMENTOS.ParamByName('INS_CODIGO').AsInteger := codigoInstrumento;
  SP_CADASTRO_INSTRUMENTOS.ParamByName('INS_DESCRICAO').AsString := '-1';
  SP_CADASTRO_INSTRUMENTOS.ParamByName('INS_TIPO').AsString := '';
  SP_CADASTRO_INSTRUMENTOS.ParamByName('INS_AFINACAO').AsString := '';
  SP_CADASTRO_INSTRUMENTOS.ExecProc;
  ShowMessage('EXCLUIDO COM SUCESSO');
  except on ERRO:exception do
  begin
  TR_CADASTRO.Rollback;
  ShowMessage('ERRO: '+ Erro.Message + ' ERRO AO TENTAR EXCLUIR CADASTRO!');
  Abort;
  end;
  end;
  TR_CADASTRO.Commit;
end;

procedure TFrmCadastroInstrumento.limpatexto();
begin
     Edit1.TEXT := '';
     Edit2.TEXT := '';
     Edit3.Text := '';
end;

procedure TFrmCadastroInstrumento.ATUALIZAQRY(NOME_QRY: TIBQuery);
begin
     NOME_QRY.Close();
     NOME_QRY.OPEN();
end;

procedure TFrmCadastroInstrumento.BUSCA_ID_INSTRUMENTO();
begin
QRY_BUSCAID.CLOSE;
QRY_BUSCAID.SQL.CLEAR;
QRY_BUSCAID.SQL.ADD('SELECT FIRST 1 INS_CODIGO FROM INSTRUMENTOS');
QRY_BUSCAID.SQL.ADD('ORDER BY INS_CODIGO DESC');
QRY_BUSCAID.OPEN;
codIns := QRY_BUSCAID.FieldByName('INS_CODIGO').AsInteger;
end;


end.
