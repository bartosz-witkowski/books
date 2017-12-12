pragma SPARK_Mode(On);

package inc is
  type Array_Type is Array(Integer range <>) of Integer;

  procedure inc(xs : in out Array_Type) 
    with
      Pre => (
        for all i in xs'range => xs(i) < Integer'Last
      ),
      Post => (
        for all i in xs'range => xs(i) = Integer'Succ(xs'old(i))
      );
end inc;
