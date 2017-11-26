with Ada.Text_IO; use Ada.Text_IO;

procedure ex_2_13 is
  a : Integer := 0;
  b : Integer := 100;
  procedure swap(x: in out Integer; y: in out Integer) is 
    tmp : Integer;
  begin
    tmp := x;
    x := y;
    y := tmp;
  end swap;
begin
  put_line("Before: a == " & Integer'Image(a) & ", b: " & Integer'Image(b));
  swap(a, b);
  put_line("After: a == " & Integer'Image(a) & ", b: " & Integer'Image(b));
end ex_2_13;
