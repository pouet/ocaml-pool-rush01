class tama = 
    object(self)
        val mutable health = 100
        val mutable energy = 100
        val mutable hygiene = 100
        val mutable happyness = 100

         method check = health <= 0 || energy <= 0 || hygiene <= 0 || happyness <= 0

         method sethealth add =
             let res = happyness + add in
             if res > 100
             then health <- 100
             else if res < 0
             then health <- 0
             else health <- res

        method setenergy add =
             let res = happyness + add in
             if res > 100
             then energy <- 100
             else if res < 0
             then energy <- 0
             else energy <- res

        method sethygiene add =
             let res = happyness + add in
             if res > 100
             then hygiene <- 100
             else if res < 0
             then hygiene <- 0
             else hygiene <- res

        method sethappyness add =
             let res = happyness + add in
             if res > 100
             then happyness <- 100
             else if res < 0
             then happyness <- 0
             else happyness <- res

         method eat =
            self#sethealth 25;
            self#setenergy (-10);
            self#sethygiene (-20);
            self#sethappyness(5);

        method thunder =
            self#sethealth (-20);
            self#setenergy (25);
            self#sethappyness(-20)

        method bath =
            self#sethealth (-20);
            self#setenergy (-10);
            self#sethygiene (25);
            self#sethappyness(5)

        method kill =
            self#sethealth (-20);
            self#setenergy (-10);
            self#sethappyness(20)

        method print_stat =
            Printf.printf "Health:%d Energy:%d Hygiene:%d Happyness:%d\n" health energy hygiene happyness

   end
