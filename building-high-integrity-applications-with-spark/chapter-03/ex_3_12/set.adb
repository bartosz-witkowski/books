package body Set is
  function union(s1 : in Set_Type; s2 : in Set_Type) return Set_Type is
    r : Set_Type;
  begin
    for i in s1'range loop
      r(i) := s1(i) or s2(i);
    end loop;
    return r;
  end;

  function intersection(s1 : in Set_Type; s2 : in Set_Type) return Set_Type is
    r : Set_Type;
  begin
    for i in s1'range loop
      r(i) := s1(i) and s2(i);
    end loop;
    return r;
  end;

  function is_member(s : in Set_Type; e : Member_Type) return Boolean is
  begin
    return s(e);
  end is_member;

  procedure add_value(s : in out Set_Type; e : in Member_Type) is
  begin
    s(e) := true;
  end;

  procedure remove_value(s : in out Set_Type; e : in Member_Type) is
  begin
    s(e) := false;
  end;

  procedure make_empty(s : in out Set_Type) is
  begin
    for i in s'range loop
      s(i) := false;
    end loop;
  end;
end Set;
