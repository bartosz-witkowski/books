with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

-- adapted from the listing
procedure ex_5_14 is
   type Percent       is delta 0.25 range 0.0 .. 100.0;
   type Percent_Array is array (Integer range <>) of Percent;

   function num_below (list  : in Percent_Array;
                       value : in Percent) return Natural
   -- Returns the number of values in List that are less than Value
      with
         -- must be in ascending order
         Pre => (
           for all i in list'first .. list'last - 1 =>
             list(i) <= list(i + 1)
           and then
             list'length >= 1
         )
   is
      Result : Natural;
      Index  : Integer;
   begin
      Result := 0;
      Index  := List'First;
      loop
         exit when Index > List'Last or else List (Index) >= Value;
         Result := Result + 1;
         Index  := Index + 1;
      end loop;
      return Result;
   end Num_Below;

  A : Percent_Array := (1 .. 0 => Percent(0.0));
begin
   put(num_below(list  => A,
                 value => 50.0));
end ex_5_14;
