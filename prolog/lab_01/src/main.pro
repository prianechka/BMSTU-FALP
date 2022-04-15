domains
	name = string
	surname = string
	city = string
	age = integer
	phoneNumber = integer

predicates
	nondeterm record(name, surname, city, age, phoneNumber)

clauses
	record("Alexander", "Prianishnikov", "Moscow", 20, 890801).
	record("Artem", "Bogachenko", "Kishinev", 22, 898551).
	record("Sofia", "Shelia", "Sochi", 21, 891810).
	record("Tatiana", "Solntceva", "Vysokie Polyany", 20, 896056).
	record("Natalia", "Prianishnikova", "Krasnoyarsk", 59, 890821).
	record("Evgenia", "Grimberg", "Krasnoyarsk", 34, 890298).
	record("Andrew", "Tonkoshtan", "Stavropol", 20, 896245).
	record("Maria", "Serova", "Moscow", 20, 898577).
	record("Alexander", "Mezherovski", "Moscow", 19, 899999).

goal
	record(Name, Surname, "Moscow", 20, PhoneNumber).
/*
	record("Alexander", Surname, City, Age, PhoneNumber)
	record(Name, "Shelia", City, 21, PhoneNumber)
	record(Name, Surname, "Krasnoyarsk", Age, PhoneNumber)
	record(Name, Surname, City, Age, PhoneNumber)
	record("Silvestr", Surname, City, Age, PhoneNumber)
*/ 
