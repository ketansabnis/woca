module DatabaseSeeds
    module Menu
        def self.seed
            category_seed
            product_seed
        end
        
        private
        def self.category_seed
            Category.create(name: "Snacks") if Category.where(name: "Snacks").blank?
            Category.create(name: "Lunch") if Category.where(name: "Lunch").blank?
            Category.create(name: "Breakfast") if Category.where(name: "Breakfast").blank?
            Category.create(name: "Beverages") if Category.where(name: "Beverages").blank?
            Category.create(name: "Cigarettes") if Category.where(name: "Cigarettes").blank?
        end

        def self.product_seed
            snacks = Category.find_by(name: "Snacks")
            lunch = Category.find_by(name: "Lunch")
            breakfast = Category.find_by(name: "Breakfast")
            beverages = Category.find_by(name: "Beverages")
            cigarettes = Category.find_by(name: "Cigarettes")
            [
                {pos_reference_id: "4671211",name: "Paperboat Apple",category: beverages,price: "20"},
                {pos_reference_id: "4665856",name: "Bread/toast Butter",category: snacks,price: "15"},
                {pos_reference_id: "4662759",name: "Epigamia Wild Raspberry",category: beverages,price: "40"},
                {pos_reference_id: "4662758",name: "Epigamia Honey Banana",category: beverages,price: "40"},
                {pos_reference_id: "4645351",name: "Fruit Plate",category: lunch,price: "30"},
                {pos_reference_id: "4645350",name: "Nimbu Paani",category: beverages,price: "20"},
                {pos_reference_id: "4635112",name: "Epigamia Vanilla Bean",category: beverages,price: "40"},
                {pos_reference_id: "4632247",name: "Kadhi",category: lunch,price: "25"},
                {pos_reference_id: "4611222",name: "Kheer",category: lunch,price: "25"},
                {pos_reference_id: "4610906",name: "Tandalachi Ukad",category: breakfast,price: "30"},
                {pos_reference_id: "4610900",name: "Egg Maggi",category: snacks,price: "40"},
                {pos_reference_id: "4610558",name: "Veg Rice Mini Meal",category: lunch,price: "70"},
                {pos_reference_id: "4610557",name: "Non Veg Rice Mini Meal",category: lunch,price: "90"},
                {pos_reference_id: "4610556",name: "Marlboro Red",category: cigarettes,price: "17"},
                {pos_reference_id: "4610555",name: "Classic Regular",category: cigarettes,price: "17"},
                {pos_reference_id: "4610554",name: "Clove Mix",category: cigarettes,price: "17"},
                {pos_reference_id: "4600078",name: "Grilled Chicken Mayo Sandwich",category: snacks,price: "70"},
                {pos_reference_id: "4600076",name: "Chicken Mayo Sandwich",category: snacks,price: "60"},
                {pos_reference_id: "4600074",name: "Chicken Maggi",category: snacks,price: "60"},
                {pos_reference_id: "4600051",name: "Bread Upma",category: breakfast,price: "30"},
                {pos_reference_id: "4592434",name: "Veg Biryani",category: lunch,price: "50"},
                {pos_reference_id: "4589124",name: "Marlboro Advance",category: cigarettes,price: "17"},
                {pos_reference_id: "4585742",name: "Cream Roll",category: snacks,price: "10"},
                {pos_reference_id: "4582908",name: "Gold Flake Small",category: cigarettes,price: "10"},
                {pos_reference_id: "4582907",name: "Gold Flake Kings",category: cigarettes,price: "17"},
                {pos_reference_id: "4582899",name: "Gold Flake Light",category: cigarettes,price: "17"},
                {pos_reference_id: "4582765",name: "Sliced Bread",category: snacks,price: "5"},
                {pos_reference_id: "4579836",name: "Esse Lights",category: cigarettes,price: "10"},
                {pos_reference_id: "4578523",name: "Papad",category: lunch,price: "10"},
                {pos_reference_id: "4578522",name: "Dal",category: lunch,price: "30"},
                {pos_reference_id: "4578514",name: "Chicken",category: lunch,price: "50"},
                {pos_reference_id: "4577542",name: "Subzi",category: lunch,price: "30"},
                {pos_reference_id: "4577540",name: "Rice",category: lunch,price: "30"},
                {pos_reference_id: "4577539",name: "Chapati",category: lunch,price: "10"},
                {pos_reference_id: "4576531",name: "Marlboro Lights",category: cigarettes,price: "17"},
                {pos_reference_id: "4576529",name: "Benson Lights",category: cigarettes,price: "17"},
                {pos_reference_id: "4576527",name: "Ice Burst",category: cigarettes,price: "17"},
                {pos_reference_id: "4576525",name: "Classic Mild",category: cigarettes,price: "17"},
                {pos_reference_id: "4575115",name: "Thumps Up",category: beverages,price: "35"},
                {pos_reference_id: "4574649",name: "Fanta",category: beverages,price: "35"},
                {pos_reference_id: "4574648",name: "Sprite",category: beverages,price: "35"},
                {pos_reference_id: "4574647",name: "Coke Lite",category: beverages,price: "35"},
                {pos_reference_id: "4526849",name: "German Lager - german lager", category: beverages,price: "79"},
                {pos_reference_id: "4526848",name: "Strawberry Beer -strawberry", category: beverages,price: "79"},
                {pos_reference_id: "4526847",name: "Ginger Beer", category: beverages,price: "79"},
                {pos_reference_id: "4526846",name: "Cranberry Beer", category: beverages,price: "79"},
                {pos_reference_id: "4526845",name: "Peach Beer", category: beverages,price: "79"},
                {pos_reference_id: "4526821",name: "Paperboat Sb Milkshake",category: beverages,price: "30"},
                {pos_reference_id: "4526820",name: "Paperboat Vanilla Milkshake",category: beverages,price: "30"},
                {pos_reference_id: "4526819",name: "Paperboat Coconut Water",category: beverages,price: "40"},
                {pos_reference_id: "4526818",name: "Paperboat Aam Panna",category: beverages,price: "20"},
                {pos_reference_id: "4526817",name: "Paperboat Aamras",category: beverages,price: "20"},
                {pos_reference_id: "4526816",name: "Paperboat Mixed Fruit",category: beverages,price: "20"},
                {pos_reference_id: "4526815",name: "Paperboat Chilli Guava",category: beverages,price: "20"},
                {pos_reference_id: "4526814",name: "Paperboat Lychee",category: beverages,price: "20"},
                {pos_reference_id: "4526813",name: "Paperboat Santra",category: beverages,price: "20"},
                {pos_reference_id: "4526766",name: "Epigamia Misti Doi",category: beverages,price: "30"},
                {pos_reference_id: "4526765",name: "Epigamia Strawberry",category: beverages,price: "40"},
                {pos_reference_id: "4526764",name: "Epigamia Blue Berry",category: beverages,price: "40"},
                {pos_reference_id: "4526763",name: "Epigamia Natural",category: beverages,price: "40"},
                {pos_reference_id: "4526762",name: "Epigamia Mango",category: beverages,price: "40"},
                {pos_reference_id: "4504264",name: "Mix Dal Wada",category: breakfast,price: "30"},
                {pos_reference_id: "4504263",name: "Sevaya Upma",category: breakfast,price: "30"},
                {pos_reference_id: "4504262",name: "Dalia",category: breakfast,price: "30"},
                {pos_reference_id: "4504261",name: "Idli With Chutney & Sambar",category: breakfast,price: "30"},
                {pos_reference_id: "4504260",name: "Sabudana Khichdi",category: breakfast,price: "30"},
                {pos_reference_id: "4504259",name: "Medu Wada With Chutney",category: breakfast,price: "30"},
                {pos_reference_id: "4504258",name: "Sabudana Wada",category: breakfast,price: "30"},
                {pos_reference_id: "4504257",name: "Batata Vada With Chutney",category: breakfast,price: "30"},
                {pos_reference_id: "4504256",name: "Upma",category: breakfast,price: "25"},
                {pos_reference_id: "4504255",name: "Poha",category: breakfast,price: "25"},
                {pos_reference_id: "4504254",name: "Watermelon French Juice",category: beverages,price: "50"},
                {pos_reference_id: "4504253",name: "Sweet Lime French Juice",category: beverages,price: "50"},
                {pos_reference_id: "4504252",name: "Pineapple Fresh Juice",category: beverages,price: "50"},
                {pos_reference_id: "4504251",name: "Orange Fresh Juice",category: beverages,price: "50"},
                {pos_reference_id: "4504250",name: "Freshlime Soda",category: beverages,price: "40"},
                {pos_reference_id: "4504249",name: "Buttermilk Glass",category: beverages,price: "15"},
                {pos_reference_id: "4504248",name: "Cold Coffee",category: beverages,price: "40"},
                {pos_reference_id: "4504247",name: "Hot Chocolate",category: beverages,price: "50"},
                {pos_reference_id: "4504246",name: "Bournvita",category: beverages,price: "30"},
                {pos_reference_id: "4504245",name: "Milk",category: beverages,price: "20"},
                {pos_reference_id: "4504244",name: "Coffee",category: beverages,price: "20"},
                {pos_reference_id: "4504243",name: "Tea",category: beverages,price: "10"},
                {pos_reference_id: "4504242",name: "Egg Bhurji Pav",category: snacks,price: "50"},
                {pos_reference_id: "4504241",name: "Bread Omelet",category: snacks,price: "50"},
                {pos_reference_id: "4504240",name: "Veg Grilled Sandwich",category: snacks,price: "50"},
                {pos_reference_id: "4504239",name: "Veg Sandwich",category: snacks,price: "40"},
                {pos_reference_id: "4504238",name: "Chutney Sandwich",category: snacks,price: "30"},
                {pos_reference_id: "4504237",name: "Cheese Chilli Toast",category: snacks,price: "80"},
                {pos_reference_id: "4504236",name: "Cheese Maggi",category: snacks,price: "40"},
                {pos_reference_id: "4504235",name: "Veg Maggi",category: snacks,price: "30"},
                {pos_reference_id: "4504234",name: "Plain Maggi",category: snacks,price: "25"},
                {pos_reference_id: "4504233",name: "Masala French Fries",category: snacks,price: "80"},
                {pos_reference_id: "4504232",name: "French Fries",category: snacks,price: "70"},
                {pos_reference_id: "4504231",name: "Bakarwadi Chaat",category: snacks,price: "70"},
                {pos_reference_id: "4504230",name: "Kachori",category: snacks,price: "20"},
                {pos_reference_id: "4504229",name: "Samosa",category: snacks,price: "20"},
                {pos_reference_id: "4504228",name: "Batata Vada Pav",category: snacks,price: "30"},
                {pos_reference_id: "4504227",name: "Misal Pav",category: snacks,price: "50"},
                {pos_reference_id: "4504226",name: "Toast Butter Jam",category: snacks,price: "20"},
                {pos_reference_id: "4504225",name: "Bun Maska",category: snacks,price: "20"},
                {pos_reference_id: "4504224",name: "Non-veg Chapati Mini Meal",category: lunch,price: "90"},
                {pos_reference_id: "4504223",name: "Non-Veg Full Meal",category: lunch,price: "150"},
                {pos_reference_id: "4504222",name: "Veg Chapati Mini Meal",category: lunch,price: "70"},
                {pos_reference_id: "4504221",name: "Veg Full Meal",category: lunch,price: "120"}
            ].each do |data|
                Product.create(pos_reference_id: data[:pos_reference_id], name: data[:name], category: data[:category], price: Money.new(data[:price].to_i, 'INR'))
            end
        end
    end
end
#rzp_test_kXUULUzbMYEJSP
#j31YJZMvRVKywYCECuANwHSJ 