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
    final_count : constant Buffer_Count_Type := count_char_from_to(
      buffer_old, ch, buffer'first, buffer'last
    )
      with
        Ghost => true;
  begin
    count := 0;
  
    for index in buffer'range loop
      pragma assert (buffer(index) = buffer_old(index));
   
      if (buffer(index) = ch) then
        if (buffer(index) = ch) then
          count := count + 1;
        end if;

        buffer(index) := ' ';
     end if;
   
     pragma loop_invariant(
       count <= index
         and then
       (if (index < buffer'last) then
         final_count = count + count_char_from_to(buffer_old, ch, index + 1, buffer'last)
        else
         final_count = count)
         and then
       replaced_char_from_to(buffer, buffer_old, ch, buffer'first, index)
     );
   end loop;

   pragma assert (count = final_count);
  end count_and_erase_character;

  procedure compact(buffer          : in out Buffer_Type;
                    erase_character : in Character;
                    fill_character  : in Character;
                    valid           : out Buffer_Count_Type)
  is
    buffer_old : constant Buffer_Type := buffer;
    dest : Integer := Buffer_Index_Type'first;

    final_valid : constant Buffer_Count_Type := count_not_char_from_to(
      buffer_old, erase_character, buffer'first, buffer'last
    )
      with
        Ghost => true;
  begin
    valid := 0;

    pragma assert(dest = buffer_old'first);

    for index in buffer_old'range loop
      pragma assert(dest <= index);

      if (buffer_old(index) /= erase_character) then
        buffer(dest) := buffer_old(index);
        valid        := valid + 1;
        dest         := dest  + 1;
      end if;

      -- bounds
      pragma loop_invariant (
        dest  >= buffer'first
          and then
        dest  <= index + 1
          and then
        valid < index + 1
      );

      -- dest
      pragma loop_invariant(
        (if (dest /= buffer'first) then
          (if dest <= buffer'last then (
            for all i in buffer'first .. (dest - 1)=>
              buffer(i) /= erase_character
           ) else (
            for all i in buffer'first .. buffer'last =>
              buffer(i) /= erase_character
          )))
      );

      -- valid
      pragma loop_invariant(
       valid = dest - buffer'first
         and then
       (if (index < buffer'last) then
         final_valid = valid + count_not_char_from_to(buffer_old, erase_character, index + 1, buffer'last)
        else
         final_valid = valid)
      );

      -- correspond all
      pragma loop_invariant(
        dest - 1 <= index
          and then
        (if dest > buffer'first then
          correspond_all_def(buffer_old, buffer'first, index, buffer, dest - 1, erase_character))
          and then
        (if index < buffer'last then
          correspond_all_def(buffer_old, index + 1, buffer'last, buffer, dest, erase_character))
      );
    end loop;

    if (dest = buffer'last + 1) then
      pragma assert(
        (for all i in buffer'first .. buffer'last =>
          buffer(i) /= erase_character)
      );
      pragma assert(
        valid = Buffer_Count_Type'last
      );

      pragma assert(
        correspond_all(buffer_old, buffer'first, buffer'last, buffer, erase_character)
      );

      return;
    end if;

    pragma assert(
      (for all i in buffer'first .. (dest - 1)=>
        buffer(i) /= erase_character)
    );

    pragma assert (
      dest <= buffer_old'last
    );

    for index in dest .. buffer_old'last loop
      buffer(index) := fill_character;

      pragma loop_invariant(
        (for all i in buffer'first .. dest - 1 =>
          buffer(i) /= erase_character)
          and then
        (for all i in dest .. index =>
          buffer(i) = fill_character)
      );
    end loop;

  end compact;
end Buffers;
