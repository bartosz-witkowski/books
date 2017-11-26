with Ada.Text_IO; use Ada.Text_IO;
with Ada.Long_Float_Text_IO; use Ada.Long_Float_Text_IO;

procedure ex_2_19 is
  a : Long_Float := 11.1199;
  b : Long_Float := 11.12;
  RELATIVE_DIFFERENCE : constant Long_Float := 0.001 * 0.01;
  function nearly_equal(x: Long_Float; y: Long_Float) return Boolean is 
    smaller : constant Long_Float := Long_Float'Min(x, y);
    bigger : constant Long_Float := Long_Float'Max(x, y);
    eps : constant Long_Float := RELATIVE_DIFFERENCE * smaller;
    absolute_difference : constant Long_Float := bigger - smaller;
  begin
    return absolute_difference < eps;
  end nearly_equal;
begin
  put("a: ");
  put(a, Fore => 1, Aft => 2, Exp => 0);
  put(" b: ");
  put(b, Fore => 1, Aft => 2, Exp => 0);
  put(" nearly_equal : ");
  put_line(Boolean'Image(nearly_equal(a, b)));
end ex_2_19;
