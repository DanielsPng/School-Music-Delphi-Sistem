unit UniCadastroAulas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, acPNG, ExtCtrls, StdCtrls, ComCtrls, IBDatabase, IBStoredProc, DB,
  IBCustomDataSet, IBQuery, DBCtrls, Grids, DBGrids, Menus;

type
  TFrmCadastroAulas = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel2: TPanel;
    AULA_MATERIA: TEdit;
    Panel3: TPanel;
    Button1: TButton;
    Panel5: TPanel;
    Panel4: TPanel;
    AULA_HORARIO: TEdit;
    Panel6: TPanel;
    Panel7: TPanel;
    AULA_DURACAO: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Image1: TImage;
    Panel8: TPanel;
    Panel9: TPanel;
    AULA_DIA: TEdit;
    DTS_1: TDataSource;
    IBQuery1: TIBQuery;
    IBQuery1ALU_CODIGO: TIntegerField;
    TR_CADASTRO: TIBTransaction;
    QRY_BUSCAID: TIBQuery;
    DTS_BUSCAID: TDataSource;
    INS_CODIGO: TDBLookupComboBox;
    QRY_INSTRUMENTO: TIBQuery;
    DTS_INS: TDataSource;
    QRY_INSTRUMENTOINS_CODIGO: TIntegerField;
    QRY_INSTRUMENTOINS_DESCRICAO: TIBStringField;
    QRY_INSTRUMENTOINS_TIPO: TIBStringField;
    QRY_INSTRUMENTOINS_AFINACAO: TIBStringField;
    QRY_PRO: TIBQuery;
    DTS_PRO: TDataSource;
    QRY_PROPRO_CODIGO: TIntegerField;
    QRY_PROPRO_NOME: TIBStringField;
    QRY_PROPRO_CPF: TIntegerField;
    QRY_PROPRO_DATA_NASCI: TDateField;
    PRO_CODIGO: TDBLookupComboBox;
    DBGrid1: TDBGrid;
    Label8: TLabel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    A1: TMenuItem;
    N3: TMenuItem;
    D1: TMenuItem;
    IBQuery1AULA_CODIGO: TIntegerField;
    IBQuery1AULA_MATERIA: TIBStringField;
    IBQuery1AULA_DIA: TIBStringField;
    IBQuery1AULA_HORARIO: TIBStringField;
    IBQuery1AULA_DURACAO: TIBStringField;
    IBQuery1PRO_CODIGO: TIntegerField;
    IBQuery1INS_CODIGO: TIntegerField;
    IBQuery1PRO_NOME: TIBStringField;
    IBQuery1INS_DESCRICAO: TIBStringField;
    QRY_ALUNOS: TIBQuery;
    DTS_ALUNOS: TDataSource;
    QRY_ALUNOSALU_CODIGO: TIntegerField;
    QRY_ALUNOSALU_NOME: TIBStringField;
    QRY_ALUNOSALU_CPF: TIntegerField;
    QRY_ALUNOSALU_DATA_NASCI: TDateField;
    SP_CADASTRO_AULAS: TIBStoredProc;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure GravaCadastro();
    procedure BUSCA_ID_AULA();
    procedure AbreBusca();
    procedure ATUALIZAQRY(NOME_QRY: TIBQuery);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure limpatexto();
    procedure N1Click(Sender: TObject);
    procedure abreQRY();

  private
    AUX_CODIGO_CIDADE : string;
  public
    codAula : integer;
  end;

var
  FrmCadastroAulas: TFrmCadastroAulas;
  CodigoAula : Integer = 0;

implementation

uses UniCadastroUsuario, UniBusca, UniBuscaAluno;

{$R *.dfm}

procedure TFrmCadastroAulas.Button1Click(Sender: TObject);
begin
   if (CodigoAula = 0) then
     BUSCA_ID_AULA();
     
     GravaCadastro();
     ATUALIZAQRY(IBQuery1);
end;

