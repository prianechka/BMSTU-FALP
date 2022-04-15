domains
	name = string
	surname = string
	university = string
	age = integer
	phoneNumber = integer

predicates
	nondeterm record(name, surname, city, age, phoneNumber)

clauses
	record("Alexander", "Prianishnikov", "MGTU", 20, 890801).
	record("Artem", "Bogachenko", "MGTU", 22, 898551).
	record("Sofia", "Shelia", "MIPT", 21, 891810).
	record("Tatiana", "Solntceva", "RSU", 20, 896056).
	record("Natalia", "Prianishnikova", "SFU", 59, 890821).
	record("Evgenia", "Grimberg", "KGPU", 34, 890298).
	record("Andrew", "Tonkoshtan", "MGTU", 20, 896245).
	record("Maria", "Serova", "MSU", 20, 898577).
	record("Alexander", "Mezherovski", "RGGU", 19, 899999).
	record("Alexander", "Prianishnikov", "SFU", 20, 890801).

goal
	record(Name, Surname, "MGTU", 20, PhoneNumber).

/*
	record("Alexander", Surname, University, Age, PhoneNumber)
	record(Name, "Shelia", University, 21, PhoneNumber)
	record(Name, Surname, "MGTU", Age, PhoneNumber)
	record(Name, Surname, University, Age, PhoneNumber)
	record("Alexander", "Prianishnikov", University, 20, PhoneNumber)
*/ 
