with Ada.Text_IO; use Ada.Text_IO;
with Ada.Long_Float_Text_IO; use Ada.Long_Float_Text_IO;

procedure ex_2_14 is
  a : Long_Float := 11.11;
  b : Long_Float := 12.12;
  function bigger(x: Long_Float; y: Long_Float) return Long_Float is 
  begin
    if (x > y) then
      return x;
    else
      return y;
    end if;
  end bigger;
begin
  put("a: ");
  put(a, Fore => 1, Aft => 2, Exp => 0);
  put(" b: ");
  put(b, Fore => 1, Aft => 2, Exp => 0);
  put(" bigger: ");
  put(bigger(a, b), Fore => 1, Aft => 2, Exp => 0);
  new_line;
end ex_2_14;
