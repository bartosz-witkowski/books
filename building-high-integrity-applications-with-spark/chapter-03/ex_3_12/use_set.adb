with Set;
with Ada.Text_IO; use Ada.Text_IO;

procedure use_set is
  type Uppercase is new Character range 'A' .. 'Z';

  package Char_Set is new Set(Uppercase);
  use Char_Set;
 
  a_set : Char_Set.Set_Type;
  b_set : Char_Set.Set_Type;

  procedure put_set(s : Char_Set.Set_Type) is
    printed_before : Boolean := false;
  begin
    put("{");
    for c in Uppercase'range loop
      if (is_member(s, c)) then
        if printed_before then
          put(", ");
        end if;
        put(Uppercase'image(c));
        printed_before := true;
      end if;
    end loop;
    put("}");
  end put_set;

  procedure put_sets is
  begin
    put("a: ");
    put_set(a_set);
    new_line;
    put("b: ");
    put_set(b_set);
  end put_sets;

begin
  put_line("Uninitialized:");
  put_sets;
  new_line;

  make_empty(a_set);
  make_empty(b_set);
  put_line("After make_empty:");
  put_sets;
  new_line;

  put_line("After initialization:");
  add_value(a_set, Uppercase'('A'));
  add_value(a_set, Uppercase'('B'));
  add_value(a_set, Uppercase'('C'));
  add_value(a_set, Uppercase'('E'));
  add_value(a_set, Uppercase'('F'));
  add_value(b_set, Uppercase'('B'));
  add_value(b_set, Uppercase'('D'));
  add_value(b_set, Uppercase'('F'));
  add_value(b_set, Uppercase'('G'));
  put_sets;
  new_line;
  
  put("Union: ");
  put_set(union(a_set, b_set));
  new_line;

  put("Intersection: ");
  put_set(intersection(a_set, b_set));
  new_line;

  put_line("Remove: 'B' from a");
  remove_value(a_set, Uppercase'('B'));
  put_sets;
  new_line;

end use_set;
