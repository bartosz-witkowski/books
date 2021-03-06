data PowerSource = Petrol | Pedal

data Vehicle : PowerSource -> Type where
     Bicycle : Vehicle Pedal
     Unicycle : Vehicle Pedal
     Car : (fuel : Nat) -> Vehicle Petrol
     Bus : (fuel : Nat) -> Vehicle Petrol
     Motorcycle : (fuel : Nat) -> Vehicle Petrol

wheels : Vehicle power -> Nat
wheels Bicycle = 2
wheels Unicycle = 1
wheels (Car fuel) = 4
wheels (Bus fuel) = 4
wheels (Motorcycle fuel) = 2

refuel : Vehicle Petrol -> Vehicle Petrol
refuel (Car fuel) = Car 100
refuel (Bus fuel) = Bus 200
refuel Bicycle impossible
refuel (Motorcycle fuel) = Motorcycle 50
