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
    --                                               (pivot------------)
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

  procedure rotate_right(buffer   : in out Buffer_Type;
                         distance : in Buffer_Count_Type) 
  is
    -- TODO: how to do without copying?
    tmp_buffer      : Buffer_Type := buffer;
  begin
    for i in buffer'range loop
      tmp_buffer(rotated_index(i, distance)) := buffer(i);

      pragma loop_invariant(
        rotated_right(tmp_buffer, buffer, distance, buffer'first, i)
      );
    end loop;
    buffer := tmp_buffer;
  end rotate_right;

  function search(haystack : in Buffer_Type;
                  needle   : in String) return Buffer_Count_Type 
  is
  begin
    for index in haystack'first .. (haystack'last - needle'length) loop
      if needle_in(haystack, needle, index) then
        return index;
      end if;
  
      pragma loop_invariant (
        (for all i in haystack'first .. index =>
          not needle_in(haystack, needle, i)));
    end loop;

    return 0;
  end search;

  procedure count_and_erase_character(buffer   : in out Buffer_Type;
                                      ch       : in Character;
                                      count    : out Buffer_Count_Type)
  is
    buffer_old : constant Buffer_Type := buffer
      with 
        Ghost => true;
  begin
    count := 0;

    for index in buffer'range loop
      if (buffer(index) = ch) then
        buffer(index) := ' ';
        count := count + 1;
      end if;

      pragma loop_invariant(
        (for all i in buffer'first .. index =>
          (if buffer_old(i) = ch then
            buffer(i) = buffer_old(i)
          else
            buffer(i) = ' '))
          and then
        count <= index
          and then
        count = count_char_from_to(buffer, ch, buffer'first, index)
      );
    end loop;
  end count_and_erase_character;

end Buffers;
