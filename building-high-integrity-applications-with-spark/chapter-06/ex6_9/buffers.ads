pragma SPARK_Mode(On);

package Buffers is
   Maximum_Buffer_Size : constant := 1024;
   subtype Buffer_Count_Type is Natural  range 0 .. Maximum_Buffer_Size;
   subtype Buffer_Index_Type is Positive range 1 .. Maximum_Buffer_Size;
   type    Buffer_Type       is array (Buffer_Index_Type) of Character;

   -- Returns the number of occurrences of Ch in Buffer.
   function count_character (Buffer : in Buffer_Type;
                             Ch     : in Character) return Buffer_Count_Type;

   -- Reverses the content of the Buffer.
   procedure reverse_buffer(buffer : in out Buffer_Type)
     with
       Global  => null,
       Depends => (buffer => buffer),
       Post => (
         swapped(buffer, buffer'old, buffer'first, buffer'last)
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
