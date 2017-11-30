generic
  type Member_Type is (<>);
package Set is
  type Set_Type is private;

  function union(s1 : in Set_Type; s2 : in Set_Type) return Set_Type;
  function intersection(s1 : in Set_Type; s2 : in Set_Type) return Set_Type;
  function is_member(s : in Set_Type; e : in Member_Type) return Boolean;
  procedure add_value(s : in out Set_Type; e : in Member_Type);
  procedure remove_value(s : in out Set_Type; e : in Member_Type);
  procedure make_empty(s : in out Set_Type);

private
  type Set_Type is array (Member_Type) of Boolean;

end Set;
