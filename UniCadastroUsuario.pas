unit UniCadastroUsuario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, acPNG, IBDatabase, DB, IBCustomDataSet, IBQuery,
  DBTables, IBStoredProc, Grids, DBGrids;

type
  TFrmCadastroUsuario = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Panel2: TPanel;
    Panel3: TPanel;
    Label2: TLabel;
    Panel4: TPanel;
    Edit2: TEdit;
    Panel5: TPanel;
    Label3: TLabel;
    Button1: TButton;
    Image1: TImage;
    IBQuery1: TIBQuery;
    DataSource1: TDataSource;
    SP_CADASTRO_USUARIO: TIBStoredProc;
    QRY_BUSCAID: TIBQuery;
    DataSource2: TDataSource;
    IBQuery1USU_CODIGO: TIntegerField;
    IBQuery1USU_DESCRICAO: TIBStringField;
    IBQuery1USU_SENHA: TIBStringField;
    IBQuery1PRO_CODIGO: TIntegerField;
    TR_CADASTRO: TIBTransaction;
    IBDatabase1: TIBDatabase;
    DBGrid1: TDBGrid;

    procedure Button1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure abrecadastraluno();
    procedure abrecadastrprofessor();
    procedure abrecadastroinstrumento();
    procedure abrelogin();
    procedure GravaCadastro();
    procedure BUSCA_ID_USUARIO();
    procedure limpatexto();
    procedure abrecadastroaulas();
    procedure FormCreate(Sender: TObject);
    procedure ATUALIZAQRY(NOME_QRY: TIBQuery);
    
    
  private
    codUsuario : integer;
  public
    { Public declarations }
  end;

var
  FrmCadastroUsuario: TFrmCadastroUsuario;

implementation

uses UniCadastroAluno, UniLoginUsuario, UniCadastroProfessor, 
UniCadastroInstrumento, UniCadastroAulas, UniBusca, UniDashboard;

{$R *.dfm}


procedure TFrmCadastroUsuario.Button1Click(Sender: TObject);
begin
     BUSCA_ID_USUARIO();
     GravaCadastro();
     ATUALIZAQRY(IBQuery1);
     limpatexto();
end;

procedure TFrmCadastroUsuario.GravaCadastro();
begin
  if NOT(TR_CADASTRO.Active) then
  TR_CADASTRO.Active := TRUE;
  try
  SP_CADASTRO_USUARIO.ParamByName('USU_CODIGO').AsInteger := codUsuario + 1;
  SP_CADASTRO_USUARIO.ParamByName('USU_DESCRICAO').AsString := Edit1.text;
  SP_CADASTRO_USUARIO.ParamByName('USU_SENHA').AsString := Edit2.text;

  SP_CADASTRO_USUARIO.ExecProc;
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


procedure TFrmCadastroUsuario.BUSCA_ID_USUARIO();
begin
QRY_BUSCAID.CLOSE;
QRY_BUSCAID.SQL.CLEAR;
QRY_BUSCAID.SQL.ADD('SELECT FIRST 1 USU_CODIGO FROM USUARIOS');
QRY_BUSCAID.SQL.ADD('ORDER BY USU_CODIGO DESC');
QRY_BUSCAID.OPEN;

codUsuario := QRY_BUSCAID.FieldByName('USU_CODIGO').AsInteger;
end;

procedure TFrmCadastroUsuario.FormCreate(Sender: TObject);
begin
 IBQuery1.close;
 IBQuery1.Open;
Application.CreateForm(TFrmLogin, FrmLogin);
try
FrmLogin.ShowModal;
finally
FreeAndNil(FrmLogin);
end;
end;

procedure TFrmCadastroUsuario.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
begin
     if (key = vk_f5) then
begin
     abrecadastraluno();
end;
     if (key = vk_f2) then
begin
     abrecadastrprofessor();
end;
    if (key = vk_f3) then
begin
     abrecadastroinstrumento();
end;
    if (key = vk_f4) then
begin
     abrelogin();
end;
  if (key = vk_f1) then
begin
     abrecadastroaulas();
end;
    
end;
end;

procedure TFrmCadastroUsuario.ATUALIZAQRY(NOME_QRY: TIBQuery);
begin
     NOME_QRY.Close();
     NOME_QRY.OPEN();
end;

procedure TFrmCadastroUsuario.limpatexto();
var
n:integer;

begin

for n := 0 to ComponentCount -1 do begin

if Components[n] is Tedit then

Tedit(Components[n]).Text := '';

end;
end;

procedure TFrmCadastroUsuario.abrecadastraluno;
begin
Application.CreateForm(TFrmCadastroAulas, FrmCadastroAulas);
try
FrmCadastroAulas.ShowModal;
finally
FreeAndNil(FrmCadastroAulas);
end;
end;


procedure TFrmCadastroUsuario.abrecadastroaulas;
begin
Application.CreateForm(TFrmCadastroAluno, FrmCadastroAluno);
try
FrmCadastroAluno.ShowModal;
finally
FreeAndNil(FrmCadastroAluno);
end;
end;

procedure TFrmCadastroUsuario.abrecadastrprofessor;
begin
Application.CreateForm(TFrmCadastroProfessor, FrmCadastroProfessor);
try
FrmCadastroProfessor.ShowModal;
finally
FreeAndNil(FrmCadastroProfessor);
end;
end;

procedure TFrmCadastroUsuario.abrecadastroinstrumento;
begin
  Application.CreateForm(TFrmCadastroInstrumento, FrmCadastroInstrumento);
try
FrmCadastroInstrumento.ShowModal;
finally
FreeAndNil(FrmCadastroInstrumento);
end;
end;

procedure TFrmCadastroUsuario.abrelogin;
begin
  Application.CreateForm(TFrmLogin, FrmLogin);
try
FrmLogin.ShowModal;
finally
FreeAndNil(FrmLogin);
end;
end;

end.
