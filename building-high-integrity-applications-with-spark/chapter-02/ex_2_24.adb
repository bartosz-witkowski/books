with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

procedure ex_2_24 is
  type Float_Array is Array (Positive range <>) of Float;
  function max(items : in Float_Array) return Float is 
    max : Float := Float'First;
  begin
    for i in items'Range loop
      max := Float'Max(items(i), max);
    end loop;
    return max;
  end max;
  my_int_array : Float_Array := (0.0, 0.1, 0.2, 0.3, 0.4);
begin
  put_line("max: " & Float'Image(max(my_int_array)));
end ex_2_24;
