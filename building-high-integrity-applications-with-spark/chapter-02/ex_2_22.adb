with Ada.Text_IO; use Ada.Text_IO;
with Ada.Long_Float_Text_IO; use Ada.Long_Float_Text_IO;

procedure ex_2_22 is
  type Pixel_Color is (Red, Green, Blue, Cyan, Magenta, Yellow, Black, White);
  type Pixel_Array is Array (Pixel_Color) of Integer;
begin
  put_line("Hello world");
end ex_2_22;
