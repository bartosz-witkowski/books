with Ada.Text_IO; use Ada.Text_IO;

procedure ex_2_11 is
  RANGE_START : constant Integer := 0;
  RANGE_END : constant Integer := 100;
  DIVISIBLE_BY : constant Integer := 3;
begin
  for i in Integer range 0 .. 100 loop
    if i rem DIVISIBLE_BY = 0 then
      put_line(Integer'Image(i) & " is divisible by " & Integer'Image(DIVISIBLE_BY));
    end if;
  end loop;
end ex_2_11;
