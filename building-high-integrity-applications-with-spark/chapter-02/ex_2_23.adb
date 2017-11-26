with Ada.Text_IO; use Ada.Text_IO;
with Ada.Long_Float_Text_IO; use Ada.Long_Float_Text_IO;

procedure ex_2_23 is
  type Int_Array is Array (Character range <>) of Integer;
  function max(items : in Int_Array) return Integer is 
    max : Integer := Integer'First;
  begin
    for i in items'Range loop
      max := Integer'Max(items(i), max);
    end loop;
    return max;
  end max;
  my_int_array : Int_Array := (0, 1, 2, 3, 4);
begin
  put_line("max: " & Integer'Image(max(my_int_array)));
end ex_2_23;
