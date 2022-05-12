	phoneRecord("Prianishnikov", 890801, address("Moscow", "Izmailovky", 73, 628)).    
	phoneRecord("Bogachenko", 898551, address("Kishinev", "Izmailovky", 73, 628)).     
	phoneRecord("Shelia", 891810, address("Sochi", "Tulskaya", 21, 1)).     
	phoneRecord("Solntceva", 896056, address("Vysokie Polyany", "Rimskaya", 123, 422)).     
	phoneRecord("Prianishnikova", 812312, address("Krasnoyarsk", "Mate Zalki", 6, 49)).    
	phoneRecord("Grimberg", 890298, address("Krasnoyarsk", "Yastynskaya", 8, 223)).    
	phoneRecord("Tonkoshtan", 896245, address("Stavropol", "Akadem", 29, 229)).     
	phoneRecord("Serova", 898577, address("Moscow", "Bauman", 13, 56)).
	phoneRecord("Prianishnikov", 899999, address("Krasnoyarsk", "Mate Zalki", 18, 49)).         
    
   	bankRecord("Prianishnikov", "Tinkoff", "12345", 91234).
   	bankRecord("Bogachenko", "Tinkoff", "76543", 1).
   	bankRecord("Serova", "Alpha", "65439", 666).
   	bankRecord("Solntceva", "Tinkoff", "00001", 150000).   
   	bankRecord("Prianishnikova", "Raiffazen", "11111", 1000).     
   	bankRecord("Prianishnikov", "Sberbank", "33333", 91234).
   	
   	owner("Bogachenko", car("Lada", "black", 1500)).     
   	owner("Prianishnikov", car("BMW", "white", 6666)).     
   	owner("Grimberg", car("Toyota", "green", 777)).    
   	owner("Shelia", car("Tesla", "georgia14", 420)).     
   	owner("Serova", car("BMW", "white", 9999)).
   	
   	owner("Prianishnikov", building("Kremlin", 1000)).
   	owner("Grimberg", building("PentHouse", 10000)).
   	owner("Solntceva", building("Avito", 3333)).
   	
   	owner("Shelia", region("Sochi", 2014)).
   	owner("Tonkoshtan", region("Stavropol", 9)).
   	owner("Bogachenko", region("Moldova", 333)).
   	
   	owner("Serova", transport("yacht", 7777)).
   	owner("Prianishnikova", transport("yacht", 7878)).
   	% First ex
   	allPersonObj(Surname, Name) :- owner(Surname, building(Name, _)).
   	allPersonObj(Surname, Name) :- owner(Surname, car(Name, _, _)).
   	allPersonObj(Surname, Name) :- owner(Surname, region(Name, _)).
   	allPersonObj(Surname, Name) :- owner(Surname, transport(Name, _)).
   	% Second ex
   	allPersonObjWithPrice(Surname, Name, Price) :- owner(Surname, building(Name, Price)).
   	allPersonObjWithPrice(Surname, Name, Price) :- owner(Surname, car(Name, _, Price)).
   	allPersonObjWithPrice(Surname, Name, Price) :- owner(Surname, region(Name, Price)).
   	allPersonObjWithPrice(Surname, Name, Price) :- owner(Surname, transport(Name, Price)).
   	% Third ex
   	sumlist([], 0).
   	sumlist([X|Xs], Sum) :- sumlist(Xs, SumTail), Sum is X + SumTail.
   	
   	merge_list([],L,L ).
   	merge_list([H|T],L,[H|M]):- merge_list(T,L,M).
   	
   	allPersonSumObj(Surname, Sum) :- findall(Price, owner(Surname, building(_, Price)), AllPriceBuild), findall(Price, owner(Surname, car(_,  _, Price)), AllPriceCar), findall(Price, owner(Surname, region(_, Price)), AllPriceRegion), findall(Price, owner(Surname, transport(_, Price)), AllPriceTransport), merge_list(AllPriceBuild, AllPriceCar, All1), merge_list(All1, AllPriceRegion, All2), merge_list(All2, AllPriceTransport, All), sumlist(All, Sum).
