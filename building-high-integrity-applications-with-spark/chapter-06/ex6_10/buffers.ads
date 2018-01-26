pragma spark_mode(On);

package Buffers is
  subtype Buffer_Count_Type is Natural;
  subtype Buffer_Index_Type is Positive;
  type    Buffer_Type       is array (Buffer_Index_Type range <>) of Character;

  -- Returns the number of occurrences of Ch in Buffer.
  function count_character (buffer : in Buffer_Type;
                            ch     : in Character) return Buffer_Count_Type;
  
   -- Reverses the content of the Buffer.
  procedure reverse_buffer(buffer : in out Buffer_Type)
    with
      Global  => null,
      Depends => (buffer => buffer),
      Post => (
        (if buffer'length > 0 then
          swapped(buffer, buffer'old, buffer'first, buffer'last))
      );

  procedure rotate_right(buffer   : in out Buffer_Type;
                         distance : in     Buffer_Count_Type)
    with
      Global => null,
      Depends => (buffer =>+ distance),
      Post => (
        (if buffer'length > 0 then
          rotated_right(buffer, buffer'old, distance, buffer'first, buffer'last))
      );
--
-- function search(haystack : Buffer_Type;
--               needle   : String) return Buffer_Count_Type
-- with
--   Global => null,
--   Pre => (
--     needle'length > 0
--   ),
--   Post => (
--     if search'result = 0 then
--       (for all index in haystack'first .. (haystack'last - needle'length) =>
--         not needle_in(haystack, needle, index))
--       or needle'length > haystack'length
--     else (
--       search'result + needle'length <= haystack'last
--         and then
--       needle_in(haystack, needle, search'result)
--     )
--   );
-- 
-- procedure count_and_erase_character(buffer : in out Buffer_Type;
--                                     ch     : in     Character;
--                                     count  : out    Buffer_Count_Type)
-- with
--   Global => null,
--   Depends => (
--     buffer =>+ ch,
--     count  => (ch, buffer)
--   ),
--   Post => (
--     count = count_char_from_to(buffer'old, ch, buffer'first, buffer'last)
--       and then
--     replaced_char_from_to(buffer, buffer'old, ch, buffer'first, buffer'last)
--   );
--
-- --
-- -- functions needed to provide postconditions:
-- -- 
--
-- function count_char_from_to_def(buffer : in Buffer_Type;
--                                 ch     : in Character;
--                                 from   : in Buffer_Index_Type;
--                                 to     : in Buffer_Index_Type) return Buffer_Count_Type
-- is (
--   (if (from = to) then (
--     if buffer(from) = ch then 1 else 0
--   ) else 
--     count_char_from_to_def(buffer, ch, from,     from) +
--     count_char_from_to_def(buffer, ch, from + 1, to)
--   )
-- )
-- with
--   Global => null,
--   Pre => (
--     from <= to
--   ),
--   Post => (
--     count_char_from_to_def'result <= (to - from) + 1
--   ),
--   Ghost => true;
-- 
-- pragma annotate(
--   GNATprove, 
--   Terminating, 
--   count_char_from_to_def);
-- pragma annotate(
--   GNATprove, 
--   False_Positive, 
--   "terminate",
--   "count_char_from_to_def is called recursively on a strictly smaller array");
--
-- function count_char_from_to(buffer : in Buffer_Type;
--                             ch     : in Character;
--                             from   : in Buffer_Index_Type;
--                             to     : in Buffer_Index_Type) return Buffer_Count_Type
-- is (
--   count_char_from_to_def(buffer, ch, from, to)
-- ) with
--   Global => null,
--   Pre => (
--     from <= to
--   ),
--   Post => (
--     count_char_from_to'result <= (to - from) + 1
--   ),
--   Ghost => true;
--
-- function replaced_char_from_to(buffer     : in Buffer_Type;
--                                buffer_old : in Buffer_Type;
--                                ch         : in Character;
--                                from       : in Buffer_Index_Type;
--                                to         : in Buffer_Index_Type) return Boolean
-- is (
--   (for all i in from .. to =>
--     (if buffer_old(i) = ch then
--        buffer(i) = ' '
--      else
--        buffer(i) = buffer_old(i)))
-- )
-- with
--   Global => null,
--   Pre => (
--     from <= to
--   ),
--   Ghost => true;
-- 
-- function needle_in(haystack : Buffer_Type;
--                    needle   : String;
--                    index    : Buffer_Index_Type) return Boolean 
-- is (for all i in needle'range =>
--     haystack(index + (i - needle'first)) = needle(i))
-- with
--   Pre => (
--     index <= haystack'last - needle'length
--   );
-- 
  function rotated_index(i        : Buffer_Index_Type; 
                         distance : Buffer_Count_Type;
                         first    : Buffer_Index_Type;
                         last     : Buffer_Index_Type) return Buffer_Index_Type 
  is (
    first + Integer(
      (Long_Integer(i - first) + Long_Integer(distance)) mod Long_Integer((last - first) + 1)
    )
  ) with
    Pre => (
      first <= last
        and then
      i >= first
        and then
      i <= last
        and then
      distance <= last - first
    ),
    Post => (
      rotated_index'result >= first
        and then
      rotated_index'result <= last
    );
  
  function rotated_right(xs     : Buffer_Type; 
                         xs_old : Buffer_Type;
                         n      : Buffer_Count_Type;
                         from   : Buffer_Index_Type;
                         to     : Buffer_Index_Type) return Boolean 
  is (
    for all i in from .. to => 
      xs_old(i) = xs(rotated_index(i, (n mod xs'length), xs'first, xs'last))
  ) with 
    Ghost => true,
    Pre => (
      xs'first = xs_old'first
        and then
      xs'last = xs_old'last
        and then
      xs'first <= xs'last
        and then
      from <= to
        and then
      from >= xs'first
        and then
      to <= xs'last
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
        xs'first = xs_old'first
          and then
        xs'last = xs_old'last
          and then
        from <= to
         and then
        from >= xs'first
         and then
        to <= xs'last
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
         and then
       first >= xs'first
         and then
       last <= xs'last
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
