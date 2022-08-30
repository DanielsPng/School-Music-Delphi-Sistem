program Project4;

uses
  Forms,
  UniCadastroUsuario in 'UniCadastroUsuario.pas' {FrmCadastroUsuario},
  UniCadastroProfessor in 'UniCadastroProfessor.pas' {FrmCadastroProfessor},
  UniCadastroAluno in 'UniCadastroAluno.pas' {FrmCadastroAluno},
  UniLoginUsuario in 'UniLoginUsuario.pas' {FrmLogin},
  UniCadastroInstrumento in 'UniCadastroInstrumento.pas' {FrmCadastroInstrumento},
  UniCadastroAulas in 'UniCadastroAulas.pas' {FrmCadastroAulas},
  UniBusca in 'UniBusca.pas' {FrmBusca},
  UniBuscaAluno in 'UniBuscaAluno.pas' {FrmBuscaAluno},
  UniDashboard in 'UniDashboard.pas' {FrmDasboard},
  FReAulas in 'FReAulas.pas' {FRelAulas};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmCadastroUsuario, FrmCadastroUsuario);
  Application.CreateForm(TFRelAulas, FRelAulas);
  Application.CreateForm(TFrmCadastroProfessor, FrmCadastroProfessor);
  Application.CreateForm(TFrmCadastroAluno, FrmCadastroAluno);
  Application.CreateForm(TFrmCadastroInstrumento, FrmCadastroInstrumento);
  Application.CreateForm(TFrmCadastroAulas, FrmCadastroAulas);
  Application.CreateForm(TFrmBusca, FrmBusca);
  Application.CreateForm(TFrmBuscaAluno, FrmBuscaAluno);
  Application.CreateForm(TFrmDasboard, FrmDasboard);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.Run;
end.