procedure TFrmCadastroAulas.limpatexto();
begin
     AULA_MATERIA.TEXT := '';
     AULA_HORARIO.TEXT := '';
     AULA_DIA.TEXT := '';
     AULA_DURACAO.Text := '';
     INS_CODIGO.KeyValue := null;
     PRO_CODIGO.KeyValue := Null;
end;

procedure TFrmCadastroAulas.N1Click(Sender: TObject);
begin
   Application.CreateForm(TFrmBuscaAluno, FrmBuscaAluno);
try
   FrmBuscaAluno.ShowModal;
finally
   FreeAndNil(FrmBuscaAluno);
end;    
end;

procedure TFrmCadastroAulas.abreQRY();
begin
     QRY_ALUNOS.CLOSE;
     QRY_ALUNOS.ParamByName('AULA_CODIGO').AsInteger := CodigoAula;
     QRY_ALUNOS.OPEN;
end;

Procedure TFrmCadastroAulas.GravaCadastro();
begin
if NOT(TR_CADASTRO.Active) then
TR_CADASTRO.Active := TRUE;
try
   if (CodigoAula <> 0) then
      SP_CADASTRO_AULAS.ParamByName('AULA_CODIGO').AsInteger := CodigoAula
   else
     SP_CADASTRO_AULAS.ParamByName('AULA_CODIGO').AsInteger := codAula + 1;

  SP_CADASTRO_AULAS.ParamByName('AULA_MATERIA').AsString := AULA_MATERIA.text;
  SP_CADASTRO_AULAS.ParamByName('AULA_DIA').AsString := AULA_DIA.text;
  SP_CADASTRO_AULAS.ParamByName('AULA_HORARIO').AsString := AULA_HORARIO.text;
  SP_CADASTRO_AULAS.ParamByName('AULA_DURACAO').AsString := AULA_DURACAO.text;
  SP_CADASTRO_AULAS.ParamByName('INS_CODIGO').AsInteger := INS_CODIGO.KeyValue;
  SP_CADASTRO_AULAS.ParamByName('PRO_CODIGO').AsInteger := PRO_CODIGO.KeyValue;
  SP_CADASTRO_AULAS.ExecProc;
except on ERRO:exception do
begin
TR_CADASTRO.Rollback;
ShowMessage('ERRO: '+ Erro.Message + ' ERRO AO TENTAR GRAVAR CADASTRO!');
Abort;
end;
end;
TR_CADASTRO.Commit;
ATUALIZAQRY(IBQuery1);
limpatexto();
CodigoAula := 0;
end;

procedure TFrmCadastroAulas.BUSCA_ID_AULA();
begin
  QRY_BUSCAID.CLOSE;
  QRY_BUSCAID.SQL.CLEAR;
  QRY_BUSCAID.SQL.ADD('SELECT FIRST 1 AULA_CODIGO FROM AULAS');
  QRY_BUSCAID.SQL.ADD('ORDER BY AULA_CODIGO DESC');
  QRY_BUSCAID.OPEN;
  codAula := QRY_BUSCAID.FieldByName('AULA_CODIGO').AsInteger;
end;

procedure TFrmCadastroAulas.ATUALIZAQRY(NOME_QRY: TIBQuery);
begin
     NOME_QRY.Close();
     NOME_QRY.OPEN();
end;

procedure TFrmCadastroAulas.FormCreate(Sender: TObject);
begin
  QRY_INSTRUMENTO.OPEN;
  QRY_INSTRUMENTO.FetchAll;
  QRY_PRO.OPEN;
  QRY_PRO.FetchAll;
end;

procedure TFrmCadastroAulas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if (key = vk_f1) then
begin
     AbreBusca();
end;
end;



procedure TFrmCadastroAulas.AbreBusca;
begin
  Application.CreateForm(TFrmBusca, FrmBusca);
try
   FrmBusca.ShowModal;
finally
   FreeAndNil(FrmBusca);
   abreQRY();
end;
end;

end.
