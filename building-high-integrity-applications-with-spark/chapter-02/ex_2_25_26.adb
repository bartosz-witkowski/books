with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

procedure ex_2_25_26 is
  generic
    type Component_Type is limited private;
    type Index_Type is (<>);
    type Array_Type is array (Index_Type range <>) of Component_Type;
    with function Selected (From_Source : in Component_Type;
                            Pattern     : in Component_Type) return Boolean;
  procedure Tally (source : in Array_Type; 
                   pattern : in Component_Type;
                   result : out Natural);

  procedure Tally (source : in Array_Type; 
                   pattern : in Component_Type;
                   result : out Natural) is
  begin
     Result := 0;
     for index in source'Range loop
        if selected (source (index), Pattern) then
           result := result + 1;
        end if;
     end loop;
  end Tally;

  function nearly_equal(x: Long_Float; y: Long_Float) return Boolean is 
    RELATIVE_DIFFERENCE : constant Long_Float := 0.001 * 0.01;
    smaller : constant Long_Float := Long_Float'Min(x, y);
    bigger : constant Long_Float := Long_Float'Max(x, y);
    eps : constant Long_Float := RELATIVE_DIFFERENCE * smaller;
    absolute_difference : constant Long_Float := bigger - smaller;
  begin
    return absolute_difference < eps;
  end nearly_equal;

  type Long_Float_Array is Array (Integer range <>) of Long_Float;

  procedure my_tally is new Tally(Component_Type => Long_Float,
                                  Index_Type     => Integer,
                                  Array_Type     => Long_Float_Array,
                                  Selected       => nearly_equal);
  my_array : Long_Float_Array := (0.0, 0.1, 0.1000001);

  result : Natural;
begin
  -- interesting behavior of nearly_equal when one of the compared values is 0
  my_tally(my_array, 0.1, result);
  put_line("result " & Natural'Image(result));
end ex_2_25_26;
