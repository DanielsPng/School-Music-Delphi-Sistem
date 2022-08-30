unit UniCadastroAluno;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, acPNG, ExtCtrls, DB, IBQuery, IBCustomDataSet,
  IBStoredProc, IBDatabase, Grids, DBGrids;

type
  TFrmCadastroAluno = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Image1: TImage;
    Panel2: TPanel;
    ALU_NOME: TEdit;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    ALU_CPF: TEdit;
    ALU_DATA_NASCI: TDateTimePicker;
    Panel6: TPanel;
    Button1: TButton;
    SP_CADASTRO_ALUNOS: TIBStoredProc;
    IBQuery1: TIBQuery;
    TR_CADASTRO: TIBTransaction;
    QRY_BUSCAID: TIBQuery;
    DataSource2: TDataSource;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    IBQuery1ALU_CODIGO: TIntegerField;
    IBQuery1ALU_NOME: TIBStringField;
    IBQuery1ALU_CPF: TIntegerField;
    IBQuery1ALU_DATA_NASCI: TDateField;
    Button2: TButton;
    procedure GravaCadastro();
    procedure Button1Click(Sender: TObject);
    procedure BUSCA_ID_ALUNOS();
    procedure ATUALIZAQRY(NOME_QRY: TIBQuery);
    procedure limpatexto();
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ExcluirCadastro(codigoAlunos:integer);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AbreBuscaAluno();
    
  private
    codAluno : Integer;
    AUX_CODIGO_ALUNO : string;
    editar : Boolean;
  public
     codigoAlunos : integer;
  end;

var
  FrmCadastroAluno: TFrmCadastroAluno;
  CodigoAluno : Integer = 0;

implementation


uses UniCadastroUsuario, UniBuscaAluno;

{$R *.dfm}

procedure TFrmCadastroAluno.Button1Click(Sender: TObject);
begin
if (CodigoAluno = 0) then
   BUSCA_ID_ALUNOS();
   
     GravaCadastro();
end;

procedure TFrmCadastroAluno.Button2Click(Sender: TObject);
begin
     ExcluirCadastro(DBGrid1.DataSource.DataSet.FieldByName('ALU_CODIGO').AsInteger);

end;

procedure TFrmCadastroAluno.DBGrid1DblClick(Sender: TObject);
begin
  ALU_NOME.Text :=  DBGrid1.DataSource.DataSet.FieldByName ('ALU_NOME').AsString;
  ALU_CPF.Text :=  IntToStr(DBGrid1.DataSource.DataSet.FieldByName ('ALU_CPF').AsInteger);
  AUX_CODIGO_ALUNO := IntToStr(DBGrid1.DataSource.DataSet.FieldByName ('ALU_CODIGO').AsInteger);
  editar := True;
end;

procedure TFrmCadastroAluno.FormCreate(Sender: TObject);
begin
     IBQuery1.close;
     IBQuery1.Open;
end;

procedure TFrmCadastroAluno.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if (key = vk_f1) then
begin
     AbreBuscaAluno();
end;
end;

procedure TFrmCadastroAluno.AbreBuscaAluno();
begin
  Application.CreateForm(TFrmBuscaAluno, FrmBuscaAluno);
try
   FrmBuscaAluno.ShowModal;
finally
   FreeAndNil(FrmBuscaAluno);
end;
end;

procedure TFrmCadastroAluno.GravaCadastro();
begin
  if NOT(TR_CADASTRO.Active) then
  TR_CADASTRO.Active := TRUE;
  try
  if (CodigoAluno <> 0) then
      SP_CADASTRO_ALUNOS.ParamByName('ALU_CODIGO').AsInteger := codigoAluno
   else
  
  SP_CADASTRO_ALUNOS.ParamByName('ALU_CODIGO').AsInteger := codAluno + 1;
  SP_CADASTRO_ALUNOS.ParamByName('ALU_NOME').AsString := ALU_NOME.text;
  SP_CADASTRO_ALUNOS.ParamByName('ALU_CPF').AsInteger := StrToInt(ALU_CPF.text);
  SP_CADASTRO_ALUNOS.ParamByName('ALU_DATA_NASCI').AsDate := ALU_DATA_NASCI.DATE;
  SP_CADASTRO_ALUNOS.ExecProc;
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
  CodigoAluno := 0;
end;

procedure TFrmCadastroAluno.ExcluirCadastro(codigoAlunos:integer);
begin
  if NOT(TR_CADASTRO.Active) then
  TR_CADASTRO.Active := TRUE;
  try
  SP_CADASTRO_ALUNOS.ParamByName('ALU_CODIGO').AsInteger := codigoAlunos;
  SP_CADASTRO_ALUNOS.ParamByName('ALU_NOME').AsString := '-1';
  SP_CADASTRO_ALUNOS.ParamByName('ALU_CPF').AsInteger := 0;
  SP_CADASTRO_ALUNOS.ParamByName('ALU_DATA_NASCI').AsDate := date;
  SP_CADASTRO_ALUNOS.ExecProc;
  ShowMessage('CADASTRO EXCLUIDO');
  except on ERRO:exception do
  begin
  TR_CADASTRO.Rollback;
  ShowMessage('ERRO: '+Erro.Message + ' ERRO AO TENTAR EXCLUIR CADASTRO!"');
  Abort;
  end;
  end;
  TR_CADASTRO.Commit;
  ATUALIZAQRY(IBQuery1);
end;

procedure TFrmCadastroAluno.BUSCA_ID_ALUNOS();
begin
QRY_BUSCAID.CLOSE;
QRY_BUSCAID.SQL.CLEAR;
QRY_BUSCAID.SQL.ADD('SELECT FIRST 1 ALU_CODIGO FROM ALUNOS');
QRY_BUSCAID.SQL.ADD('ORDER BY ALU_CODIGO DESC');
QRY_BUSCAID.OPEN;
codAluno := QRY_BUSCAID.FieldByName('ALU_CODIGO').AsInteger;
end;

procedure TFrmCadastroAluno.limpatexto();
begin
     ALU_NOME.TEXT := '';
     ALU_CPF.TEXT := '';
     ALU_DATA_NASCI.Date := 0;
end;

procedure TFrmCadastroAluno.ATUALIZAQRY(NOME_QRY: TIBQuery);
begin
     NOME_QRY.Close();
     NOME_QRY.OPEN();
end;
end.
