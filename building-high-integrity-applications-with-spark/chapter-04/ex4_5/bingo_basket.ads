with Bingo_Numbers; use Bingo_Numbers;
package Bingo_Basket 
  with Abstract_State => State
is

   function Empty return Boolean with
     Global => (Input => State);

   procedure Load   -- Load all the Bingo numbers into the basket
      with
         Global => (In_Out => State),
         Depends => (State =>+ null),
         Post => not Empty;

   procedure Draw (Letter : out Bingo_Letter;
                   Number : out Callable_Number)
   -- Draw a random number from the basket
      with
         Global => (In_Out => State),
         Depends => (State =>+ null,
                     Letter => State,
                     Number => State),
         Pre => not Empty;

end Bingo_Basket;
