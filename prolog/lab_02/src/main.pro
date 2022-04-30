domains    
	surname = string    
	phoneNumber = integer     
	city, street = string    
	house, room = integer    
	address = address(city, street, house, room)          
	carModel, carColor = string    
	carCost = integer          
	bankName, account = string     
	sum = integer  

predicates    
	nondeterm phoneRecord(surname, phoneNumber, address)  
	nondeterm carRecord(surname, carModel, carColor, carCost)    
 	nondeterm bankRecord(surname, bankName, account, sum)     
  	nondeterm findCarByPhone(phoneNumber, surname, carModel, carColor, carCost)    
   	nondeterm findCarModelByPhone(phoneNumber, carModel)     
   	nondeterm findBankUsersBySurname(surname, city, bankName, street) 
   	nondeterm findSurnameByCar(carModel, carColor, surname, city, phoneNumber, bankName)
clauses 
     
	phoneRecord("Prianishnikov", 890801, address("Moscow", "Izmailovky", 73, 628)).    
	phoneRecord("Bogachenko", 898551, address("Kishinev", "Izmailovky", 73, 628)).     
	phoneRecord("Shelia", 891810, address("Sochi", "Tulskaya", 21, 1)).     
	phoneRecord("Solntceva", 896056, address("Vysokie Polyany", "Rimskaya", 123, 422)).     
	phoneRecord("Prianishnikova", 812312, address("Krasnoyarsk", "Mate Zalki", 6, 49)).    
	phoneRecord("Grimberg", 890298, address("Krasnoyarsk", "Yastynskaya", 8, 223)).    
	phoneRecord("Tonkoshtan", 896245, address("Stavropol", "Akadem", 29, 229)).     
	phoneRecord("Serova", 898577, address("Moscow", "Bauman", 13, 56)).     
	phoneRecord("Prianishnikov", 899999, address("Krasnoyarsk", "Mate Zalki", 18, 49)).      
   
   	carRecord("Bogachenko", "Lada", "black", 1500).     
   	carRecord("Prianishnikov", "BMW", "white", 6666).     
   	carRecord("Grimberg", "Toyota", "green", 777).    
   	carRecord("Prianishnikov", "BelAZ", "yellow", 15062).     
    carRecord("Shelia", "Tesla", "georgia14", 420).     
    carRecord("Serova", "BMW", "white", 9999).      
    
   	bankRecord("Prianishnikov", "Tinkoff", "12345", 91234).    
    bankRecord("Bogachenko", "Tinkoff", "76543", 1).    
    bankRecord("Serova", "Alpha", "65439", 666).     
    bankRecord("Solntceva", "Tinkoff", "00001", 150000).   
    bankRecord("Prianishnikova", "Raiffazen", "11111", 1000).     
    bankRecord("Prianishnikov", "Sberbank", "33333", 91234).      
        
    findCarByPhone(PhoneNumber, Surname, CarModel, CarColor, CarCost)     
        	:- phoneRecord(Surname, PhoneNumber, _), carRecord(Surname, CarModel, CarColor, CarCost).  
    findCarModelByPhone(PhoneNumber, CarModel) :- findCarByPhone(PhoneNumber, _, CarModel, _, _).      
    findBankUsersBySurname(Surname, City, BankName, Street) 
      	:- phoneRecord(Surname, _, address(City, Street, _, _)), bankRecord(Surname, BankName, _, _).
      	
    findSurnameByCar(CarModel, CarColor, Surname, City, PhoneNumber, BankName) :- 
      	carRecord(Surname, CarModel, CarColor, _), 
      	phoneRecord(Surname, PhoneNumber, address(City, _, _, _)), bankRecord(Surname, BankName, _, _).
      
goal
    /* findBankUsersBySurname("Prianishnikov", "Moscow", Bank, Street). */
    /* findCarModelByPhone(890801, Car). */
    /* findCarByPhone(890801, Surname, CarModel, CarColor, CarCost). */
    findSurnameByCar("BMW", "white", Surname, City, PhoneNumber, BankName).
