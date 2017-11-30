package body Stack is
   function is_full(stack : in Stack_Type) return Boolean is
   begin
      return stack.count = stack.Max_Size;
   end is_full;

   function is_empty(stack : in Stack_Type) return Boolean is
   begin
      return stack.count = 0;
   end is_empty;

   function size(stack : in Stack_Type) return Natural is
   begin
      return stack.count;
   end size;

   function peek(stack : in Stack_Type) return Element_Type is
   begin
      return stack.items(stack.index);
   end peek;

   procedure clear(stack : in out Stack_Type) is
   begin
      stack.count := 0;
      stack.index := 1;
   end clear;

   procedure push(stack : in out Stack_Type;
                  item  : in     Element_Type) is
   begin
      stack.index := stack.index + 1;
      stack.items(stack.index) := item;
      stack.count := stack.count + 1;
   end push;

   procedure pop (stack : in out Stack_Type;
                  item  :    out Element_Type) is
   begin
      item := stack.items(stack.index);
      stack.index := stack.index - 1;
      stack.count := stack.count - 1;
   end pop;
end Stack;
