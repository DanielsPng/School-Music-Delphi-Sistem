unit UniDashboard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, acPNG, ExtCtrls, StdCtrls, DB, IBCustomDataSet, IBQuery;

type
  TFrmDasboard = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image1: TImage;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Image5: TImage;
    DataSource1: TDataSource;
    IBQuery1: TIBQuery;
    IBQuery1USU_CODIGO: TIntegerField;
    IBQuery1USU_DESCRICAO: TIBStringField;
    IBQuery1USU_SENHA: TIBStringField;
    IBQuery1PRO_CODIGO: TIntegerField;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure abreRelatorioAulas();
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDasboard: TFrmDasboard;

implementation
uses UniCadastroAluno, UniLoginUsuario, UniCadastroProfessor, 
UniCadastroInstrumento, UniCadastroAulas, UniBusca, UniCadastroUsuario, FReAulas;

{$R *.dfm}

procedure TFrmDasboard.Button1Click(Sender: TObject);
begin
     Application.CreateForm(TFrmCadastroAulas,FrmCadastroAulas);
     FrmCadastroAulas.ShowModal;
     FrmCadastroAulas.Close;
end;

procedure TFrmDasboard.Button2Click(Sender: TObject);
begin
     Application.CreateForm(TFrmCadastroAluno, FrmCadastroAluno);
     FrmCadastroAluno.ShowModal;
     FrmCadastroAluno.Close;
end;

procedure TFrmDasboard.Button3Click(Sender: TObject);
begin
     Application.CreateForm(TFrmCadastroProfessor, FrmCadastroProfessor);
     FrmCadastroProfessor.ShowModal;
     FrmCadastroProfessor.Close;
end;

procedure TFrmDasboard.Button4Click(Sender: TObject);
begin
     Application.CreateForm(TFrmCadastroInstrumento, FrmCadastroInstrumento);
     FrmCadastroInstrumento.ShowModal;
     FrmCadastroInstrumento.Close;
end;

procedure TFrmDasboard.Button5Click(Sender: TObject);
begin
      IBQuery1.close;
      IBQuery1.Open;     
     FrmCadastroUsuario.ShowModal;
     FrmCadastroUsuario.Close;
end;

procedure TFrmDasboard.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
       if (key = vk_f1) then
begin
     abreRelatorioAulas();
end;
end;

procedure TFrmDasboard.abreRelatorioAulas;
begin
Application.CreateForm(TFRelAulas, FRelAulas);
try
FRelAulas.QuickRep1.PreviewModal;
finally
FreeAndNil(FRelAulas);
end;
end;

end.
