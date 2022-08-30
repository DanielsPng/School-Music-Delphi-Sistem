unit FReAulas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, IBCustomDataSet, IBQuery, QRCtrls, QuickRpt, ExtCtrls;

type
  TFRelAulas = class(TForm)
    QuickRep1: TQuickRep;
    PageHeaderBand1: TQRBand;
    QRSysData4: TQRSysData;
    QRSysData5: TQRSysData;
    QRLabel1: TQRLabel;
    QRBand2: TQRBand;
    QRY_AULAS: TIBQuery;
    QRGroup1: TQRGroup;
    QRLabel9: TQRLabel;
    QRDBText3: TQRDBText;
    QRDBText8: TQRDBText;
    QRLabel8: TQRLabel;
    QRDBText2: TQRDBText;
    QRLabel3: TQRLabel;
    QRDBText5: TQRDBText;
    QRLabel5: TQRLabel;
    QRDBText1: TQRDBText;
    QRLabel2: TQRLabel;
    QRDBText4: TQRDBText;
    QRLabel4: TQRLabel;
    QRY_AULASAULA_CODIGO: TIntegerField;
    QRY_AULASAULA_DIA: TIBStringField;
    QRY_AULASAULA_HORARIO: TIBStringField;
    QRY_AULASAULA_DURACAO: TIBStringField;
    QRY_AULASAULA_MATERIA: TIBStringField;
    QRY_AULASALU_CODIGO: TIntegerField;
    QRY_AULASALU_NOME: TIBStringField;
    QRY_AULASPRO_CODIGO: TIntegerField;
    QRY_AULASPRO_NOME: TIBStringField;
    QRY_AULASINS_CODIGO: TIntegerField;
    QRY_AULASINS_DESCRICAO: TIBStringField;
    QRLabel10: TQRLabel;
    QRDBText9: TQRDBText;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRelAulas: TFRelAulas;

implementation
uses UniCadastroUsuario;

{$R *.dfm}

procedure TFRelAulas.FormCreate(Sender: TObject);
begin
     QRY_AULAS.Open;
end;

end.
