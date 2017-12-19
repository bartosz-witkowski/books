pragma SPARK_Mode(On);

package body inc is
  function increased(xs     : Array_Type; 
                     xs_old : Array_Type;
                     first  : Integer;
                     last   : Integer) return Boolean 
   is
     (for all i in first .. last => (xs(i) = Integer'Succ(xs_old(i))))
   with 
     Ghost => True,
     Pre => (
       (xs'first = xs_old'first and then xs'last = xs_old'last)
         and then
       first in xs'range
         and then
       last in xs'range
         and then
       first <= last
         and then
       (for all i in first .. last =>
          xs_old(i) < Integer'Last)
     );

  function not_touched(xs     : Array_Type; 
                       xs_old : Array_Type;
                       first  : Integer;
                       last   : Integer) return Boolean 
   is
     (for all i in first .. last => (xs(i) = xs_old(i)))
   with 
     Ghost => True,
     Pre => (
       (xs'first = xs_old'first and then xs'last = xs_old'last)
         and then
       first in xs'range
         and then
       last in xs'range
         and then
       first <= last
     );
                  
  

  procedure inc_one(xs : in out Array_Type; i : Integer) is 
  begin
    xs(i) := Integer'Succ(xs(i));
  end;

  procedure inc(xs : in out Array_Type) 
  is 
    xs_old : constant Array_Type := xs
      with 
        Ghost => true;
  begin
    pragma assert (
      for all x of xs => x < Integer'last
    );

    for i in xs'range loop
      pragma assert (
        i in xs'range 
          and then
        xs(i) < Integer'last
      );

      inc_one(xs, i);

      pragma Loop_Invariant(
        (
          increased(xs, xs_old, xs'first, i) 
        ) and then  (
          if (i < xs'last) then not_touched(xs, xs_old, Integer'Succ(i), xs'last)
        )
      );
    end loop;
  end;
end inc;
