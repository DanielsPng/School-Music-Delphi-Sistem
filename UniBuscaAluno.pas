unit UniBuscaAluno;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, IBCustomDataSet, IBQuery, Grids, DBGrids, StdCtrls, ExtCtrls,
  acPNG, IBStoredProc, IBDatabase;

type
  TFrmBuscaAluno = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    RadioGroup1: TRadioGroup;
    Edit1: TEdit;
    GridBusca: TDBGrid;
    DataSource1: TDataSource;
    QRY_ALUNOS: TIBQuery;
    QRY_ALUNOSALU_CODIGO: TIntegerField;
    QRY_ALUNOSALU_NOME: TIBStringField;
    QRY_ALUNOSALU_CPF: TIntegerField;
    QRY_ALUNOSALU_DATA_NASCI: TDateField;
    SP_CADASTRO_AA: TIBStoredProc;
    TR_AULA_ALUNO: TIBTransaction;
    procedure buscaAula();
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure CarregaAluno();
    procedure GridBuscaDblClick(Sender: TObject);
    procedure GravarAlunoAula();
    
  private
    { Private declarations }
  public
  CodigoAluno : string;
  end;

var
  FrmBuscaAluno: TFrmBuscaAluno;

implementation
uses UniCadastroAluno, UniCadastroAulas, UniCadastroUsuario;

{$R *.dfm}

procedure TFrmBuscaAluno.buscaAula;
begin
  QRY_ALUNOS.CLOSE;
  QRY_ALUNOS.SQL.CLEAR;
  QRY_ALUNOS.SQL.ADD('SELECT AL.*');
  QRY_ALUNOS.SQL.ADD('FROM ALUNOS AL');

if (RadioGroup1.ItemIndex = 0)  then
begin
     QRY_ALUNOS.SQL.ADD('WHERE AL.ALU_NOME LIKE ' + QuotedStr('%' + Edit1.Text + '%'));
end
else if (RadioGroup1.ItemIndex = 1) then
begin
     QRY_ALUNOS.SQL.ADD('WHERE AL.ALU_CPF LIKE ' + QuotedStr('%' + Edit1.Text + '%'));
end
else if (RadioGroup1.ItemIndex = 2) then
begin
     QRY_ALUNOS.SQL.ADD('WHERE AL.ALU_DATA_NASCI LIKE ' + QuotedStr('%' + Edit1.Text + '%'));  
end;
    QRY_ALUNOS.OPEN;
end;

procedure TFrmBuscaAluno.CarregaAluno;
begin
 WITH FrmCadastroAluno do
   begin
     codigoAlunos := GridBusca.DataSource.DataSet.FieldByName('ALU_CODIGO').AsInteger;
     ALU_NOME.Text := GridBusca.DataSource.DataSet.FieldByName('ALU_NOME').AsString;
     ALU_CPF.TEXT := GridBusca.DataSource.DataSet.FieldByName('ALU_CPF').AsString;
     ALU_DATA_NASCI.Date := GridBusca.DataSource.DataSet.FieldByName('ALU_DATA_NASCI').AsDateTime;
   end;
end;

procedure TFrmBuscaAluno.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
if(Key = #13)then 
begin
  buscaAula();
end
end;

procedure TFrmBuscaAluno.FormCreate(Sender: TObject);
begin
  QRY_ALUNOS.CLOSE;
  QRY_ALUNOS.OPEN;
end;

procedure TFrmBuscaAluno.GravarAlunoAula;
begin
   if NOT(TR_AULA_ALUNO.Active) then
   TR_AULA_ALUNO.Active := TRUE;
  try
  SP_CADASTRO_AA.ParamByName('AA_CODIGO').AsInteger := StrToIntDef(CodigoAluno, 0);
  SP_CADASTRO_AA.ParamByName('ALU_CODIGO').AsInteger := GridBusca.DataSource.DataSet.FieldByName('ALU_CODIGO').AsInteger;
  SP_CADASTRO_AA.ParamByName('AULA_CODIGO').AsInteger := UniCadastroAulas.CodigoAula;

  SP_CADASTRO_AA.ExecProc;
  except on ERRO:exception do
  begin
  TR_AULA_ALUNO.Rollback;
  ShowMessage('ERRO: '+Erro.Message + 'ERRO AO TENTAR GRAVAR CADASTRO!"');
  Abort;
  end;
  end;
  TR_AULA_ALUNO.Commit;
end;

procedure TFrmBuscaAluno.GridBuscaDblClick(Sender: TObject);
begin
if Assigned(FrmCadastroAulas) then
   GravarAlunoAula()
else if Assigned(FrmCadastroAluno) then
  CarregaAluno();
  FrmCadastroAulas.QRY_ALUNOS.close;
  FrmCadastroAulas.QRY_ALUNOS.open;
     Close;
end;

end.
