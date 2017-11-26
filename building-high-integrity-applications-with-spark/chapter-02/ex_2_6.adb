with Ada.Text_IO; use Ada.Text_IO;

procedure ex_2_6 is
  a : Integer := 3;
  b : Integer := 3;
  c : Integer := 3;
begin
  if (a = b and b = c) then
    put_line("All three values are the same!");
  elsif (a = b or b = c or a = c) then
    put_line("Two values are the same!");
  else 
    put_line("All values are different!");
  end if;
end ex_2_6;;
