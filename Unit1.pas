unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    DBGrid1: TDBGrid;
    Label3: TLabel;
    Edit3: TEdit;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    DataSource1: TDataSource;
    procedure Button1Click(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  a: String;
  searchValue: String;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
try
  if (Edit1.Text = '') or (Edit2.Text = '') then
  begin
    ShowMessage('Semua kolom harus diisi!');
    Exit;
  end;

  ZQuery1.SQL.Clear;
  ZQuery1.SQL.Add('insert into satuan (nama, diskripsi) values (:field1, :field2)');
  ZQuery1.ParamByName('field1').AsString := Edit1.Text;
  ZQuery1.ParamByName('field2').AsString := Edit2.Text;
  ZQuery1.ExecSQL;

  ZQuery1.SQL.Clear;
  ZQuery1.SQL.Add('Select * from satuan');
  ZQuery1.Open;

  ShowMessage('Data Berhasil Disimpan');
  Edit1.Text := '';
  Edit2.Text := '';

  Edit1.SetFocus;

except
  on E: Exception do
    ShowMessage('Terjadi kesalahan: ' + E.Message);
end;

end;

procedure TForm1.DBGrid1CellClick(Column: TColumn);
begin
if not ZQuery1.IsEmpty then
  begin
    Edit1.Text := ZQuery1.FieldByName('nama').AsString;
    Edit2.Text := ZQuery1.FieldByName('diskripsi').AsString;
    a:=ZQuery1.Fields[0].AsString;
  end;

  Button1.Enabled := False;
  Button2.Enabled := True;
  Button3.Enabled := True;

  Edit1.SetFocus;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
Button1.Enabled := True;
Button2.Enabled := False;
Button3.Enabled := False;
Button4.Enabled := True;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
try
  if (Edit1.Text = '') or (Edit2.Text = '') then
  begin
    ShowMessage('Semua kolom harus diisi!');
    Exit;
  end;

  ZQuery1.SQL.Clear;
  ZQuery1.SQL.Add('UPDATE satuan SET nama = :field1, diskripsi = :field2 WHERE id = :id');
  ZQuery1.ParamByName('id').AsString := a;
  ZQuery1.ParamByName('field1').AsString := Edit1.Text;
  ZQuery1.ParamByName('field2').AsString := Edit2.Text;
  ZQuery1.ExecSQL;

  ZQuery1.SQL.Clear;
  ZQuery1.SQL.Add('SELECT * FROM satuan');
  ZQuery1.Open;

  ShowMessage('Data Berhasil Diupdate');

  Edit1.Text := '';
  Edit2.Text := '';

  Edit1.SetFocus;

  Button1.Enabled := True;
  Button2.Enabled := False;
  Button3.Enabled := False;
  Button4.Enabled := True;

except
  on E: Exception do
    ShowMessage('Terjadi kesalahan: ' + E.Message);
end;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
try
  if a = '' then
  begin
    ShowMessage('Pilih data yang akan dihapus.');
    Exit;
  end;

  if MessageDlg('Anda yakin ingin menghapus data ini?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    ZQuery1.SQL.Clear;
    ZQuery1.SQL.Add('DELETE FROM satuan WHERE id = :id');
    ZQuery1.ParamByName('id').AsString := a;
    ZQuery1.ExecSQL;

    ZQuery1.SQL.Clear;
    ZQuery1.SQL.Add('SELECT * FROM satuan');
    ZQuery1.Open;

    ShowMessage('Data Berhasil Dihapus');

    Edit1.Text := '';
    Edit2.Text := '';

    Edit1.SetFocus;

    Button1.Enabled := True;
    Button2.Enabled := False;
    Button3.Enabled := False;
    Button4.Enabled := True;

  end;

except
  on E: Exception do
    ShowMessage('Terjadi kesalahan: ' + E.Message);
end;

end;

procedure TForm1.Edit3Change(Sender: TObject);
begin
  searchValue := Edit3.Text;

  ZQuery1.SQL.Clear;
  ZQuery1.SQL.Add('SELECT * FROM satuan WHERE nama LIKE :search');
  ZQuery1.ParamByName('search').AsString := '%' + searchValue + '%';
  ZQuery1.Open;

  DBGrid1.DataSource.DataSet.Refresh;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Edit1.Text := '';
  Edit2.Text := '';

  Edit1.SetFocus;
  
  Button1.Enabled := True;
  Button2.Enabled := False;
  Button3.Enabled := False;
  Button4.Enabled := True;


end;

end.
