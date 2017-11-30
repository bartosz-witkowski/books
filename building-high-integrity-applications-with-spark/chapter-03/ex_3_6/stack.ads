package Stack is
   subtype Element_Type is Character;

   type Stack_Type(max_size : Positive) is private;

   function is_full(stack : in Stack_Type) return Boolean;

   function is_empty(stack : in Stack_Type) return Boolean;

   function size(stack : in Stack_Type) return Natural;

   function peek (stack : in Stack_Type) return Element_Type
      with
         Pre => not is_empty(Stack);

   procedure clear(stack : in out Stack_Type)
      with
         Post => is_empty(stack) and then size(stack) = 0;

   procedure push(stack : in out Stack_Type;
                  item  : in     Element_Type)
      with
         Pre  => not is_full(stack),
         Post => not is_empty(stack) and then
                 size(stack) = size(stack'old) + 1 and then
                 peek(stack) = Item;

   procedure pop(stack : in out Stack_Type;
                 item  :    out Element_Type)
      with
        Pre  => not is_empty(stack),
        Post => item = peek(stack'old) and then
                size(stack) = size(stack'old) - 1;

private
   type Stack_Array is array (Positive range <>) of Element_Type;
   type Stack_Type (max_size : Positive) is
      record
         count : Natural  := 0;                -- Number of items.
         index  : Positive := 1;               -- The stack index.
         items : Stack_Array (1 .. max_size);  -- The element array.
      end record;
end Stack;
