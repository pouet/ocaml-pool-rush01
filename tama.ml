class tama = 
    object (self)
        val mutable health = 100
        val mutable energy = 100
        val mutable hygiene = 100
        val mutable happyness = 100
        val mutable _die_sound_played = false

        initializer self#load

        method is_alive = health > 0 && energy > 0 && hygiene > 0 && happyness > 0

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
            self#sethappyness (5);

        method thunder =
            self#sethealth (-20);
            self#setenergy (25);
            self#sethappyness (-20)

        method bath =
            self#sethealth (-20);
            self#setenergy (-10);
            self#sethygiene (25);
            self#sethappyness (5)

        method kill =
            self#sethealth (-20);
            self#setenergy (-10);
            self#sethappyness (20)

        method get_health = health
        method get_energy = energy
        method get_hygiene = hygiene
        method get_happyness = happyness

        method die_sound_played = _die_sound_played
        method update_die_snd_played = _die_sound_played <- true

        method print_stat =
            Printf.printf "Health:%d Energy:%d Hygiene:%d Happyness:%d\n" health energy hygiene happyness

        method to_string =
           (string_of_int health) ^ " " ^ (string_of_int energy) ^ " " ^ (string_of_int hygiene) ^ " " ^ (string_of_int happyness)     

        method save =
            if self#is_alive = false then begin
                    health <- 100;
                    energy <- 100;
                    hygiene <- 100;
                    happyness <- 100;
            end;
            try
                let oc = open_out "save.itama" in
                Printf.fprintf oc "%s" self#to_string
            with
            | _         -> print_endline "Error when saving"

        method load =
            try
                let ic = open_in "save.itama" in
                let line = input_line ic in
                let split = String.split_on_char ' ' line in
                health <- (int_of_string(List.nth split 0));
                energy <- (int_of_string(List.nth split 1));
                hygiene <- (int_of_string(List.nth split 2));
                happyness <- (int_of_string(List.nth split 3));
                if health < 0 || health > 100 then invalid_arg "";
                if energy < 0 || energy > 100 then invalid_arg "";
                if hygiene < 0 || hygiene > 100 then invalid_arg "";
                if happyness < 0 || happyness > 100 then invalid_arg ""
            with
            | _         ->
                    print_endline "File corruped";
                    health <- 100;
                    energy <- 100;
                    hygiene <- 100;
                    happyness <- 100;
    end
