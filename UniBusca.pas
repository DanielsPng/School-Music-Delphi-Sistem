unit UniBusca;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, IBCustomDataSet, IBQuery, acPNG, ExtCtrls, Grids, DBGrids,
  StdCtrls;

type
  TFrmBusca = class(TForm)
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    Edit1: TEdit;
    GridBusca: TDBGrid;
    Image1: TImage;
    QRY_AULA: TIBQuery;
    DataSource1: TDataSource;
    QRY_AULAAULA_CODIGO: TIntegerField;
    QRY_AULAAULA_MATERIA: TIBStringField;
    QRY_AULAAULA_DIA: TIBStringField;
    QRY_AULAAULA_HORARIO: TIBStringField;
    QRY_AULAAULA_DURACAO: TIBStringField;
    QRY_AULAALU_CODIGO: TIntegerField;
    QRY_AULAPRO_CODIGO: TIntegerField;
    QRY_AULAINS_CODIGO: TIntegerField;
    QRY_AULAPRO_NOME: TIBStringField;
    QRY_AULAINS_DESCRICAO: TIBStringField;

    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure GridBuscaDblClick(Sender: TObject);
    procedure CarregaAula();
    
  private
  
    procedure buscaAula();
    
  public
    { Public declarations }
  end;

var
  FrmBusca: TFrmBusca;

implementation
uses UniCadastroAulas;

{$R *.dfm}

procedure TFrmBusca.buscaAula;
begin
  QRY_AULA.CLOSE;
  QRY_AULA.SQL.CLEAR;
  QRY_AULA.SQL.ADD('SELECT AU.*, PR.PRO_NOME, IT.INS_DESCRICAO');
  QRY_AULA.SQL.ADD('FROM AULAS AU');
  QRY_AULA.SQL.ADD('INNER JOIN PROFESSORES PR ON AU.PRO_CODIGO = PR.PRO_CODIGO');
  QRY_AULA.SQL.ADD('INNER JOIN INSTRUMENTOS IT ON AU.INS_CODIGO = IT.INS_CODIGO');

if (RadioGroup1.ItemIndex = 0)  then
begin
     QRY_AULA.SQL.ADD('WHERE IT.INS_DESCRICAO LIKE ' + QuotedStr('%' + Edit1.Text + '%'));
end
else if (RadioGroup1.ItemIndex = 1) then
begin
     QRY_AULA.SQL.ADD('WHERE PR.PRO_NOME LIKE ' + QuotedStr('%' + Edit1.Text + '%'));
end
else if (RadioGroup1.ItemIndex = 2) then
begin
     QRY_AULA.SQL.ADD('WHERE AU.AULA_MATERIA LIKE ' + QuotedStr('%' + Edit1.Text + '%'));  
end
else if (RadioGroup1.ItemIndex = 3) then
begin
     QRY_AULA.SQL.ADD('WHERE AU.AULA_DIA LIKE ' + QuotedStr('%' + Edit1.Text + '%'));  
end
else if (RadioGroup1.ItemIndex = 4) then
begin
     QRY_AULA.SQL.ADD('WHERE AU.AULA_HORARIO LIKE ' + QuotedStr('%' + Edit1.Text + '%'));  
end;
           
QRY_AULA.OPEN;

end;

procedure TFrmBusca.CarregaAula;
begin
     WITH FrmCadastroAulas do
     begin
       CodigoAula := GridBusca.DataSource.DataSet.FieldByName('AULA_CODIGO').AsInteger;
       AULA_MATERIA.Text := GridBusca.DataSource.DataSet.FieldByName('AULA_MATERIA').AsString;
       AULA_DIA.TEXT := GridBusca.DataSource.DataSet.FieldByName('AULA_DIA').AsString;
       AULA_HORARIO.TEXT := GridBusca.DataSource.DataSet.FieldByName('AULA_HORARIO').AsString;
       AULA_DURACAO.TEXT := GridBusca.DataSource.DataSet.FieldByName('AULA_DURACAO').AsString;
       INS_CODIGO.KeyValue := GridBusca.DataSource.DataSet.FieldByName('INS_CODIGO').AsInteger;
       PRO_CODIGO.KeyValue := GridBusca.DataSource.DataSet.FieldByName('PRO_CODIGO').AsInteger;
     end;
end;

procedure TFrmBusca.GridBuscaDblClick(Sender: TObject);
begin
     CarregaAula();
     Close;
end;

procedure TFrmBusca.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
if(Key = #13)then 
begin
  buscaAula();
end;
end;

procedure TFrmBusca.FormCreate(Sender: TObject);
begin
     QRY_AULA.CLOSE;
     QRY_AULA.OPEN;
end;

end.
