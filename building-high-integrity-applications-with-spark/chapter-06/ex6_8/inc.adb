pragma SPARK_Mode(On);

package body inc is
  procedure inc(xs : in out Array_Type) is 
  begin
    for i in xs'range loop
      pragma Loop_Invariant(true);
      xs(i) := Integer'Succ(xs(i));
    end loop;
  end;
end inc;
