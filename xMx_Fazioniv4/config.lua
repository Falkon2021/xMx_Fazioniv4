Fazioni = {  

        police = { 
            -- boss interaction
      
            bossmenu = vector3(91.226379, -185.050552, 54.706177),
            triggerboss = 'esx_society:openBossMenu',
            grade = 4,

            -- creazione job sul database
            Registrajob = false,  -- se devi registrare il job e creare anche i gradi metti true e creati i gradi e job [MIRACCOMANDO UNA VOLTA REGISTRATO  CHE DICE SUL CMD IL JOB POI SUCCESSIVAMENTE METTI false E RIAVVIA IL SERVER ]
            label = 'police', -- devi inserire il nome job e poi successivamente inserire grati gradi vuoi creare
            gradi = {
                {grade = 0, name = 'dipendente', label = 'Dipendente', salary = 69},
                {grade = 1, name = 'boss', label = 'Direttore', salary = 69}
            },
          
            -- deposito
            Nome_deposito = 'police',
            bloccopin = false, -- se vuoi attivare il pin metti true altrimenti digita false
            pin = '0000',
            slot = 10,
            peso = 20000,
            deposito = vector3(89.393410, -186.975830, 54.874756),
            grade = 1,

            -- garage

            garage = {
                pos = vector3(92.584618, -176.492310, 54.942139),
                spawn = vector3(84.052750, -172.918671, 55.093750),
                heading = 336.269,
                vehicles = {
                    {label = 'Police', model = 'police'},
                },
            },

            -- shop
            ShopPos = vector3(-256.114288, -979.265930, 31.217529),
            Shop = {
                abilitato = true,
                grade = 1,
                items = {
                    {label = 'burger', item = 'burger', price = '2'},
                },
            },

            --moneywash & percentuale
            moneywashPos = vector3(-263.683502, -980.505493, 31.217529),
            moneywash = {
                abilitato = true,
                percentuale = 20,
            },

            blip = {
                abilitato = true,
                pos = vector3(89.195602, -186.909882, 54.874756),
                id = 61,
                grandezza = 0.7,
                colore = 6,
                nome = 'polizia',
            }, 

            Fattura = {
                abilitato = true,
                pulsante = 'f6'
            },
        },

    }
