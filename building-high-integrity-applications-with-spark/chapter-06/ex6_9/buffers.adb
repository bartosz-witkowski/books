pragma SPARK_Mode(On);

package body Buffers is
  function count_character (Buffer : in Buffer_Type;
                            Ch     : in Character) return Buffer_Count_Type 
  is
    count : Buffer_Count_Type := 0;
  begin
     for index in Buffer_Index_Type loop
        pragma Loop_Invariant (count < index);

        if buffer(index) = ch then
           count := count + 1;
        end if;
     end loop;
     return Count;
  end Count_Character;

  procedure swap(
      buffer : in out Buffer_Type;
      from : in Buffer_Index_Type;
      to : in Buffer_Index_Type) 
  is
    tmp   : Character;
  begin
      tmp          := buffer(from);
      buffer(from) := buffer(to);
      buffer(to)   := tmp;
  end swap;

  --
  --        0 .. 1
  -- [a, b, c, d, e]  -> [e, d, c, b, a]    length = 5 last_swap_offset = 2
  --        0 .. 1
  -- [a, b, c, d]     -> [d, c, b, a]       length = 4 last_swap_offset = 2
  --        0 .. 0
  -- [a, b, c]        -> [c, b, a],         length = 3 last_swap_offset = 1
  --        0 .. 0
  -- [a, b]           -> [b, a]             length = 2 last_swap_offset = 0
  --
  --
  -- swap(1 + 0, 4 - 0)        [d, b, c, a]
  -- swap(1 + 1, 4 - 1)        [d, c  b, a]
  procedure reverse_buffer(buffer : in out Buffer_Type) is
    buffer_old : constant Buffer_Type := buffer
      with 
        Ghost => true;
    --                                      (pivot------------)
    last_swap_offset : constant Buffer_Count_Type := (buffer'length / 2) - 1;
  begin
    for i in 0 .. last_swap_offset loop
      swap(buffer, buffer'first + i, buffer'last - i);

      pragma loop_invariant(
        swapped(buffer, buffer_old, buffer'first,    buffer'first + i) and then
        swapped(buffer, buffer_old, buffer'last - i, buffer'last) and then
        (
          if (i < last_swap_offset) then
            same(buffer, buffer_old, buffer'first + i + 1, buffer'last - i - 1)
        )
      );
    end loop;
  end reverse_buffer;

end Buffers;
