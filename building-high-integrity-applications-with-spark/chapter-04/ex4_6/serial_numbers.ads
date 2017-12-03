package Serial_Numbers 
  with Abstract_State => State
is
   type Serial_Number is range 1000 .. Integer'Last;
   procedure Get_Next (Number : out Serial_Number) 
     with
       Global => (In_Out => State),
       Depends => (State =>+ null,
                   Number => State);
end Serial_Numbers;
