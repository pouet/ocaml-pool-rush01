class tama = 
    object (self)
        val mutable health = 100
        val mutable energy = 100
        val mutable hygiene = 100
        val mutable happyness = 100

        method check = health <= 0 || energy <= 0 || hygiene <= 0 || happyness <= 0

        method sethealth add =
            let res = health + add in
            if res > 100
            then health <- 100
            else if res < 0
            then health <- 0
            else health <- res

        method setenergy add =
            let res = energy + add in
            if res > 100
            then energy <- 100
            else if res < 0
            then energy <- 0
            else energy <- res

        method sethygiene add =
            let res = hygiene + add in
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

        method get_health = health
        method get_energy = energy
        method get_hygiene = hygiene
        method get_happyness = happyness

        method print_stat =
            Printf.printf "Health:%d Energy:%d Hygiene:%d Happyness:%d\n" health energy hygiene happyness

        method to_string =
           (string_of_int health) ^ " " ^ (string_of_int energy) ^ " " ^ (string_of_int hygiene) ^ " " ^ (string_of_int happyness)     

        method save =
            try
                let oc = open_out "save.txt" in
                Printf.fprintf oc "%s" self#to_string
            with
            | _         -> raise(invalid_arg "Error when saving")

        method load =
            try
                let ic = open_in "save.txt" in
                let line = input_line ic in
                let split = String.split_on_char ' ' line in
                health <- (int_of_string(List.nth split 0));
                energy <- (int_of_string(List.nth split 1));
                hygiene <- (int_of_string(List.nth split 2));
                happyness <- (int_of_string(List.nth split 3));
                if health < 0 || health > 100 then health <- 100;
                if energy < 0 || energy > 100 then energy <- 100;
                if hygiene < 0 || hygiene > 100 then hygiene <- 100;
                if happyness < 0 || happyness > 100 then happyness <- 100
            with
            | _         -> ()
    end
