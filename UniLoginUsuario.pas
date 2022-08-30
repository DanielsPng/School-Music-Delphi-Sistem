unit UniLoginUsuario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, acPNG, ExtCtrls, DBCtrls, DB, IBCustomDataSet, IBQuery,
  IBDatabase, IBStoredProc;

type
  TFrmLogin = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Image1: TImage;
    Panel4: TPanel;
    Panel5: TPanel;
    Edit2: TEdit;
    Button1: TButton;
    QRY_USUARIO: TIBQuery;
    DataSource1: TDataSource;
    USU_CODIGO: TDBLookupComboBox;
    TR_CADASTRO: TIBTransaction;
    QRY_USUARIOUSU_CODIGO: TIntegerField;
    QRY_USUARIOUSU_DESCRICAO: TIBStringField;
    QRY_USUARIOUSU_SENHA: TIBStringField;
    SP_CADASTRO_USUARIO: TIBStoredProc;
    procedure ATUALIZA_QRY();
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

uses UniCadastroUsuario, UniCadastroInstrumento, UniCadastroAulas, UniDashboard;

{$R *.dfm}



{ TFrmLogin }


procedure TFrmLogin.ATUALIZA_QRY;
begin
     QRY_USUARIO.CLOSE;
     QRY_USUARIO.OPEN;
end;

procedure TFrmLogin.Button1Click(Sender: TObject);
begin
     if (edit2.text = ('1234')) then
begin
 Application.CreateForm(TFrmDasboard,FrmDasboard);
 FrmDasboard.ShowModal;
 end;                                  
 begin
 if (edit2.text <> ('1234')) then
 ShowMessage('SENHA INCORRETA');
 end;
end;    

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
     ATUALIZA_QRY();
end;

end.
