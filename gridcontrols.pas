unit gridcontrols;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Grids;

type
  TPStringGrid = ^TStringGrid;

type

  { TGridControl }

  TGridControl = class
  private
    FStringGrid: TStringGrid;
    FUpdateGrid: TPStringGrid;
  public
    constructor Create(var Grid: TStringGrid);
    function FilterBy(const Column: integer; const Parameter: string): boolean;
    procedure Restore;
  end;

implementation

{ TGridControl }


constructor TGridControl.Create(var Grid: TStringGrid);
begin
  FStringGrid := TStringGrid.Create(Nil);
  FStringGrid.Assign(Grid);
  FUpdateGrid := @Grid;
end;

function TGridControl.FilterBy(const Column: integer; const Parameter: string): boolean;
var
  StringGrid: TStringGrid;
  x: integer;
  y: integer;
  z: integer;
begin
  Result := False;

  x := 0;
  y := 0;
  z := 0;

  if not (trim(Parameter) = EmptyStr) then
  begin
    try
      StringGrid := TStringGrid.Create(nil);
      StringGrid.Assign(FStringGrid);
      StringGrid.RowCount := 1;

      for x := 1 to FStringGrid.RowCount - 1 do
      begin
        if (pos(UpperCase(FStringGrid.Cells[Column, x]), UpperCase(Parameter)) > 0) then
        begin
          StringGrid.RowCount := StringGrid.RowCount + 1;
          for y := 0 to StringGrid.ColCount - 1 do
          begin
            StringGrid.Cells[y, StringGrid.RowCount - 1] := FStringGrid.Cells[y, x];
          end;
          z := z + 1;
        end;
      end;
      if (z > 0) then
      begin
        FUpdateGrid^.Assign(StringGrid);
        Result := True;
      end;
    finally
      StringGrid.Free;
    end;
  end;
end;

procedure TGridControl.Restore;
begin
  FUpdateGrid^.Assign(FStringGrid);
end;

end.
