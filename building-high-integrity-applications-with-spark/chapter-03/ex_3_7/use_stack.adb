with Stack;
with Ada.Text_IO; use Ada.Text_IO;

procedure use_stack is
   package Char_Stack is new Stack(Character);
   use Char_Stack;

   a_stack : Char_Stack.Stack_Type(max_size => 100);
   value   : Character;

begin
   clear(a_stack);  -- Initialize stack
   for char in Character range 'a' .. 'z' loop
      push(a_stack, char);
   end loop;

   for count in Integer range 1 .. 5 loop
      pop(a_stack, value);
      put_line(Character'image(value));
   end loop;

   clear(a_stack);
   put_line("Size of cleared stack is " & Integer'image(size(a_stack)));
end use_stack;
