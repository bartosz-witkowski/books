pragma spark_mode(On);

package Buffers is

  Maximum_Buffer_Size : constant := 1024;
  subtype Buffer_Count_Type is Natural  range 0 .. Maximum_Buffer_Size;
  subtype Buffer_Index_Type is Positive range 1 .. Maximum_Buffer_Size;
  type    Buffer_Type       is array (Buffer_Index_Type) of Character;

  -- Returns the number of occurrences of Ch in Buffer.
  function count_character (buffer : in Buffer_Type;
                            ch     : in Character) return Buffer_Count_Type;
  
   -- Reverses the content of the Buffer.
  procedure reverse_buffer(buffer : in out Buffer_Type)
    with
      Global  => null,
      Depends => (buffer => buffer),
      Post => (
        swapped(buffer, buffer'old, buffer'first, buffer'last)
      );

  procedure rotate_right(buffer   : in out Buffer_Type;
                         distance : in     Buffer_Count_Type)
    with
      Global => null,
      Depends => (buffer =>+ distance),
      Post => (
        rotated_right(buffer, buffer'old, distance, buffer'first, buffer'last)
      );

  function search(haystack : Buffer_Type;
                needle   : String) return Buffer_Count_Type
  with
    Global => null,
    Pre => (
      needle'length > 0
    ),
    Post => (
      if search'result = 0 then
        (for all index in haystack'first .. (haystack'last - needle'length) =>
          not needle_in(haystack, needle, index))
        or needle'length > haystack'length
      else (
        search'result + needle'length <= haystack'last
          and then
        needle_in(haystack, needle, search'result)
      )
    );
  
  procedure count_and_erase_character(buffer : in out Buffer_Type;
                                      ch     : in     Character;
                                      count  : out    Buffer_Count_Type)
  with
    Global => null,
    Depends => (
      buffer =>+ ch,
      count  => (ch, buffer)
    ),
    Post => (
      count = count_char_from_to(buffer'old, ch, buffer'first, buffer'last)
        and then
      replaced_char_from_to(buffer, buffer'old, ch, buffer'first, buffer'last)
    );

  procedure compact(buffer          : in out Buffer_Type;
                    erase_character : in Character;
                    fill_character  : in Character;
                    valid           : out Buffer_Count_Type)
  with
    Global => null,
    Depends => (
      buffer =>+ (erase_character, fill_character),
      valid  =>  (buffer, erase_character)
    ),
    Post => (
      -- all erase_character were replaced
      -- valid = 0  empty
      -- valid = 1  buffer'first .. buffer'first 
      (for all i in buffer'first .. buffer'first + valid - 1 =>
         buffer(i) /= erase_character)
       and then
       -- the left over characters are filled by fill_character
       (for all i in buffer'first + valid .. buffer'last =>
         buffer(i) = fill_character
       )
       -- valid - use count_char_from_to
         and then
       valid = count_not_char_from_to(buffer'old, erase_character, buffer'first, buffer'last)
       -- -- all the characters from the old buffer correspond to the new one
        and then
       correspond_all(buffer'old, buffer'first, buffer'last, buffer, erase_character)
    );
      
function correspond1(old_buffer      : Buffer_Type;
                    old_position    : Buffer_Index_Type;
                    new_buffer      : Buffer_Type;
                    new_position    : Buffer_Index_Type) return Boolean 
  is (
    old_buffer(old_position) = new_buffer(new_position)
  ) with
    Global => null,
    Ghost => true;

--------------------------------------------------------------------
--                1    2    3    4    5    6
-- old_buffer = ['#', 'a', '#', 'b', '#', 'c']
--
-- new_buffer = ['a', 'b', 'c', '_', '_', '_']
-- 
-- correspond_all_def(old_buffer, 1, 6, new_buffer, 1, '#') ->
--   correspond_all_def(old_buffer, 2, 6, new_buffer, 1, '#') ->
--     correspond_all_def(old_buffer, 2, 2, new_buffer, 1, '#') ->
--     correspond_all_def(old_buffer, 3, 6, new_buffer, 2, '#') ->
--       correspond_all_def(old_buffer, 4, 6, new_buffer, 2, '#') ->
--         correspond_all_def(old_buffer, 4, 4, new_buffer, 2, '#') 
--         correspond_all_def(old_buffer, 5, 6, new_buffer, 3, '#') ->
--           correspond_all_def(old_buffer, 6, 6, new_buffer, 3, '#')
function correspond_all_def(old_buffer      : Buffer_Type;
                            old_from        : Buffer_Index_Type;
                            old_to          : Buffer_Index_Type;
                            new_buffer      : Buffer_Type;
                            new_from        : Buffer_Index_Type;
                            erase_character : Character) return Boolean 
  is (
    if (old_buffer(old_from) = erase_character) then (
      if (old_from = old_to) then (
        true
      ) else (
        correspond_all_def(old_buffer, old_from + 1, old_to, new_buffer, new_from, erase_character)
      )
    ) else (
      if (old_from = old_to) then (
        correspond1(old_buffer, old_from, new_buffer, new_from)
      ) else (
        correspond_all_def(old_buffer, old_from,      old_from, new_buffer, new_from,     erase_character) and then
        correspond_all_def(old_buffer, old_from + 1,  old_to,   new_buffer, new_from + 1, erase_character)
      )
    )
  )
  with
    Global => null,
    Ghost => true,
    Pre => (
      new_from <= old_from
        and then
      old_from <= old_to
    );

  pragma annotate(
    GNATprove, 
    Terminating, 
    correspond_all_def);
  pragma annotate(
    GNATprove, 
    False_Positive, 
    "terminate",
    "correspond_all_def is called recursively on a strictly smaller array");

   function correspond_all(old_buffer      : Buffer_Type;
                           old_from        : Buffer_Index_Type;
                           old_to          : Buffer_Index_Type;
                           new_buffer      : Buffer_Type;
                           erase_character : Character) return Boolean 
     is (
       correspond_all_def(old_buffer, old_from, old_to, new_buffer, old_from, erase_character)
     ) with
       Global => null,
       Pre => (
        old_from <= old_to
       ),
       Ghost => true;


  --
  -- functions needed to provide postconditions:
  -- 

  function count_char_from_to_def(buffer : in Buffer_Type;
                                  ch     : in Character;
                                  from   : in Buffer_Index_Type;
                                  to     : in Buffer_Index_Type) return Buffer_Count_Type
  is (
    (if (from = to) then (
      if buffer(from) = ch then 1 else 0
    ) else 
      count_char_from_to_def(buffer, ch, from,     from) +
      count_char_from_to_def(buffer, ch, from + 1, to)
    )
  )
  with
    Global => null,
    Pre => (
      from <= to
    ),
    Post => (
      count_char_from_to_def'result <= (to - from) + 1
    ),
    Ghost => true;
  
  pragma annotate(
    GNATprove, 
    Terminating, 
    count_char_from_to_def);
  pragma annotate(
    GNATprove, 
    False_Positive, 
    "terminate",
    "count_char_from_to_def is called recursively on a strictly smaller array");

  function count_char_from_to(buffer : in Buffer_Type;
                              ch     : in Character;
                              from   : in Buffer_Index_Type;
                              to     : in Buffer_Index_Type) return Buffer_Count_Type
  is (
    count_char_from_to_def(buffer, ch, from, to)
  ) with
    Global => null,
    Pre => (
      from <= to
    ),
    Post => (
      count_char_from_to'result <= (to - from) + 1
    ),
    Ghost => true;

  function count_not_char_from_to_def(buffer : in Buffer_Type;
                                      ch     : in Character;
                                      from   : in Buffer_Index_Type;
                                      to     : in Buffer_Index_Type) return Buffer_Count_Type
  is (
    (if (from = to) then (
      if buffer(from) /= ch then 1 else 0
    ) else 
      count_not_char_from_to_def(buffer, ch, from,     from) +
      count_not_char_from_to_def(buffer, ch, from + 1, to)
    )
  )
  with
    Global => null,
    Pre => (
      from <= to
    ),
    Post => (
      count_not_char_from_to_def'result <= (to - from) + 1
    ),
    Ghost => true;
  
  pragma annotate(
    GNATprove, 
    Terminating, 
    count_not_char_from_to_def);
  pragma annotate(
    GNATprove, 
    False_Positive, 
    "terminate",
    "count_not_char_from_to_def is called recursively on a strictly smaller array");

  function count_not_char_from_to(buffer : in Buffer_Type;
                                  ch     : in Character;
                                  from   : in Buffer_Index_Type;
                                  to     : in Buffer_Index_Type) return Buffer_Count_Type
  is (
    count_not_char_from_to_def(buffer, ch, from, to)
  ) with
    Global => null,
    Pre => (
      from <= to
    ),
    Post => (
      count_not_char_from_to'result <= (to - from) + 1
    ),
    Ghost => true;

  function replaced_char_from_to(buffer     : in Buffer_Type;
                                 buffer_old : in Buffer_Type;
                                 ch         : in Character;
                                 from       : in Buffer_Index_Type;
                                 to         : in Buffer_Index_Type) return Boolean
  is (
    (for all i in from .. to =>
      (if buffer_old(i) = ch then
         buffer(i) = ' '
       else
         buffer(i) = buffer_old(i)))
  )
  with
    Global => null,
    Pre => (
      from <= to
    ),
    Ghost => true;
  
  function needle_in(haystack : Buffer_Type;
                     needle   : String;
                     index    : Buffer_Index_Type) return Boolean 
  is (for all i in needle'range =>
      haystack(index + (i - needle'first)) = needle(i))
  with
    Pre => (
      index <= haystack'last - needle'length
    );
  
  function rotated_index(i        : Buffer_Index_Type; 
                         distance : Buffer_Count_Type) return Buffer_Index_Type 
  is (
    Buffer_Type'first + (
      (i - Buffer_Type'first + distance) mod Buffer_Type'length)
  );

  function rotated_right(xs     : Buffer_Type; 
                         xs_old : Buffer_Type;
                         n      : Buffer_Count_Type;
                         from   : Buffer_Index_Type;
                         to     : Buffer_Index_Type) return Boolean 
  is (
    for all i in from .. to => 
      xs_old(i) = xs(rotated_index(i, n))
  ) with 
    Ghost => true,
    Pre => (
     from <= to
    );

  function swapped(xs     : Buffer_Type; 
                   xs_old : Buffer_Type;
                   from   : Buffer_Index_Type;
                   to     : Buffer_Index_Type) return Boolean 
   is
     (for all i in from .. to => 
        xs(i) = xs_old(xs'last - (i - xs'first)))
   with 
     Ghost => True,
     Pre => (
      from <= to
     );

  function same(xs     : Buffer_Type; 
                xs_old : Buffer_Type;
                first  : Buffer_Index_Type;
                last   : Buffer_Index_Type) return Boolean 
   is
      (for all i in first .. last => xs(i) = xs_old(i))
   with 
     Ghost => True,
     Pre => (
       (xs'first = xs_old'first and then xs'last = xs_old'last)
         and then
       first <= last
     );



private
  procedure swap(buffer : in out Buffer_Type; 
                 from : in Buffer_Index_Type;
                 to : Buffer_Index_Type)
    with
      Global => null,
      Depends => (
        buffer =>+ (from, to)
      ),
      Pre => (
        (from /= to)
          and then
        (from in buffer'range)
          and then
        (to in buffer'range)
      ),
      Post => (
        (buffer(from) = buffer'old(to))
          and then
        (buffer(to)   = buffer'old(from)) 
          and then
        (for all i in buffer'range =>
          (if ((i /= from) and (i /= to)) then buffer(i) = buffer'old(i)))
      );


end Buffers;
