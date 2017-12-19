pragma SPARK_Mode(On);

package inc is
  type Array_Type is Array(Integer range <>) of Integer;

  procedure inc(xs : in out Array_Type) 
    with
      Pre => (
        for all x of xs => x < Integer'Last
      ),
      Post => (
        for all i in xs'range => xs(i) = Integer'Succ(xs'old(i))
      );
private
  procedure inc_one(xs : in out Array_Type; 
                     i : Integer)
    with
      Pre => (
        i in xs'range 
          and then
        xs(i) < Integer'Last
      ),
      Post => (
        for all k in xs'range =>
          (if (k /= i) then xs(k) = xs'old(k) else xs(k) = Integer'Succ(xs'old(k)))
      );

end inc;
